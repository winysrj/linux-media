Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3845 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaHYL62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:58:28 -0400
Message-ID: <53FB24C7.1000408@xs4all.nl>
Date: Mon, 25 Aug 2014 13:57:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCHv3] videobuf2-core: take mmap_sem before calling __qbuf_userptr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Changes since v2: dropped local variable as suggested by Laurent)

Commit f035eb4e976ef5a059e30bc91cfd310ff030a7d3 (videobuf2: fix lockdep warning)
unfortunately removed the mmap_sem lock that is needed around the call to
__qbuf_userptr. Amazingly nobody noticed this (especially me as the author)
until Jan Kara pointed this out to me.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Jan Kara <jack@suse.cz>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5b808e2..ce59962b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1627,7 +1627,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = __qbuf_mmap(vb, b);
 		break;
 	case V4L2_MEMORY_USERPTR:
+		down_read(&current->mm->mmap_sem);
 		ret = __qbuf_userptr(vb, b);
+		up_read(&current->mm->mmap_sem);
 		break;
 	case V4L2_MEMORY_DMABUF:
 		ret = __qbuf_dmabuf(vb, b);
-- 
2.1.0.rc1

