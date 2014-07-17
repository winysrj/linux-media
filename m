Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41645 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaGQW0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 18:26:36 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so7634177wiw.12
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 15:26:35 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH 1/1] si2168: Support Si2168-A20 firmware downloading.
Date: Thu, 17 Jul 2014 23:26:29 +0100
Message-Id: <1405635989-23758-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for the Si2168-A20 firmware download.
Extracting the firmware:

wget http://www.tbsdtv.com/download/document/tbs6281/tbs6281-t2-t-driver_v1.0.0.6.zip
unzip tbs6281-t2-t-driver_v1.0.0.6.zip
dd if=tbs-6281_x64/tbs6281_64.sys of=dvb-demod-si2168-a20-01.fw count=28656 bs=1 skip=1625088

md5sum:
32e06713b33915f674bfb2c209beaea5 /lib/firmware/dvb-demod-si2168-a20-01.fw

Regards,
Luis

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c      | 4 ++++
 drivers/media/dvb-frontends/si2168_priv.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7e45eeab..ad38c17 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -377,10 +377,14 @@ static int si2168_init(struct dvb_frontend *fe)
 	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
 			cmd.args[4] << 0;
 
+	#define SI2168_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
 	#define SI2168_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
 	#define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
 
 	switch (chip_id) {
+	case SI2168_A20:
+		fw_file = SI2168_A20_FIRMWARE;
+		break;
 	case SI2168_A30:
 		fw_file = SI2168_A30_FIRMWARE;
 		break;
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index bebb68a..ebbf502 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
 
+#define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
 #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
-- 
1.9.1

