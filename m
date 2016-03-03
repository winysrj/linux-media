Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36551 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbcCCTM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 14:12:58 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: albert@newtec.dk, Jan Kara <jack@suse.cz>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] [media] vb2-memops: Use bool macros instead of 1
Date: Thu,  3 Mar 2016 20:12:49 +0100
Message-Id: <1457032369-10503-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1457032369-10503-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1457032369-10503-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the prototype of the called function:

int get_vaddr_frames(unsigned long start, unsigned int nr_pfns,
bool write, bool force, struct frame_vector *vec);

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-memops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index e4e4976c6849..3c3b517f1d1c 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -49,7 +49,7 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
 	vec = frame_vector_create(nr);
 	if (!vec)
 		return ERR_PTR(-ENOMEM);
-	ret = get_vaddr_frames(start & PAGE_MASK, nr, write, 1, vec);
+	ret = get_vaddr_frames(start & PAGE_MASK, nr, write, true, vec);
 	if (ret < 0)
 		goto out_destroy;
 	/* We accept only complete set of PFNs */
-- 
2.7.0

