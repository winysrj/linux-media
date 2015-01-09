Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:27437 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbbAIHuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2015 02:50:14 -0500
Message-ID: <54AF8834.1090904@cisco.com>
Date: Fri, 09 Jan 2015 08:50:12 +0100
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org, hansverk@cisco.com
Subject: Re: [RFC v01] Driver for Toshiba TC358743 CSI-2 to HDMI bridge
References: <1418667661-21078-1-git-send-email-matrandg@cisco.com> <1420737164.3190.49.camel@pengutronix.de>
In-Reply-To: <1420737164.3190.49.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for testing the driver!

On 01/08/2015 06:12 PM, Philipp Zabel wrote:
> Hi Mats,
>
> Am Montag, den 15.12.2014, 19:21 +0100 schrieb matrandg@cisco.com:
>> From: Mats Randgaard <matrandg@cisco.com>
>>
>> The driver is tested on our hardware and all the implemented features
>> works as expected.
>>
>> Missing features:
>> - CEC support
>> - HDCP repeater support
>> - IR support
>>
>> Signed-off-by: Mats Randgaard <matrandg@cisco.com>
>> ---
>>   MAINTAINERS                        |    6 +
>>   drivers/media/i2c/Kconfig          |   12 +
>>   drivers/media/i2c/Makefile         |    1 +
>>   drivers/media/i2c/tc358743.c       | 1768 ++++++++++++++++++++++++++++++++++++
>>   drivers/media/i2c/tc358743_regs.h  |  670 ++++++++++++++
>>   include/media/tc358743.h           |   89 ++
>>   include/uapi/linux/v4l2-controls.h |    4 +
>>   7 files changed, 2550 insertions(+)
>>   create mode 100644 drivers/media/i2c/tc358743.c
>>   create mode 100644 drivers/media/i2c/tc358743_regs.h
>>   create mode 100644 include/media/tc358743.h
>>
> [...]
>> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
>> new file mode 100644
>> index 0000000..a86cbe0
>> --- /dev/null
>> +++ b/drivers/media/i2c/tc358743.c
> [...]
>> +/* --------------- CUSTOM CTRLS --------------- */
>> +
>> +static const struct v4l2_ctrl_config tc358743_ctrl_audio_sampling_rate = {
>> +	.id = TC358743_CID_AUDIO_SAMPLING_RATE,
>> +	.name = "Audio sampling rate",
>> +	.type = V4L2_CTRL_TYPE_INTEGER,
>> +	.min = 0,
>> +	.max = 768000,
>> +	.step = 1,
>> +	.def = 0,
>> +	.flags = V4L2_CTRL_FLAG_READ_ONLY,
>> +};
>> +
>> +static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
>> +	.id = TC358743_CID_AUDIO_PRESENT,
>> +	.name = "Audio present",
>> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> If I don't add
> +	.max = 1,
> +	.step = 1,
> here, I get -ERANGE from v4l2_ctrl_new_custom for this control.

The product I use for testing of this driver has a really old kernel 
where this validation of the boolean controls is missing. I'll fix this 
in the next revision of this driver.

Thanks,

Mats Randgaard

>
> regards
> Philipp
>
