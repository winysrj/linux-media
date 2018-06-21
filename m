Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36276 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932879AbeFUJqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 05:46:31 -0400
Date: Thu, 21 Jun 2018 12:46:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH v4] media: ov5640: fix frame interval enumeration
Message-ID: <20180621094628.23ot7red6ggcwtzm@valkosipuli.retiisi.org.uk>
References: <1529571219-7599-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529571219-7599-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Jun 21, 2018 at 10:53:39AM +0200, Hugues Fruchet wrote:
> Driver must reject frame interval enumeration of unsupported resolution.
> This was detected by v4l2-compliance format ioctl test:
> v4l2-compliance Format ioctls:
>     info: found 2 frameintervals for pixel format 4745504a and size 176x144
>   fail: v4l2-test-formats.cpp(123):
>                            found frame intervals for invalid size 177x144
>     test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
> version 2:
>   - revisit patch according to Mauro comments:
>     See https://www.mail-archive.com/linux-media@vger.kernel.org/msg127380.html
> 
> version 3:
>   - revisit patch using v4l2_find_nearest_size() helper as per Sakari suggestion:
>     See https://www.mail-archive.com/linux-media@vger.kernel.org/msg128186.html
> 
> version 4:
>   - fix sparse warning:
>     See https://www.mail-archive.com/linux-media@vger.kernel.org/msg132925.html
> 
>  drivers/media/i2c/ov5640.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index f6e40cc..4257ca6 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1389,24 +1389,16 @@ static int ov5640_set_timings(struct ov5640_dev *sensor,
>  ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
>  		 int width, int height, bool nearest)
>  {
> -	const struct ov5640_mode_info *mode = NULL;
> -	int i;
> -
> -	for (i = OV5640_NUM_MODES - 1; i >= 0; i--) {
> -		mode = &ov5640_mode_data[fr][i];
> -
> -		if (!mode->reg_data)
> -			continue;
> +	const struct ov5640_mode_info *mode;
>  
> -		if ((nearest && mode->hact <= width &&
> -		     mode->vact <= height) ||
> -		    (!nearest && mode->hact == width &&
> -		     mode->vact == height))
> -			break;
> -	}
> +	mode = v4l2_find_nearest_size(&ov5640_mode_data[fr][0],
> +				      ARRAY_SIZE(ov5640_mode_data[fr]),
> +				      hact, vact,
> +				      width, height);

I noticed the warning, too, but I think the fix should be done into the
macro, not to each driver individually. I'll see if that'd work out, and if
so, I'll go with v3.

>  
> -	if (nearest && i < 0)
> -		mode = &ov5640_mode_data[fr][0];
> +	if (!mode ||
> +	    (!nearest && (mode->hact != width || mode->vact != height)))
> +		return NULL;
>  
>  	return mode;
>  }
> @@ -2435,8 +2427,14 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
>  
>  	sensor->current_fr = frame_rate;
>  	sensor->frame_interval = fi->interval;
> -	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
> -						mode->vact, true);
> +	mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
> +				mode->vact, true);
> +	if (!mode) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	sensor->current_mode = mode;
>  	sensor->pending_mode_change = true;
>  out:
>  	mutex_unlock(&sensor->lock);
> -- 
> 1.9.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
