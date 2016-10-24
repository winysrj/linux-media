Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:51607 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756976AbcJXDWR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 23:22:17 -0400
Message-ID: <1477279328.10501.10.camel@mtksdaap41>
Subject: Re: [PATCH v5 3/9] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 24 Oct 2016 11:22:08 +0800
In-Reply-To: <20161021110104.5733240e@vento.lan>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
         <1472818800-22558-2-git-send-email-tiffany.lin@mediatek.com>
         <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
         <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
         <20161021110104.5733240e@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, 2016-10-21 at 11:01 -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 2 Sep 2016 20:19:54 +0800
> Tiffany Lin <tiffany.lin@mediatek.com> escreveu:
> 
> > Add v4l2 layer decoder driver for MT8173
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> 
> > +int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
> > +{
> > +	int ret = 0;
> > +
> > +	switch (fourcc) {
> > +	case V4L2_PIX_FMT_H264:
> > +	case V4L2_PIX_FMT_VP8:
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> Did you ever test this driver? The above code will *always* return
> -EINVAL, with will cause vidioc_vdec_s_fmt() to always fail!
> 
> I suspect that what you wanted to do, instead, is:
> 
> 	switch (fourcc) {
> 	case V4L2_PIX_FMT_H264:
> 	case V4L2_PIX_FMT_VP8:
> 		break;
> 	default:
> 		return -EINVAL;
> 

The original idea here is that vp8 and h264 are added in later patches.
If get this patch without later patches, it should return -EINVAL.


> Btw, this patch series has also several issues that were pointed by
> checkpatch. Please *always* run checkpatch when submitting your work.
> 
> You should take a look at the Kernel documentation about how to
> submit patches, at:
> 	https://mchehab.fedorapeople.org/kernel_docs/process/index.html
> 
> PS.: this time, I fixed the checkpatch issues for you. So, let me know
> if the patch below is OK, and I'll merge it at media upstream,
> assuming that the other patches in this series are ok.
> 

I did run checkpatch, but I don't know why these issues missed.
probably I run checkpatch for all files not for patches.
I will take a look at the documentation and keep this in mind for future
upstream.
Appreciated for your help.


best regards,
Tiffany

