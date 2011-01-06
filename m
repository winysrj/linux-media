Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:3914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab1AFLc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 06:32:28 -0500
Date: Thu, 6 Jan 2011 09:28:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: moinejf@free.fr, stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] gspca - sonixj: Fix a bad probe exchange
Message-ID: <20110106092832.41f5d061@gaivota>
In-Reply-To: <cover.1294312927.git.mchehab@redhat.com>
References: <cover.1294312927.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

backport changeset 4f67f3a

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 7adadd8..6f48b46 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -1715,7 +1715,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	/* setup a selector by bridge */
 	reg_w1(gspca_dev, 0xf1, 0x01);
 	reg_r(gspca_dev, 0x00, 1);
-	reg_w1(gspca_dev, 0xf1, gspca_dev->usb_buf[0]);
+	reg_w1(gspca_dev, 0xf1, 0x00);
 	reg_r(gspca_dev, 0x00, 1);		/* get sonix chip id */
 	regF1 = gspca_dev->usb_buf[0];
 	PDEBUG(D_PROBE, "Sonix chip id: %02x", regF1);
-- 
1.7.3.4

