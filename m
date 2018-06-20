Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59887 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752806AbeFTLB0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 02/27] media: cpia2_usb: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:40 +0200
Message-Id: <20180620110105.19955-3-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/=
cpia2_usb.c
index a771e0a52610..6f94bdcc4111 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -689,16 +689,11 @@ static int submit_urbs(struct camera_data *cam)
 		}
=20
 		cam->sbuf[i].urb =3D urb;
-		urb->dev =3D cam->dev;
+		usb_fill_int_urb(urb, cam->dev, usb_rcvisocpipe(cam->dev, 1),
+				 cam->sbuf[i].data, FRAME_SIZE_PER_DESC *
+				 FRAMES_PER_DESC, cpia2_usb_complete, cam, 1);
 		urb->context =3D cam;
-		urb->pipe =3D usb_rcvisocpipe(cam->dev, 1 /*ISOC endpoint*/);
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->transfer_buffer =3D cam->sbuf[i].data;
-		urb->complete =3D cpia2_usb_complete;
-		urb->number_of_packets =3D FRAMES_PER_DESC;
-		urb->interval =3D 1;
-		urb->transfer_buffer_length =3D
-			FRAME_SIZE_PER_DESC * FRAMES_PER_DESC;
=20
 		for (fx =3D 0; fx < FRAMES_PER_DESC; fx++) {
 			urb->iso_frame_desc[fx].offset =3D
--=20
2.17.1
