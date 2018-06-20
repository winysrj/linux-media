Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59923 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbeFTLBi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:38 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 17/27] media: stk1160: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:55 +0200
Message-Id: <20180620110105.19955-18-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an URB. A
grep for members of the struct (like ->complete) reveal lots of other
things, too.

Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/stk1160/stk1160-video.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-video.c b/drivers/media/usb/=
stk1160/stk1160-video.c
index 2811f612820f..2dd2cb9079d7 100644
--- a/drivers/media/usb/stk1160/stk1160-video.c
+++ b/drivers/media/usb/stk1160/stk1160-video.c
@@ -481,13 +481,10 @@ int stk1160_alloc_isoc(struct stk1160 *dev)
 		/*
 		 * FIXME: Where can I get the endpoint?
 		 */
-		urb->dev =3D dev->udev;
-		urb->pipe =3D usb_rcvisocpipe(dev->udev, STK1160_EP_VIDEO);
-		urb->transfer_buffer =3D dev->isoc_ctl.transfer_buffer[i];
-		urb->transfer_buffer_length =3D sb_size;
-		urb->complete =3D stk1160_isoc_irq;
-		urb->context =3D dev;
-		urb->interval =3D 1;
+		usb_fill_int_urb(urb, dev->udev,
+				 usb_rcvisocpipe(dev->udev, STK1160_EP_VIDEO),
+				 dev->isoc_ctl.transfer_buffer[i], sb_size,
+				 stk1160_isoc_irq, dev, 1);
 		urb->start_frame =3D 0;
 		urb->number_of_packets =3D max_packets;
 #ifndef CONFIG_DMA_NONCOHERENT
--=20
2.17.1
