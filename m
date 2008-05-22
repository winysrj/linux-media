Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4MJUuDI012505
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 15:30:56 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4MJUiZx010520
	for <video4linux-list@redhat.com>; Thu, 22 May 2008 15:30:44 -0400
Date: Thu, 22 May 2008 21:30:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0805222126070.8800@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Remove v4l2_video_std_fps prototype declaration
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

The v4l2_video_std_fps function has been removed by Adrian Bunk in 2004 
but then its prototype re-appeared in include/media/v4l2-dev.h. Remove it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index a807d2f..33f01ae 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -40,7 +40,6 @@
 #define VFL_TYPE_VTX		3
 
 /*  Video standard functions  */
-extern unsigned int v4l2_video_std_fps(struct v4l2_standard *vs);
 extern char *v4l2_norm_to_name(v4l2_std_id id);
 extern int v4l2_video_std_construct(struct v4l2_standard *vs,
 				    int id, char *name);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
