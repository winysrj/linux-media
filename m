Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40876 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750907AbeFHJON (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 05:14:13 -0400
Subject: Re: [PATCH v2 2/2] media: mtk-vcodec: Support VP9 profile in decoder
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <20180530071613.125768-1-keiichiw@chromium.org>
 <20180530071613.125768-3-keiichiw@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a631f7f4-3405-5c1a-2932-106e4481ae5a@xs4all.nl>
Date: Fri, 8 Jun 2018 11:14:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180530071613.125768-3-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/30/2018 09:16 AM, Keiichi Watanabe wrote:
> Add V4L2_CID_MPEG_VIDEO_VP9_PROFILE control in MediaTek decoder's
> driver.
> MediaTek decoder only supports profile 0 for now.
> 
> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> index 86f0a7134365..f9393504356d 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> @@ -1400,6 +1400,12 @@ int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
>  				V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
>  				0, 32, 1, 1);
>  	ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +	v4l2_ctrl_new_std_menu(&ctx->ctrl_hdl,
> +				&mtk_vcodec_dec_ctrl_ops,
> +				V4L2_CID_MPEG_VIDEO_VP9_PROFILE,
> +				V4L2_MPEG_VIDEO_VP9_PROFILE_3,

It makes no sense to set max to PROFILE_3 if PROFILE_0 is the only choice.
Just set max to PROFILE_0 as well.

> +				~(1U << V4L2_MPEG_VIDEO_VP9_PROFILE_0),
> +				V4L2_MPEG_VIDEO_VP9_PROFILE_0);
> 
>  	if (ctx->ctrl_hdl.error) {
>  		mtk_v4l2_err("Adding control failed %d",
> --
> 2.17.0.921.gf22659ad46-goog
> 

Regards,

	Hans
