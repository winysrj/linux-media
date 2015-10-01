Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbJAR0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 13:26:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/5] [media] DocBook: fix most of warnings at videobuf2-core.h
Date: Thu,  1 Oct 2015 14:26:01 -0300
Message-Id: <32d81b41cd4f2021ef1b6378b4f6029307687df2.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	include/media/videobuf2-core.h:112: warning: No description found for parameter 'get_dmabuf'
	include/media/videobuf2-core.h:146: warning: No description found for parameter 'm'
	include/media/videobuf2-core.h:146: warning: Excess struct/union/enum/typedef member 'mem_offset' description in 'vb2_plane'

There are still several warnings, but those are hard to fix,
as they're actually a bug at DocBook. Those should be fixed on
separate patches.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 108fa160168a..128b15ad5497 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -36,6 +36,8 @@ struct vb2_threadio_data;
  *		no other users of this buffer are present); the buf_priv
  *		argument is the allocator private per-buffer structure
  *		previously returned from the alloc callback.
+ * @get_dmabuf: acquire userspace memory for a hardware operation; used for
+ *		 DMABUF memory types.
  * @get_userptr: acquire userspace memory for a hardware operation; used for
  *		 USERPTR memory types; vaddr is the address passed to the
  *		 videobuf layer when queuing a video buffer of USERPTR type;
@@ -118,7 +120,7 @@ struct vb2_mem_ops {
  * @dbuf_mapped:	flag to show whether dbuf is mapped or not
  * @bytesused:	number of bytes occupied by data in the plane (payload)
  * @length:	size of this plane (NOT the payload) in bytes
- * @mem_offset:	when memory in the associated struct vb2_buffer is
+ * @offset:	when memory in the associated struct vb2_buffer is
  *		VB2_MEMORY_MMAP, equals the offset from the start of
  *		the device memory for this plane (or is a "cookie" that
  *		should be passed to mmap() called on the video node)
@@ -126,6 +128,8 @@ struct vb2_mem_ops {
  *		pointing to this plane
  * @fd:		when memory is VB2_MEMORY_DMABUF, a userspace file
  *		descriptor associated with this plane
+ * @m:		Union with memtype-specific data (@offset, @userptr or
+ *		@fd).
  * @data_offset:	offset in the plane to the start of data; usually 0,
  *		unless there is a header in front of the data
  * Should contain enough information to be able to cover all the fields
-- 
2.4.3

