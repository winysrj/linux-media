Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094021.788747028@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:49 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline; filename=videobuf-buf_release-vm_close.patch
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Brandon Philips <bphilips@suse.de>
Subject: [patch 5/9] videobuf-vmalloc.c: Remove buf_release from
	videobuf_vm_close
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

Remove the buf_release on vm_close because it will lead to a buffer being
released multiple times since all buffers are already freed under the two
possible cases: device close or STREAMOFF.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

Index: v4l-dvb/linux/drivers/media/video/videobuf-vmalloc.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/videobuf-vmalloc.c
+++ v4l-dvb/linux/drivers/media/video/videobuf-vmalloc.c
@@ -79,8 +79,6 @@ videobuf_vm_close(struct vm_area_struct 
 			if (q->bufs[i]->map != map)
 				continue;
 
-			q->ops->buf_release(q,q->bufs[i]);
-
 			q->bufs[i]->map   = NULL;
 			q->bufs[i]->baddr = 0;
 		}

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
