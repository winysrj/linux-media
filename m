Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45759 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754838AbeAHSGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 13:06:01 -0500
Subject: Re: [PATCH] media: i2c: adv748x: fix HDMI field heights
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1515433167-15912-1-git-send-email-kieran.bingham@ideasonboard.com>
 <20180108175629.GE23075@bigcity.dyn.berto.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <66cfaf77-de48-2380-85a2-442a95f8752d@ideasonboard.com>
Date: Mon, 8 Jan 2018 18:05:56 +0000
MIME-Version: 1.0
In-Reply-To: <20180108175629.GE23075@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 08/01/18 17:56, Niklas Söderlund wrote:
> Hi Kieran,
> 
> Thanks for your patch.
> 
> On 2018-01-08 17:39:30 +0000, Kieran Bingham wrote:
>> The ADV748x handles interlaced media using V4L2_FIELD_ALTERNATE field
>> types.  The correct specification for the height on the mbus is the
>> image height, in this instance, the field height.
>>
>> The AFE component already correctly adjusts the height on the mbus, but
>> the HDMI component got left behind.
>>
>> Adjust the mbus height to correctly describe the image height of the
>> fields when processing interlaced video for HDMI pipelines.
>>
>> Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/i2c/adv748x/adv748x-hdmi.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> index 4da4253553fc..0e2f76f3f029 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> @@ -105,6 +105,10 @@ static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
>>  
>>  	fmt->width = hdmi->timings.bt.width;
>>  	fmt->height = hdmi->timings.bt.height;
>> +
>> +	/* Propagate field height on the mbus for FIELD_ALTERNATE fmts */
>> +	if (hdmi->timings.bt.interlaced)
> 
>         if (V4L2_FIELD_HAS_T_OR_B(fmt->field))
> 
> Nit-picking but I would use the field here (which is set just above this 
> in the same function) as it makes it more clear why the format is cut in 
> half. I looked at the documentation for bt.interlaced and I'm not sure 
> if it would be set to true for INTERLACED field formats when the height 
> should not be halved? In this case it do not matter as 
> 
>         fmt->field = hdmi->timings.bt.interlaced ?
>             V4L2_FIELD_ALTERNATE : V4L2_FIELD_NONE;
> 
> So I leave this up to you and feel free to add in either case.

In this instance, I chose to mirror the value(/code path) which explicitly sets
the V4L2_FIELD_ALTERNATE, rather than:
 if (fmt->field == V4L2_FIELD_ALTERNATE ||
     fmt->field == V4L2_FIELD_TOP ||
     fmt->field == V4L2_FIELD_BOTTOM)

But perhaps we would never expect _TOP || _BOTTOM therefore

 if (fmt->field == V4L2_FIELD_ALTERNATE)

might be perfectly suitable?

Actually - yes - I now agree. I'll respin.

--
Kieran

> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
>> +		fmt->height /= 2;
>>  }
>>  
>>  static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
>> -- 
>> 2.7.4
>>
> 
