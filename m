Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59930 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754171AbeFTLBk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:40 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 20/27] media: ttusb-budget: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:58 +0200
Message-Id: <20180620110105.19955-21-bigeasy@linutronix.de>
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
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/me=
dia/usb/ttusb-budget/dvb-ttusb-budget.c
index eed56895c2b9..493fb44586e9 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -846,16 +846,12 @@ static int ttusb_start_iso_xfer(struct ttusb *ttusb)
 		int frame_offset =3D 0;
 		struct urb *urb =3D ttusb->iso_urb[i];
=20
-		urb->dev =3D ttusb->dev;
-		urb->context =3D ttusb;
-		urb->complete =3D ttusb_iso_irq;
-		urb->pipe =3D ttusb->isoc_in_pipe;
+		usb_fill_int_urb(urb, ttusb->dev, ttusb->isoc_in_pipe,
+				 ttusb->iso_buffer + buffer_offset,
+				 ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF,
+				 ttusb_iso_irq, ttusb, 1);
 		urb->transfer_flags =3D URB_ISO_ASAP;
-		urb->interval =3D 1;
 		urb->number_of_packets =3D FRAMES_PER_ISO_BUF;
-		urb->transfer_buffer_length =3D
-		    ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF;
-		urb->transfer_buffer =3D ttusb->iso_buffer + buffer_offset;
 		buffer_offset +=3D ISO_FRAME_SIZE * FRAMES_PER_ISO_BUF;
=20
 		for (j =3D 0; j < FRAMES_PER_ISO_BUF; j++) {
--=20
2.17.1
