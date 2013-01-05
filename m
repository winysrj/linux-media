Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3AEEH1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 23:07:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrice Chotard <patricechotard@free.fr>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] ngene: fix commit 36a495a336c3fbbb2f4eeed2a94ab6d5be19d186
Date: Sat,  5 Jan 2013 02:06:42 -0200
Message-Id: <1357358802-17296-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The above commit were applied only partially; it broke tuner and
demod attach, but the part that added it to ngene_info was missing.

Not sure what happened there, but, without this patch, a regression
would be happening.

Also, gcc complains about a defined but not used symbol.

So, apply manually the missing part.

Cc: Patrice Chotard <patricechotard@free.fr>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/ngene/ngene-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 2a4895b..82318d1 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -732,6 +732,7 @@ static struct ngene_info ngene_info_terratec = {
 	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
 	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
+	.tuner_attach	= {tuner_attach_dtt7520x, tuner_attach_dtt7520x},
 	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
 	.i2c_access     = 1,
 };
-- 
1.7.11.7

