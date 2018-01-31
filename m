Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35148 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751662AbeAaL53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 06:57:29 -0500
Date: Wed, 31 Jan 2018 13:57:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH] media: ov5640: add error trace in case of i2c read
 failure
Message-ID: <20180131115726.meyzjtv3odlr4rki@valkosipuli.retiisi.org.uk>
References: <1517397564-12335-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517397564-12335-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 31, 2018 at 12:19:24PM +0100, Hugues Fruchet wrote:
> Add an error trace in ov5640_read_reg() in case of i2c_transfer()
> failure.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 99a5902..882a7c3 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -868,8 +868,11 @@ static int ov5640_read_reg(struct ov5640_dev *sensor, u16 reg, u8 *val)
>  	msg[1].len = 1;
>  
>  	ret = i2c_transfer(client->adapter, msg, 2);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		v4l2_err(&sensor->sd, "%s: error: reg=%x\n",

The driver uses dev_ macros almost universally, how about doing the same
here?

> +			 __func__, reg);
>  		return ret;
> +	}
>  
>  	*val = buf[0];
>  	return 0;
> -- 
> 1.9.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
