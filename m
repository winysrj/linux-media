Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:33424 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbcHAL2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 07:28:38 -0400
Message-ID: <1470050904.30651.47.camel@mtksdaap41>
Subject: Re: [PATCH v3 5/9] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 1 Aug 2016 19:28:24 +0800
In-Reply-To: <8bd71dee-62ec-beba-c1d1-fc7e586d593b@xs4all.nl>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-5-git-send-email-tiffany.lin@mediatek.com>
	 <1464611363-14936-6-git-send-email-tiffany.lin@mediatek.com>
	 <32112952-6a34-ac8b-9d06-198c6c653611@xs4all.nl>
	 <1470044307.30651.18.camel@mtksdaap41>
	 <8bd71dee-62ec-beba-c1d1-fc7e586d593b@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-08-01 at 12:39 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> On 08/01/2016 11:38 AM, Tiffany Lin wrote:
> > Hi Hans,
> 
> <snip>
> 
> >>> +static int vidioc_vdec_g_selection(struct file *file, void *priv,
> >>> +			struct v4l2_selection *s)
> >>> +{
> >>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> >>> +
> >>> +	if (V4L2_TYPE_IS_OUTPUT(s->type))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (s->target != V4L2_SEL_TGT_CROP)
> >>> +		return -EINVAL;
> >>
> >> How does the cropping rectangle relate to the format size? There is no s_selection,
> >> so this doesn't make sense.
> >>
> > I want to return encoded crop information or real display region that
> > display driver could know where is padding region.
> 
> Sorry, I don't understand this.
> 
> This is a decoder, so based on the bitstream it decodes to a certain width
> and height. I assume that is what you refer to as coded_width and coded_height?
> 
> If so, then what is the 'real display region' and how does it relate to the
> coded width/height?
> 
> This is probably a terminology issue but I need to understand this before I
> can decide what should be done here.
> 
We define coded_width and coded_height as frame buffer width and height.
Coded resolution is stream resolution in pixels aligned to codec format
and hardware requirements.
And we assign bytesperline as coded_width.

g_selection is for getting visible resolution for user space.
visible resolution - stream resolution of the visible picture, in
pixels, to be used for display purposes; must be smaller or equal to
coded resolution;
visible height - height for given visible resolution
visible width - width for given visible resolution

For my understand, g_fmt should return coded width/height in
pix_mp->width, pix_mp->height.
And bytesperline is coded with.
g_selection return visible width/height.
Is this understanding correct?


best regards,
Tiffany
> Regards,
> 
> 	Hans
> 
> > User space use s_fmt/g_fmt  to set/get coded_width and coded_height, and
> > use g_crop to get real display region.
> > That's why I do not add s_selection.
> > 
> >> Alternatively, it could be that you are really returning V4L2_SEL_TGT_COMPOSE_PADDED.
> >>
> > 
> > V4L2_SEL_TGT_COMPOSE_PADDED means
> > "The active area and all padding pixels that are inserted or modified by
> > hardware."
> > But I just want to return active area to user space.
> > 
> >>> +
> >>> +	if (ctx->state < MTK_STATE_HEADER)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if ((ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_H264) ||
> >>> +	    (ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_VP8) ||
> >>> +	    (ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc == V4L2_PIX_FMT_VP9)) {
> >>> +
> >>> +		if (vdec_if_get_param(ctx, GET_PARAM_CROP_INFO, &(s->r))) {
> >>> +			mtk_v4l2_debug(2,
> >>> +					"[%d]Error!! Cannot get param : GET_PARAM_CROP_INFO ERR",
> >>> +					ctx->id);
> >>> +			s->r.left = 0;
> >>> +			s->r.top = 0;
> >>> +			s->r.width = ctx->picinfo.buf_w;
> >>> +			s->r.height = ctx->picinfo.buf_h;
> >>> +		}
> >>> +		mtk_v4l2_debug(2, "Cropping info: l=%d t=%d w=%d h=%d",
> >>> +				s->r.left, s->r.top, s->r.width,
> >>> +				s->r.height);
> >>> +	} else {
> >>> +		s->r.left = 0;
> >>> +		s->r.top = 0;
> >>> +		s->r.width = ctx->picinfo.pic_w;
> >>> +		s->r.height = ctx->picinfo.pic_h;
> >>> +		mtk_v4l2_debug(2, "Cropping info: w=%d h=%d fw=%d fh=%d",
> >>> +				s->r.width, s->r.height, ctx->picinfo.buf_w,
> >>> +				ctx->picinfo.buf_h);
> >>> +	}
> >>> +	return 0;
> >>> +}


