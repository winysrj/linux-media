Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EC2Xck004347
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:02:33 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EC1Cmd000717
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:02:19 -0400
Received: by rv-out-0506.google.com with SMTP id f6so5595835rvb.51
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 05:02:19 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Mon, 14 Jul 2008 21:02:31 +0900
Message-Id: <20080714120231.4806.47837.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 03/06] videobuf: Fix gather spelling
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

Use "scatter gather" instead of "scatter gatter".

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/videobuf-dma-sg.c  |    2 +-
 drivers/media/video/videobuf-vmalloc.c |    2 +-
 include/media/videobuf-dma-sg.h        |    2 +-
 include/media/videobuf-vmalloc.h       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- 0001/drivers/media/video/videobuf-dma-sg.c
+++ work/drivers/media/video/videobuf-dma-sg.c	2008-07-14 14:33:01.000000000 +0900
@@ -1,7 +1,7 @@
 /*
  * helper functions for SG DMA video4linux capture buffers
  *
- * The functions expect the hardware being able to scatter gatter
+ * The functions expect the hardware being able to scatter gather
  * (i.e. the buffers are not linear in physical memory, but fragmented
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
--- 0001/drivers/media/video/videobuf-vmalloc.c
+++ work/drivers/media/video/videobuf-vmalloc.c	2008-07-14 14:32:50.000000000 +0900
@@ -1,7 +1,7 @@
 /*
  * helper functions for vmalloc video4linux capture buffers
  *
- * The functions expect the hardware being able to scatter gatter
+ * The functions expect the hardware being able to scatter gather
  * (i.e. the buffers are not linear in physical memory, but fragmented
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
--- 0001/include/media/videobuf-dma-sg.h
+++ work/include/media/videobuf-dma-sg.h	2008-07-14 14:33:15.000000000 +0900
@@ -1,7 +1,7 @@
 /*
  * helper functions for SG DMA video4linux capture buffers
  *
- * The functions expect the hardware being able to scatter gatter
+ * The functions expect the hardware being able to scatter gather
  * (i.e. the buffers are not linear in physical memory, but fragmented
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
--- 0001/include/media/videobuf-vmalloc.h
+++ work/include/media/videobuf-vmalloc.h	2008-07-14 14:33:22.000000000 +0900
@@ -1,7 +1,7 @@
 /*
  * helper functions for vmalloc capture buffers
  *
- * The functions expect the hardware being able to scatter gatter
+ * The functions expect the hardware being able to scatter gather
  * (i.e. the buffers are not linear in physical memory, but fragmented
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
