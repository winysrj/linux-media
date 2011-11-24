Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1KXRFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:05:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAOH5WEX019647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 12:05:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] em28xx: Fix a few warnings due to HVR-930C addition
Date: Thu, 24 Nov 2011 15:05:20 -0200
Message-Id: <1322154321-24028-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/em28xx/em28xx-cards.c:339:30: warning: ‘hauppauge_930c_gpio’ defined but not used [-Wunused-variable]
drivers/media/video/em28xx/em28xx-dvb.c: In function ‘em28xx_dvb_init’:
drivers/media/video/em28xx/em28xx-dvb.c:886:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    2 +-
 drivers/media/video/em28xx/em28xx-dvb.c   |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index f63a715..5b0336b 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -336,6 +336,7 @@ static struct em28xx_reg_seq pctv_460e[] = {
 	{             -1,   -1,   -1,  -1},
 };
 
+#if 0
 static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{EM2874_R80_GPIO,	0x6f,	0xff,	10},
 	{EM2874_R80_GPIO,	0x4f,	0xff,	10}, /* xc5000 reset */
@@ -344,7 +345,6 @@ static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{ -1,			-1,	-1,	-1},
 };
 
-#if 0
 static struct em28xx_reg_seq hauppauge_930c_digital[] = {
 	{EM2874_R80_GPIO,	0xf6,	0xff,	10},
 	{EM2874_R80_GPIO,	0xe6,	0xff,	100},
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 55a9008..ea2208e 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -864,6 +864,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
+	{
+		struct xc5000_config cfg;
 		hauppauge_hvr930c_init(dev);
 
 		dvb->dont_attach_fe1 = 1;
@@ -883,7 +885,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[1]->id = 1;
 
 		/* Attach xc5000 */
-		struct xc5000_config cfg;
 		memset(&cfg, 0, sizeof(cfg));
 		cfg.i2c_address  = 0x61;
 		cfg.if_khz = 4000;
@@ -906,6 +907,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		       sizeof(dvb->fe[0]->ops.tuner_ops));
 
 		break;
+	}
 	case EM2884_BOARD_TERRATEC_H5:
 		terratec_h5_init(dev);
 
-- 
1.7.7.1

