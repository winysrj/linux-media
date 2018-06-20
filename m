Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:59892 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754061AbeFTLB2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:01:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 05/27] media: dvb-usb: use usb_fill_int_urb()
Date: Wed, 20 Jun 2018 13:00:43 +0200
Message-Id: <20180620110105.19955-6-bigeasy@linutronix.de>
In-Reply-To: <20180620110105.19955-1-bigeasy@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using usb_fill_int_urb() helps to find code which initializes an
URB. A grep for members of the struct (like ->complete) reveal lots
of other things, too.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/dvb-usb/usb-urb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/usb-urb.c b/drivers/media/usb/dvb-us=
b/usb-urb.c
index 5e05963f4220..3c6b88e0a437 100644
--- a/drivers/media/usb/dvb-usb/usb-urb.c
+++ b/drivers/media/usb/dvb-usb/usb-urb.c
@@ -187,16 +187,14 @@ static int usb_isoc_urb_init(struct usb_data_stream *=
stream)
 		}
=20
 		urb =3D stream->urb_list[i];
-
-		urb->dev =3D stream->udev;
-		urb->context =3D stream;
-		urb->complete =3D usb_urb_complete;
-		urb->pipe =3D usb_rcvisocpipe(stream->udev,stream->props.endpoint);
+		usb_fill_int_urb(urb, stream->udev,
+				 usb_rcvisocpipe(stream->udev,
+						 stream->props.endpoint),
+				 stream->buf_list[i], stream->buf_size,
+				 usb_urb_complete, stream,
+				 stream->props.u.isoc.interval);
 		urb->transfer_flags =3D URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
-		urb->interval =3D stream->props.u.isoc.interval;
 		urb->number_of_packets =3D stream->props.u.isoc.framesperurb;
-		urb->transfer_buffer_length =3D stream->buf_size;
-		urb->transfer_buffer =3D stream->buf_list[i];
 		urb->transfer_dma =3D stream->dma_addr[i];
=20
 		for (j =3D 0; j < stream->props.u.isoc.framesperurb; j++) {
--=20
2.17.1
