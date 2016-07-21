Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbcGUUS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 16:18:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 08/12] [media] doc-rst: merge v4l2-async.rst with v4l2-subdev.rst
Date: Thu, 21 Jul 2016 17:18:13 -0300
Message-Id: <82422da7040a8158d378098219fa54aa0ff38217.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
In-Reply-To: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
References: <8bf2bc4813f5dc2b797576bd9e61b4f5ee86bf22.1469132139.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Async API is actually part of the v4l2 subdev.
Move its declarations to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-async.rst  | 4 ----
 Documentation/media/kapi/v4l2-core.rst   | 1 -
 Documentation/media/kapi/v4l2-subdev.rst | 5 +++++
 3 files changed, 5 insertions(+), 5 deletions(-)
 delete mode 100644 Documentation/media/kapi/v4l2-async.rst

diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/media/kapi/v4l2-async.rst
deleted file mode 100644
index 372aa29fbf29..000000000000
--- a/Documentation/media/kapi/v4l2-async.rst
+++ /dev/null
@@ -1,4 +0,0 @@
-V4L2 Async kAPI
-^^^^^^^^^^^^^^^
-
-.. kernel-doc:: include/media/v4l2-async.h
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index 8c127ccdb0ae..fc623e9ca871 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -5,7 +5,6 @@ Video2Linux devices
     :maxdepth: 1
 
     v4l2-framework
-    v4l2-async
     v4l2-controls
     v4l2-device
     v4l2-dv-timings
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index 101902c930b9..829016940597 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -266,3 +266,8 @@ V4L2 subdev kAPI
 ^^^^^^^^^^^^^^^^
 
 .. kernel-doc:: include/media/v4l2-subdev.h
+
+V4L2 subdev async kAPI
+^^^^^^^^^^^^^^^^^^^^^^
+
+.. kernel-doc:: include/media/v4l2-async.h
-- 
2.7.4

