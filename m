Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59885 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbeFTLBZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:25 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/27] media: b2c2: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:39 +0200
Message-Id: <20180620110105.19955-2-bigeasy@linutronix.de>
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
Cc: linux-media@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/=
flexcop-usb.c
index a8f3169e30b3..d5296f643a29 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -461,15 +461,13 @@ static int flexcop_usb_transfer_init(struct flexcop_u=
sb *fc_usb)
 		deb_ts("initializing and submitting urb no. %d (buf_offset: %d).\n",
 		       i, buffer_offset);
=20
-		urb->dev =3D fc_usb->udev;
-		urb->context =3D fc_usb;
-		urb->complete =3D flexcop_usb_urb_complete;
-		urb->pipe =3D B2C2_USB_DATA_PIPE;
+		usb_fill_int_urb(urb, fc_usb->udev, B2C2_USB_DATA_PIPE,
+				 fc_usb->iso_buffer + buffer_offset,
+				 frame_size * B2C2_USB_FRAMES_PER_ISO,
+				 flexcop_usb_urb_complete, fc_usb, 1);
+
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->interval =3D 1;
 		urb->number_of_packets =3D B2C2_USB_FRAMES_PER_ISO;
-		urb->transfer_buffer_length =3D frame_size * B2C2_USB_FRAMES_PER_ISO;
-		urb->transfer_buffer =3D fc_usb->iso_buffer + buffer_offset;
=20
 		buffer_offset +=3D frame_size * B2C2_USB_FRAMES_PER_ISO;
 		for (j =3D 0; j < B2C2_USB_FRAMES_PER_ISO; j++) {
--=20
2.17.1
