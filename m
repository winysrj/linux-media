Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39468 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751915AbdJDL6d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:33 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v3 03/17] docs: kernel-doc.rst: improve function documentation section
Date: Wed,  4 Oct 2017 08:48:41 -0300
Message-Id: <3cfce5ca2cf05efbf8b3ad36f0654d728e0cba0a.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move its contents to happen earlier and improve the description
of return values, adding a subsection to it. Most of the contents
there came from kernel-doc-nano-HOWTO.txt.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 100 ++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 39 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 146041fc494a..ad0fb487e423 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -197,6 +197,67 @@ Example::
       int d;
   };
 
+Function documentation
+----------------------
+
+The general format of a function and function-like macro kernel-doc comment is::
+
+  /**
+   * function_name() - Brief description of function.
+   * @arg1: Describe the first argument.
+   * @arg2: Describe the second argument.
+   *        One can provide multiple line descriptions
+   *        for arguments.
+   *
+   * A longer description, with more discussion of the function function_name()
+   * that might be useful to those using or modifying it. Begins with an
+   * empty comment line, and may include additional embedded empty
+   * comment lines.
+   *
+   * The longer description may have multiple paragraphs.
+   *
+   * Return: Describe the return value of foobar.
+   *
+   * The return value description can also have multiple paragraphs, and should
+   * be placed at the end of the comment block.
+   */
+
+The brief description following the function name may span multiple lines, and
+ends with an argument description, a blank comment line, or the end of the
+comment block.
+
+Return values
+~~~~~~~~~~~~~
+
+The return value, if any, should be described in a dedicated section
+named ``Return``.
+
+.. note::
+
+  #) The multi-line descriptive text you provide does *not* recognize
+     line breaks, so if you try to format some text nicely, as in::
+
+	* Return:
+	* 0 - OK
+	* -EINVAL - invalid argument
+	* -ENOMEM - out of memory
+
+     this will all run together and produce::
+
+	Return: 0 - OK -EINVAL - invalid argument -ENOMEM - out of memory
+
+     So, in order to produce the desired line breaks, you need to use a
+     ReST list, e. g.::
+
+      * Return:
+      * * 0		- OK to runtime suspend the device
+      * * -EBUSY	- Device should not be runtime suspended
+
+  #) If the descriptive text you provide has lines that begin with
+     some phrase followed by a colon, each of those phrases will be taken
+     as a new section heading, with probably won't produce the desired
+     effect.
+
 
 Highlights and cross-references
 -------------------------------
@@ -269,45 +330,6 @@ cross-references.
 
 For further details, please refer to the `Sphinx C Domain`_ documentation.
 
-Function documentation
-----------------------
-
-The general format of a function and function-like macro kernel-doc comment is::
-
-  /**
-   * function_name() - Brief description of function.
-   * @arg1: Describe the first argument.
-   * @arg2: Describe the second argument.
-   *        One can provide multiple line descriptions
-   *        for arguments.
-   *
-   * A longer description, with more discussion of the function function_name()
-   * that might be useful to those using or modifying it. Begins with an
-   * empty comment line, and may include additional embedded empty
-   * comment lines.
-   *
-   * The longer description may have multiple paragraphs.
-   *
-   * Return: Describe the return value of foobar.
-   *
-   * The return value description can also have multiple paragraphs, and should
-   * be placed at the end of the comment block.
-   */
-
-The brief description following the function name may span multiple lines, and
-ends with an ``@argument:`` description, a blank comment line, or the end of the
-comment block.
-
-The kernel-doc function comments describe each parameter to the function, in
-order, with the ``@argument:`` descriptions. The ``@argument:`` descriptions
-must begin on the very next line following the opening brief function
-description line, with no intervening blank comment lines. The ``@argument:``
-descriptions may span multiple lines. The continuation lines may contain
-indentation. If a function parameter is ``...`` (varargs), it should be listed
-in kernel-doc notation as: ``@...:``.
-
-The return value, if any, should be described in a dedicated section at the end
-of the comment starting with "Return:".
 
 Structure, union, and enumeration documentation
 -----------------------------------------------
-- 
2.13.6
