Return-Path: <SRS0=tbWQ=RG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F722C43381
	for <linux-media@archiver.kernel.org>; Sun,  3 Mar 2019 23:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18C7B20835
	for <linux-media@archiver.kernel.org>; Sun,  3 Mar 2019 23:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfCCXe2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Mar 2019 18:34:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44888 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfCCXe2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2019 18:34:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 60E932802CD
Message-ID: <1f7ab3d0a759c583fc33a83ee24ed780e40ce7a1.camel@collabora.com>
Subject: Re: [PATCH] Remove deductively redundant NULL pointer checks
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Shaobo He <shaobo@cs.utah.edu>, linux-media@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Leontiev <scileont@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FDP1" 
        <linux-renesas-soc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC support" 
        <linux-rockchip@lists.infradead.org>
Date:   Sun, 03 Mar 2019 20:34:09 -0300
In-Reply-To: <1551228250-36426-1-git-send-email-shaobo@cs.utah.edu>
References: <1551228250-36426-1-git-send-email-shaobo@cs.utah.edu>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-02-26 at 17:43 -0700, Shaobo He wrote:
> The fixes included in this commit essentially removes NULL pointer
> checks on the return values of function `get_queue_ctx` as well as
> `v4l2_m2m_get_vq` defined in file v4l2-mem2mem.c.
> 
> Function `get_queue_ctx` is very unlikely to return a NULL pointer
> because its return value is an address composed of the base address
> pointed by `m2m_ctx` and an offset of field `out_q_ctx` or `cap_q_ctx`.
> Since the offset of either field is not 0, for the return value to be
> NULL, pointer `m2m_ctx` must be a very large unsigned value such that
> its addition to the offset overflows to NULL which may be undefined
> according to this post:
> https://wdtz.org/catching-pointer-overflow-bugs.html. Moreover, even if
> `m2m_ctx` is NULL, the return value cannot be NULL, either. Therefore, I
> think it is reasonable to conclude that the return value of function
> `get_queue_ctx` cannot be NULL.
> 
> Given the return values of `get_queue_ctx` not being NULL, we can follow
> a similar reasoning to conclude that the return value of
> `v4l2_mem_get_vq` cannot be NULL since its return value is the same
> address as the return value of `get_queue_ctx`. Therefore, this patch
> also removes NULL pointer checks on the return values of
> `v4l2_mem_get_vq`.
> 
> Signed-off-by: Shaobo He <shaobo@cs.utah.edu>

Hi Shaobo,

It seems this is v2 of 1551128631-19713-1-git-send-email-shaobo@cs.utah.edu,
and it should be marked as such.

Do you think you can read Documentation/process/submitting-patches.rst,
for your future patches?

Also, two comments...

>  drivers/media/platform/coda/coda-common.c          |  4 ----
>  drivers/media/platform/imx-pxp.c                   |  7 -------
>  drivers/media/platform/m2m-deinterlace.c           |  7 -------
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |  7 -------
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  7 -------
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 13 -------------
>  drivers/media/platform/mx2_emmaprp.c               |  7 -------
>  drivers/media/platform/rcar_fdp1.c                 |  3 ---
>  drivers/media/platform/rcar_jpu.c                  |  8 --------
>  drivers/media/platform/rockchip/rga/rga.c          |  4 ----
>  drivers/media/platform/s5p-g2d/g2d.c               |  4 ----
>  drivers/media/platform/s5p-jpeg/jpeg-core.c        |  7 -------
>  drivers/media/platform/sh_veu.c                    |  2 --
>  drivers/media/platform/ti-vpe/vpe.c                |  7 -------
>  drivers/media/platform/vicodec/vicodec-core.c      |  5 -----
>  drivers/media/platform/vim2m.c                     |  7 -------
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |  4 ----
>  17 files changed, 103 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 7518f01..ee1e05b 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -696,8 +696,6 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
>  	struct vb2_queue *vq;
>  
>  	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> -	if (!vq)
> -		return -EINVAL;
>  
>  	q_data = get_q_data(ctx, f->type);
>  	if (!q_data)
> @@ -817,8 +815,6 @@ static int coda_s_fmt_vid_out(struct file *file, void *priv,
>  	ctx->quantization = f->fmt.pix.quantization;
>  
>  	dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> -	if (!dst_vq)
> -		return -EINVAL;
>  
>  	/*
>  	 * Setting the capture queue format is not possible while the capture
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index c1c2554..d079b3c 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -1071,13 +1071,8 @@ static int pxp_enum_fmt_vid_out(struct file *file, void *priv,
>  
>  static int pxp_g_fmt(struct pxp_ctx *ctx, struct v4l2_format *f)
>  {
> -	struct vb2_queue *vq;
>  	struct pxp_q_data *q_data;
>  
> -	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> -	if (!vq)
> -		return -EINVAL;
> -

It seems your patch also removes unused code, but this is not really explained in the
commit log.

Perhaps it is better to split all these changes on their own patch:
one patch to remove dead code, and then another patch to remove unneeded null checks.

And also, I think you should add some comments, either in v4l2_m2m_get_vq's declaration
or definition, explaining that the return value cannot be NULL.

I have to say: I'm not a fan of "improvement" patches in code paths that
are anything but hot... but knock yourself out!

Thanks,
Eze

