Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45113 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389449AbeHAQM0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 12:12:26 -0400
Message-ID: <1533133585.5491.2.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: don't overwrite h.264 profile_idc on
 decoder instance
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lucas Stach <l.stach@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Date: Wed, 01 Aug 2018 16:26:25 +0200
In-Reply-To: <20180801141804.19684-1-l.stach@pengutronix.de>
References: <20180801141804.19684-1-l.stach@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 16:18 +0200, Lucas Stach wrote:
> On a decoder instance, after the profile has been parsed from the stream
> __v4l2_ctrl_s_ctrl() is called to notify userspace about changes in the
> read-only profile control. This ends up calling back into the CODA driver
> where a mssing check on the s_ctrl caused the profile information that has
> just been parsed from the stream to be overwritten with the default
> baseline profile.
> 
> Later on the driver fails to enable frame reordering, based on the wrong
> profile information.
> 
> Fixes: 347de126d1da (media: coda: add read-only h.264 decoder
>                      profile/level controls)
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/media/platform/coda/coda-common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index c7631e117dd3..1ae15d4ec5ed 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1719,7 +1719,8 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
>  		/* TODO: switch between baseline and constrained baseline */
> -		ctx->params.h264_profile_idc = 66;
> +		if (ctx->inst_type == CODA_INST_ENCODER)
> +			ctx->params.h264_profile_idc = 66;
>  		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
>  		/* nothing to do, this is set by the encoder */

regards
Philipp
