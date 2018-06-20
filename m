Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59889 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbeFTLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:27 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 03/27] media: cx231xx: use usb_fill_XXX_urb()
Date: Wed, 20 Jun 2018 13:00:41 +0200
Message-Id: <20180620110105.19955-4-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_XXX_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/cx231xx/cx231xx-audio.c | 30 ++++++++---------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/=
cx231xx/cx231xx-audio.c
index c4a84fb930b6..5d7a0c085902 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -281,6 +281,7 @@ static int cx231xx_init_audio_isoc(struct cx231xx *dev)
 	for (i =3D 0; i < CX231XX_AUDIO_BUFS; i++) {
 		struct urb *urb;
 		int j, k;
+		unsigned int pipe;
=20
 		dev->adev.transfer_buffer[i] =3D kmalloc(sb_size, GFP_ATOMIC);
 		if (!dev->adev.transfer_buffer[i])
@@ -295,17 +296,12 @@ static int cx231xx_init_audio_isoc(struct cx231xx *de=
v)
 			}
 			return -ENOMEM;
 		}
-
-		urb->dev =3D dev->udev;
-		urb->context =3D dev;
-		urb->pipe =3D usb_rcvisocpipe(dev->udev,
-						dev->adev.end_point_addr);
+		pipe =3D usb_rcvisocpipe(dev->udev, dev->adev.end_point_addr);
+		usb_fill_int_urb(urb, dev->udev, pipe,
+				 dev->adev.transfer_buffer[i], sb_size,
+				 cx231xx_audio_isocirq, dev, 1);
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->transfer_buffer =3D dev->adev.transfer_buffer[i];
-		urb->interval =3D 1;
-		urb->complete =3D cx231xx_audio_isocirq;
 		urb->number_of_packets =3D CX231XX_ISO_NUM_AUDIO_PACKETS;
-		urb->transfer_buffer_length =3D sb_size;
=20
 		for (j =3D k =3D 0; j < CX231XX_ISO_NUM_AUDIO_PACKETS;
 			j++, k +=3D dev->adev.max_pkt_size) {
@@ -356,18 +352,12 @@ static int cx231xx_init_audio_bulk(struct cx231xx *de=
v)
 			}
 			return -ENOMEM;
 		}
-
-		urb->dev =3D dev->udev;
-		urb->context =3D dev;
-		urb->pipe =3D usb_rcvbulkpipe(dev->udev,
-						dev->adev.end_point_addr);
-		urb->transfer_flags =3D 0;
-		urb->transfer_buffer =3D dev->adev.transfer_buffer[i];
-		urb->complete =3D cx231xx_audio_bulkirq;
-		urb->transfer_buffer_length =3D sb_size;
-
+		usb_fill_bulk_urb(urb, dev->udev,
+				  usb_rcvbulkpipe(dev->udev,
+						  dev->adev.end_point_addr),
+				  dev->adev.transfer_buffer[i], sb_size,
+				  cx231xx_audio_bulkirq, dev);
 		dev->adev.urb[i] =3D urb;
-
 	}
=20
 	for (i =3D 0; i < CX231XX_AUDIO_BUFS; i++) {
--=20
2.17.1
