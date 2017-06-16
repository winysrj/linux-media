Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38911 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752651AbdFPKmh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 06:42:37 -0400
Subject: Re: [PATCH v2] [media] mtk-mdp: Fix g_/s_selection capture/compose
 logic
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
References: <1494556970-12278-1-git-send-email-minghsiu.tsai@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a180f2fc-1dce-3630-ed48-25c247eff79a@xs4all.nl>
Date: Fri, 16 Jun 2017 12:42:22 +0200
MIME-Version: 1.0
In-Reply-To: <1494556970-12278-1-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/17 04:42, Minghsiu Tsai wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Experiments show that the:
>  (1) mtk-mdp uses the _MPLANE form of CAPTURE/OUTPUT

Please drop this, since this no longer applies to this patch.

>  (2) CAPTURE types use CROP targets, and OUTPUT types use COMPOSE targets

Are you really certain about this?

For m2m devices the output (i.e. memory to hardware) typically crops from memory
and the capture side (hardware to memory) composes into memory.

I.e.: for the output side you crop the part of the memory buffer that you want
to process and on the capture side you compose the result into a memory buffer:
i.e. the memory buffer might be 1920x1080, but you compose the decoder output
into a rectangle of 640x480 at offset 128x128 within that buffer (just an example).

CAPTURE using crop would be if, before the data is DMAed, the hardware decoder
output is cropped. E.g. if the stream fed to the decoder is 1920x1080, but you
want to only DMA a subselection of that, then that would be cropping, and it
would go to a memory buffer of the size of the crop selection.

OUTPUT using compose is highly unlikely: that means that the frame you give
is composed in a larger internal buffer with generated border data around it.
Very rare and really only something that a compositor of some sort would do.

What exactly does the hardware do? Both for the encoder and for the decoder
case. Perhaps if I knew exactly what that is, then I can advise.

Regards,

	Hans

> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> Signed-off-by: Houlong Wei <houlong.wei@mediatek.com>
> 
> ---
> Changes in v2:
> . Can not use *_MPLANE type in g_/s_selection 
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> index 13afe48..e18ac626 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> @@ -838,10 +838,10 @@ static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
>  	bool valid = false;
>  
>  	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		if (mtk_mdp_is_target_compose(s->target))
> +		if (mtk_mdp_is_target_crop(s->target))
>  			valid = true;
>  	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -		if (mtk_mdp_is_target_crop(s->target))
> +		if (mtk_mdp_is_target_compose(s->target))
>  			valid = true;
>  	}
>  	if (!valid) {
> @@ -908,10 +908,10 @@ static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
>  	bool valid = false;
>  
>  	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		if (s->target == V4L2_SEL_TGT_COMPOSE)
> +		if (s->target == V4L2_SEL_TGT_CROP)
>  			valid = true;
>  	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -		if (s->target == V4L2_SEL_TGT_CROP)
> +		if (s->target == V4L2_SEL_TGT_COMPOSE)
>  			valid = true;
>  	}
>  	if (!valid) {
> @@ -925,7 +925,7 @@ static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
>  	if (ret)
>  		return ret;
>  
> -	if (mtk_mdp_is_target_crop(s->target))
> +	if (mtk_mdp_is_target_compose(s->target))
>  		frame = &ctx->s_frame;
>  	else
>  		frame = &ctx->d_frame;
> 
