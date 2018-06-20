Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59895 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbeFTLB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:29 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/27] media: dvb_usb_v2: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:44 +0200
Message-Id: <20180620110105.19955-7-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/dvb-usb-v2/usb_urb.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c b/drivers/media/usb/dvb=
-usb-v2/usb_urb.c
index b0499f95ec45..e5e0bf96bad2 100644
--- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
@@ -180,18 +180,17 @@ static int usb_urb_alloc_isoc_urbs(struct usb_data_st=
ream *stream)
 		}
=20
 		urb =3D stream->urb_list[i];
+		usb_fill_int_urb(urb, stream->udev,
+				 usb_rcvisocpipe(stream->udev,
+						 stream->props.endpoint),
+				 stream->buf_list[i],
+				 stream->props.u.isoc.framesize *
+				 stream->props.u.isoc.framesperurb,
+				 usb_urb_complete, stream,
+				 stream->props.u.isoc.interval);
=20
-		urb->dev =3D stream->udev;
-		urb->context =3D stream;
-		urb->complete =3D usb_urb_complete;
-		urb->pipe =3D usb_rcvisocpipe(stream->udev,
-				stream->props.endpoint);
 		urb->transfer_flags =3D URB_ISO_ASAP | URB_FREE_BUFFER;
-		urb->interval =3D stream->props.u.isoc.interval;
 		urb->number_of_packets =3D stream->props.u.isoc.framesperurb;
-		urb->transfer_buffer_length =3D stream->props.u.isoc.framesize *
-				stream->props.u.isoc.framesperurb;
-		urb->transfer_buffer =3D stream->buf_list[i];
=20
 		for (j =3D 0; j < stream->props.u.isoc.framesperurb; j++) {
 			urb->iso_frame_desc[j].offset =3D frame_offset;
--=20
2.17.1
