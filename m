Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59910 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753321AbeFTLBf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:35 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 13/27] media: gspca: konica: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:51 +0200
Message-Id: <20180620110105.19955-14-bigeasy@linutronix.de>
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
 drivers/media/usb/gspca/konica.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/kon=
ica.c
index 989ae997f66d..6ab96bcb338f 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -203,6 +203,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 #endif
 #define SD_NPKT 32
 	for (n =3D 0; n < 4; n++) {
+		void *buf;
+
 		i =3D n & 1 ? 0 : 1;
 		packet_size =3D
 			le16_to_cpu(alt->endpoint[i].desc.wMaxPacketSize);
@@ -210,24 +212,21 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		if (!urb)
 			return -ENOMEM;
 		gspca_dev->urb[n] =3D urb;
-		urb->transfer_buffer =3D usb_alloc_coherent(gspca_dev->dev,
-						packet_size * SD_NPKT,
-						GFP_KERNEL,
-						&urb->transfer_dma);
-		if (urb->transfer_buffer =3D=3D NULL) {
+		buf =3D usb_alloc_coherent(gspca_dev->dev, packet_size * SD_NPKT,
+					 GFP_KERNEL, &urb->transfer_dma);
+		if (buf =3D=3D NULL) {
 			pr_err("usb_buffer_alloc failed\n");
 			return -ENOMEM;
 		}
=20
-		urb->dev =3D gspca_dev->dev;
-		urb->context =3D gspca_dev;
-		urb->transfer_buffer_length =3D packet_size * SD_NPKT;
-		urb->pipe =3D usb_rcvisocpipe(gspca_dev->dev,
-					n & 1 ? 0x81 : 0x82);
+		usb_fill_int_urb(urb, gspca_dev->dev,
+				 usb_rcvisocpipe(gspca_dev->dev,
+						 n & 1 ? 0x81 : 0x82),
+				 buf, packet_size * SD_NPKT, sd_isoc_irq,
+				 gspca_dev, 1);
+
 		urb->transfer_flags =3D URB_ISO_ASAP
 					| URB_NO_TRANSFER_DMA_MAP;
-		urb->interval =3D 1;
-		urb->complete =3D sd_isoc_irq;
 		urb->number_of_packets =3D SD_NPKT;
 		for (i =3D 0; i < SD_NPKT; i++) {
 			urb->iso_frame_desc[i].length =3D packet_size;
--=20
2.17.1
