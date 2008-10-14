Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECnIor028693
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:49:18 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECmAqc005783
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:49:07 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182462rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:49:06 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:47:43 +0900
Message-Id: <20081014124743.5194.33407.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
References: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 05/05] video: Add support for rgb555 pixel formats to vivi
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

This patch adds RGB555 pixel format support to the vivi driver. Both
little endian and big endian versions are added. The driver follows
the RGB pixel format described in Table 2-2 of the V4L2 API spec,
_not_ the older BGR interpretation described in Table 2-1.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- 0019/drivers/media/video/vivi.c
+++ work/drivers/media/video/vivi.c	2008-10-14 20:29:17.000000000 +0900
@@ -149,6 +149,16 @@ static struct vivi_fmt formats[] = {
 		.fourcc   = V4L2_PIX_FMT_RGB565X, /* rrrrrggg gggbbbbb */
 		.depth    = 16,
 	},
+	{
+		.name     = "RGB555 (LE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555, /* gggbbbbb arrrrrgg */
+		.depth    = 16,
+	},
+	{
+		.name     = "RGB555 (BE)",
+		.fourcc   = V4L2_PIX_FMT_RGB555X, /* arrrrrgg gggbbbbb */
+		.depth    = 16,
+	},
 };
 
 static struct vivi_fmt *get_format(struct v4l2_format *f)
@@ -335,6 +345,30 @@ static void gen_twopix(struct vivi_fh *f
 				break;
 			}
 			break;
+		case V4L2_PIX_FMT_RGB555:
+			switch (color) {
+			case 0:
+			case 2:
+				*p = (g_u << 5) | b_v;
+				break;
+			case 1:
+			case 3:
+				*p = (r_y << 2) | (g_u >> 3);
+				break;
+			}
+			break;
+		case V4L2_PIX_FMT_RGB555X:
+			switch (color) {
+			case 0:
+			case 2:
+				*p = (r_y << 2) | (g_u >> 3);
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
@@ -818,6 +852,12 @@ static int vidioc_s_fmt_vid_cap(struct f
 			g >>= 2;
 			b >>= 3;
 			break;
+		case V4L2_PIX_FMT_RGB555:
+		case V4L2_PIX_FMT_RGB555X:
+			r >>= 3;
+			g >>= 3;
+			b >>= 3;
+			break;
 		}
 
 		if (is_yuv) {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
