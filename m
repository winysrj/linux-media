Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63AgCCi032668
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 06:42:12 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63AfwT7001314
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 06:41:59 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEMGE-00032t-FB
	for video4linux-list@redhat.com; Thu, 03 Jul 2008 12:41:58 +0200
Message-ID: <486CACD5.1020307@hhs.nl>
Date: Thu, 03 Jul 2008 12:41:25 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------020801090608040709030101"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca, spca561:  fix low res modes
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
--------------020801090608040709030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

The low (half) res modes of the spca561 are not spca561 compressed, but are
raw bayer, this patches fixes this and adds a PIX_FMT define for the GBRG
bayer format used by the spca561 in low res mode.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------020801090608040709030101
Content-Type: text/plain;
 name="gspca-spca561-low-res.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-spca561-low-res.patch"

The low (half) res modes of the spca561 are not spca561 compressed, but are
raw bayer, this patches fixes this and adds a PIX_FMT define for the GBRG
bayer format used by the spca561 in low res mode.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c~	2008-07-03 12:34:09.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/spca561.c	2008-07-03 12:34:09.000000000 +0200
@@ -98,8 +98,8 @@ static struct ctrl sd_ctrls[] = {
 };
 
 static struct cam_mode sif_mode[] = {
-	{V4L2_PIX_FMT_SPCA561, 160, 120, 3},
-	{V4L2_PIX_FMT_SPCA561, 176, 144, 2},
+	{V4L2_PIX_FMT_SGBRG8, 160, 120, 3},
+	{V4L2_PIX_FMT_SGBRG8, 176, 144, 2},
 	{V4L2_PIX_FMT_SPCA561, 320, 240, 1},
 	{V4L2_PIX_FMT_SPCA561, 352, 288, 0},
 };
@@ -808,7 +808,7 @@ static void sd_pkt_scan(struct gspca_dev
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
 					frame, data, len);
 		} else {
-			/*fixme: which format?*/
+			/* raw bayer (with a header, which we skip) */
 			data += 20;
 			len -= 20;
 			gspca_frame_add(gspca_dev, FIRST_PACKET,
--- gspca-2bbb47f61a95/linux/include/linux/videodev2.h~	2008-07-03 12:34:06.000000000 +0200
+++ gspca-2bbb47f61a95/linux/include/linux/videodev2.h	2008-07-03 12:34:06.000000000 +0200
@@ -310,6 +310,7 @@ struct v4l2_pix_format
 
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G','B','R','G') /*  8  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */

--------------020801090608040709030101
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------020801090608040709030101--
