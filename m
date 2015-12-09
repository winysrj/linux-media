Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:8358 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbbLIH0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 02:26:30 -0500
From: "Wu, Xia" <xia.wu@intel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"horms+renesas@verge.net.au" <horms+renesas@verge.net.au>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Subject: [PATCH] media: videobuf2-core: Fix one __qbuf_dmabuf() error path
Date: Wed, 9 Dec 2015 07:26:26 +0000
Message-ID: <05B4341E5F09BF4E97AEC15A9DBEC11A1193CA21@shsmsx102.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add dma_buf_put() to decrease refcount of the dmabuf in error path if DMABUF size is smaller than the requirement.

Signed-off-by: wu xia <xia.wu@intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 33bdd81..1f232e7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1084,6 +1084,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 		if (planes[plane].length < q->plane_sizes[plane]) {
 			dprintk(1, "invalid dmabuf length for plane %d\n",
 				plane);
+			dma_buf_put(dbuf);
 			ret = -EINVAL;
 			goto err;
 		}
--
1.7.9.5
