Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:32629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0L3Njz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:39:55 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUDdsUP018961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:39:54 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUDcVPf021334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:39:48 -0500
Date: Thu, 30 Dec 2010 11:38:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] cx88: Remove the obsolete i2c_adapter.id field
Message-ID: <20101230113825.6fdbe2bb@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-i2c.c b/drivers/media/video/cx88/cx88-i2c.c
index f53836b..a1fe0ab 100644
--- a/drivers/media/video/cx88/cx88-i2c.c
+++ b/drivers/media/video/cx88/cx88-i2c.c
@@ -146,7 +146,6 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 	core->i2c_adap.dev.parent = &pci->dev;
 	strlcpy(core->i2c_adap.name,core->name,sizeof(core->i2c_adap.name));
 	core->i2c_adap.owner = THIS_MODULE;
-	core->i2c_adap.id = I2C_HW_B_CX2388x;
 	core->i2c_algo.udelay = i2c_udelay;
 	core->i2c_algo.data = core;
 	i2c_set_adapdata(&core->i2c_adap, &core->v4l2_dev);
diff --git a/drivers/media/video/cx88/cx88-vp3054-i2c.c b/drivers/media/video/cx88/cx88-vp3054-i2c.c
index ec5476d..d77f8ec 100644
--- a/drivers/media/video/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/video/cx88/cx88-vp3054-i2c.c
@@ -125,7 +125,6 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 	strlcpy(vp3054_i2c->adap.name, core->name,
 		sizeof(vp3054_i2c->adap.name));
 	vp3054_i2c->adap.owner = THIS_MODULE;
-	vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
 	vp3054_i2c->algo.data = dev;
 	i2c_set_adapdata(&vp3054_i2c->adap, dev);
 	vp3054_i2c->adap.algo_data = &vp3054_i2c->algo;
-- 
1.7.3.4


