Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41859 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbbEUGKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 02:10:50 -0400
Message-ID: <555D76E3.1070809@xs4all.nl>
Date: Thu, 21 May 2015 08:10:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 17/20] media: adv7604: Support V4L_FIELD_INTERLACED
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-18-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-18-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 06:39 PM, William Towle wrote:
> When hardware reports interlaced input, correctly set field to
> V4L_FIELD_INTERLACED ini adv76xx_fill_format.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/i2c/adv7604.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4bde3e1..d77ee1f 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -1791,7 +1791,12 @@ static void adv76xx_fill_format(struct adv76xx_state *state,
>  
>  	format->width = state->timings.bt.width;
>  	format->height = state->timings.bt.height;
> -	format->field = V4L2_FIELD_NONE;
> +
> +	if (state->timings.bt.interlaced)
> +		format->field= V4L2_FIELD_INTERLACED;

No, this should be FIELD_ALTERNATE. FIELD_INTERLACED means that the two fields
are interlaced into a single frame buffer, with FIELD_ALTERNATE each buffer
contains one field. And when capturing v4l2_buffer should return which field
(TOP/BOTTOM) the buffer contains. It also complicates cropping/composing: the
crop rectangle is in frame coordinates, composing uses field coordinates.
The vivid driver handles this correctly and can be used as a reference.

Also, no space before the '='. Please add.

You might be interested in this patch series as well:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/90578

I'm thinking of doing some interlaced tests myself, possibly this weekend,
using the adv7604.

Regards,

	Hans

> +	else
> +		format->field= V4L2_FIELD_NONE;
> +
>  	format->colorspace = V4L2_COLORSPACE_SRGB;
>  
>  	if (state->timings.bt.flags & V4L2_DV_FL_IS_CE_VIDEO)
> 

