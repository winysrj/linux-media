Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55724
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S966562AbdIZR71 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 06/10] docs: kernel-doc: improve typedef documentation
Date: Tue, 26 Sep 2017 14:59:16 -0300
Message-Id: <ee1660a659d071477e5c0da0549a540011e6a4ad.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation about typedefs for function prototypes and
move it to happen earlier.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/doc-guide/kernel-doc.rst | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 68cb1b496c73..9777aa53e3dd 100644
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
2.13.5
