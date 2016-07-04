Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbcGDLr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 16/51] Documentation: standard.rst: read the example captions
Date: Mon,  4 Jul 2016 08:46:37 -0300
Message-Id: <76d2d63ca7fcb336dadf6848de66838dd5bace54.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those got lost during format conversion.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/standard.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index 20c0d044a129..11d1a7183c73 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -66,6 +66,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
+    :caption: Example 5: Information about the current video standard
 
     v4l2_std_id std_id;
     struct v4l2_standard standard;
@@ -101,6 +102,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
+    :caption: Example 6: Listing the video standards supported by the current input
 
     struct v4l2_input input;
     struct v4l2_standard standard;
@@ -139,6 +141,7 @@ standard ioctls can be used with the given input or output.
 
 
 .. code-block:: c
+    :caption: Example 7: Selecting a new video standard
 
     struct v4l2_input input;
     v4l2_std_id std_id;
-- 
2.7.4


