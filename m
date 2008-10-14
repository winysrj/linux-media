Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECmuhA028439
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:56 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.239])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECm02D005686
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:44 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182413rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:48:44 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:47:35 +0900
Message-Id: <20081014124735.5194.46887.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
References: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 04/05] video: Add support for rgb565 pixel formats to vivi
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

From: Magnus Damm <damm@igel.co.jp>

This patch adds RGB565 pixel format support to the vivi driver. Both
little endian and big endian versions are added. The driver follows
the RGB pixel format described in Table 2-2 of the V4L2 API spec,
_not_ the older BGR interpretation described in Table 2-1.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- 0018/drivers/media/video/vivi.c
+++ work/drivers/media/video/vivi.c	2008-10-14 20:28:17.000000000 +0900
@@ -139,6 +139,16 @@ static struct vivi_fmt formats[] = {
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.depth    = 16,
 	},
+	{
+		.name     = "RGB565 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565, /* gggbbbbb rrrrrggg */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB565 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
+		.depth    = 16,
+	},
 };
 
 static struct vivi_fmt *get_format(struct v4l2_format *f)
@@ -301,6 +311,30 @@ static void gen_twopix(struct vivi_fh *f
 				break;
 			}
 			break;
+		case V4L2_PIX_FMT_RGB565:
+			switch (color) {
+			case 0:
+			case 2:
+				*p = (g_u << 5) | b_v;
+				break;
+			case 1:
+			case 3:
+				*p = (r_y << 3) | (g_u >> 3);
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_RGB565X:
+			switch (color) {
+			case 0:
+			case 2:
+				*p = (r_y << 3) | (g_u >> 3);
+				break;
+			case 1:
+			case 3:
+				*p = (g_u << 5) | b_v;
+				break;
+			}
+			break;
 		}
 	}
 }
@@ -778,6 +812,12 @@ static int vidioc_s_fmt_vid_cap(struct f
 		case V4L2_PIX_FMT_UYVY:
 			is_yuv = 1;
 			break;
+		case V4L2_PIX_FMT_RGB565:
+		case V4L2_PIX_FMT_RGB565X:
+			r >>= 3;
+			g >>= 2;
+			b >>= 3;
+			break;
 		}
 
 		if (is_yuv) {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
