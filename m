Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55800
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933267AbcJUNIT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:08:19 -0400
Date: Fri, 21 Oct 2016 11:08:09 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Subject: Re: [PATCH v5 3/9] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
Message-ID: <20161021110809.269fd70d@vento.lan>
In-Reply-To: <20161021110104.5733240e@vento.lan>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-2-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-3-git-send-email-tiffany.lin@mediatek.com>
        <1472818800-22558-4-git-send-email-tiffany.lin@mediatek.com>
        <20161021110104.5733240e@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Oct 2016 11:01:04 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

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

Yeah, a latter patch in this series added a break there.

Thanks,
Mauro
