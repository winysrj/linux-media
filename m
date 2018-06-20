Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59951 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754201AbeFTLBr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:47 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 25/27] media: usbvision: remove time_in_irq
Date: Wed, 20 Jun 2018 13:01:03 +0200
Message-Id: <20180620110105.19955-26-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Time "in interrupt" accounting with the help of `jiffies' is a pointless
exercise. This variable isn't even used.
Remove time_in_irq.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/usbvision/usbvision-core.c | 3 ---
 drivers/media/usb/usbvision/usbvision.h      | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/u=
sb/usbvision/usbvision-core.c
index 7138c2b606cc..31e0e98d6daf 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -1272,7 +1272,6 @@ static void usbvision_isoc_irq(struct urb *urb)
 	int len;
 	struct usb_usbvision *usbvision =3D urb->context;
 	int i;
-	unsigned long start_time =3D jiffies;
 	struct usbvision_frame **f;
=20
 	/* We don't want to do anything if we are about to be removed! */
@@ -1324,8 +1323,6 @@ static void usbvision_isoc_irq(struct urb *urb)
 		scratch_reset(usbvision);
 	}
=20
-	usbvision->time_in_irq +=3D jiffies - start_time;
-
 	for (i =3D 0; i < USBVISION_URB_FRAMES; i++) {
 		urb->iso_frame_desc[i].status =3D 0;
 		urb->iso_frame_desc[i].actual_length =3D 0;
diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/us=
bvision/usbvision.h
index 6ecdcd58248f..017e7baf5747 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -447,7 +447,6 @@ struct usb_usbvision {
 	unsigned long isoc_skip_count;			/* How many empty ISO packets received */
 	unsigned long isoc_err_count;			/* How many bad ISO packets received */
 	unsigned long isoc_packet_count;		/* How many packets we totally got */
-	unsigned long time_in_irq;			/* How long do we need for interrupt */
 	int isoc_measure_bandwidth_count;
 	int frame_num;					/* How many video frames we send to user */
 	int max_strip_len;				/* How big is the biggest strip */
--=20
2.17.1
