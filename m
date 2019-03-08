Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54287C10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB712087C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 14:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfCHOMa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:12:30 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59908 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbfCHOMW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 09:12:22 -0500
Received: from [IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d] ([IPv6:2001:420:44c1:2579:1aa:f05e:8209:429d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 2GERh2Lp44HFn2GEVh26IL; Fri, 08 Mar 2019 15:12:20 +0100
Subject: Re: [PATCH] rcar-csi2: Allow configuring of video standard
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <47a6b6ce-e570-0ba3-f498-09ca83ce868d@xs4all.nl>
Date:   Fri, 8 Mar 2019 15:12:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfC6VBFxRzKum9zOE8rJKMUi/ItRiS19fX8YqaFx7U5b8l53covuHaOWhpTeDwNxxwwhDpthb3OKGq+t59GXpgFjvPH9yPdCDX21jqae4bWMQS1KVf2MN
 y1rwRUQ8h6w2KipPtWWLyT7UAf3/m1gl/8xQwrEuFxe8tdi+G1f6y3UeRHT+UBg58QXBrf2ltqlpNPyBaH7O/min471A6BxW2tTyX5eQsgnabxephULXDpT/
 HOsWX/JV8rSIxNoRpYehTHjihbJAl/03HaD6i6uMU3cBJua+49VEe402G6P5qTWXlueuD7ILpDOM5a3MquEGmC06BVo0DfUPRsLQK3L1wsmfgObmoxz8Pvib
 AsbibN5opgGfNLWORNfEwBOaIqMm/Mo0V+3j/gWZhRWnvd/O2A4VAIR40X1S/PTGZ4U51dumMQlquQMM4H6Q9PnJBsoWMQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/16/19 11:57 PM, Niklas Söderlund wrote:
> Allow the hardware to to do proper field detection for interlaced field
> formats by implementing s_std() and g_std(). Depending on which video
> standard is selected the driver needs to setup the hardware to correctly
> identify fields.
> 
> Later versions of the datasheet have also been updated to make it clear
> that FLD register should be set to 0 when dealing with none interlaced
> field formats.

Nacked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The G/S_STD and QUERYSTD ioctls are specific for SDTV video receivers
(composite, S-Video, analog tuner) and can't be used for CSI devices.

struct v4l2_mbus_framefmt already has a 'field' value that is explicit
about the field ordering (TB vs BT) or the field ordering can be deduced
from the frame height (FIELD_INTERLACED).

Regards,

	Hans

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 33 +++++++++++++++++++--
>  1 file changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index f3099f3e536d808a..664d3784be2b9db9 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -361,6 +361,7 @@ struct rcar_csi2 {
>  	struct v4l2_subdev *remote;
>  
>  	struct v4l2_mbus_framefmt mf;
> +	v4l2_std_id std;
>  
>  	struct mutex lock;
>  	int stream_count;
> @@ -389,6 +390,22 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
>  	iowrite32(data, priv->base + reg);
>  }
>  
> +static int rcsi2_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> +
> +	priv->std = std;
> +	return 0;
> +}
> +
> +static int rcsi2_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> +
> +	*std = priv->std;
> +	return 0;
> +}
> +
>  static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
>  {
>  	if (!on) {
> @@ -475,7 +492,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
>  static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
> -	u32 phycnt, vcdt = 0, vcdt2 = 0;
> +	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
>  	unsigned int i;
>  	int mbps, ret;
>  
> @@ -507,6 +524,15 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  			vcdt2 |= vcdt_part << ((i % 2) * 16);
>  	}
>  
> +	if (priv->mf.field != V4L2_FIELD_NONE) {
> +		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
> +
> +		if (priv->std & V4L2_STD_525_60)
> +			fld |= FLD_FLD_NUM(2);
> +		else
> +			fld |= FLD_FLD_NUM(1);
> +	}
> +
>  	phycnt = PHYCNT_ENABLECLK;
>  	phycnt |= (1 << priv->lanes) - 1;
>  
> @@ -519,8 +545,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  	rcsi2_write(priv, PHTC_REG, 0);
>  
>  	/* Configure */
> -	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
> -		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
> +	rcsi2_write(priv, FLD_REG, fld);
>  	rcsi2_write(priv, VCDT_REG, vcdt);
>  	if (vcdt2)
>  		rcsi2_write(priv, VCDT2_REG, vcdt2);
> @@ -662,6 +687,8 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
>  }
>  
>  static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
> +	.s_std = rcsi2_s_std,
> +	.g_std = rcsi2_g_std,
>  	.s_stream = rcsi2_s_stream,
>  };
>  
> 

