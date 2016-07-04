Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbcGDLr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 15/51] Documentation: audio.rst: re-add captions for the examples
Date: Mon,  4 Jul 2016 08:46:36 -0300
Message-Id: <21f75a37fce50afd389b181d14fe760fb7d485f5.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The captions were lost during the format conversion.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/audio.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index 8c3314218f75..e9d99f6a259a 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -55,6 +55,7 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 .. code-block:: c
+    :caption: Example 3: Information about the current audio input
 
     struct v4l2_audio audio;
 
@@ -69,6 +70,7 @@ the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 .. code-block:: c
+    :caption: Example 4: Switching to the first audio input
 
     struct v4l2_audio audio;
 
-- 
2.7.4


