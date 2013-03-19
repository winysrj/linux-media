Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3CSRX5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:23:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/46] [media] siano: store firmware version
Date: Tue, 19 Mar 2013 13:48:59 -0300
Message-Id: <1363711775-2120-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As there are some changes that seem to be firmware-dependent,
we need to store the firmware version, as we don't want to break
support for existing cards that use a legacy (and sometimes
custom) firmware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 2 ++
 drivers/media/common/siano/smscoreapi.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 7377c16..0bfb429 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1360,6 +1360,8 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			coredev->mode = ver->FirmwareId == 255 ?
 				DEVICE_MODE_NONE : ver->FirmwareId;
 			coredev->modes_supported = ver->SupportedProtocols;
+			coredev->fw_version = ver->RomVersionMajor << 8 |
+					      ver->RomVersionMinor;
 
 			complete(&coredev->version_ex_done);
 			break;
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index fc451e2..f1440a5 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -178,6 +178,7 @@ struct smscore_device_t {
 	/* Firmware */
 	u8 *fw_buf;
 	u32 fw_buf_size;
+	u16 fw_version;
 
 	/* Infrared (IR) */
 	struct ir_t ir;
-- 
1.8.1.4

