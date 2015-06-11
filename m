Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36083 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbbFKGFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 02:05:38 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0042A2A0376
	for <linux-media@vger.kernel.org>; Thu, 11 Jun 2015 08:05:25 +0200 (CEST)
Message-ID: <55792525.9030003@xs4all.nl>
Date: Thu, 11 Jun 2015 08:05:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mantis: fix unused variable compiler warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mantis_i2c.c:222:15: warning: variable 'intmask' set but not used [-Wunused-but-set-variable]
  u32 intstat, intmask;
               ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index a938234..9abe1c7 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -219,7 +219,7 @@ static struct i2c_algorithm mantis_algo = {
 
 int mantis_i2c_init(struct mantis_pci *mantis)
 {
-	u32 intstat, intmask;
+	u32 intstat;
 	struct i2c_adapter *i2c_adapter = &mantis->adapter;
 	struct pci_dev *pdev		= mantis->pdev;
 
@@ -242,7 +242,6 @@ int mantis_i2c_init(struct mantis_pci *mantis)
 	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
 
 	intstat = mmread(MANTIS_INT_STAT);
-	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite(intstat, MANTIS_INT_STAT);
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
 	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
