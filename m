Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLWQr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 11:47:57 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] cx88-dvb: whitespace cleanup
Date: Tue, 23 Dec 2014 14:47:47 -0200
Message-Id: <1419353267-7588-1-git-send-email-mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following smatch warning:
	drivers/media/pci/cx88//cx88-dvb.c:1508 dvb_register() warn: if statement not indented

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/cx88/cx88-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 5780e2f013b4..1b2ed238cdb6 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -1504,8 +1504,8 @@ static int dvb_register(struct cx8802_dev *dev)
 			fe0->dvb.frontend = dvb_attach(stv0288_attach,
 							    &tevii_tuner_earda_config,
 							    &core->i2c_adap);
-				if (fe0->dvb.frontend != NULL) {
-					if (!dvb_attach(stb6000_attach, fe0->dvb.frontend, 0x61,
+			if (fe0->dvb.frontend != NULL) {
+				if (!dvb_attach(stb6000_attach, fe0->dvb.frontend, 0x61,
 						&core->i2c_adap))
 					goto frontend_detach;
 				core->prev_set_voltage = fe0->dvb.frontend->ops.set_voltage;
-- 
2.1.0

