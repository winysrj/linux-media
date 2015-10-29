Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37700 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbbJ2VXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:42 -0400
Received: by wicfv8 with SMTP id fv8so54102324wic.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:41 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 6/9] media: rc: nuvoton-cir: add support for the NCT6779D
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328E0F.7080102@gmail.com>
Date: Thu, 29 Oct 2015 22:22:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the NCT6779D. It's found e.g. on the Zotac CI321 mini-pc
and I successfully tested it on this device.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 1 +
 drivers/media/rc/nuvoton-cir.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index df4b9cb..ff874fc 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -43,6 +43,7 @@ static const struct nvt_chip nvt_chips[] = {
 	{ "w83667hg", NVT_W83667HG },
 	{ "NCT6775F", NVT_6775F },
 	{ "NCT6776F", NVT_6776F },
+	{ "NCT6779D", NVT_6779D },
 };
 
 static inline bool is_w83667hg(struct nvt_dev *nvt)
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 81b5a09..c96a9d3 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -70,7 +70,8 @@ enum nvt_chip_ver {
 	NVT_UNKNOWN	= 0,
 	NVT_W83667HG	= 0xa510,
 	NVT_6775F	= 0xb470,
-	NVT_6776F	= 0xc330
+	NVT_6776F	= 0xc330,
+	NVT_6779D	= 0xc560
 };
 
 struct nvt_chip {
-- 
2.6.2


