Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6665rdI009816
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 02:05:53 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6665fSG031288
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 02:05:41 -0400
Message-ID: <48706247.8080500@hhs.nl>
Date: Sun, 06 Jul 2008 08:12:23 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------020301090406070206000000"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-pac207-framesize.patch
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
--------------020301090406070206000000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The pac207 only does compression when the usb bandwidth mandates it, so when
in full ress mode but doing low framerates (high exposure) setting it does not
compress. Adjust full res bufsize for this, otherwise things stop working when
the framerate gets too low.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------020301090406070206000000
Content-Type: text/x-patch;
 name="gspca-pac207-framesize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-pac207-framesize.patch"

The pac207 only does compression when the usb bandwidth mandates it, so when
in full ress mode but doing low framerates (high exposure) setting it does not
compress. Adjust full res bufsize for this, otherwise things stop working when
the framerate gets too low.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r 3bbf8991628b linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Sat Jul 05 13:49:20 2008 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c	Sun Jul 06 08:08:19 2008 +0200
@@ -166,7 +166,9 @@
 		.priv = 1},
 	{352, 288, V4L2_PIX_FMT_PAC207, V4L2_FIELD_NONE,
 		.bytesperline = 352,
-		.sizeimage = 352 * 288 / 2,	/* compressed */
+			/* compressed, but only when needed (not compressed
+			   when the framerate is low) */
+		.sizeimage = (352 + 2) * 288,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 0},
 };

--------------020301090406070206000000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------020301090406070206000000--
