Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 35/41] Documentation: dev-codec.rst: Fix a reference for _STREAMON
Date: Mon,  4 Jul 2016 22:31:10 -0300
Message-Id: <5550ef4dd9bf676c6295472940d049dfb96cdf3b.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The referenced ioctl there is only VIDIOC_STREAMON, so we
should override the name, to avoid it to also show _STREAMOFF.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-codec.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-codec.rst b/Documentation/linux_tv/media/v4l/dev-codec.rst
index 5e834d51309e..7fd28d085c2c 100644
--- a/Documentation/linux_tv/media/v4l/dev-codec.rst
+++ b/Documentation/linux_tv/media/v4l/dev-codec.rst
@@ -15,7 +15,7 @@ A memory-to-memory video node acts just like a normal video node, but it
 supports both output (sending frames from memory to the codec hardware)
 and capture (receiving the processed frames from the codec hardware into
 memory) stream I/O. An application will have to setup the stream I/O for
-both sides and finally call :ref:`VIDIOC_STREAMON`
+both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 for both capture and output to start the codec.
 
 Video compression codecs use the MPEG controls to setup their codec
-- 
2.7.4

