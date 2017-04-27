Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:36530 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162752AbdD0OmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 10:42:15 -0400
Received: by mail-wr0-f176.google.com with SMTP id l50so18453633wrc.3
        for <linux-media@vger.kernel.org>; Thu, 27 Apr 2017 07:42:14 -0700 (PDT)
Subject: Re: [PATCH] [media] mtk-mdp: Fix g_/s_selection capture/compose logic
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
References: <1492057130-1194-1-git-send-email-minghsiu.tsai@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <a8c1da24-d812-7c4d-a05d-34cb90edddf5@linaro.org>
Date: Thu, 27 Apr 2017 17:42:10 +0300
MIME-Version: 1.0
In-Reply-To: <1492057130-1194-1-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/13/2017 07:18 AM, Minghsiu Tsai wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Experiments show that the:
>  (1) mtk-mdp uses the _MPLANE form of CAPTURE/OUTPUT
>  (2) CAPTURE types use CROP targets, and OUTPUT types use COMPOSE targets
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> 
> ---
>  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> index 13afe48..8ab7ca0 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> @@ -837,12 +837,12 @@ static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
>  	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
>  	bool valid = false;
>  
> -	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		if (mtk_mdp_is_target_compose(s->target))
> -			valid = true;
> -	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>  		if (mtk_mdp_is_target_crop(s->target))
>  			valid = true;
> +	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		if (mtk_mdp_is_target_compose(s->target))
> +			valid = true;
>  	}

Using MPLANE formats in g/s_selection violates the v4l2 spec. See [1].

<snip>

-- 
regards,
Stan

[1]
https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-g-selection.html
