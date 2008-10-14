Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECmlMP028409
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:47 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECmAqb005783
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:36 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182462rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:48:35 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:47:25 +0900
Message-Id: <20081014124725.5194.87458.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
References: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 03/05] video: Add uyvy pixel format support to vivi
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

This patch simply adds UYVY pixel format support to the vivi driver.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- 0017/drivers/media/video/vivi.c
+++ work/drivers/media/video/vivi.c	2008-10-10 16:32:58.000000000 +0900
@@ -134,6 +134,11 @@ static struct vivi_fmt formats[] = {
 		.fourcc   = V4L2_PIX_FMT_YUYV,
 		.depth    = 16,
 	},
+	{
+		.name     = "4:2:2, packed, UYVY",
+		.fourcc   = V4L2_PIX_FMT_UYVY,
+		.depth    = 16,
+	},
 };
 
 static struct vivi_fmt *get_format(struct v4l2_format *f)
@@ -282,6 +287,20 @@ static void gen_twopix(struct vivi_fh *f
 				break;
 			}
 			break;
+		case V4L2_PIX_FMT_UYVY:
+			switch (color) {
+			case 1:
+			case 3:
+				*p = r_y;
+				break;
+			case 0:
+				*p = g_u;
+				break;
+			case 2:
+				*p = b_v;
+				break;
+			}
+			break;
 		}
 	}
 }
@@ -756,6 +775,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 
 		switch (fh->fmt->fourcc) {
 		case V4L2_PIX_FMT_YUYV:
+		case V4L2_PIX_FMT_UYVY:
 			is_yuv = 1;
 			break;
 		}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
