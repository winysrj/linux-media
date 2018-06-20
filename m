Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59940 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752914AbeFTLBo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:44 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 24/27] media: usbtv: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:01:02 +0200
Message-Id: <20180620110105.19955-25-bigeasy@linutronix.de>
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
 drivers/media/usb/usbtv/usbtv-video.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbt=
v/usbtv-video.c
index 36a9a4017185..2be4935b7afe 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -496,26 +496,24 @@ static struct urb *usbtv_setup_iso_transfer(struct us=
btv *usbtv)
 {
 	struct urb *ip;
 	int size =3D usbtv->iso_size;
+	void *buf;
 	int i;
=20
 	ip =3D usb_alloc_urb(USBTV_ISOC_PACKETS, GFP_KERNEL);
 	if (ip =3D=3D NULL)
 		return NULL;
=20
-	ip->dev =3D usbtv->udev;
-	ip->context =3D usbtv;
-	ip->pipe =3D usb_rcvisocpipe(usbtv->udev, USBTV_VIDEO_ENDP);
-	ip->interval =3D 1;
-	ip->transfer_flags =3D URB_ISO_ASAP;
-	ip->transfer_buffer =3D kcalloc(USBTV_ISOC_PACKETS, size,
-						GFP_KERNEL);
-	if (!ip->transfer_buffer) {
+	buf =3D kcalloc(USBTV_ISOC_PACKETS, size, GFP_KERNEL);
+	if (!buf) {
 		usb_free_urb(ip);
 		return NULL;
 	}
-	ip->complete =3D usbtv_iso_cb;
+	usb_fill_int_urb(ip, usbtv->udev,
+			 usb_rcvisocpipe(usbtv->udev, USBTV_VIDEO_ENDP),
+			 buf, size * USBTV_ISOC_PACKETS, usbtv_iso_cb,
+			 usbtv, 1);
+	ip->transfer_flags =3D URB_ISO_ASAP;
 	ip->number_of_packets =3D USBTV_ISOC_PACKETS;
-	ip->transfer_buffer_length =3D size * USBTV_ISOC_PACKETS;
 	for (i =3D 0; i < USBTV_ISOC_PACKETS; i++) {
 		ip->iso_frame_desc[i].offset =3D size * i;
 		ip->iso_frame_desc[i].length =3D size;
--=20
2.17.1
