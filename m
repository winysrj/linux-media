Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40393 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbbEUGOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 02:14:02 -0400
Message-ID: <555D77A4.8000706@xs4all.nl>
Date: Thu, 21 May 2015 08:13:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 18/20] media: adv7604: Always query_dv_timings in adv76xx_fill_format
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-19-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-19-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 06:39 PM, William Towle wrote:
> Make sure we're always reporting the current format of the input.
> Fixes start of day bugs.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/i2c/adv7604.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index d77ee1f..526fa4e 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1787,8 +1787,12 @@ static int adv76xx_enum_mbus_code(struct v4l2_subdev *sd,
>  static void adv76xx_fill_format(struct adv76xx_state *state,
>  				struct v4l2_mbus_framefmt *format)
>  {
> +	struct v4l2_subdev *sd = &state->sd;
> +
>  	memset(format, 0, sizeof(*format));
>  
> +	v4l2_subdev_call(sd, video, query_dv_timings, &state->timings);
> +

NACK.

Never use querystd/query_dv_timings in a driver. If the format changes, then the
required buffer sizes change as well. The only place this can be done correctly
is in userspace where the application has to call the query ioctl, then based on
that allocate the buffers.

Automagically changing the format from underneath the video pipeline is a recipe
for disaster.

Regards,

	Hans

>  	format->width = state->timings.bt.width;
>  	format->height = state->timings.bt.height;
>  
> 

