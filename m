Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52637 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0FUFfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 01:35:55 -0400
Received: by fxm10 with SMTP id 10so1532683fxm.19
        for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 22:35:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
References: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
Date: Mon, 21 Jun 2010 01:35:52 -0400
Message-ID: <AANLkTinBDKX3Qg6FQRc2R1_ImRnhb7tW7zPZrF1DKOsZ@mail.gmail.com>
Subject: Re: [PATCH] af9005: use generic_bulk_ctrl_endpoint_response
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Luca Olivetti <luca@ventoso.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 1:29 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Could somebody please test this patch and confirm that it doesn't
> break the af9005 support?
>
> This patch removes the af9005_usb_generic_rw function and uses the
> dvb_usb_generic_rw function instead, using
> generic_bulk_ctrl_endpoint_response to differentiate between the read
> pipe and the write pipe.
>
> Also found in the mercurial repository:
>
> http://kernellabs.com/hg/~mkrufky/af9005
>
> Cheers,
>
> Mike Krufky

(patch inline this time)

# HG changeset patch
# User Michael Krufky <mkrufky@kernellabs.com>
# Date 1277095782 14400
# Node ID 8d43c09cfe26655166e7ab039f765223bc87f3c5
# Parent 723e03a57ef335a4e005ac57e49fa50d2c66a010
af9005: use generic_bulk_ctrl_endpoint_response

From: Michael Krufky <mkrufky@kernellabs.com>

Priority: normal

Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>

--- a/linux/drivers/media/dvb/dvb-usb/af9005.c	Sun Jan 31 19:06:10 2010 -0500
+++ b/linux/drivers/media/dvb/dvb-usb/af9005.c	Mon Jun 21 00:49:42 2010 -0400
@@ -54,50 +54,6 @@
 	int led_state;
 };

-static int af9005_usb_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen,
-			  u8 *rbuf, u16 rlen, int delay_ms)
-{
-	int actlen, ret = -ENOMEM;
-
-	if (wbuf == NULL || wlen == 0)
-		return -EINVAL;
-
-	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
-		return ret;
-
-	deb_xfer(">>> ");
-	debug_dump(wbuf, wlen, deb_xfer);
-
-	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
-						    2), wbuf, wlen,
-			   &actlen, 2000);
-
-	if (ret)
-		err("bulk message failed: %d (%d/%d)", ret, wlen, actlen);
-	else
-		ret = actlen != wlen ? -1 : 0;
-
-	/* an answer is expected, and no error before */
-	if (!ret && rbuf && rlen) {
-		if (delay_ms)
-			msleep(delay_ms);
-
-		ret = usb_bulk_msg(d->udev, usb_rcvbulkpipe(d->udev,
-							    0x01), rbuf,
-				   rlen, &actlen, 2000);
-
-		if (ret)
-			err("recv bulk message failed: %d", ret);
-		else {
-			deb_xfer("<<< ");
-			debug_dump(rbuf, actlen, deb_xfer);
-		}
-	}
-
-	mutex_unlock(&d->usb_mutex);
-	return ret;
-}
-
 static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
 			      int readwrite, int type, u8 * values, int len)
 {
@@ -146,7 +102,7 @@
 		obuf[8] = values[0];
 	obuf[7] = command;

-	ret = af9005_usb_generic_rw(d, obuf, 16, ibuf, 17, 0);
+	ret = dvb_usb_generic_rw(d, obuf, 16, ibuf, 17, 0);
 	if (ret)
 		return ret;

@@ -537,7 +493,7 @@
 	buf[6] = wlen;
 	for (i = 0; i < wlen; i++)
 		buf[7 + i] = wbuf[i];
-	ret = af9005_usb_generic_rw(d, buf, wlen + 7, ibuf, rlen + 7, 0);
+	ret = dvb_usb_generic_rw(d, buf, wlen + 7, ibuf, rlen + 7, 0);
 	if (ret)
 		return ret;
 	if (ibuf[2] != 0x27) {
@@ -584,7 +540,7 @@

 	obuf[6] = len;
 	obuf[7] = address;
-	ret = af9005_usb_generic_rw(d, obuf, 16, ibuf, 14, 0);
+	ret = dvb_usb_generic_rw(d, obuf, 16, ibuf, 14, 0);
 	if (ret)
 		return ret;
 	if (ibuf[2] != 0x2b) {
@@ -885,7 +841,7 @@
 	obuf[2] = 0x40;		/* read remote */
 	obuf[3] = 1;		/* rest of packet length */
 	obuf[4] = st->sequence++;	/* sequence number */
-	ret = af9005_usb_generic_rw(d, obuf, 5, ibuf, 256, 0);
+	ret = dvb_usb_generic_rw(d, obuf, 5, ibuf, 256, 0);
 	if (ret) {
 		err("rc query failed");
 		return ret;
@@ -1077,6 +1033,9 @@
 	.rc_key_map_size = 0,
 	.rc_query = af9005_rc_query,

+	.generic_bulk_ctrl_endpoint          = 2,
+	.generic_bulk_ctrl_endpoint_response = 1,
+
 	.num_device_descs = 3,
 	.devices = {
 		    {.name = "Afatech DVB-T USB1.1 stick",
