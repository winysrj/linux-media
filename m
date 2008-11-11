Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABHgLtd005847
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 12:42:21 -0500
Received: from smtp-out112.alice.it (smtp-out112.alice.it [85.37.17.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABHg6Lg001950
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 12:42:07 -0500
Date: Tue, 11 Nov 2008 18:42:00 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081111184200.cb9a2ba4.ospite@studenti.unina.it>
In-Reply-To: <20081105203114.213b599a@pedra.chehab.org>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
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

On Wed, 5 Nov 2008 20:31:14 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Sat, 16 Aug 2008 07:13:37 -0500
> "Mark Ferrell" <majortrips@gmail.com> wrote:
> 
> > Done
> 
> 
> Mark,
> 
> Any news?
> 
> Cheers,
> Mauro
>

Hi,

Actually I've started a port of this driver to gspca as an exercise.
You can find a rough preview here:
http://shell.studenti.unina.it/~ospite/tmp/gspca_ov534-20081111-1733.tar.bz2

I tried to (ab)use gpsca infrastructure for bulk transfers, the driver is
quite essential but it works acceptably well, for now, even if I still
loose fames because of some bug.

The driver needs the attached changes (or any better equivalent)
to gspca bulk transfers code.
Could these changes break other drivers which work with bulk transfers?

Thanks,
   Antonio Ospite


Use gspca itself for usb communication when using bulk transfers.
Let the subdriver define the number of URBs to submit.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index e48fbfc..a909149 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -200,6 +200,7 @@ static void bulk_irq(struct urb *urb
 {
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;
 	struct gspca_frame *frame;
+	int st;
 
 	PDEBUG(D_PACK, "bulk irq");
 	if (!gspca_dev->streaming)
@@ -223,6 +224,11 @@ static void bulk_irq(struct urb *urb
 					urb->transfer_buffer,
 					urb->actual_length);
 	}
+	/* resubmit the URB */
+	urb->status = 0;
+	st = usb_submit_urb(urb, GFP_ATOMIC);
+	if (st < 0)
+		PDEBUG(D_ERR|D_PACK, "usb_submit_urb() ret %d", st);
 }
 
 /*
@@ -520,11 +526,11 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 		nurbs = DEF_NURBS;
 	} else {				/* bulk */
 		npkt = 0;
-		bsize = gspca_dev->cam.	bulk_size;
+		bsize = gspca_dev->cam.bulk_size;
 		if (bsize == 0)
 			bsize = psize;
 		PDEBUG(D_STREAM, "bulk bsize:%d", bsize);
-		nurbs = 1;
+		nurbs = gspca_dev->cam.bulk_nurbs;
 	}
 
 	gspca_dev->nurbs = nurbs;
@@ -607,8 +613,10 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 		atomic_set(&gspca_dev->nevent, 0);
 
 		/* bulk transfers are started by the subdriver */
+		/* XXX: find a way to esplicitly skip submitting urbs
 		if (gspca_dev->alt == 0)
 			break;
+		*/
 
 		/* submit the URBs */
 		for (n = 0; n < gspca_dev->nurbs; n++) {
@@ -1855,6 +1863,9 @@ int gspca_dev_probe(struct usb_interface *intf,
 	ret = gspca_dev->sd_desc->config(gspca_dev, id);
 	if (ret < 0)
 		goto out;
+	if (!gspca_dev->cam.bulk_nurbs)
+		gspca_dev->cam.bulk_nurbs = 1;
+
 	ret = gspca_dev->sd_desc->init(gspca_dev);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index 1d9dc90..4f42953 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -56,6 +56,7 @@ extern int gspca_debug;
 /* device information - set at probe time */
 struct cam {
 	int bulk_size;		/* buffer size when image transfer by bulk */
+	int bulk_nurbs;		/* number of URBs to use in bulk mode*/
 	struct v4l2_pix_format *cam_mode;	/* size nmodes */
 	char nmodes;
 	__u8 epaddr;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
