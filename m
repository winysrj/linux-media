Return-path: <linux-media-owner@vger.kernel.org>
Received: from [173.38.203.54] ([173.38.203.54]:30033 "EHLO
	aer-iport-4.cisco.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750809AbaBKMLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 07:11:20 -0500
Message-ID: <52FA1297.5070108@cisco.com>
Date: Tue, 11 Feb 2014 13:07:51 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 35/47] adv7604: Add sink pads
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-36-git-send-email-laurent.pinchart@ideasonboard.com> <52F9F934.9090202@xs4all.nl> <3580605.MqbMpcI5hW@avalon>
In-Reply-To: <3580605.MqbMpcI5hW@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/11/14 13:00, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 11 February 2014 11:19:32 Hans Verkuil wrote:
>> On 02/05/14 17:42, Laurent Pinchart wrote:
>>> The ADV7604 has sink pads for its HDMI and analog inputs. Report them.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>
>>>  drivers/media/i2c/adv7604.c | 71 +++++++++++++++++++++++++---------------
>>>  include/media/adv7604.h     | 14 ---------
>>>  2 files changed, 45 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>> index 05e7e1a..da32ce9 100644
>>> --- a/drivers/media/i2c/adv7604.c
>>> +++ b/drivers/media/i2c/adv7604.c
>>> @@ -97,13 +97,25 @@ struct adv7604_chip_info {
>>>
>>>   **********************************************************************
>>>   */
>>>
>>> +enum adv7604_pad {
>>> +	ADV7604_PAD_HDMI_PORT_A = 0,
>>> +	ADV7604_PAD_HDMI_PORT_B = 1,
>>> +	ADV7604_PAD_HDMI_PORT_C = 2,
>>> +	ADV7604_PAD_HDMI_PORT_D = 3,
>>> +	ADV7604_PAD_VGA_RGB = 4,
>>> +	ADV7604_PAD_VGA_COMP = 5,
>>> +	/* The source pad is either 1 (ADV7611) or 6 (ADV7604) */
>>
>> How about making this explicit:
>>
>> 	ADV7604_PAD_SOURCE = 6,
>> 	ADV7611_PAD_SOURCE = 1,
> 
> I can do that, but those two constants won't be used in the driver as they 
> computed dynamically.
> 
>>> +	ADV7604_PAD_MAX = 7,
>>> +};
>>
>> Wouldn't it make more sense to have this in the header? I would really
>> like to use the symbolic names for these pads in my bridge driver.
> 
> That would add a dependency on the adv7604 driver to the bridge driver, isn't 
> the whole point of subdevs to avoid such dependencies ?

The bridge driver has to know about the adv7604, not the other way around.

E.g. in my bridge driver I have to match v4l2 inputs to pads, both for
S_EDID and for s_routing, so it needs to know which pad number to use.

Also, for calling set_fmt, BTW. There I need to specify the source pad,
which is also why I would like to have a symbolic name for it as suggested
above.

Regards,

	Hans
