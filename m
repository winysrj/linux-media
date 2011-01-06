Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:48313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1AFT7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 14:59:50 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Kyle McMartin <kmcmartin@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/6] rc/ene_ir: fix oops on module load
Date: Thu,  6 Jan 2011 14:59:33 -0500
Message-Id: <1294343977-31929-3-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Kyle McMartin <kmcmartin@redhat.com>

dev->rdev is accessed in ene_setup_hw_settings, so it needs to be wired
up before then.

[Jarod Wilson]: Also fix a possible improper resource freeing bug while
we're looking at possible probe issues here.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ene_ir.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 80b3c31..885abdd 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1004,6 +1004,10 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	/* validate resources */
 	error = -ENODEV;
 
+	/* init these to -1, as 0 is valid for both */
+	dev->hw_io = -1;
+	dev->irq = -1;
+
 	if (!pnp_port_valid(pnp_dev, 0) ||
 	    pnp_port_len(pnp_dev, 0) < ENE_IO_SIZE)
 		goto error;
@@ -1072,6 +1076,8 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 		rdev->input_name = "ENE eHome Infrared Remote Transceiver";
 	}
 
+	dev->rdev = rdev;
+
 	ene_rx_setup_hw_buffer(dev);
 	ene_setup_default_settings(dev);
 	ene_setup_hw_settings(dev);
@@ -1083,7 +1089,6 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	if (error < 0)
 		goto error;
 
-	dev->rdev = rdev;
 	ene_notice("driver has been succesfully loaded");
 	return 0;
 error:
-- 
1.7.3.4

