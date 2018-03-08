Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965800AbeCHKjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 05:39:21 -0500
Date: Thu, 8 Mar 2018 07:39:09 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: ov5640: fix frame interval enumeration
Message-ID: <20180308073909.6c1e0ac9@vento.lan>
In-Reply-To: <1520499719-23955-1-git-send-email-hugues.fruchet@st.com>
References: <1520499719-23955-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 8 Mar 2018 10:01:59 +0100
Hugues Fruchet <hugues.fruchet@st.com> escreveu:

> Driver must reject frame interval enumeration of unsupported resolution.
> This was detected by v4l2-compliance format ioctl test:
> v4l2-compliance Format ioctls:
>   info: found 2 frameintervals for pixel format 4745504a and size 176x144
>   fail: v4l2-test-formats.cpp(123):
>                            found frame intervals for invalid size 177x144
>   test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 676f635..28dc687 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1400,6 +1400,9 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
>  	if (nearest && i < 0)
>  		mode = &ov5640_mode_data[fr][0];
>  
> +	if (!nearest && i < 0)
> +		return NULL;
> +
>  	return mode;
>  }


I didn't check the full logic here, nor if this patch makes sense, but
just looking at the above code, it looks ugly to fill "mode" var just
to discard it. I would code the above as:

	if (i < 0) {
		if (!nearest)
			return NULL;
		mode = &ov5640_mode_data[fr][0];
	}


Also, if this function starts returning NULL, I suspect that you also
need to change ov5640_s_frame_interval(), as currently it is called
at ov5640_s_frame_interval() as:

	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
						mode->height, true);

without checking if the returned value is NULL. Setting
current_mode to NULL can cause oopses at ov5640_set_mode().

Regards,
Mauro
