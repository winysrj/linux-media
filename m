Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42381 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbZKGVvS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:18 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:21 +0000
Message-ID: <1257630681.15927.423.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/cx18/cx18-av-firmware.c |    1 +
 drivers/media/video/cx18/cx18-dvb.c         |    2 ++
 drivers/media/video/cx18/cx18-firmware.c    |    3 +++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/media/video/cx18/cx18-av-firmware.c
index b9e8cc5..137445c 100644
--- a/drivers/media/video/cx18/cx18-av-firmware.c
+++ b/drivers/media/video/cx18/cx18-av-firmware.c
@@ -32,6 +32,7 @@
 #define CX18_AI1_MUX_INVALID 0x30
 
 #define FWFILE "v4l-cx23418-dig.fw"
+MODULE_FIRMWARE(FWFILE);
 
 static int cx18_av_verifyfw(struct cx18 *cx, const struct firmware *fw)
 {
diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/cx18/cx18-dvb.c
index 51a0c33..9f70168 100644
--- a/drivers/media/video/cx18/cx18-dvb.c
+++ b/drivers/media/video/cx18/cx18-dvb.c
@@ -131,6 +131,8 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
 	return ret;
 }
 
+MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
+
 static int yuan_mpc718_mt352_init(struct dvb_frontend *fe)
 {
 	struct cx18_dvb *dvb = container_of(fe->dvb,
diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
index 83cd559..4ac4b81 100644
--- a/drivers/media/video/cx18/cx18-firmware.c
+++ b/drivers/media/video/cx18/cx18-firmware.c
@@ -446,3 +446,6 @@ int cx18_firmware_init(struct cx18 *cx)
 	cx18_write_reg_expect(cx, 0x14001400, 0xc78110, 0x00001400, 0x14001400);
 	return 0;
 }
+
+MODULE_FIRMWARE("v4l-cx23418-cpu.fw");
+MODULE_FIRMWARE("v4l-cx23418-apu.fw");
-- 
1.6.5.2



