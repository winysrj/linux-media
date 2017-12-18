Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44978 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758992AbdLRMab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:31 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH v4 04/18] docs: kernel-doc.rst: improve structs chapter
Date: Mon, 18 Dec 2017 10:30:05 -0200
Message-Id: <c4ffb725fcd26ec045fb8a22a2108699fa04641b.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a mess on this chapter: it suggests that even
enums and unions should be documented with "struct". That's
not the way it should be ;-)

Fix it and move it to happen earlier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 48 +++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 3aac228fc346..e3e82f8f4de5 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -258,6 +258,30 @@ named ``Return``.
      as a new section heading, with probably won't produce the desired
      effect.
 
+Structure, union, and enumeration documentation
+-----------------------------------------------
+
+The general format of a struct, union, and enum kernel-doc comment is::
+
+  /**
+   * struct struct_name - Brief description.
+   * @argument: Description of member member_name.
+   *
+   * Description of the structure.
+   */
+
+On the above, ``struct`` is used to mean structs. You can also use ``union``
+and ``enum``  to describe unions and enums. ``argument`` is used
+to mean struct and union member names as well as enumerations in an enum.
+
+The brief description following the structure name may span multiple lines, and
+ends with a member description, a blank comment line, or the end of the
+comment block.
+
+The kernel-doc data structure comments describe each member of the structure,
+in order, with the member descriptions.
+
+
 
 Highlights and cross-references
 -------------------------------
@@ -331,30 +355,6 @@ cross-references.
 For further details, please refer to the `Sphinx C Domain`_ documentation.
 
 
-Structure, union, and enumeration documentation
------------------------------------------------
-
-The general format of a struct, union, and enum kernel-doc comment is::
-
-  /**
-   * struct struct_name - Brief description.
-   * @member_name: Description of member member_name.
-   *
-   * Description of the structure.
-   */
-
-Below, "struct" is used to mean structs, unions and enums, and "member" is used
-to mean struct and union members as well as enumerations in an enum.
-
-The brief description following the structure name may span multiple lines, and
-ends with a ``@member:`` description, a blank comment line, or the end of the
-comment block.
-
-The kernel-doc data structure comments describe each member of the structure, in
-order, with the ``@member:`` descriptions. The ``@member:`` descriptions must
-begin on the very next line following the opening brief function description
-line, with no intervening blank comment lines. The ``@member:`` descriptions may
-span multiple lines. The continuation lines may contain indentation.
 
 In-line member documentation comments
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.14.3
