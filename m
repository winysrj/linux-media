Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbZJDPhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 11:37:19 -0400
Message-ID: <4AC8C227.4000301@redhat.com>
Date: Sun, 04 Oct 2009 17:41:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: James Blanford <jhblanford@gmail.com>,
	=?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: PATCH: gscpa stv06xx + ov518: dont discard every other frame
Content-Type: multipart/mixed;
 boundary="------------050800020709060407060204"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050800020709060407060204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

As noticed by James Blanford <jhblanford@gmail.com>, we were discarding
every other frame in stv06xx and the ov518 (part of ov519.c) drivers.

When we call gspca_frame_add, it returns a pointer to the frame passed in,
unless we call it with LAST_PACKET, when it will return a pointer to a
new frame in which to store the frame data for the next frame. So whenever
calling:
gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
we should do this as:
frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);

So that any further data got from of the pkt we are handling in pkt_scan, goes
to the next frame.

We are not doing this in stv06xx.c pkt_scan method, which the cause of what
James is seeing. So I started checking all drivers, and we are not doing this
either in ov519.c when handling an ov518 bridge. So now the framerate of my
3 ov518 test cams has just doubled. Thanks James!

The attached patch fixes this.

Regards,

Hans

--------------050800020709060407060204
Content-Type: text/plain;
 name="gspca-dont-discard-every-other-frame.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gspca-dont-discard-every-other-frame.patch"

diff -r 5ad36b0c0e90 linux/drivers/media/video/gspca/ov519.c
--- a/linux/drivers/media/video/gspca/ov519.c	Sun Oct 04 16:23:04 2009 +0200
+++ b/linux/drivers/media/video/gspca/ov519.c	Sun Oct 04 17:26:43 2009 +0200
@@ -2939,7 +2939,7 @@
 	/* A false positive here is likely, until OVT gives me
 	 * the definitive SOF/EOF format */
 	if ((!(data[0] | data[1] | data[2] | data[3] | data[5])) && data[6]) {
-		gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
+		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
 		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, 0);
 		sd->packet_nr = 0;
 	}
diff -r 5ad36b0c0e90 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Sun Oct 04 16:23:04 2009 +0200
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Sun Oct 04 17:26:43 2009 +0200
@@ -394,7 +394,7 @@
 			PDEBUG(D_PACK, "End of frame detected");
 
 			/* Complete the last frame (if any) */
-			gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
+			frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
 
 			if (chunk_len)
 				PDEBUG(D_ERR, "Chunk length is "

--------------050800020709060407060204--
