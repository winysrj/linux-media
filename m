Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20649 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0DAKK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 06:10:59 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0700HWB0A8UL@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 11:10:56 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L07006JG0A7IG@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 11:10:56 +0100 (BST)
Date: Thu, 01 Apr 2010 12:08:56 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 2/2] mem2mem_testdev: Code cleanup
In-reply-to: <1270110025-1854-2-git-send-email-hvaibhav@ti.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <003001cad183$5757e720$0607b560$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <hvaibhav@ti.com> <1270110025-1854-2-git-send-email-hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

> Vaibhav Hiremath <hvaibhav@ti.com> wrote:
>From: Vaibhav Hiremath <hvaibhav@ti.com>
>
>
>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>---
> drivers/media/video/mem2mem_testdev.c |   58 ++++++++++++++------------------
> 1 files changed, 25 insertions(+), 33 deletions(-)
>
>diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
>index 05630e3..1f35b7e 100644
>--- a/drivers/media/video/mem2mem_testdev.c
>+++ b/drivers/media/video/mem2mem_testdev.c
>@@ -98,11 +98,10 @@ static struct m2mtest_fmt formats[] = {
> };
>
> /* Per-queue, driver-specific private data */
>-struct m2mtest_q_data
>-{
>-	unsigned int		width;
>-	unsigned int		height;
>-	unsigned int		sizeimage;
>+struct m2mtest_q_data {
>+	u32			width;
>+	u32			height;
>+	u32			sizeimage;
> 	struct m2mtest_fmt	*fmt;
> };

Could you explain this change?

[...]

>@@ -158,7 +156,7 @@ static struct v4l2_queryctrl m2mtest_ctrls[] = {
> static struct m2mtest_fmt *find_format(struct v4l2_format *f)
> {
> 	struct m2mtest_fmt *fmt;
>-	unsigned int k;
>+	u32 k;

This is a loop index... Is there any reason for using u32?

[...]

>@@ -535,8 +532,8 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
>
> 	if (videobuf_queue_is_busy(vq)) {
> 		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
>-		ret = -EBUSY;
>-		goto out;
>+		mutex_unlock(&vq->vb_lock);
>+		return -EBUSY;
> 	}
>
> 	q_data->fmt		= find_format(f);
>@@ -550,9 +547,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
> 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
>
>-out:
>-	mutex_unlock(&vq->vb_lock);
>-	return ret;
>+	return 0;
> }
>

Unless I'm somehow misreading patch output, aren't you removing mutex_unlock for the path
that reaches the end of the function?

[...]


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





