Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbJAWRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:43 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sergey Kozlov <serjk@netup.ru>
Subject: [PATCH 4/7] [media] netup_unidvb_ci: Fix dereference of noderef expression
Date: Thu,  1 Oct 2015 19:17:26 -0300
Message-Id: <340ccedb76593a2961ad5dd72b33894dd755a358.1443737683.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those sparse warnings:
	drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:150:40: warning: dereference of noderef expression
	drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:165:31: warning: dereference of noderef expression
	drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:174:36: warning: dereference of noderef expression
	drivers/media/pci/netup_unidvb/netup_unidvb_ci.c:189:27: warning: dereference of noderef expression

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
index 0bfb14c9e527..f46ffac66ee9 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
@@ -147,7 +147,7 @@ static int netup_unidvb_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
 {
 	struct netup_ci_state *state = en50221->data;
 	struct netup_unidvb_dev *dev = state->dev;
-	u8 val = state->membase8_config[addr];
+	u8 val = *((u8 __force *)state->membase8_io + addr);
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x val=0x%x\n", __func__, addr, val);
@@ -162,7 +162,7 @@ static int netup_unidvb_ci_write_attribute_mem(struct dvb_ca_en50221 *en50221,
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x data=0x%x\n", __func__, addr, data);
-	state->membase8_config[addr] = data;
+	*((u8 __force *)state->membase8_io + addr) = data;
 	return 0;
 }
 
@@ -171,7 +171,7 @@ static int netup_unidvb_ci_read_cam_ctl(struct dvb_ca_en50221 *en50221,
 {
 	struct netup_ci_state *state = en50221->data;
 	struct netup_unidvb_dev *dev = state->dev;
-	u8 val = state->membase8_io[addr];
+	u8 val = *((u8 __force *)state->membase8_io + addr);
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x val=0x%x\n", __func__, addr, val);
@@ -186,7 +186,7 @@ static int netup_unidvb_ci_write_cam_ctl(struct dvb_ca_en50221 *en50221,
 
 	dev_dbg(&dev->pci_dev->dev,
 		"%s(): addr=0x%x data=0x%x\n", __func__, addr, data);
-	state->membase8_io[addr] = data;
+	*((u8 __force *)state->membase8_io + addr) = data;
 	return 0;
 }
 
-- 
2.4.3


