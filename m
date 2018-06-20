Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59945 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754171AbeFTLBp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:45 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 26/27] media: usbvision: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:01:04 +0200
Message-Id: <20180620110105.19955-27-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/usbvision/usbvision-core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/u=
sb/usbvision/usbvision-core.c
index 31e0e98d6daf..52f21ba2a368 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -2302,16 +2302,14 @@ int usbvision_init_isoc(struct usb_usbvision *usbvi=
sion)
 					   sb_size,
 					   GFP_KERNEL,
 					   &urb->transfer_dma);
-		urb->dev =3D dev;
-		urb->context =3D usbvision;
-		urb->pipe =3D usb_rcvisocpipe(dev, usbvision->video_endp);
+		usb_fill_int_urb(urb, dev,
+				 usb_rcvisocpipe(dev, usbvision->video_endp),
+				 usbvision->sbuf[buf_idx].data,
+				 usbvision->isoc_packet_size * USBVISION_URB_FRAMES,
+				 usbvision_isoc_irq, usbvision, 1);
+
 		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->interval =3D 1;
-		urb->transfer_buffer =3D usbvision->sbuf[buf_idx].data;
-		urb->complete =3D usbvision_isoc_irq;
 		urb->number_of_packets =3D USBVISION_URB_FRAMES;
-		urb->transfer_buffer_length =3D
-		    usbvision->isoc_packet_size * USBVISION_URB_FRAMES;
 		for (j =3D k =3D 0; j < USBVISION_URB_FRAMES; j++,
 		     k +=3D usbvision->isoc_packet_size) {
 			urb->iso_frame_desc[j].offset =3D k;
--=20
2.17.1
