Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADIYXxJ005327
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 13:34:33 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADIYKfP002227
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 13:34:20 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081113180421.09c5ca05.ospite@studenti.unina.it>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
	<1226576038.2040.42.camel@localhost>
	<20081113180421.09c5ca05.ospite@studenti.unina.it>
Content-Type: multipart/mixed; boundary="=-+SkPUKyZ9Ibj+Rel4998"
Date: Thu, 13 Nov 2008 19:30:59 +0100
Message-Id: <1226601059.1705.12.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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


--=-+SkPUKyZ9Ibj+Rel4998
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On Thu, 2008-11-13 at 18:04 +0100, Antonio Ospite wrote:
> So (cam->bulk_nurbs == 0) would mean that the subdriver takes care of
> usb tranfers, right? That would also imply that bulk_irq() is not set
> for these drivers and sd_pkt_scan() is never called which looks fair to
> me.
	[snip]

Yes. In the finepix subdriver, the 'complete' function of the URB is
changed to a local function which does the packet analysis and restarts
the next transfer after a delay.

I attached the patch of the main driver.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--=-+SkPUKyZ9Ibj+Rel4998
Content-Disposition: attachment; filename=gspca_bulk.patch
Content-Type: text/x-patch; name=gspca_bulk.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

diff -r 417024f56f55 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Tue Nov 11 12:42:56 2008 +0100
+++ b/linux/drivers/media/video/gspca/gspca.c	Thu Nov 13 19:14:42 2008 +0100
@@ -213,6 +213,7 @@
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 	struct gspca_frame *frame;
+	int st;
 
 	PDEBUG(D_PACK, "bulk irq");
 	if (!gspca_dev->streaming)
@@ -235,6 +236,13 @@
 					frame,
 					urb->transfer_buffer,
 					urb->actual_length);
+	}
+
+	/* resubmit the URB */
+	if (gspca_dev->cam.bulk_nurbs != 0) {
+		st = usb_submit_urb(urb, GFP_ATOMIC);
+		if (st < 0)
+			PDEBUG(D_ERR|D_PACK, "usb_submit_urb() ret %d", st);
 	}
 }
 
@@ -533,11 +541,14 @@
 		nurbs = DEF_NURBS;
 	} else {				/* bulk */
 		npkt = 0;
-		bsize = gspca_dev->cam.	bulk_size;
+		bsize = gspca_dev->cam.bulk_size;
 		if (bsize == 0)
 			bsize = psize;
 		PDEBUG(D_STREAM, "bulk bsize:%d", bsize);
-		nurbs = 1;
+		if (gspca_dev->cam.bulk_nurbs != 0)
+			nurbs = gspca_dev->cam.bulk_nurbs;
+		else
+			nurbs = 1;
 	}
 
 	gspca_dev->nurbs = nurbs;
@@ -625,8 +636,8 @@
 		gspca_dev->streaming = 1;
 		atomic_set(&gspca_dev->nevent, 0);
 
-		/* bulk transfers are started by the subdriver */
-		if (gspca_dev->alt == 0)
+		/* some bulk transfers are started by the subdriver */
+		if (gspca_dev->alt == 0 && gspca_dev->cam.bulk_nurbs == 0)
 			break;
 
 		/* submit the URBs */
diff -r 417024f56f55 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Tue Nov 11 12:42:56 2008 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h	Thu Nov 13 19:14:42 2008 +0100
@@ -58,6 +58,10 @@
 	int bulk_size;		/* buffer size when image transfer by bulk */
 	struct v4l2_pix_format *cam_mode;	/* size nmodes */
 	char nmodes;
+	__u8 bulk_nurbs;	/* number of URBs in bulk mode
+				 * - cannot be > MAX_NURBS
+				 * - when 0 and bulk_size != 0 means
+				 *   1 URB and submit done by subdriver */
 	__u8 epaddr;
 };
 

--=-+SkPUKyZ9Ibj+Rel4998
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-+SkPUKyZ9Ibj+Rel4998--
