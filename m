Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53160 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933850AbdCVKRI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 06:17:08 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_fCeyC817wDa7TARuHkjI3w)"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0ON700L1JOKHDUA0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Mar 2017 10:17:05 +0000 (GMT)
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the reserved
 memory
To: Marian Mihailescu <mihailescu2m@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <913c58e0-d37c-489c-be9e-339efbb5dab6@samsung.com>
Date: Wed, 22 Mar 2017 11:17:02 +0100
In-reply-to: <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CGME20170317120635eucas1p1d13c446f1418de46a49516e95bf9075d@eucas1p1.samsung.com>
 <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
 <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_fCeyC817wDa7TARuHkjI3w)
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 8bit

Hi Marian,


On 2017-03-22 10:33, Marian Mihailescu wrote:
> Hi,
>
> I was testing with the linux-next kernel + the v2 patches
> HW: odroid xu4
> decoding (working): tested with gstreamer
> encoding: tested with gstreamer && mfc-patched ffmpeg
> before patches: encoding worked
> after patches: encoding didn’t work.
>
> I moved on from linux-next in the meantime and I cannot give you logs, BUT I’ve seen Hardkernel applied these patches (and all the linux-next MFC patches) on top of their 4.9 tree, and the result is very similar to mine on linux-next: https://github.com/hardkernel/linux/issues/284
>
> Mar 21 13:04:54 odroid kernel: [   37.165153] s5p_mfc_alloc_priv_buf:78: Allocating private buffer of size 23243744 failed
> Mar 21 13:04:54 odroid kernel: [   37.171865] s5p_mfc_alloc_codec_buffers_v6:244: Failed to allocate Bank1 memory
> Mar 21 13:04:54 odroid kernel: [   37.179143] vidioc_reqbufs:1174: Failed to allocate encoding buffers
>
>
> A user reported even adding s5p_mfc.mem=64M did not make the encoder work.
> Any thoughts?

s5p_mfc.mem=64M should fix the issue. If not then there is some kind of different issue.

We did a bit more tests and in fact encoding h264 requires quite a lot of memory, so the default preallocated size might be not enough. However the codec temporary buffers don't need to be allocated from the preallocated region. In our tests it also worked when codec buffers were allocated in a generic way. Please check if the attached patch (applied on top of v3 patchset) fixes the issue.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


--Boundary_(ID_fCeyC817wDa7TARuHkjI3w)
Content-type: text/x-patch; CHARSET=EUC-KR;
 name=0001-media-s5p-mfc-Don-t-allocate-codec-buffers-from-pre-.patch
Content-transfer-encoding: 7bit
Content-disposition: attachment;
 filename*0=0001-media-s5p-mfc-Don-t-allocate-codec-;
 filename*1=buffers-from-pre-.patch

From: Marek Szyprowski <m.szyprowski@samsung.com>
Date: Wed, 22 Mar 2017 10:59:26 +0100
Subject: [PATCH] media: s5p-mfc: Don't allocate codec buffers from
 pre-allocated region

Further investigation revealed that codec buffers also don't need to
be allocated at higher addresses than firmware base for MFC v6+ hardware.
Those buffers can be quite large and its size depends on the selected
format and framesize. This patch changes the way the codec buffers are
allocated - driver will use generic allocator for them instead of the
pre-allocated buffer for firmware and contexts.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    | 28 +++++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  4 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  4 ++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 34a66189d980..7f33cf23947f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -79,6 +79,25 @@ int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
 	return -ENOMEM;
 }
 
+int s5p_mfc_alloc_generic_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b)
+{
+	struct device *mem_dev = dev->mem_dev[mem_ctx];
+
+	mfc_debug(3, "Allocating generic buf: %zu\n", b->size);
+
+	b->ctx = mem_ctx;
+	b->virt = dma_alloc_coherent(mem_dev, b->size, &b->dma, GFP_KERNEL);
+	if (!b->virt)
+		goto no_mem;
+
+	mfc_debug(3, "Allocated addr %p %pad\n", b->virt, &b->dma);
+	return 0;
+no_mem:
+	mfc_err("Allocating generic buffer of size %zu failed\n", b->size);
+	return -ENOMEM;
+}
+
 void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 			      struct s5p_mfc_priv_buf *b)
 {
@@ -97,3 +116,12 @@ void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 	b->size = 0;
 }
 
+void s5p_mfc_release_generic_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b)
+{
+	struct device *mem_dev = dev->mem_dev[b->ctx];
+	dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
+	b->virt = NULL;
+	b->dma = 0;
+	b->size = 0;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 108e59382e0c..16d553fcff08 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -319,6 +319,10 @@ int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
 			   struct s5p_mfc_priv_buf *b);
 void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 			      struct s5p_mfc_priv_buf *b);
+int s5p_mfc_alloc_generic_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b);
+void s5p_mfc_release_generic_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b);
 
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 70071a12db16..85880e9106be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,7 +239,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->bank1);
+		ret = s5p_mfc_alloc_generic_buf(dev, BANK_L_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -252,7 +252,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
+	s5p_mfc_release_generic_buf(ctx->dev, &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
-- 
1.9.1




--Boundary_(ID_fCeyC817wDa7TARuHkjI3w)--
