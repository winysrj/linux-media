Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbZKGVvq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:46 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:49 +0000
Message-ID: <1257630709.15927.428.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 34/75] ivtv: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/ivtv/ivtv-firmware.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
index c1b7ec4..fd74d41 100644
--- a/drivers/media/video/ivtv/ivtv-firmware.c
+++ b/drivers/media/video/ivtv/ivtv-firmware.c
@@ -41,6 +41,7 @@
 
 #define IVTV_DECODE_INIT_MPEG_FILENAME 	"v4l-cx2341x-init.mpg"
 #define IVTV_DECODE_INIT_MPEG_SIZE 	(152*1024)
+MODULE_FIRMWARE(IVTV_DECODE_INIT_MPEG_FILENAME);
 
 /* Encoder/decoder firmware sizes */
 #define IVTV_FW_ENC_SIZE 		(376836)
@@ -171,6 +172,8 @@ static int ivtv_firmware_copy(struct ivtv *itv)
 	}
 	return 0;
 }
+MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
+MODULE_FIRMWARE(CX2341X_FIRM_DEC_FILENAME);
 
 static volatile struct ivtv_mailbox __iomem *ivtv_search_mailbox(const volatile u8 __iomem *mem, u32 size)
 {
-- 
1.6.5.2



