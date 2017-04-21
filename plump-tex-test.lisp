#|
 This file is a part of Plump
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:plump-tex-test
  (:nicknames #:org.tymoonnext.plump.tex.test)
  (:use #:cl #:fiveam))
(in-package :plump-tex-test)

(def-suite tests)
(in-suite tests)

(defun parse (str)
  (with-output-to-string (stream)
    (plump:serialize (plump-tex:parse str) stream)))

(test text
  (is (string= "foo"
               (parse "foo")))

  (is (string= "\\"
               (parse "\\\\")))

  (is (string= "}{&amp;%$#_~^\\"
               (parse "\\}\\{\\&\\%\\$\\#\\_\\~\\^\\"))))

(test tag
  (is (string= "<foo/>"
               (parse "\\foo")))
  
  (is (string= "<foo bar=\"\"/>"
               (parse "\\foo[bar]")))
  
  (is (string= "<foo bar=\"baz\"/>"
               (parse "\\foo[bar=baz]")))

  (is (string= "<foo bar=\"\" baz=\"\"/>"
               (parse "\\foo[bar,baz]"))))

(test block
  (is (string= "<div/>"
               (parse "{}")))
  
  (is (string= "<div>1</div>"
               (parse "{1}")))
  
  (is (string= "<div><div/></div>"
               (parse "{{}}"))))


(test tagblock
  (is (string= "<foo>bar baz</foo>"
               (parse "\\foo{bar baz}")))

  (is (string= "<foo> bar baz </foo>"
               (parse "\\foo bar baz \\/")))

  (is (string= "<foo><bar>baz</bar></foo>"
               (parse "\\foo{\\bar{baz}}")))

  (is (string= "<foo>bar</foo><baz/>"
               (parse "\\foo{bar}\\baz{}"))))

(test sanity
  (is (string= "<foo>bar</foo>"
               (parse "\\foo{bar")))

  (is (string= "<div><div/></div>"
               (parse "{{}")))

  (is (string= "<foo bar=\"\"/>"
               (parse "\\foo[bar")))

  (is (string= "<foo bar=\"\"/>"
               (parse "\\foo[bar="))))

(defmethod asdf:perform ((op asdf:test-op) (system (eql (asdf:find-system :plump-tex-test))))
  (run! 'tests))
