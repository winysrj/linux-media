Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59935 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeFTLBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:42 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sean Young <sean@mess.org>
Subject: [PATCH 22/27] media: ttusbir: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:01:00 +0200
Message-Id: <20180620110105.19955-23-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/rc/ttusbir.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index aafea3c5170b..6a7c9b50ff5a 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -257,10 +257,6 @@ static int ttusbir_probe(struct usb_interface *intf,
 			goto out;
 		}
=20
-		urb->dev =3D tt->udev;
-		urb->context =3D tt;
-		urb->pipe =3D usb_rcvisocpipe(tt->udev, tt->iso_in_endp);
-		urb->interval =3D 1;
 		buffer =3D usb_alloc_coherent(tt->udev, 128, GFP_KERNEL,
 						&urb->transfer_dma);
 		if (!buffer) {
@@ -268,11 +264,11 @@ static int ttusbir_probe(struct usb_interface *intf,
 			ret =3D -ENOMEM;
 			goto out;
 		}
+		usb_fill_int_urb(urb, tt->udev,
+				 usb_rcvisocpipe(tt->udev, tt->iso_in_endp),
+				 buffer, 128, ttusbir_urb_complete, tt, 1);
 		urb->transfer_flags =3D URB_NO_TRANSFER_DMA_MAP | URB_ISO_ASAP;
-		urb->transfer_buffer =3D buffer;
-		urb->complete =3D ttusbir_urb_complete;
 		urb->number_of_packets =3D 8;
-		urb->transfer_buffer_length =3D 128;
=20
 		for (j =3D 0; j < 8; j++) {
 			urb->iso_frame_desc[j].offset =3D j * 16;
--=20
2.17.1
