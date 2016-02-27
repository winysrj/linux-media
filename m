Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbcB0Kva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:30 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/7] [media] pt3: fix device identification
Date: Sat, 27 Feb 2016 07:51:11 -0300
Message-Id: <191e1434e72b442507d8e4dbae55644ce38b5be1.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/pt3/pt3.c:398 pt3_attach_fe() error: strncmp() '"tc90522sat"' too small (11 vs 20)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/pt3/pt3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 0d2e2b217121..eff5e9f51ace 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -395,7 +395,8 @@ static int pt3_attach_fe(struct pt3_board *pt3, int i)
 	if (!try_module_get(cl->dev.driver->owner))
 		goto err_demod_i2c_unregister_device;
 
-	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT, sizeof(cl->name))) {
+	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT,
+		     strlen(TC90522_I2C_DEV_SAT))) {
 		struct qm1d1c0042_config tcfg;
 
 		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
-- 
2.5.0

