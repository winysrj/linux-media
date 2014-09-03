Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933953AbaICWoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 18:44:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/5] [media] sp8870: fix bad alignments
Date: Wed,  3 Sep 2014 19:43:53 -0300
Message-Id: <a16ae7d5bcc79fb4b882a611815fad05f818bfb4.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
In-Reply-To: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
References: <97e0e1e867952d369f245fce0d6791eacb40b2bb.1409784200.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by cocinelle:

drivers/media/dvb-frontends/sp8870.c:395:2-14: code aligned with following code on line 397

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 2aa8ef76eba2..57dc2abaa87b 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -394,8 +394,7 @@ static int sp8870_read_ber (struct dvb_frontend* fe, u32 * ber)
 	if (ret < 0)
 		return -EIO;
 
-	 tmp = ret << 6;
-
+	tmp = ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
1.9.3

