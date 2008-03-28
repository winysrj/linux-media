Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAZBsZ028966
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:35:11 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAY4mk018492
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:48 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175182fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:48 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <91e7d2afab2c180c435e.1206699520@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:40 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 9 of 9] videobuf-dma-sg.c: Avoid NULL dereference and add
	comment about backwards compatibility
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
# Date 1206699283 25200
# Node ID 91e7d2afab2c180c435e5dc85b4cb749b1001e5a
# Parent  0b7eea4e7b7dc24b1c015e5768fdb8f70f70c751
videobuf-dma-sg.c: Avoid NULL dereference and add comment about backwards compatibility

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-dma-sg.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/linux/drivers/media/video/videobuf-dma-sg.c b/linux/drivers/media/video/videobuf-dma-sg.c
--- a/linux/drivers/media/video/videobuf-dma-sg.c
+++ b/linux/drivers/media/video/videobuf-dma-sg.c
@@ -592,6 +592,14 @@ static int __videobuf_mmap_mapper(struct
 		goto done;
 	}
 
+	/* This function maintains backwards compatibility with V4L1 and will
+	 * map more than one buffer if the vma length is equal to the combined
+	 * size of multiple buffers than it will map them together.  See
+	 * VIDIOCGMBUF in the v4l spec
+	 *
+	 * TODO: Allow drivers to specify if they support this mode
+	 */
+
 	/* look for first buffer to map */
 	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
 		if (NULL == q->bufs[first])
@@ -636,10 +644,16 @@ static int __videobuf_mmap_mapper(struct
 	map = kmalloc(sizeof(struct videobuf_mapping),GFP_KERNEL);
 	if (NULL == map)
 		goto done;
-	for (size = 0, i = first; i <= last; size += q->bufs[i++]->bsize) {
+
+	size = 0;
+	for (i = first; i <= last; i++) {
+		if (NULL == q->bufs[i])
+			continue;
 		q->bufs[i]->map   = map;
 		q->bufs[i]->baddr = vma->vm_start + size;
+		size += q->bufs[i]->bsize;
 	}
+
 	map->count    = 1;
 	map->start    = vma->vm_start;
 	map->end      = vma->vm_end;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
