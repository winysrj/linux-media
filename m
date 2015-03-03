Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37050 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbbCCJ7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 04:59:40 -0500
Message-ID: <54F585FA.70701@xs4all.nl>
Date: Tue, 03 Mar 2015 10:59:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] media: adv7604: improve usage of gpiod API
References: <1425279644-25873-1-git-send-email-u.kleine-koenig@pengutronix.de> <54F5851E.70906@xs4all.nl>
In-Reply-To: <54F5851E.70906@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2015 10:55 AM, Hans Verkuil wrote:
> Hi Uwe,
> 
> On 03/02/2015 08:00 AM, Uwe Kleine-König wrote:
>> Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
>> which appeared in v3.17-rc1, the gpiod_get* functions take an additional
>> parameter that allows to specify direction and initial value for output.
>> Simplify accordingly.
>>
>> Moreover use devm_gpiod_get_index_optional instead of
>> devm_gpiod_get_index with ignoring all errors.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> ---
>> BTW, sparse fails to check this file with many errors like:
>>
>> 	drivers/media/i2c/adv7604.c:311:11: error: unknown field name in initializer
>>
>> Didn't look into that.
> 
> That's a sparse bug that's been fixed in the sparse repo, but not in the 0.5.0
> release (they really should make a new sparse release IMHO).
> 
> Some comments below:

Never mind those comments, after checking what devm_gpiod_get_index_optional
does it's clear that this patch is correct.

Sorry about the noise.

	Hans

> 
>> ---
>>  drivers/media/i2c/adv7604.c | 16 ++++++----------
>>  1 file changed, 6 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 5a7c9389a605..ddeeb6695a4b 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -537,12 +537,8 @@ static void adv7604_set_hpd(struct adv7604_state *state, unsigned int hpd)
>>  {
>>  	unsigned int i;
>>  
>> -	for (i = 0; i < state->info->num_dv_ports; ++i) {
>> -		if (IS_ERR(state->hpd_gpio[i]))
>> -			continue;
> 
> Why this change? See also below:
> 
>> -
>> +	for (i = 0; i < state->info->num_dv_ports; ++i)
>>  		gpiod_set_value_cansleep(state->hpd_gpio[i], hpd & BIT(i));
>> -	}
>>  
>>  	v4l2_subdev_notify(&state->sd, ADV7604_HOTPLUG, &hpd);
>>  }
>> @@ -2720,13 +2716,13 @@ static int adv7604_probe(struct i2c_client *client,
>>  	/* Request GPIOs. */
>>  	for (i = 0; i < state->info->num_dv_ports; ++i) {
>>  		state->hpd_gpio[i] =
>> -			devm_gpiod_get_index(&client->dev, "hpd", i);
>> +			devm_gpiod_get_index_optional(&client->dev, "hpd", i,
>> +						      GPIOD_OUT_LOW);
>>  		if (IS_ERR(state->hpd_gpio[i]))
>> -			continue;
>> -
>> -		gpiod_direction_output(state->hpd_gpio[i], 0);
>> +			return PTR_ERR(state->hpd_gpio[i]);
> 
> This isn't correct. The use of gpio is optional, on some boards a different
> mechanism is used to control the hpd, and there devm_gpiod_get_index will just
> return an error. That's OK, we just continue in that case.
> 
> Regards,
> 
> 	Hans
> 
>>  
>> -		v4l_info(client, "Handling HPD %u GPIO\n", i);
>> +		if (state->hpd_gpio[i])
>> +			v4l_info(client, "Handling HPD %u GPIO\n", i);
>>  	}
>>  
>>  	state->timings = cea640x480;
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

