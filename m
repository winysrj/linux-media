Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-n.franken.de ([193.175.24.27]:57803 "EHLO
	mail-n.franken.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2AXU67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 15:58:59 -0500
Received: from aqua.hirmke.de (aquarius.franken.de [193.175.24.89])
	by mail-n.franken.de (Postfix) with ESMTP id 9BD181C0C0BD8
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 21:36:07 +0100 (CET)
Received: from calimero.vinschen.de (calimero.vinschen.de [192.168.129.6])
	by aqua.hirmke.de (Postfix) with ESMTP id D7AC626C066
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 21:36:06 +0100 (CET)
Date: Tue, 24 Jan 2012 21:36:05 +0100
From: Corinna Vinschen <vinschen@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] imon: Input from ffdc device type ignored
Message-ID: <20120124203605.GQ2456@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have an iMON device (device ID 15c2:ffdc) in my multimedia pc, which
worked without too many problems with pre-3.x kernels and the lirc_imon
module.  With the new imon module since kernel 3.0 the remote worked as
expected, just everytime the module got reloaded or the machine was
rebooted, the machine got a kernel oops.

With kernel version 3.2, the oops is fixed, but now the input from the
remote is not recognized at all.  There are no input entries in the log.

I have a patch to drivers/media/rc/imon.c for this issue which "works
for me"(tm), but I'm not sure it's the right thing to do.  With this
patch keypresses from the remote are recognized and the kernel oops
doesn't occur either.  It also fixes a minor typo (intf0 instead of
intf1) in imon_init_intf1.

See patch below.  Is that ok to go into mainline?

Please keep me CCed, I'm not subscribed to the list.


Thanks,
Corinna


Signed-off-by: Corinna Vinschen <vinschen@redhat.com>

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1658,7 +1658,7 @@ static void usb_rx_callback_intf0(struct
 		return;
 
 	ictx = (struct imon_context *)urb->context;
-	if (!ictx || !ictx->dev_present_intf0)
+	if (!ictx)
 		return;
 
 	switch (urb->status) {
@@ -1669,7 +1669,8 @@ static void usb_rx_callback_intf0(struct
 		break;
 
 	case 0:
-		imon_incoming_packet(ictx, urb, intfnum);
+		if (ictx->dev_present_intf0)
+			imon_incoming_packet(ictx, urb, intfnum);
 		break;
 
 	default:
@@ -2242,7 +2243,7 @@ find_endpoint_failed:
 	mutex_unlock(&ictx->lock);
 	usb_free_urb(rx_urb);
 rx_urb_alloc_failed:
-	dev_err(ictx->dev, "unable to initialize intf0, err %d\n", ret);
+	dev_err(ictx->dev, "unable to initialize intf1, err %d\n", ret);
 
 	return NULL;
 }
