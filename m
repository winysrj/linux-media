Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48897 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab0LNTM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:12:58 -0500
Date: Tue, 14 Dec 2010 20:15:00 +0100
From: =?UTF-8?B?SmVhbi1GcmFuw6dvaXM=?= Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/6] gspca - sonixj: Fix a bad probe exchange
Message-ID: <20101214201500.3990da9e@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 4660cbe..5978676 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1794,7 +1794,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	/* setup a selector by bridge */
 	reg_w1(gspca_dev, 0xf1, 0x01);
 	reg_r(gspca_dev, 0x00, 1);
-	reg_w1(gspca_dev, 0xf1, gspca_dev->usb_buf[0]);
+	reg_w1(gspca_dev, 0xf1, 0x00);
 	reg_r(gspca_dev, 0x00, 1);		/* get sonix chip id */
 	regF1 = gspca_dev->usb_buf[0];
 	if (gspca_dev->usb_err < 0)
@@ -2289,10 +2289,10 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
 	u8 reg0102[2];
-	const u8 *reg9a;
 	u8 reg1, reg17;
 	const u8 *sn9c1xx;
 	const u8 (*init)[8];
+	const u8 *reg9a;
 	int mode;
 	static const u8 reg9a_def[] =
 		{0x00, 0x40, 0x20, 0x00, 0x00, 0x00};
-- 
1.7.2.3

