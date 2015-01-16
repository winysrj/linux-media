Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50067 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbbAPKM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 05:12:26 -0500
Message-ID: <54B8E3F7.9020606@xs4all.nl>
Date: Fri, 16 Jan 2015 11:12:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 08/16] [media] adv7180: Consolidate video mode setting
References: <1421150481-30230-1-git-send-email-lars@metafoo.de> <1421150481-30230-9-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-9-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On 01/13/2015 01:01 PM, Lars-Peter Clausen wrote:
> We have basically the same code to set the video standard in init_device()
> and adv7180_s_std(). Factor this out into a common helper function.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/media/i2c/adv7180.c | 67 ++++++++++++++++++++++-----------------------
>  1 file changed, 32 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 349cae3..4d9bcc8 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -304,37 +304,54 @@ static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
>  	return ret;
>  }
>  
> -static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +static int adv7180_program_std(struct adv7180_state *state)
>  {
> -	struct adv7180_state *state = to_state(sd);
> -	int ret = mutex_lock_interruptible(&state->mutex);
> -	if (ret)
> -		return ret;
> +	int ret;
>  
> -	/* all standards -> autodetect */
> -	if (std == V4L2_STD_ALL) {
> +	if (state->autodetect) {

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

That said, I am unhappy about this autodetect handling. That isn't something
that this patch changes, which is why I've Acked it, but I hope you can look
at this yourself.

The reason I don't like it is because 1) it is non-standard behavior of a video
receiver to turn on autodetect if STD_ALL is passed in. And 2) there are
multiple autodetect modes and the one chosen seems to imply that NTSC M is not
autodetected, only NTSC-J. I have no adv7180 hardware, so I can't test if that
is indeed what is happening. In any case, every autodetect mode seems to
autodetect only a subset of all possible standards according to the adv7180
datasheet, which doesn't really make it a real autodetect IMHO.

The third and last reason is that if the autodetect system switches from NTSC to
PAL you suddenly get larger frames. Depending on the exact DMA configuration
of the board this could lead to buffer overflows (e.g. if the DMA configuration
just DMAs until the end of frame, and yes, such terrible DMA implementations
exist).

An initial autodetect when the driver is loaded might make sense in order to get
a reasonable initial standard, but I am skeptical about using it anywhere else.

BTW, if you can easily detect standard changes via an interrupt, then you can
use that interrupt to send a V4L2_EVENT_SOURCE_CHANGE event. That would allow
applications to dynamically react to changes in the standard.

As I said, I have no adv718x hardware so I am unable to test this, but if you
could test this autodetect functionality and think about whether it should be
kept at all, then that would be useful.

Regards,

	Hans

>  		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
>  				    ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
>  				    | state->input);
>  		if (ret < 0)
> -			goto out;
> +			return ret;
>  
>  		__adv7180_status(state, NULL, &state->curr_norm);
> -		state->autodetect = true;
>  	} else {
> -		ret = v4l2_std_to_adv7180(std);
> +		ret = v4l2_std_to_adv7180(state->curr_norm);
>  		if (ret < 0)
> -			goto out;
> +			return ret;
>  
>  		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
>  				    ret | state->input);
>  		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +	int ret = mutex_lock_interruptible(&state->mutex);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* all standards -> autodetect */
> +	if (std == V4L2_STD_ALL) {
> +		state->autodetect = true;
> +	} else {
> +		/* Make sure we can support this std */
> +		ret = v4l2_std_to_adv7180(std);
> +		if (ret < 0)
>  			goto out;
>  
>  		state->curr_norm = std;
>  		state->autodetect = false;
>  	}
> -	ret = 0;
> +
> +	ret = adv7180_program_std(state);
>  out:
>  	mutex_unlock(&state->mutex);
>  	return ret;
> @@ -547,30 +564,10 @@ static int init_device(struct adv7180_state *state)
>  	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
>  	usleep_range(2000, 10000);
>  
> -	/* Initialize adv7180 */
> -	/* Enable autodetection */
> -	if (state->autodetect) {
> -		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
> -				ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM
> -					      | state->input);
> -		if (ret < 0)
> -			goto out_unlock;
> -
> -		ret = adv7180_write(state, ADV7180_REG_AUTODETECT_ENABLE,
> -					      ADV7180_AUTODETECT_DEFAULT);
> -		if (ret < 0)
> -			goto out_unlock;
> -	} else {
> -		ret = v4l2_std_to_adv7180(state->curr_norm);
> -		if (ret < 0)
> -			goto out_unlock;
> -
> -		ret = adv7180_write(state, ADV7180_REG_INPUT_CONTROL,
> -					      ret | state->input);
> -		if (ret < 0)
> -			goto out_unlock;
> +	ret = adv7180_program_std(state);
> +	if (ret)
> +		goto out_unlock;
>  
> -	}
>  	/* ITU-R BT.656-4 compatible */
>  	ret = adv7180_write(state, ADV7180_REG_EXTENDED_OUTPUT_CONTROL,
>  			ADV7180_EXTENDED_OUTPUT_CONTROL_NTSCDIS);
> 

