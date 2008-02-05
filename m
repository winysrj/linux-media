Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m152CvYu014088
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:57 -0500
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m152CRE9019219
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <a030ada87143b0e559ae.1202176997@localhost>
In-Reply-To: <patchbomb.1202176995@localhost>
Date: Mon, 04 Feb 2008 18:03:17 -0800
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org, laurent.pinchart@skynet.be
Cc: v4l-dvb-maintainer@linuxtv.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com
Subject: [PATCH 2 of 3] [v4l] Add new user class controls and deprecate
	others
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1202175714 28800
# Node ID a030ada87143b0e559aecb0bbd9fc1ed7384d0be
# Parent  0810f250d078bf6159de69569828c07cb54f4389
[v4l] Add new user class controls and deprecate others

These changes should appear in the next update of the v4l2spec.

HCENTER and VCENTER are unused in the tree so I added a _DEPRECATED
postfix so applications can remove their use.

Signed-off-by: Brandon Philips <bphilips@suse.de>

diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -848,21 +848,34 @@ struct v4l2_querymenu
 #define V4L2_CID_AUDIO_TREBLE		(V4L2_CID_BASE+8)
 #define V4L2_CID_AUDIO_MUTE		(V4L2_CID_BASE+9)
 #define V4L2_CID_AUDIO_LOUDNESS		(V4L2_CID_BASE+10)
-#define V4L2_CID_BLACK_LEVEL		(V4L2_CID_BASE+11)
+#define V4L2_CID_BLACK_LEVEL		(V4L2_CID_BASE+11) /* Deprecated */
 #define V4L2_CID_AUTO_WHITE_BALANCE	(V4L2_CID_BASE+12)
 #define V4L2_CID_DO_WHITE_BALANCE	(V4L2_CID_BASE+13)
 #define V4L2_CID_RED_BALANCE		(V4L2_CID_BASE+14)
 #define V4L2_CID_BLUE_BALANCE		(V4L2_CID_BASE+15)
 #define V4L2_CID_GAMMA			(V4L2_CID_BASE+16)
-#define V4L2_CID_WHITENESS		(V4L2_CID_GAMMA) /* ? Not sure */
+#define V4L2_CID_WHITENESS		(V4L2_CID_GAMMA) /* Deprecated */
 #define V4L2_CID_EXPOSURE		(V4L2_CID_BASE+17)
 #define V4L2_CID_AUTOGAIN		(V4L2_CID_BASE+18)
 #define V4L2_CID_GAIN			(V4L2_CID_BASE+19)
 #define V4L2_CID_HFLIP			(V4L2_CID_BASE+20)
 #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
-#define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
-#define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
-#define V4L2_CID_LASTP1			(V4L2_CID_BASE+24) /* last CID + 1 */
+
+/* Deprecated, use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
+#define V4L2_CID_HCENTER_DEPRECATED	(V4L2_CID_BASE+22) 
+#define V4L2_CID_VCENTER_DEPRECATED	(V4L2_CID_BASE+23) 
+
+#define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24) 
+enum v4l2_power_line_frequency {
+	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
+	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
+	V4L2_CID_POWER_LINE_FREQUENCY_60HZ	= 2,
+};
+#define V4L2_CID_HUE_AUTO			(V4L2_CID_BASE+25) 
+#define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26) 
+#define V4L2_CID_SHARPNESS			(V4L2_CID_BASE+27) 
+#define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28) 
+#define V4L2_CID_LASTP1				(V4L2_CID_BASE+29) /* last CID + 1 */
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
