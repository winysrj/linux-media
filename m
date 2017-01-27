Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:37851 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754214AbdA0IHt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 03:07:49 -0500
Date: Fri, 27 Jan 2017 11:06:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mantis_dvb: fix some error codes in mantis_dvb_init()
Message-ID: <20170127080622.GA4153@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should be returning negative error codes here or it leads to a crash.
This also silences a static checker warning.

	drivers/media/pci/mantis/mantis_cards.c:250 mantis_pci_probe()
	warn: 'mantis->dmxdev.dvbdev->fops' double freed

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
index 5a71e1791cf5..0db4de3a2285 100644
--- a/drivers/media/pci/mantis/mantis_dvb.c
+++ b/drivers/media/pci/mantis/mantis_dvb.c
@@ -226,11 +226,12 @@ int mantis_dvb_init(struct mantis_pci *mantis)
 			goto err5;
 		} else {
 			if (mantis->fe == NULL) {
+				result = -ENOMEM;
 				dprintk(MANTIS_ERROR, 1, "FE <NULL>");
 				goto err5;
 			}
-
-			if (dvb_register_frontend(&mantis->dvb_adapter, mantis->fe)) {
+			result = dvb_register_frontend(&mantis->dvb_adapter, mantis->fe);
+			if (result) {
 				dprintk(MANTIS_ERROR, 1, "ERROR: Frontend registration failed");
 
 				if (mantis->fe->ops.release)
