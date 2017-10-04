Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35417 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdJDL6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v3 05/17] docs: kernel-doc.rst: improve typedef documentation
Date: Wed,  4 Oct 2017 08:48:43 -0300
Message-Id: <412e58f3646edd61bcf7be4df7696e8f1201339d.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation about typedefs for function prototypes and
move it to happen earlier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index b330234a3601..0923c8bd5769 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -282,6 +282,28 @@ The kernel-doc data structure comments describe each member of the structure,
 in order, with the member descriptions.
 
 
+Typedef documentation
+---------------------
+
+The general format of a typedef kernel-doc comment is::
+
+  /**
+   * typedef type_name - Brief description.
+   *
+   * Description of the type.
+   */
+
+Typedefs with function prototypes can also be documented::
+
+  /**
+   * typedef type_name - Brief description.
+   * @arg1: description of arg1
+   * @arg2: description of arg2
+   *
+   * Description of the type.
+   */
+   typedef void (*type_name)(struct v4l2_ctrl *arg1, void *arg2);
+
 
 Highlights and cross-references
 -------------------------------
@@ -384,16 +406,6 @@ on a line of their own, like all other kernel-doc comments::
         int foobar;
   }
 
-Typedef documentation
----------------------
-
-The general format of a typedef kernel-doc comment is::
-
-  /**
-   * typedef type_name - Brief description.
-   *
-   * Description of the type.
-   */
 
 Overview documentation comments
 -------------------------------
-- 
2.13.6
