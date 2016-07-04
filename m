Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 07/51] Documentation: video.rst: use reference for VIDIOC_ENUMINPUT
Date: Mon,  4 Jul 2016 08:46:28 -0300
Message-Id: <3898aca56b5af23c0773c928083ab58d23a078d3.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using const, transform it into a reference.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/video.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index 803bb37f4be8..f214bd835622 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -17,8 +17,8 @@ outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` and
 :ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` ioctl, respectively. The
 struct :ref:`v4l2_input <v4l2-input>` returned by the
-``VIDIOC_ENUMINPUT`` ioctl also contains signal status information
-applicable when the current video input is queried.
+:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` ioctl also contains signal
+:status information applicable when the current video input is queried.
 
 The :ref:`VIDIOC_G_INPUT <vidioc-g-input>` and
 :ref:`VIDIOC_G_OUTPUT <vidioc-g-output>` ioctls return the index of
-- 
2.7.4


