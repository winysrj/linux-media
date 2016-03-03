Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34595 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbcCCTM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 14:12:56 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: albert@newtec.dk, Jan Kara <jack@suse.cz>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] [media] vb2-memops: Fix over allocation of frame vectors
Date: Thu,  3 Mar 2016 20:12:48 +0100
Message-Id: <1457032369-10503-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On page unaligned frames, create_framevec forces get_vaddr_frames to
allocate an extra page at the end of the buffer. Under some
circumstances, this leads to -EINVAL on VIDIOC_QBUF.

E.g:
We have vm_a that vm_area that goes from 0x1000 to 0x3000. And a
frame that goes from 0x1800 to 0x2800, i.e. 2 pages.

frame_vector_create will be called with the following params:

get_vaddr_frames(0x1800 , 2, write, 1, vec);

get_vaddr will allocate the first page after checking that the memory
0x1800-0x27ff is valid, but it will not allocate the second page because
the range 0x2800-0x37ff is out of the vm_a range. This results in
create_framevec returning -EFAULT

Error Trace:
[ 9083.793015] video0: VIDIOC_QBUF: 00:00:00.00000000 index=1,
type=vid-cap, flags=0x00002002, field=any, sequence=0,
memory=userptr, bytesused=0, offset/userptr=0x7ff2b023ca80, length=5765760
[ 9083.793028] timecode=00:00:00 type=0, flags=0x00000000,
frames=0, userbits=0x00000000
[ 9083.793117] video0: VIDIOC_QBUF: error -22: 00:00:00.00000000
index=2, type=vid-cap, flags=0x00000000, field=any, sequence=0,
memory=userptr, bytesused=0, offset/userptr=0x7ff2b07bc500, length=5765760

Fixes: 21fb0cb7ec65 ("[media] vb2: Provide helpers for mapping virtual addresses")
Reported-by: Albert Antony <albert@newtec.dk>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

Maybe we should cc stable.

This error has not pop-out yet because userptr is usually called with memory
on the heap and malloc usually overallocate. This error has been a pain to trace :).

Regards!



 drivers/media/v4l2-core/videobuf2-memops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index dbec5923fcf0..e4e4976c6849 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -49,7 +49,7 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
 	vec = frame_vector_create(nr);
 	if (!vec)
 		return ERR_PTR(-ENOMEM);
-	ret = get_vaddr_frames(start, nr, write, 1, vec);
+	ret = get_vaddr_frames(start & PAGE_MASK, nr, write, 1, vec);
 	if (ret < 0)
 		goto out_destroy;
 	/* We accept only complete set of PFNs */
-- 
2.7.0

