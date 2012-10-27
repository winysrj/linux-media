Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab2J0Um2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:28 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgRpI019858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:28 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 52/68] [media] m2m-deinterlace: remove unused vars
Date: Sat, 27 Oct 2012 18:41:10 -0200
Message-Id: <1351370486-29040-53-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/m2m-deinterlace.c:229:15: warning: variable 'd_size' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/m2m-deinterlace.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index fcdbb27..05c560f 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -218,15 +218,14 @@ static void dma_callback(void *data)
 static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 				  int do_callback)
 {
-	struct deinterlace_q_data *s_q_data, *d_q_data;
+	struct deinterlace_q_data *s_q_data;
 	struct vb2_buffer *src_buf, *dst_buf;
 	struct deinterlace_dev *pcdev = ctx->dev;
 	struct dma_chan *chan = pcdev->dma_chan;
 	struct dma_device *dmadev = chan->device;
 	struct dma_async_tx_descriptor *tx;
 	unsigned int s_width, s_height;
-	unsigned int d_width, d_height;
-	unsigned int d_size, s_size;
+	unsigned int s_size;
 	dma_addr_t p_in, p_out;
 	enum dma_ctrl_flags flags;
 
@@ -238,11 +237,6 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	s_height = s_q_data->height;
 	s_size = s_width * s_height;
 
-	d_q_data = get_q_data(V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	d_width = d_q_data->width;
-	d_height = d_q_data->height;
-	d_size = d_width * d_height;
-
 	p_in = (dma_addr_t)vb2_dma_contig_plane_dma_addr(src_buf, 0);
 	p_out = (dma_addr_t)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 	if (!p_in || !p_out) {
-- 
1.7.11.7

