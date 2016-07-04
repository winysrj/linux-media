Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 09/51] Documentation: video.rst: Restore the captions for the examples
Date: Mon,  4 Jul 2016 08:46:30 -0300
Message-Id: <69f9771c659958ecc7c8ba26e85c2f61f821b022.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two examples in the code, but the captions of them
were lost during the ReST conversion. Manually add them again.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/video.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index f214bd835622..fc220be52c2b 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -28,8 +28,8 @@ applications call the :ref:`VIDIOC_S_INPUT <vidioc-g-input>` and
 implement all the input ioctls when the device has one or more inputs,
 all the output ioctls when the device has one or more outputs.
 
-
 .. code-block:: c
+    :caption: Example 1: Information about the current video input
 
     struct v4l2_input input;
     int index;
@@ -51,6 +51,7 @@ all the output ioctls when the device has one or more outputs.
 
 
 .. code-block:: c
+    :caption: Example 2: Switching to the first video input
 
     int index;
 
-- 
2.7.4


