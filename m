Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 10/18] [media] cx2341x.rst: add the contents of fw-upload.txt
Date: Mon, 18 Jul 2016 15:30:32 -0300
Message-Id: <5e739096c2fa3ef8d56ec1d1fab8e10825fc1c61.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the contents of fw-upload.txt, after converting it to
ReST format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx2341x.rst | 53 +++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/media/v4l-drivers/cx2341x.rst
index ed7e536c9bd0..0d1bd26623b9 100644
--- a/Documentation/media/v4l-drivers/cx2341x.rst
+++ b/Documentation/media/v4l-drivers/cx2341x.rst
@@ -152,6 +152,59 @@ Missing documentation
 - Decoder VTRACE event
 
 
+The cx2341x firmware upload
+---------------------------
+
+This document describes how to upload the cx2341x firmware to the card.
+
+How to find
+~~~~~~~~~~~
+
+See the web pages of the various projects that uses this chip for information
+on how to obtain the firmware.
+
+The firmware stored in a Windows driver can be detected as follows:
+
+- Each firmware image is 256k bytes.
+- The 1st 32-bit word of the Encoder image is 0x0000da7
+- The 1st 32-bit word of the Decoder image is 0x00003a7
+- The 2nd 32-bit word of both images is 0xaa55bb66
+
+How to load
+~~~~~~~~~~~
+
+- Issue the FWapi command to stop the encoder if it is running. Wait for the
+  command to complete.
+- Issue the FWapi command to stop the decoder if it is running. Wait for the
+  command to complete.
+- Issue the I2C command to the digitizer to stop emitting VSYNC events.
+- Issue the FWapi command to halt the encoder's firmware.
+- Sleep for 10ms.
+- Issue the FWapi command to halt the decoder's firmware.
+- Sleep for 10ms.
+- Write 0x00000000 to register 0x2800 to stop the Video Display Module.
+- Write 0x00000005 to register 0x2D00 to stop the AO (audio output?).
+- Write 0x00000000 to register 0xA064 to ping? the APU.
+- Write 0xFFFFFFFE to register 0x9058 to stop the VPU.
+- Write 0xFFFFFFFF to register 0x9054 to reset the HW blocks.
+- Write 0x00000001 to register 0x9050 to stop the SPU.
+- Sleep for 10ms.
+- Write 0x0000001A to register 0x07FC to init the Encoder SDRAM's pre-charge.
+- Write 0x80000640 to register 0x07F8 to init the Encoder SDRAM's refresh to 1us.
+- Write 0x0000001A to register 0x08FC to init the Decoder SDRAM's pre-charge.
+- Write 0x80000640 to register 0x08F8 to init the Decoder SDRAM's refresh to 1us.
+- Sleep for 512ms. (600ms is recommended)
+- Transfer the encoder's firmware image to offset 0 in Encoder memory space.
+- Transfer the decoder's firmware image to offset 0 in Decoder memory space.
+- Use a read-modify-write operation to Clear bit 0 of register 0x9050 to
+  re-enable the SPU.
+- Sleep for 1 second.
+- Use a read-modify-write operation to Clear bits 3 and 0 of register 0x9058
+  to re-enable the VPU.
+- Sleep for 1 second.
+- Issue status API commands to both firmware images to verify.
+
+
 How to call the firmware API
 ----------------------------
 
-- 
2.7.4


