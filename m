Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59933 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbeFTLBl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:41 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 21/27] media: ttusb-dec: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:59 +0200
Message-Id: <20180620110105.19955-22-bigeasy@linutronix.de>
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
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/tt=
usb-dec/ttusb_dec.c
index 44ca66cb9b8f..4c094364873d 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -858,16 +858,13 @@ static void ttusb_dec_setup_urbs(struct ttusb_dec *de=
c)
 		int frame_offset =3D 0;
 		struct urb *urb =3D dec->iso_urb[i];
=20
-		urb->dev =3D dec->udev;
-		urb->context =3D dec;
-		urb->complete =3D ttusb_dec_process_urb;
-		urb->pipe =3D dec->in_pipe;
+		usb_fill_int_urb(urb, dec->udev, dec->in_pipe,
+				 dec->iso_buffer + buffer_offset,
+				 ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF,
+				 ttusb_dec_process_urb, dec, 1);
+
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->interval =3D 1;
 		urb->number_of_packets =3D FRAMES_PER_ISO_BUF;
-		urb->transfer_buffer_length =3D ISO_FRAME_SIZE *
-					      FRAMES_PER_ISO_BUF;
-		urb->transfer_buffer =3D dec->iso_buffer + buffer_offset;
 		buffer_offset +=3D ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF;
=20
 		for (j =3D 0; j < FRAMES_PER_ISO_BUF; j++) {
--=20
2.17.1
