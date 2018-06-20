Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59916 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbeFTLBg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:36 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/27] media: msi2500: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:53 +0200
Message-Id: <20180620110105.19955-16-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an URB. A
grep for members of the struct (like ->complete) reveal lots of other
things, too.

Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/msi2500/msi2500.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi250=
0/msi2500.c
index 65ef755adfdc..7ac6284248ce 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -507,6 +507,8 @@ static int msi2500_isoc_init(struct msi2500_dev *dev)
=20
 	/* Allocate and init Isochronuous urbs */
 	for (i =3D 0; i < MAX_ISO_BUFS; i++) {
+		void *buf;
+
 		urb =3D usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb =3D=3D NULL) {
 			msi2500_isoc_cleanup(dev);
@@ -515,22 +517,19 @@ static int msi2500_isoc_init(struct msi2500_dev *dev)
 		dev->urbs[i] =3D urb;
 		dev_dbg(dev->dev, "Allocated URB at 0x%p\n", urb);
=20
-		urb->interval =3D 1;
-		urb->dev =3D dev->udev;
-		urb->pipe =3D usb_rcvisocpipe(dev->udev, 0x81);
-		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer =3D usb_alloc_coherent(dev->udev,
-				ISO_BUFFER_SIZE,
-				GFP_KERNEL, &urb->transfer_dma);
-		if (urb->transfer_buffer =3D=3D NULL) {
+
+		buf =3D usb_alloc_coherent(dev->udev, ISO_BUFFER_SIZE, GFP_KERNEL,
+					 &urb->transfer_dma);
+		if (buf =3D=3D NULL) {
 			dev_err(dev->dev,
 				"Failed to allocate urb buffer %d\n", i);
 			msi2500_isoc_cleanup(dev);
 			return -ENOMEM;
 		}
-		urb->transfer_buffer_length =3D ISO_BUFFER_SIZE;
-		urb->complete =3D msi2500_isoc_handler;
-		urb->context =3D dev;
+		usb_fill_int_urb(urb, dev->udev,
+				 usb_rcvisocpipe(dev->udev, 0x81), buf,
+				 ISO_BUFFER_SIZE, msi2500_isoc_handler, dev, 1);
+		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->start_frame =3D 0;
 		urb->number_of_packets =3D ISO_FRAMES_PER_DESC;
 		for (j =3D 0; j < ISO_FRAMES_PER_DESC; j++) {
--=20
2.17.1
