Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61Cl29p005311
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:47:02 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61CkY7P021891
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:46:52 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2164461rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 05:46:52 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 01 Jul 2008 21:47:07 +0900
Message-Id: <20080701124707.30446.214.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
Cc: linux-sh@vger.kernel.org, akpm@linux-foundation.org, lethal@linux-sh.org,
	mchehab@infradead.org
Subject: [PATCH 03/07] soc_camera: Remove vbq_ops and msize
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

The struct soc_camera_host members vbq_ops and msize are not needed
anymore since we now let the soc_camera host manage the videobuf queue.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/pxa_camera.c |    2 --
 include/media/soc_camera.h       |    2 --
 2 files changed, 4 deletions(-)

--- 0007/drivers/media/video/pxa_camera.c
+++ work/drivers/media/video/pxa_camera.c	2008-06-12 14:30:25.000000000 +0900
@@ -1018,8 +1018,6 @@ static struct soc_camera_host_ops pxa_so
 /* Should be allocated dynamically too, but we have only one. */
 static struct soc_camera_host pxa_soc_camera_host = {
 	.drv_name		= PXA_CAM_DRV_NAME,
-	.vbq_ops		= &pxa_videobuf_ops,
-	.msize			= sizeof(struct pxa_buffer),
 	.ops			= &pxa_soc_camera_host_ops,
 };
 
--- 0007/include/media/soc_camera.h
+++ work/include/media/soc_camera.h	2008-06-12 14:30:18.000000000 +0900
@@ -55,8 +55,6 @@ struct soc_camera_host {
 	struct list_head list;
 	struct device dev;
 	unsigned char nr;				/* Host number */
-	size_t msize;
-	struct videobuf_queue_ops *vbq_ops;
 	void *priv;
 	char *drv_name;
 	struct soc_camera_host_ops *ops;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
