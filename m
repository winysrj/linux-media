Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbcGDLrX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 10/51] Documentation: audio.rst: Fix some cross references
Date: Mon,  4 Jul 2016 08:46:31 -0300
Message-Id: <4b5f8836b66635a2f2a951f6200d103a7e04930e.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several constants there that should be, instead,
cross-references. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/audio.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index 5e37adfbb49c..95622902e86e 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -30,16 +30,16 @@ outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` and
 :ref:`VIDIOC_ENUMAUDOUT <vidioc-enumaudioout>` ioctl, respectively.
 The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
-``VIDIOC_ENUMAUDIO`` ioctl also contains signal status information
-applicable when the current audio input is queried.
+:ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` ioctl also contains signal
+:status information applicable when the current audio input is queried.
 
 The :ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` and
 :ref:`VIDIOC_G_AUDOUT <vidioc-g-audioout>` ioctls report the current
 audio input and output, respectively. Note that, unlike
 :ref:`VIDIOC_G_INPUT <vidioc-g-input>` and
 :ref:`VIDIOC_G_OUTPUT <vidioc-g-output>` these ioctls return a
-structure as ``VIDIOC_ENUMAUDIO`` and ``VIDIOC_ENUMAUDOUT`` do, not just
-an index.
+structure as :ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` and
+:ref:`VIDIOC_ENUMAUDOUT <vidioc-enumaudioout>` do, not just an index.
 
 To select an audio input and change its properties applications call the
 :ref:`VIDIOC_S_AUDIO <vidioc-g-audio>` ioctl. To select an audio
-- 
2.7.4


