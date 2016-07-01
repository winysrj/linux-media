Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48397 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbcGAOj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 10:39:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tw686x: make const structs static
Message-ID: <37b742cd-d308-efe9-e48c-d65bc9d24ccb@xs4all.nl>
Date: Fri, 1 Jul 2016 16:39:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix sparse warnings:

tw686x-video.c:148:29: warning: symbol 'memcpy_dma_ops' was not declared. Should it be static?
tw686x-video.c:195:29: warning: symbol 'contig_dma_ops' was not declared. Should it be static?
tw686x-video.c:361:29: warning: symbol 'sg_dma_ops' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 0e839f6..bae33d9 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -145,7 +145,7 @@ static void tw686x_memcpy_buf_refill(struct tw686x_video_channel *vc,
 	vc->curr_bufs[pb] = NULL;
 }

-const struct tw686x_dma_ops memcpy_dma_ops = {
+static const struct tw686x_dma_ops memcpy_dma_ops = {
 	.alloc		= tw686x_memcpy_dma_alloc,
 	.free		= tw686x_memcpy_dma_free,
 	.buf_refill	= tw686x_memcpy_buf_refill,
@@ -192,7 +192,7 @@ static int tw686x_contig_setup(struct tw686x_dev *dev)
 	return 0;
 }

-const struct tw686x_dma_ops contig_dma_ops = {
+static const struct tw686x_dma_ops contig_dma_ops = {
 	.setup		= tw686x_contig_setup,
 	.cleanup	= tw686x_contig_cleanup,
 	.buf_refill	= tw686x_contig_buf_refill,
@@ -358,7 +358,7 @@ static int tw686x_sg_setup(struct tw686x_dev *dev)
 	return 0;
 }

-const struct tw686x_dma_ops sg_dma_ops = {
+static const struct tw686x_dma_ops sg_dma_ops = {
 	.setup		= tw686x_sg_setup,
 	.cleanup	= tw686x_sg_cleanup,
 	.alloc		= tw686x_sg_dma_alloc,
-- 
2.8.1

