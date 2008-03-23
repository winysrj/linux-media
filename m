Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NMihHp018795
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:43 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NMiBae019549
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 18:44:11 -0400
Received: by fg-out-1718.google.com with SMTP id e12so2174216fga.7
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 15:44:10 -0700 (PDT)
From: "Frej Drejhammar" <frej.drejhammar@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <b3a7ec84ad4959869d50.1206312203@liva.fdsoft.se>
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Date: Sun, 23 Mar 2008 23:43:23 +0100
To: video4linux-list@redhat.com
Cc: Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 4 of 6] v4l2-api: Define a standard control for color killer
	functionality
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

1 file changed, 2 insertions(+), 1 deletion(-)
linux/include/linux/videodev2.h |    3 ++-


# HG changeset patch
# User "Frej Drejhammar <frej.drejhammar@gmail.com>"
# Date 1206311969 -3600
# Node ID b3a7ec84ad4959869d50710bfcbfb997fb39850d
# Parent  f11b3fd53145c7ce1b9dbde7e83cbaf6478576bc
v4l2-api: Define a standard control for color killer functionality

From: "Frej Drejhammar <frej.drejhammar@gmail.com>"

Define a pre-defined control ID for color killer functionality.

Signed-off-by: "Frej Drejhammar <frej.drejhammar@gmail.com>"

diff -r f11b3fd53145 -r b3a7ec84ad49 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Sun Mar 23 23:39:02 2008 +0100
+++ b/linux/include/linux/videodev2.h	Sun Mar 23 23:39:29 2008 +0100
@@ -880,8 +880,9 @@ enum v4l2_power_line_frequency {
 #define V4L2_CID_SHARPNESS			(V4L2_CID_BASE+27)
 #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
 #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
+#define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+30)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
