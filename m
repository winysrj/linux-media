Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:49870 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752629AbeERIcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 04:32:46 -0400
Subject: Re: [PATCH v3 01/12] media: ov5640: Fix timings setup code
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-2-maxime.ripard@bootlin.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <78510086-f59b-516a-1b51-02f938d41cbb@zonque.org>
Date: Fri, 18 May 2018 10:32:43 +0200
MIME-Version: 1.0
In-Reply-To: <20180517085405.10104-2-maxime.ripard@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> From: Samuel Bobrowicz <sam@elite-embedded.com>
> 
> The current code, when changing the mode and changing the scaling or
> sampling parameters, will look at the horizontal and vertical total size,
> which, since 5999f381e023 ("media: ov5640: Add horizontal and vertical
> totals") has been moved from the static register initialization to after
> the mode change.
> 
> That means that the values are no longer set up before the code retrieves
> them, which is obviously a bug.

I tried 'for-4.18-5' before your patch set now and noticed it didn't 
work. I then bisected the regression down to the same commit that you 
mentioned above.

The old code (before 5999f381e023) used to have the timing registers 
embedded in a large register blob. Omitting them during the bulk upload 
and writing them later doesn't work here, even if the values are the 
same. It seems that the order in which registers are written matters.

Hence your patch in this email doesn't fix it for me either. I have to 
move ov5640_set_timings() before ov5640_load_regs() to revive my platform.

One of the subsequent patches in this series introduces a new regression 
for me, unfortunately, possibly for the same reason. I'll dig a bit more.

What cameras are you testing this with? MIPI or parallel?


Thanks,
Daniel



> Fixes: 5999f381e023 ("media: ov5640: Add horizontal and vertical totals")
> Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>   drivers/media/i2c/ov5640.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index e480e53b369b..4bd968b478db 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1462,6 +1462,10 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
>   	if (ret < 0)
>   		return ret;
>   
> +	ret = ov5640_set_timings(sensor, mode);
> +	if (ret < 0)
> +		return ret;
> +
>   	/* read capture VTS */
>   	ret = ov5640_get_vts(sensor);
>   	if (ret < 0)
> @@ -1589,6 +1593,10 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
>   	if (ret < 0)
>   		return ret;
>   
> +	ret = ov5640_set_timings(sensor, mode);
> +	if (ret < 0)
> +		return ret;
> +
>   	/* turn auto gain/exposure back on for direct mode */
>   	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
>   	if (ret)
> @@ -1633,10 +1641,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
>   		ret = ov5640_set_mode_direct(sensor, mode, exposure);
>   	}
>   
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = ov5640_set_timings(sensor, mode);
>   	if (ret < 0)
>   		return ret;
>   
> 
