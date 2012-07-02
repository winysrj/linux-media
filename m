Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:51911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab2GBB6v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 21:58:51 -0400
Date: Mon, 2 Jul 2012 11:58:52 +1000
From: Anton Blanchard <anton@samba.org>
To: mchehab@infradead.org, david@hardeman.nu
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] winbond-cir: Initialise timeout, driver_type
 and allowed_protos
Message-ID: <20120702115852.6c0fe919@kryten>
In-Reply-To: <20120702115800.1275f944@kryten>
References: <20120702115800.1275f944@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


We need to set a timeout so we can go idle on no activity.

We weren't setting driver_type and allowed_protos, so fix that
up too.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux/drivers/media/rc/winbond-cir.c
===================================================================
--- linux.orig/drivers/media/rc/winbond-cir.c	2012-06-18 10:32:54.436717423 +1000
+++ linux/drivers/media/rc/winbond-cir.c	2012-06-18 10:33:00.192754858 +1000
@@ -1032,6 +1032,9 @@ wbcir_probe(struct pnp_dev *device, cons
 	data->dev->tx_ir = wbcir_tx;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
+	data->dev->timeout = MS_TO_NS(100);
+	data->dev->driver_type = RC_DRIVER_IR_RAW;
+	data->dev->allowed_protos = RC_TYPE_ALL;
 
 	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
 		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
