Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59896 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbeFTLBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:30 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/27] media: em28xx-audio: use GFP_KERNEL for memory allocation during init
Date: Wed, 20 Jun 2018 13:00:45 +0200
Message-Id: <20180620110105.19955-8-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As far as I can tell em28xx_audio_urb_init() is called once during
initialization from non atomic context. Memory allocation from
non atomic context should use GFP_KERNEL to avoid using emergency pool
for memory allocation.
Use GFP_KERNEL for memory allocation.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em=
28xx/em28xx-audio.c
index 8e799ae1df69..bb510cf8fbbb 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -842,11 +842,11 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
=20
 	dev->adev.transfer_buffer =3D kcalloc(num_urb,
 					    sizeof(*dev->adev.transfer_buffer),
-					    GFP_ATOMIC);
+					    GFP_KERNEL);
 	if (!dev->adev.transfer_buffer)
 		return -ENOMEM;
=20
-	dev->adev.urb =3D kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_ATOMIC);
+	dev->adev.urb =3D kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_KERNEL);
 	if (!dev->adev.urb) {
 		kfree(dev->adev.transfer_buffer);
 		return -ENOMEM;
@@ -859,14 +859,14 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		int j, k;
 		void *buf;
=20
-		urb =3D usb_alloc_urb(npackets, GFP_ATOMIC);
+		urb =3D usb_alloc_urb(npackets, GFP_KERNEL);
 		if (!urb) {
 			em28xx_audio_free_urb(dev);
 			return -ENOMEM;
 		}
 		dev->adev.urb[i] =3D urb;
=20
-		buf =3D usb_alloc_coherent(udev, npackets * ep_size, GFP_ATOMIC,
+		buf =3D usb_alloc_coherent(udev, npackets * ep_size, GFP_KERNEL,
 					 &urb->transfer_dma);
 		if (!buf) {
 			dev_err(&dev->intf->dev,
--=20
2.17.1
