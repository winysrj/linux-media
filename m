Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYpT3028213
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:51 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAXY5P018282
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:25 -0400
Received: by fg-out-1718.google.com with SMTP id e12so174998fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:25 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <eb99bdd0a7e3f70eb40f.1206699516@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:36 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 5 of 9] videobuf-vmalloc.c: Remove buf_release from
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699279 25200
# Node ID eb99bdd0a7e3f70eb40fcc6918794a8b8822ac49
# Parent  3ac2b9752844e2635575e50594d50cea665ca09b
videobuf-vmalloc.c: Remove buf_release from videobuf_vm_close

Remove the buf_release on vm_close because it will lead to a buffer being
released multiple times since all buffers are already freed under the two
possible cases: device close or STREAMOFF.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/linux/drivers/media/video/videobuf-vmalloc.c b/linux/drivers/media/video/videobuf-vmalloc.c
--- a/linux/drivers/media/video/videobuf-vmalloc.c
+++ b/linux/drivers/media/video/videobuf-vmalloc.c
@@ -78,8 +78,6 @@ videobuf_vm_close(struct vm_area_struct 
 
 			if (q->bufs[i]->map != map)
 				continue;
-
-			q->ops->buf_release(q,q->bufs[i]);
 
 			q->bufs[i]->map   = NULL;
 			q->bufs[i]->baddr = 0;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
