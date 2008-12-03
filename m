Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB421Obb029006
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 21:01:24 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB421A1X031774
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 21:01:10 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081203194426.f0bbdc6b.ospite@studenti.unina.it>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
	<20081127145233.f467442a.ospite@studenti.unina.it>
	<20081203174528.712f1549.ospite@studenti.unina.it>
	<20081203180128.GA19180@psychosis.jim.sh>
	<20081203194426.f0bbdc6b.ospite@studenti.unina.it>
Content-Type: multipart/mixed; boundary="=-8F+Fw2cKCVFZtI/OSDDC"
Date: Wed, 03 Dec 2008 20:17:20 +0100
Message-Id: <1228331840.1705.15.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-8F+Fw2cKCVFZtI/OSDDC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Wed, 2008-12-03 at 19:44 +0100, Antonio Ospite wrote:
> Yes, the code takes this path in gspca.c, gspca_frame_add(), line 277:
> 
> 	if (packet_type == FIRST_PACKET) {
> 		if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
> 						!= V4L2_BUF_FLAG_QUEUED) {
> 			gspca_dev->last_packet_type = DISCARD_PACKET;
> 			return frame;
> 		}
> 
> and then it keeps on adding only INTER_PACKETs because of the current
> end of frame check. It is a timing issue, it happens only with high
> frame_rates, maybe there is some code in gspca that needs to be
> protected by locking?
> Or would it be normal to loose some frames at high frame rates using
> smaller bulk_size?
> 
> > > As a side note, if I use this check to detect the end of the frame:
> > > 
> > > 	if (len < gspca_dev->cam.bulk_size) {
> > > 		...
> > > 	} else ...
> > > 
> > > I can recover from the previous error even if I get some frame
> > > discarded from time to time. Is this check acceptable to you If I take
> > > care that framesize is not a multiple of bulk_size?
> > 
> > Hold off a bit on this work.
> > 
> > There's a problem with breaking up the transfers, because we're not
> > currently getting any header data from the bridge chip that lets us
> > know when we really hit the end of a frame, and it's easy to get out
> > of sync.  Using (len < bulk_size) is a good trick if they're not a
> > multiple, as you say, since the last payload will be shorter, but I
> > have a better solution -- I found how to get the camera to add a
> > UVC-format header on each payload.  I'm finishing up the patch and
> > will post it a bit later today once I iron out a few bugs.
> > 
> > -jim

Hi Antonio,

The problem comes from the availability of the application buffer. In
the bulk_irq, there is:

	frame = gspca_get_i_frame(gspca_dev);
	if (!frame) {
		gspca_dev->last_packet_type = DISCARD_PACKET;
	} else {
		.. pkt_scan(..);
	}

Then, you are not called and you cannot know how many bytes have been
really received.

As the buffer check exists in frame_add, I may call you each time with a
valid frame pointer (see patch). In this case, you cannot count the
image bytes with the data_end. You should have a counter in the sd
structure.

An other solution is to start and stop the transfer for each image as it
was in the original driver, but it asks for a kernel thread.

Anyway, if Jim may add a mark between the images, if will be the best...

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--=-8F+Fw2cKCVFZtI/OSDDC
Content-Disposition: attachment; filename=gspca.patch
Content-Type: text/x-patch; name=gspca.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -r d23374509b5b linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Wed Dec 03 18:10:01 2008 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Wed Dec 03 20:11:23 2008 +0100
@@ -211,6 +211,7 @@
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 	struct gspca_frame *frame;
+	int i;
 	int st;
 
 	PDEBUG(D_PACK, "bulk irq");
@@ -231,16 +232,14 @@
 	}
 
 	/* check the availability of the frame buffer */
-	frame = gspca_get_i_frame(gspca_dev);
-	if (!frame) {
-		gspca_dev->last_packet_type = DISCARD_PACKET;
-	} else {
-		PDEBUG(D_PACK, "packet l:%d", urb->actual_length);
-		gspca_dev->sd_desc->pkt_scan(gspca_dev,
-					frame,
-					urb->transfer_buffer,
-					urb->actual_length);
-	}
+	i = gspca_dev->fr_i;
+	i = gspca_dev->fr_queue[i];
+	frame = &gspca_dev->frame[i];
+	PDEBUG(D_PACK, "packet l:%d", urb->actual_length);
+	gspca_dev->sd_desc->pkt_scan(gspca_dev,
+				frame,
+				urb->transfer_buffer,
+				urb->actual_length);
 
 	/* resubmit the URB */
 	if (gspca_dev->cam.bulk_nurbs != 0) {

--=-8F+Fw2cKCVFZtI/OSDDC
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-8F+Fw2cKCVFZtI/OSDDC--
