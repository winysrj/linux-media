Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:47537 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637AbcACMkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2016 07:40:39 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: bt8xx: constify sp887x_config structure
Date: Sun,  3 Jan 2016 13:27:53 +0100
Message-Id: <1451824073-6962-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sp887x_config structure is never modified, so declare it as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This patch and the previous one on the same file can be applied in any order.

 drivers/media/pci/bt8xx/dvb-bt8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index d407244..a3aa0cd 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -318,7 +318,7 @@ static int microtune_mt7202dtf_request_firmware(struct dvb_frontend* fe, const s
 	return request_firmware(fw, name, &bt->bt->dev->dev);
 }
 
-static struct sp887x_config microtune_mt7202dtf_config = {
+static const struct sp887x_config microtune_mt7202dtf_config = {
 	.demod_address = 0x70,
 	.request_firmware = microtune_mt7202dtf_request_firmware,
 };

