Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59924 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752792AbeFTLBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:39 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 18/27] media: stkwebcam: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:56 +0200
Message-Id: <20180620110105.19955-19-bigeasy@linutronix.de>
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
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/s=
tkwebcam/stk-webcam.c
index 5accb5241072..0cdf23180095 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -460,14 +460,11 @@ static int stk_prepare_iso(struct stk_camera *dev)
 			usb_kill_urb(dev->isobufs[i].urb);
 			urb =3D dev->isobufs[i].urb;
 		}
-		urb->interval =3D 1;
-		urb->dev =3D udev;
-		urb->pipe =3D usb_rcvisocpipe(udev, dev->isoc_ep);
+		usb_fill_int_urb(urb, udev, usb_rcvisocpipe(udev, dev->isoc_ep),
+				 dev->isobufs[i].data, ISO_BUFFER_SIZE,
+				 stk_isoc_handler, dev, 1);
+
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->transfer_buffer =3D dev->isobufs[i].data;
-		urb->transfer_buffer_length =3D ISO_BUFFER_SIZE;
-		urb->complete =3D stk_isoc_handler;
-		urb->context =3D dev;
 		urb->start_frame =3D 0;
 		urb->number_of_packets =3D ISO_FRAMES_PER_DESC;
=20
--=20
2.17.1
