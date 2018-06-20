Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59918 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754162AbeFTLBh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:37 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 16/27] media: pwc: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:54 +0200
Message-Id: <20180620110105.19955-17-bigeasy@linutronix.de>
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
 drivers/media/usb/pwc/pwc-if.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..8af72b0a607e 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -409,6 +409,8 @@ static int pwc_isoc_init(struct pwc_device *pdev)
=20
 	/* Allocate and init Isochronuous urbs */
 	for (i =3D 0; i < MAX_ISO_BUFS; i++) {
+		void *buf;
+
 		urb =3D usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb =3D=3D NULL) {
 			pwc_isoc_cleanup(pdev);
@@ -416,23 +418,18 @@ static int pwc_isoc_init(struct pwc_device *pdev)
 		}
 		pdev->urbs[i] =3D urb;
 		PWC_DEBUG_MEMORY("Allocated URB at 0x%p\n", urb);
-
-		urb->interval =3D 1; // devik
-		urb->dev =3D udev;
-		urb->pipe =3D usb_rcvisocpipe(udev, pdev->vendpoint);
 		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer =3D usb_alloc_coherent(udev,
-							  ISO_BUFFER_SIZE,
-							  GFP_KERNEL,
-							  &urb->transfer_dma);
-		if (urb->transfer_buffer =3D=3D NULL) {
+		buf =3D usb_alloc_coherent(udev, ISO_BUFFER_SIZE, GFP_KERNEL,
+					 &urb->transfer_dma);
+		if (buf =3D=3D NULL) {
 			PWC_ERROR("Failed to allocate urb buffer %d\n", i);
 			pwc_isoc_cleanup(pdev);
 			return -ENOMEM;
 		}
-		urb->transfer_buffer_length =3D ISO_BUFFER_SIZE;
-		urb->complete =3D pwc_isoc_handler;
-		urb->context =3D pdev;
+		usb_fill_int_urb(urb, udev,
+			usb_rcvisocpipe(udev, pdev->vendpoint),
+			buf, ISO_BUFFER_SIZE, pwc_isoc_handler, pdev, 1);
+
 		urb->start_frame =3D 0;
 		urb->number_of_packets =3D ISO_FRAMES_PER_DESC;
 		for (j =3D 0; j < ISO_FRAMES_PER_DESC; j++) {
--=20
2.17.1
