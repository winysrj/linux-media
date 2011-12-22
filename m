Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:61371 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1LVG3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 01:29:46 -0500
Date: Thu, 22 Dec 2011 09:29:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] Staging: dt3155v4l: probe() always fails
Message-ID: <20111222062934.GB19975@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were some curly braces missing so the probe() function always
failed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 25c6025..280c84e 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -908,9 +908,10 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_req_region;
 	pd->regs = pci_iomap(pdev, 0, pci_resource_len(pd->pdev, 0));
-	if (!pd->regs)
+	if (!pd->regs) {
 		err = -ENOMEM;
 		goto err_pci_iomap;
+	}
 	err = dt3155_init_board(pdev);
 	if (err)
 		goto err_init_board;
