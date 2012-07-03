Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38570 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2GCUcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 16:32:05 -0400
Date: Tue, 3 Jul 2012 22:22:54 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Anton Blanchard <anton@samba.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] winbond-cir: Initialise timeout, driver_type
 and allowed_protos
Message-ID: <20120703202254.GB29839@hardeman.nu>
References: <20120702115800.1275f944@kryten>
 <20120702115852.6c0fe919@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120702115852.6c0fe919@kryten>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 02, 2012 at 11:58:52AM +1000, Anton Blanchard wrote:
>
>We need to set a timeout so we can go idle on no activity.

This change Acked-by: David Härdeman <david@hardeman.nu>

>We weren't setting driver_type and allowed_protos, so fix that
>up too.

driver_type is set in the upstream tree.

allowed_protos isn't used for RC_DRIVER_IR_RAW type drivers (IIRC).

>
>Signed-off-by: Anton Blanchard <anton@samba.org>
>---
>
>Index: linux/drivers/media/rc/winbond-cir.c
>===================================================================
>--- linux.orig/drivers/media/rc/winbond-cir.c	2012-06-18 10:32:54.436717423 +1000
>+++ linux/drivers/media/rc/winbond-cir.c	2012-06-18 10:33:00.192754858 +1000
>@@ -1032,6 +1032,9 @@ wbcir_probe(struct pnp_dev *device, cons
> 	data->dev->tx_ir = wbcir_tx;
> 	data->dev->priv = data;
> 	data->dev->dev.parent = &device->dev;
>+	data->dev->timeout = MS_TO_NS(100);
>+	data->dev->driver_type = RC_DRIVER_IR_RAW;
>+	data->dev->allowed_protos = RC_TYPE_ALL;
> 
> 	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
> 		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
>

