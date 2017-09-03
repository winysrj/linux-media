Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50943
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752869AbdICCfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Sep 2017 22:35:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH 09/12] media: docs: don't show ToC for each part on PDF output
Date: Sat,  2 Sep 2017 23:35:01 -0300
Message-Id: <55f58b3978352d4d4e5ac23e192715a92fc0cd08.1504405125.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504405124.git.mchehab@s-opensource.com>
References: <cover.1504405124.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "Table of Contents" of a PDF file is generated only once,
at the beginning fo the output. It doesn't produce it on
each part.

So, don't output this text on each part of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/cec-drivers/index.rst              | 4 +++-
 Documentation/media/dvb-drivers/index.rst              | 4 +++-
 Documentation/media/media_kapi.rst                     | 4 +++-
 Documentation/media/media_uapi.rst                     | 4 +++-
 Documentation/media/uapi/cec/cec-api.rst               | 5 ++++-
 Documentation/media/uapi/dvb/dvbapi.rst                | 4 +++-
 Documentation/media/uapi/mediactl/media-controller.rst | 4 +++-
 Documentation/media/uapi/rc/remote_controllers.rst     | 4 +++-
 Documentation/media/uapi/v4l/v4l2.rst                  | 4 +++-
 Documentation/media/v4l-drivers/index.rst              | 4 +++-
 10 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/cec-drivers/index.rst b/Documentation/media/cec-drivers/index.rst
index 1c817aa10bb6..7ef204823422 100644
--- a/Documentation/media/cec-drivers/index.rst
+++ b/Documentation/media/cec-drivers/index.rst
@@ -21,7 +21,9 @@ more details.
 
 For more details see the file COPYING in the source distribution of Linux.
 
-.. class:: toc-title
+.. only:: html
+
+    .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index ea0da6d63299..376141143ae9 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -19,7 +19,9 @@ more details.
 
 For more details see the file COPYING in the source distribution of Linux.
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
 	Table of Contents
 
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index bc0638956a43..83da736fad72 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -20,7 +20,9 @@ more details.
 
 For more details see the file COPYING in the source distribution of Linux.
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index fd8ebe002cd2..28eb35a1f965 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -14,7 +14,9 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index bb018709970c..b68ca9c1d2e0 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -10,7 +10,10 @@ Part V - Consumer Electronics Control API
 
 This part describes the CEC: Consumer Electronics Control
 
-.. class:: toc-title
+
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 7d26e98e5a41..18c86b3a3af1 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -28,7 +28,9 @@ Part II - Digital TV API
 
 **Version 5.10**
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 7ae38d48969e..0eea4f9a07d5 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -8,7 +8,9 @@
 Part IV - Media Controller API
 ##############################
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index 3e25cc9f65e0..46a8acb82125 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -8,7 +8,9 @@
 Part III - Remote Controller API
 ################################
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index f52a11c949d3..297c293d4c93 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -11,7 +11,9 @@ This part describes the Video for Linux API version 2 (V4L2 API) specification.
 
 **Revision 4.5**
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 10f2ce42ece2..3643e63c4e46 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -21,7 +21,9 @@ more details.
 
 For more details see the file COPYING in the source distribution of Linux.
 
-.. class:: toc-title
+.. only:: html
+
+   .. class:: toc-title
 
         Table of Contents
 
-- 
2.13.5
