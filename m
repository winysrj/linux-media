Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA4uYIW022069
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 23:56:34 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA4uKbk012106
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 23:56:20 -0500
Received: by yx-out-2324.google.com with SMTP id 31so150600yxl.81
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 20:56:20 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 10 Dec 2008 13:54:32 +0900
Message-Id: <20081210045432.3810.42700.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org
Subject: [PATCH] videobuf-dma-contig: fix USERPTR free handling
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

This patch fixes a free-without-alloc bug for V4L2_MEMORY_USERPTR
video buffers.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/videobuf-dma-contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0001/drivers/media/video/videobuf-dma-contig.c
+++ work/drivers/media/video/videobuf-dma-contig.c	2008-12-07 22:34:47.000000000 +0900
@@ -400,7 +400,7 @@ void videobuf_dma_contig_free(struct vid
 	   So, it should free memory only if the memory were allocated for
 	   read() operation.
 	 */
-	if ((buf->memory != V4L2_MEMORY_USERPTR) || !buf->baddr)
+	if ((buf->memory != V4L2_MEMORY_USERPTR) || buf->baddr)
 		return;
 
 	if (!mem)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
