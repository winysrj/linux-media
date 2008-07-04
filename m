Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m647aDAM004696
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 03:36:13 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m647ZiY3004183
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 03:35:44 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEfpX-0007Yk-IV
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 09:35:43 +0200
Message-ID: <486DD2AC.1020902@hhs.nl>
Date: Fri, 04 Jul 2008 09:35:08 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------090501070806080407000200"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-uniform-pixfmt-report.patch
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

This is a multi-part message in MIME format.
--------------090501070806080407000200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

This patch fixes 3 inconsistencies between the pixfmt's returned by set_fmt
(through try_fmt / and try_fmt) and get_fmt.

* set_fmt (try_fmt) didn't set the pixformat field member
* get_fmt didn't take compression into account when setting sizeimage
* set_fmt (try_fmt) did take compression into account when setting sizeimage,
   but didn't add 600 to sizeimage for the jpeg header, as frame_alloc does

The later 2 are fixed by moving all buffer size calculations to
gspca_get_buff_size and using that everywhere for consistency.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------090501070806080407000200
Content-Type: text/plain;
 name="gspca-uniform-pixfmt-report.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-uniform-pixfmt-report.patch"

This patch fixes 3 inconsistencies between the pixfmt's returned by set_fmt
(through try_fmt / and try_fmt) and get_fmt.

* set_fmt (try_fmt) didn't set the pixformat field member
* get_fmt didn't take compression into account when setting sizeimage
* set_fmt (try_fmt) did take compression into account when setting sizeimage,
  but didn't add 600 to sizeimage for the jpeg header, as frame_alloc does

The later 2 are fixed by moving all buffer size calculations to
gspca_get_buff_size and using that everywhere for consistency.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r feeaaa9d3ed3 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Thu Jul 03 13:20:58 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 09:28:31 2008 +0200
@@ -397,14 +397,20 @@
 	return 24;
 }
 
-static int gspca_get_buff_size(struct gspca_dev *gspca_dev)
+static int gspca_get_buff_size(struct gspca_dev *gspca_dev, int mode)
 {
 	unsigned int size;
 
-	size = gspca_dev->width * gspca_dev->height
-				* get_v4l2_depth(gspca_dev->pixfmt) / 8;
+	size =  gspca_dev->cam.cam_mode[mode].width * 
+		gspca_dev->cam.cam_mode[mode].height *
+		get_v4l2_depth(gspca_dev->cam.cam_mode[mode].pixfmt) / 8;
 	if (!size)
 		return -ENOMEM;
+
+	/* if compressed (JPEG), reduce the buffer size */
+	if (gspca_is_compressed(gspca_dev->cam.cam_mode[mode].pixfmt))
+		size = (size * comp_fac) / 100 + 600; /* (+ JPEG header sz) */
+
 	return size;
 }
 
@@ -415,15 +421,12 @@
 	unsigned int frsz;
 	int i;
 
-	frsz = gspca_get_buff_size(gspca_dev);
+	frsz = gspca_get_buff_size(gspca_dev, gspca_dev->curr_mode);
 	if (frsz < 0)
 		return frsz;
 	PDEBUG(D_STREAM, "frame alloc frsz: %d", frsz);
 	if (count > GSPCA_MAX_FRAMES)
 		count = GSPCA_MAX_FRAMES;
-	/* if compressed (JPEG), reduce the buffer size */
-	if (gspca_is_compressed(gspca_dev->pixfmt))
-		frsz = (frsz * comp_fac) / 100 + 600; /* (+ JPEG header sz) */
 	frsz = PAGE_ALIGN(frsz);
 	PDEBUG(D_STREAM, "new fr_sz: %d", frsz);
 	gspca_dev->frsz = frsz;
@@ -802,8 +805,8 @@
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = get_v4l2_depth(fmt->fmt.pix.pixelformat)
 					* fmt->fmt.pix.width / 8;
-	fmt->fmt.pix.sizeimage = fmt->fmt.pix.bytesperline
-					* fmt->fmt.pix.height;
+	fmt->fmt.pix.sizeimage = gspca_get_buff_size(gspca_dev,
+							gspca_dev->curr_mode);
 /* (should be in the subdriver) */
 	fmt->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
 	fmt->fmt.pix.priv = 0;
@@ -813,7 +816,7 @@
 static int try_fmt_vid_cap(struct gspca_dev *gspca_dev,
 			struct v4l2_format *fmt)
 {
-	int w, h, mode, mode2, frsz;
+	int w, h, mode, mode2;
 
 	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -855,12 +858,10 @@
 	}
 	fmt->fmt.pix.width = gspca_dev->cam.cam_mode[mode].width;
 	fmt->fmt.pix.height = gspca_dev->cam.cam_mode[mode].height;
+	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = get_v4l2_depth(fmt->fmt.pix.pixelformat)
 					* fmt->fmt.pix.width / 8;
-	frsz = fmt->fmt.pix.bytesperline * fmt->fmt.pix.height;
-	if (gspca_is_compressed(fmt->fmt.pix.pixelformat))
-		frsz = (frsz * comp_fac) / 100;
-	fmt->fmt.pix.sizeimage = frsz;
+	fmt->fmt.pix.sizeimage = gspca_get_buff_size(gspca_dev, mode);
 	return mode;			/* used when s_fmt */
 }
 

--------------090501070806080407000200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090501070806080407000200--
