Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab0DAKVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 06:21:07 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Thu, 1 Apr 2010 15:50:44 +0530
Subject: RE: [PATCH 2/2] mem2mem_testdev: Code cleanup
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7EEE9@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1270110025-1854-2-git-send-email-hvaibhav@ti.com>
 <003001cad183$5757e720$0607b560$%osciak@samsung.com>
In-Reply-To: <003001cad183$5757e720$0607b560$%osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Pawel Osciak [mailto:p.osciak@samsung.com]
> Sent: Thursday, April 01, 2010 3:39 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Marek Szyprowski; kyungmin.park@samsung.com
> Subject: RE: [PATCH 2/2] mem2mem_testdev: Code cleanup
> 
> Hi again,
> 
> > Vaibhav Hiremath <hvaibhav@ti.com> wrote:
> >From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >
> >Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> >---
> > drivers/media/video/mem2mem_testdev.c |   58 ++++++++++++++---------------
> ---
> > 1 files changed, 25 insertions(+), 33 deletions(-)
> >
> >diff --git a/drivers/media/video/mem2mem_testdev.c
> b/drivers/media/video/mem2mem_testdev.c
> >index 05630e3..1f35b7e 100644
> >--- a/drivers/media/video/mem2mem_testdev.c
> >+++ b/drivers/media/video/mem2mem_testdev.c
> >@@ -98,11 +98,10 @@ static struct m2mtest_fmt formats[] = {
> > };
> >
> > /* Per-queue, driver-specific private data */
> >-struct m2mtest_q_data
> >-{
> >-	unsigned int		width;
> >-	unsigned int		height;
> >-	unsigned int		sizeimage;
> >+struct m2mtest_q_data {
> >+	u32			width;
> >+	u32			height;
> >+	u32			sizeimage;
> > 	struct m2mtest_fmt	*fmt;
> > };
> 
> Could you explain this change?
> 
[Hiremath, Vaibhav] No specific reason for this change, this is normal practice I learned from very first patch.

> [...]
> 
> >@@ -158,7 +156,7 @@ static struct v4l2_queryctrl m2mtest_ctrls[] = {
> > static struct m2mtest_fmt *find_format(struct v4l2_format *f)
> > {
> > 	struct m2mtest_fmt *fmt;
> >-	unsigned int k;
> >+	u32 k;
> 
> This is a loop index... Is there any reason for using u32?
> 
[Hiremath, Vaibhav] Same as above.
> [...]
> 
> >@@ -535,8 +532,8 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct
> v4l2_format *f)
> >
> > 	if (videobuf_queue_is_busy(vq)) {
> > 		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
> >-		ret = -EBUSY;
> >-		goto out;
> >+		mutex_unlock(&vq->vb_lock);
> >+		return -EBUSY;
> > 	}
> >
> > 	q_data->fmt		= find_format(f);
> >@@ -550,9 +547,7 @@ static int vidioc_s_fmt(struct m2mtest_ctx *ctx, struct
> v4l2_format *f)
> > 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> > 		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
> >
> >-out:
> >-	mutex_unlock(&vq->vb_lock);
> >-	return ret;
> >+	return 0;
> > }
> >
> 
> Unless I'm somehow misreading patch output, aren't you removing mutex_unlock
> for the path
> that reaches the end of the function?
> 
[Hiremath, Vaibhav] Oops, how did this got merged to patch? I had removed it. Just remove/ignore this change while merging.

Thanks,
Vaibhav

> [...]
> 
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> 
> 

