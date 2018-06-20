Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59901 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754122AbeFTLBb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:31 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 09/27] media: em28xx-audio: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:47 +0200
Message-Id: <20180620110105.19955-10-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an URB. A
grep for members of the struct (like ->complete) reveal lots of other
things, too.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em=
28xx/em28xx-audio.c
index 7f75002927a1..4251c9f8e07a 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -877,15 +877,13 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		}
 		dev->adev.transfer_buffer[i] =3D buf;
=20
-		urb->dev =3D udev;
-		urb->context =3D dev;
-		urb->pipe =3D usb_rcvisocpipe(udev, EM28XX_EP_AUDIO);
+		usb_fill_int_urb(urb, udev,
+				 usb_rcvisocpipe(udev, EM28XX_EP_AUDIO),
+				 buf, ep_size * npackets, em28xx_audio_isocirq,
+				 dev, ep->bInterval);
+
 		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer =3D buf;
-		urb->interval =3D interval;
-		urb->complete =3D em28xx_audio_isocirq;
 		urb->number_of_packets =3D npackets;
-		urb->transfer_buffer_length =3D ep_size * npackets;
=20
 		for (j =3D k =3D 0; j < npackets; j++, k +=3D ep_size) {
 			urb->iso_frame_desc[j].offset =3D k;
--=20
2.17.1
