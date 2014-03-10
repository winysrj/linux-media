Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4979 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaCJP27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 11:28:59 -0400
Message-ID: <531DDA30.7080306@xs4all.nl>
Date: Mon, 10 Mar 2014 16:28:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 7/7] [media] adv7180: Add support for power down
References: <1394208873-23260-1-git-send-email-lars@metafoo.de> <1394208873-23260-7-git-send-email-lars@metafoo.de> <531DCE2E.5030807@xs4all.nl> <531DD91D.5020502@metafoo.de>
In-Reply-To: <531DD91D.5020502@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2014 04:24 PM, Lars-Peter Clausen wrote:
> On 03/10/2014 03:37 PM, Hans Verkuil wrote:
> [...]
>>> +
>>> +static int adv7180_s_power(struct v4l2_subdev *sd, int on)
>>> +{
>>> +	struct adv7180_state *state = to_state(sd);
>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>> +	int ret;
>>> +
>>> +	ret = mutex_lock_interruptible(&state->mutex);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	ret = adv7180_set_power(state, client, on);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> +	state->powered = on;
>>> +out:
>>
>> I would change this to:
>>
>> 	if (!ret)
>> 		state->powered = on;
>>
>> and drop the 'goto'.
>>
> 
> ok.
> 
> [...]
>>>   static int adv7180_resume(struct device *dev)
>>> @@ -656,10 +687,11 @@ static int adv7180_resume(struct device *dev)
>>>   	struct adv7180_state *state = to_state(sd);
>>>   	int ret;
>>>
>>> -	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
>>> -					ADV7180_PWR_MAN_ON);
>>> -	if (ret < 0)
>>> -		return ret;
>>> +	if (state->powered) {
>>> +		ret = adv7180_set_power(state, client, true);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>>   	ret = init_device(client, state);
>>>   	if (ret < 0)
>>>   		return ret;
>>>
>>
>> What is the initial state of the driver when loaded? Shouldn't probe() set the
>> 'powered' variable to true initially?
> 
> Yep, st->powered should be set to true by default.
> 
> What's your process in general, want me to resend the whole series, or are 
> you going to apply the patches that are ok?

When do you think you can have a fixed version of this patch ready? If it is
today/tomorrow, then I'll wait for that, otherwise I'll make a pull request
for the other 6 patches (which look fine).

In any case there is no need to resend the whole series.

Regards,

	Hans
