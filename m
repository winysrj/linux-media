Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61934 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752011AbdJDL6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v3 02/17] docs: kernel-doc.rst: improve private members description
Date: Wed,  4 Oct 2017 08:48:40 -0300
Message-Id: <c2e38a7b7824b2a58c9f5dbff79869aee7dea89e.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The private members section can now be moved to be together
with the arguments section. Move it there and add an example
about the usage of public:

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 56 ++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 662755f830d5..146041fc494a 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -167,6 +167,36 @@ notation as::
 
       * @...: description
 
+Private members
+~~~~~~~~~~~~~~~
+
+Inside a struct or union description, you can use the ``private:`` and
+``public:`` comment tags. Structure fields that are inside a ``private:``
+area are not listed in the generated output documentation.
+
+The ``private:`` and ``public:`` tags must begin immediately following a
+``/*`` comment marker.  They may optionally include comments between the
+``:`` and the ending ``*/`` marker.
+
+Example::
+
+  /**
+   * struct my_struct - short description
+   * @a: first member
+   * @b: second member
+   * @d: fourth member
+   *
+   * Longer description
+   */
+  struct my_struct {
+      int a;
+      int b;
+  /* private: internal use only */
+      int c;
+  /* public: the next one is public */
+      int d;
+  };
+
 
 Highlights and cross-references
 -------------------------------
@@ -332,32 +362,6 @@ on a line of their own, like all other kernel-doc comments::
         int foobar;
   }
 
-Private members
-~~~~~~~~~~~~~~~
-
-Inside a struct description, you can use the "private:" and "public:" comment
-tags. Structure fields that are inside a "private:" area are not listed in the
-generated output documentation.  The "private:" and "public:" tags must begin
-immediately following a ``/*`` comment marker.  They may optionally include
-comments between the ``:`` and the ending ``*/`` marker.
-
-Example::
-
-  /**
-   * struct my_struct - short description
-   * @a: first member
-   * @b: second member
-   *
-   * Longer description
-   */
-  struct my_struct {
-      int a;
-      int b;
-  /* private: internal use only */
-      int c;
-  };
-
-
 Typedef documentation
 ---------------------
 
-- 
2.13.6
