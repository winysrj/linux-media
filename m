Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2577 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaBKMgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 07:36:38 -0500
Message-ID: <52FA187D.7070809@xs4all.nl>
Date: Tue, 11 Feb 2014 13:33:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 35/47] adv7604: Add sink pads
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <2613751.oRlAYVmzeh@avalon> <52FA1663.80307@xs4all.nl> <1908907.sAJsozBgzM@avalon>
In-Reply-To: <1908907.sAJsozBgzM@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/14 13:32, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 11 February 2014 13:24:03 Hans Verkuil wrote:
>> On 02/11/14 13:23, Laurent Pinchart wrote:
>>> On Tuesday 11 February 2014 13:07:51 Hans Verkuil wrote:
>>>> On 02/11/14 13:00, Laurent Pinchart wrote:
>>>>> On Tuesday 11 February 2014 11:19:32 Hans Verkuil wrote:
>>>>>> On 02/05/14 17:42, Laurent Pinchart wrote:
>>>>>>> The ADV7604 has sink pads for its HDMI and analog inputs. Report them.
>>>>>>>
>>>>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>>>> ---
>>>>>>>
>>>>>>>  drivers/media/i2c/adv7604.c | 71  ++++++++++++++++++++++-------------
>>>>>>>  include/media/adv7604.h     | 14 ---------
>>>>>>>  2 files changed, 45 insertions(+), 40 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>>>>>> index 05e7e1a..da32ce9 100644
>>>>>>> --- a/drivers/media/i2c/adv7604.c
>>>>>>> +++ b/drivers/media/i2c/adv7604.c
>>>>>>> @@ -97,13 +97,25 @@ struct adv7604_chip_info {
>>>>>>>
>>>>>>>   ********************************************************************
>>>>>>>   */
>>>>>>>
>>>>>>> +enum adv7604_pad {
>>>>>>> +	ADV7604_PAD_HDMI_PORT_A = 0,
>>>>>>> +	ADV7604_PAD_HDMI_PORT_B = 1,
>>>>>>> +	ADV7604_PAD_HDMI_PORT_C = 2,
>>>>>>> +	ADV7604_PAD_HDMI_PORT_D = 3,
>>>>>>> +	ADV7604_PAD_VGA_RGB = 4,
>>>>>>> +	ADV7604_PAD_VGA_COMP = 5,
>>>>>>> +	/* The source pad is either 1 (ADV7611) or 6 (ADV7604) */
>>>>>>
>>>>>> How about making this explicit:
>>>>>> 	ADV7604_PAD_SOURCE = 6,
>>>>>> 	ADV7611_PAD_SOURCE = 1,
>>>>>
>>>>> I can do that, but those two constants won't be used in the driver as
>>>>> they
>>>>> computed dynamically.
>>>>>
>>>>>>> +	ADV7604_PAD_MAX = 7,
>>>>>>> +};
>>>>>>
>>>>>> Wouldn't it make more sense to have this in the header? I would really
>>>>>> like to use the symbolic names for these pads in my bridge driver.
>>>>>
>>>>> That would add a dependency on the adv7604 driver to the bridge driver,
>>>>> isn't the whole point of subdevs to avoid such dependencies ?
>>>>
>>>> The bridge driver has to know about the adv7604, not the other way
>>>> around.
>>>>
>>>> E.g. in my bridge driver I have to match v4l2 inputs to pads, both for
>>>> S_EDID and for s_routing, so it needs to know which pad number to use.
>>>
>>> Is that information that you want to pass to the bridge driver through
>>> platform data, or do you want to hardcode it in the bridge driver itself ?
>>> In the latter case the bridge driver would become specific to the
>>> adv7604. It might be fine in your case if your bridge is specific to your
>>> board anyway (FPGAs come to mind), but it lacks genericity.
>>
>> Hardcoded. It's just like any PCI driver: the PCI ID determines what the
>> board is and based on that you set everything up. And if there are multiple
>> variations of the board you use card structures to define such things.
>>
>> The only place where you can put that information is in the bridge driver.
> 
> Or in DT I suppose ;-)

Well, there is no DT. So there's that.

> It could be argued that the bridge driver could/should 
> discover pad numbers somehow dynamically, but there's no harm in moving the 
> enum to the header, so I'll do that.

Thanks. 

	Hans
