Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FKugo7032048
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 16:56:42 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6FKu8dY031883
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 16:56:09 -0400
Message-ID: <487D10AA.6070404@hhs.nl>
Date: Tue, 15 Jul 2008 23:03:38 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------000503070502030003080502"
Cc: video4linux-list@redhat.com
Subject: Patch: gspca-spca501-imagesize.patch
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
--------------000503070502030003080502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

When moving the imagesize calculation to the subdrivers, an error was
introduced in the bufsize calculation for the spca501, causing the driver to
no longer work, this patch fixes this.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------000503070502030003080502
Content-Type: text/x-patch;
 name="gspca-spca501-imagesize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-spca501-imagesize.patch"

When moving the imagesize calculation to the subdrivers, an error was
introduced in the bufsize calculation for the spca501, causing the driver to
no longer work, this patch fixes this.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 2022d9f2fb55 linux/drivers/media/video/gspca/spca501.c
--- a/linux/drivers/media/video/gspca/spca501.c	Tue Jul 15 11:17:05 2008 +0200
+++ b/linux/drivers/media/video/gspca/spca501.c	Tue Jul 15 23:00:45 2008 +0200
@@ -104,17 +104,17 @@
 static struct v4l2_pix_format vga_mode[] = {
 	{160, 120, V4L2_PIX_FMT_SPCA501, V4L2_FIELD_NONE,
 		.bytesperline = 160,
-		.sizeimage = 160 * 120 * 3 / 8,
+		.sizeimage = 160 * 120 * 3 / 2,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 2},
 	{320, 240, V4L2_PIX_FMT_SPCA501, V4L2_FIELD_NONE,
 		.bytesperline = 320,
-		.sizeimage = 320 * 240 * 3 / 8,
+		.sizeimage = 320 * 240 * 3 / 2,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 1},
 	{640, 480, V4L2_PIX_FMT_SPCA501, V4L2_FIELD_NONE,
 		.bytesperline = 640,
-		.sizeimage = 640 * 480 * 3 / 8,
+		.sizeimage = 640 * 480 * 3 / 2,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 0},
 };

--------------000503070502030003080502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------000503070502030003080502--
