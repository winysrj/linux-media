Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaIWUHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 16:07:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] pt3: make pt3_pm_ops() static
Date: Tue, 23 Sep 2014 17:06:51 -0300
Message-Id: <b9eddd2b4a6d0feef963c00c0a34ef228ce3560c.1411502804.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/pt3/pt3.c:862:1: warning: symbol 'pt3_pm_ops' was not declared. Should it be static?

Cc: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 206ede0719b0..90f86ce7a001 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -859,7 +859,7 @@ static const struct pci_device_id pt3_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pt3_id_table);
 
-SIMPLE_DEV_PM_OPS(pt3_pm_ops, pt3_suspend, pt3_resume);
+static SIMPLE_DEV_PM_OPS(pt3_pm_ops, pt3_suspend, pt3_resume);
 
 static struct pci_driver pt3_driver = {
 	.name		= DRV_NAME,
-- 
1.9.3

