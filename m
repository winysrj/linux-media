Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094022.327990180@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:53 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline;
	filename=videobuf-dma-sg-comments-and-avoid-NULL-deref.patch
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>
Subject: [patch 9/9] videobuf-dma-sg.c: Avoid NULL dereference and add
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

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-dma-sg.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: v4l-dvb/linux/drivers/media/video/videobuf-dma-sg.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/videobuf-dma-sg.c
+++ v4l-dvb/linux/drivers/media/video/videobuf-dma-sg.c
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
