Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53917 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1FENNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 09:13:46 -0400
Received: by ewy4 with SMTP id 4so1098083ewy.19
        for <linux-media@vger.kernel.org>; Sun, 05 Jun 2011 06:13:45 -0700 (PDT)
Message-ID: <4DEB8104.5010108@gmail.com>
Date: Sun, 05 Jun 2011 15:13:40 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "Kim, HeungJun" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v9] Add support for M-5MOLS 8 Mega Pixel camera ISP
References: <1305507806-10692-1-git-send-email-riverful.kim@samsung.com> <1305871017-22924-1-git-send-email-riverful.kim@samsung.com> <20110525135435.GA3547@valkosipuli.localdomain> <4DDDFD6F.9000601@samsung.com> <20110605115529.GC6073@valkosipuli.localdomain>
In-Reply-To: <20110605115529.GC6073@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On 06/05/2011 01:55 PM, Sakari Ailus wrote:
> On Thu, May 26, 2011 at 04:12:47PM +0900, Kim, HeungJun wrote:
>> Hi Sakari,
> 
> Hi HeungJun,
> 
>> 2011-05-25 ?????? 10:54, Sakari Ailus ??? ???:
>>> Hi HeungJun,
>>>
>>> Thanks for the patch!
>> Also, thanks for the interests of this driver!
> 
> You'we welcome! :-)
> 
>>>
>>> I'm happy to see that Samsung is interested in getting such a driver to
>>> mainline. :-) I suppose that theoretically nothing would prevent plugging
>>> such a sensor to the OMAP 3 ISP, for example. It's just that the sensor
>>> already does image processing and the ISP might not be that useful because
>>> of this. But the interfaces would match, both in software and in hardware.
>> This sensor(actually integrated ISP functionality as you know) is powerful,
>> and I think this driver can help to make the controls for digital camera.
>>
>> But, TI OMAP 3 has also ISP independently, so I think having the ISP module
>> in the Processor is more better option cause of choice of various sensors,
>> although the driver's developer has more issues which should be handled.
>>
>> I hope to handle ISP directly in the Samsung Processor.
>>
>>>
>>> This is a subdev driver and uses the control framework. Good. I have
>>> comments on the code below.
>> Before that, this driver is already merged in Mauro's branch, and
>> I have spent a few months making this drivers for submitting this.
>> Some of your comments looks good and needed for this driver.
>> But, if I fix this and resend it and another comments happened,
>> this may be endless alone fight to reach "mergeing". :)
> 
> Sounds good to me. I have a few additional comments.
> 
>> So, I want that I keep this comments in mind, and I'll guarantee the fixes
>> will be adapted the next time by type of the patch, after this driver patch
>> is merged fully in 3.0.
> [clip]
> 
...

>>>> +
>>>> +/* The regulator consumer names for external voltage regulators */
>>>> +static struct regulator_bulk_data supplies[] = {
>>>> +	{
>>>> +		.supply = "core",	/* ARM core power, 1.2V */
>>>> +	}, {
>>>> +		.supply	= "dig_18",	/* digital power 1, 1.8V */
>>>> +	}, {
>>>> +		.supply	= "d_sensor",	/* sensor power 1, 1.8V */
>>>> +	}, {
>>>> +		.supply	= "dig_28",	/* digital power 2, 2.8V */
>>>> +	}, {
>>>> +		.supply	= "a_sensor",	/* analog power */
>>>> +	}, {
>>>> +		.supply	= "dig_12",	/* digital power 3, 1.2V */
>>>> +	},
>>>> +};
>>>
>>> This looks like something that belongs to board code, or perhaps in the near
>>> future, to the device tree. The power supplies that are required by a device
>>> is highly board dependent.
>> If the regulator name is not common all M-5MOLS, You're right.
>> But the regulator name of M-5MOLS is fixed.
> 
> As far as I understand, M-5MOLS is a sensor which you can, in principle,
> attach to more or less random hardware. The regulators are not part of the
> sensor. If someone adds a board which has regulators names or otherwise
> arranged differently, this change must be done at that time.

As you may know the above names are _regulator supply names_, not names
of the actual regulators. One voltage regulator can have multiple 
"regulator supply names", i.e. the "pads" to which particular loads
can be connected).

In particular all the above regulator supplies could be assigned to single
regulator in the board code, if there is, for example, only one GPIO enabling
all required voltage regulators.

The regulator API allows you to map the regulators and regulator loads 
without passing any information as platform data. Also the regulators'
hierarchy can be modelled if some of the regulators require other regulator
to be enabled in advance.

IMHO as long as the driver handles each voltage required by the device there
should be no need to abuse the platform data.
It's a different story though when some of the sensor revisions have voltage 
supplies arranged differently.

Thanks,
Sylwester
> 
>> The benefit fixed in the driver helps that the developer can attach the driver,
>> if he/she knows the names of regulators.
>>
>> Commonly, you're right, but in this case(documented accurately with M-5MOLS
>> datasheet), it's better.
>>
> [clip]
> 
