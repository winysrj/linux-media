Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:57599 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0C0Mlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 08:41:51 -0400
Received: from kabelnet-194-37.juropnet.hu ([91.147.194.37])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NvVKm-0007OM-4a
	for linux-media@vger.kernel.org; Sat, 27 Mar 2010 13:41:50 +0100
Message-ID: <4BADFE71.5090309@mailbox.hu>
Date: Sat, 27 Mar 2010 13:47:45 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: fix setting input when using DVB
Content-Type: multipart/mixed;
 boundary="------------010907010103000104080605"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010907010103000104080605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(Sorry for the double post, the previous one did not include the patch)

In cx88-mpeg.c, there is code that sets core->input to CX88_VMUX_DVB.
However, this may be incorrect, since core->input is actually an
index to core->board.input[], which has not enough elements to be
indexed by the value of CX88_VMUX_DVB. So, the modified code searches
core->board.input[] for an input with a type of CX88_VMUX_DVB, and if
it does not find one, the index is simply set to zero.
The change may not have much effect, though, since it appears the only
case when core->input is actually used is when the current input is
being queried.

Signed-off-by: Istvan Varga <istvanv@users.sourceforge.net>

--------------010907010103000104080605
Content-Type: text/x-patch;
 name="cx88-vmux-dvb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx88-vmux-dvb.patch"

diff -r -d -N -U4 v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-mpeg.c v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-mpeg.c
--- v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-mpeg.c	2010-03-23 03:39:52.000000000 +0100
+++ v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-mpeg.c	2010-03-23 19:07:26.000000000 +0100
@@ -637,15 +637,24 @@
 /* Driver asked for hardware access. */
 static int cx8802_request_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
+	unsigned int	i;
 
 	/* Fail a request for hardware if the device is busy. */
 	if (core->active_type_id != CX88_BOARD_NONE &&
 	    core->active_type_id != drv->type_id)
 		return -EBUSY;
 
-	core->input = CX88_VMUX_DVB;
+	core->input = 0;
+	for (i = 0;
+	     i < (sizeof(core->board.input) / sizeof(struct cx88_input));
+	     i++) {
+		if (core->board.input[i].type == CX88_VMUX_DVB) {
+			core->input = i;
+			break;
+		}
+	}
 
 	if (drv->advise_acquire)
 	{
 		mutex_lock(&drv->core->lock);

--------------010907010103000104080605--
