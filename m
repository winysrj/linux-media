Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59907 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbeFTLBe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:34 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 12/27] media: gspca: gspca: use usb_fill_XXX_urb()
Date: Wed, 20 Jun 2018 13:00:50 +0200
Message-Id: <20180620110105.19955-13-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an URB. A
grep for members of the struct (like ->complete) reveal lots of other
things, too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/gspca/gspca.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspc=
a.c
index 57aa521e16b1..4cc9135829df 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -698,39 +698,40 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 	}
=20
 	for (n =3D 0; n < nurbs; n++) {
+		void *buf;
+
 		urb =3D usb_alloc_urb(npkt, GFP_KERNEL);
 		if (!urb)
 			return -ENOMEM;
 		gspca_dev->urb[n] =3D urb;
-		urb->transfer_buffer =3D usb_alloc_coherent(gspca_dev->dev,
+		buf =3D usb_alloc_coherent(gspca_dev->dev,
 						bsize,
 						GFP_KERNEL,
 						&urb->transfer_dma);
=20
-		if (urb->transfer_buffer =3D=3D NULL) {
+		if (buf =3D=3D NULL) {
 			pr_err("usb_alloc_coherent failed\n");
 			return -ENOMEM;
 		}
-		urb->dev =3D gspca_dev->dev;
-		urb->context =3D gspca_dev;
-		urb->transfer_buffer_length =3D bsize;
 		if (npkt !=3D 0) {		/* ISOC */
-			urb->pipe =3D usb_rcvisocpipe(gspca_dev->dev,
-						    ep->desc.bEndpointAddress);
+			usb_fill_int_urb(urb, gspca_dev->dev,
+					 usb_rcvisocpipe(gspca_dev->dev, ep->desc.bEndpointAddress),
+					 buf, bsize, isoc_irq, gspca_dev,
+					 ep->desc.bInterval);
+
 			urb->transfer_flags =3D URB_ISO_ASAP
 					| URB_NO_TRANSFER_DMA_MAP;
-			urb->interval =3D 1 << (ep->desc.bInterval - 1);
-			urb->complete =3D isoc_irq;
 			urb->number_of_packets =3D npkt;
 			for (i =3D 0; i < npkt; i++) {
 				urb->iso_frame_desc[i].length =3D psize;
 				urb->iso_frame_desc[i].offset =3D psize * i;
 			}
 		} else {		/* bulk */
-			urb->pipe =3D usb_rcvbulkpipe(gspca_dev->dev,
-						ep->desc.bEndpointAddress);
+			usb_fill_bulk_urb(urb, gspca_dev->dev,
+					 usb_rcvbulkpipe(gspca_dev->dev, ep->desc.bEndpointAddress),
+					 buf, bsize, bulk_irq, gspca_dev);
+
 			urb->transfer_flags =3D URB_NO_TRANSFER_DMA_MAP;
-			urb->complete =3D bulk_irq;
 		}
 	}
 	return 0;
--=20
2.17.1
