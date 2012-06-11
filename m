Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58684 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2FKTSN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 15:18:13 -0400
Received: by yenm10 with SMTP id m10so2823177yen.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 12:18:12 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
	Gianluca Gennari <gennarone@gmail.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/3] em28xx: Remove unused AC97 register definitions
Date: Mon, 11 Jun 2012 16:17:24 -0300
Message-Id: <1339442244-11546-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1339442244-11546-1-git-send-email-elezegarcia@gmail.com>
References: <1339442244-11546-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a specific header sound/ac97_codec.h that defines these.
All drivers should use it instead of rolling its own set of macros.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-reg.h |   51 +------------------------------
 1 files changed, 1 insertions(+), 50 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-reg.h b/drivers/media/video/em28xx/em28xx-reg.h
index 2f62685..6ff3682 100644
--- a/drivers/media/video/em28xx/em28xx-reg.h
+++ b/drivers/media/video/em28xx/em28xx-reg.h
@@ -211,58 +211,9 @@ enum em28xx_chip_id {
 };
 
 /*
- * Registers used by em202 and other AC97 chips
+ * Registers used by em202
  */
 
-/* Standard AC97 registers */
-#define AC97_RESET               0x00
-
-	/* Output volumes */
-#define AC97_MASTER_VOL          0x02
-#define AC97_LINE_LEVEL_VOL      0x04	/* Some devices use for headphones */
-#define AC97_MASTER_MONO_VOL     0x06
-
-	/* Input volumes */
-#define AC97_PC_BEEP_VOL         0x0a
-#define AC97_PHONE_VOL           0x0c
-#define AC97_MIC_VOL             0x0e
-#define AC97_LINEIN_VOL          0x10
-#define AC97_CD_VOL              0x12
-#define AC97_VIDEO_VOL           0x14
-#define AC97_AUX_VOL             0x16
-#define AC97_PCM_OUT_VOL         0x18
-
-	/* capture registers */
-#define AC97_RECORD_SELECT       0x1a
-#define AC97_RECORD_GAIN         0x1c
-
-	/* control registers */
-#define AC97_GENERAL_PURPOSE     0x20
-#define AC97_3D_CTRL             0x22
-#define AC97_AUD_INT_AND_PAG     0x24
-#define AC97_POWER_DOWN_CTRL     0x26
-#define AC97_EXT_AUD_ID          0x28
-#define AC97_EXT_AUD_CTRL        0x2a
-
-/* Supported rate varies for each AC97 device
-   if write an unsupported value, it will return the closest one
- */
-#define AC97_PCM_OUT_FRONT_SRATE 0x2c
-#define AC97_PCM_OUT_SURR_SRATE  0x2e
-#define AC97_PCM_OUT_LFE_SRATE   0x30
-#define AC97_PCM_IN_SRATE        0x32
-
-	/* For devices with more than 2 channels, extra output volumes */
-#define AC97_LFE_MASTER_VOL      0x36
-#define AC97_SURR_MASTER_VOL     0x38
-
-	/* Digital SPDIF output control */
-#define AC97_SPDIF_OUT_CTRL      0x3a
-
-	/* Vendor ID identifier */
-#define AC97_VENDOR_ID1          0x7c
-#define AC97_VENDOR_ID2          0x7e
-
 /* EMP202 vendor registers */
 #define EM202_EXT_MODEM_CTRL     0x3e
 #define EM202_GPIO_CONF          0x4c
-- 
1.7.4.4

