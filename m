Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:56621 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755019AbcJGTCg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 15:02:36 -0400
Subject: Re: [PATCH 12/22] [media] tc358743: put lanes in STOP state before
 starting streaming
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-13-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
From: Marek Vasut <marex@denx.de>
Message-ID: <70746e61-ac7d-a773-35a2-8296d0119efb@denx.de>
Date: Fri, 7 Oct 2016 21:02:26 +0200
MIME-Version: 1.0
In-Reply-To: <20161007160107.5074-13-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> Without calling tc358743_set_csi from the new prepare_stream callback
> (or calling tc358743_s_dv_timings or tc358743_set_fmt from userspace
> after stopping the stream), the i.MX6 MIPI CSI2 input fails waiting
> for lanes to enter STOP state when streaming is started again.

What is the impact of that failure ? How does it manifest itself ?

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/tc358743.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index 1e3a0dd2..dfa45d2 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1463,6 +1463,14 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> +static int tc358743_prepare_stream(struct v4l2_subdev *sd)
> +{
> +	/* Put all lanes in PL-11 state (STOPSTATE) */
> +	tc358743_set_csi(sd);
> +
> +	return 0;
> +}
> +
>  static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	enable_stream(sd, enable);
> @@ -1637,6 +1645,7 @@ static const struct v4l2_subdev_video_ops tc358743_video_ops = {
>  	.g_dv_timings = tc358743_g_dv_timings,
>  	.query_dv_timings = tc358743_query_dv_timings,
>  	.g_mbus_config = tc358743_g_mbus_config,
> +	.prepare_stream = tc358743_prepare_stream,
>  	.s_stream = tc358743_s_stream,
>  };
>  
> 


-- 
Best regards,
Marek Vasut
