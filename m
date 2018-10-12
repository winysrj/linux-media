Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45470 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbeJLTUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 15:20:04 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD
 driver
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Lee Jones <lee.jones@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-5-vz@mleia.com> <20181012060314.GU4939@dell>
 <63733d2e-f95e-8894-f2b0-0b551b5cfeeb@mentor.com>
 <20181012083924.GW4939@dell>
 <eef99526-9232-8cd4-9a7c-c30114d58806@ideasonboard.com>
 <506c03d7-7986-44dd-3290-92d16a8106ad@mentor.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <4a807a53-1592-a895-f140-54e7acc473b3@ideasonboard.com>
Date: Fri, 12 Oct 2018 12:47:52 +0100
MIME-Version: 1.0
In-Reply-To: <506c03d7-7986-44dd-3290-92d16a8106ad@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On 12/10/18 11:58, Vladimir Zapolskiy wrote:
> Hi Kieran,
> 
> On 10/12/2018 12:20 PM, Kieran Bingham wrote:
>> Hi Vladimir,
>>
>> On 12/10/18 09:39, Lee Jones wrote:
>>> On Fri, 12 Oct 2018, Vladimir Zapolskiy wrote:
>>>> On 10/12/2018 09:03 AM, Lee Jones wrote:
>>>>> On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
>>>>>
>>>>>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>>>>>
>>>>>> The change adds I2C device driver for TI DS90Ux9xx de-/serializers,
>>>>>> support of subdevice controllers is done in separate drivers, because
>>>>>> not all IC functionality may be needed in particular situations, and
>>>>>> this can be fine grained controlled in device tree.
>>>>>>
>>>>>> The development of the driver was a collaborative work, the
>>>>>> contribution done by Balasubramani Vivekanandan includes:
>>>>>> * original implementation of the driver based on a reference driver,
>>>>>> * regmap powered interrupt controller support on serializers,
>>>>>> * support of implicitly or improperly specified in device tree ICs,
>>>>>> * support of device properties and attributes: backward compatible
>>>>>>   mode, low frequency operation mode, spread spectrum clock generator.
>>>>>>
>>>>>> Contribution by Steve Longerbeam:
>>>>>> * added ds90ux9xx_read_indirect() function,
>>>>>> * moved number of links property and added ds90ux9xx_num_fpd_links(),
>>>>>> * moved and updated ds90ux9xx_get_link_status() function to core driver,
>>>>>> * added fpd_link_show device attribute.
>>>>>>
>>>>>> Sandeep Jain added support of pixel clock edge configuration.
>>>>>>
>>>>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>>>>> ---
>>>>>>  drivers/mfd/Kconfig           |  14 +
>>>>>>  drivers/mfd/Makefile          |   1 +
>>>>>>  drivers/mfd/ds90ux9xx-core.c  | 879 ++++++++++++++++++++++++++++++++++
>>>>>>  include/linux/mfd/ds90ux9xx.h |  42 ++
>>>>>>  4 files changed, 936 insertions(+)
>>>>>>  create mode 100644 drivers/mfd/ds90ux9xx-core.c
>>>>>>  create mode 100644 include/linux/mfd/ds90ux9xx.h
>>>>>>
>>>>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>>>>> index 8c5dfdce4326..a969fa123f64 100644
>>>>>> --- a/drivers/mfd/Kconfig
>>>>>> +++ b/drivers/mfd/Kconfig
>>>>>> @@ -1280,6 +1280,20 @@ config MFD_DM355EVM_MSP
>>>>>>  	  boards.  MSP430 firmware manages resets and power sequencing,
>>>>>>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
>>>>>>  
>>>>>> +config MFD_DS90UX9XX
>>>>>> +	tristate "TI DS90Ux9xx FPD-Link de-/serializer driver"
>>>>>> +	depends on I2C && OF
>>>>>> +	select MFD_CORE
>>>>>> +	select REGMAP_I2C
>>>>>> +	help
>>>>>> +	  Say yes here to enable support for TI DS90UX9XX de-/serializer ICs.
>>>>>> +
>>>>>> +	  This driver provides basic support for setting up the de-/serializer
>>>>>> +	  chips. Additional functionalities like connection handling to
>>>>>> +	  remote de-/serializers, I2C bridging, pin multiplexing, GPIO
>>>>>> +	  controller and so on are provided by separate drivers and should
>>>>>> +	  enabled individually.
>>>>>
>>>>> This is not an MFD driver.
>>>>
>>>> Why do you think so? The representation of the ICs into device tree format
>>>> of hardware description shows that this is a truly MFD driver with multiple
>>>> IP subcomponents naturally mapped into MFD cells.
>>>
>>> This driver does too much real work ('stuff') to be an MFD driver.
>>> MFD drivers should not need to care of; links, gates, modes, pixels,
>>> frequencies maps or properties.  Nor should they contain elaborate
>>> sysfs structures to control the aforementioned 'stuff'.
>>>
>>> Granted, there may be some code in there which could be appropriate
>>> for an MFD driver.  However most of it needs moving out into a
>>> function driver (or two).
>>>
>>>> Basically it is possible to replace explicit of_platform_populate() by
>>>> adding a "simple-mfd" compatible, if it is desired.
>>>>
>>>>> After a 30 second Google of what this device actually does, perhaps
>>>>> drivers/media might be a better fit?
>>>>
>>>> I assume it would be quite unusual to add a driver with NO media functions
>>>> and controls into drivers/media.
>>>
>>> drivers/media may very well not be the correct place for this.  In my
>>> 30 second Google, I saw that this device has a lot to do with cameras,
>>> hence my media association.
>>>
>>> If *all* else fails, there is always drivers/misc, but this should be
>>> avoided if at all possible.
>>
>> The device as a whole is FPD Link for camera devices I believe, but it
> 
> I still don't understand (I could be biased though) why there is such
> a strong emphasis on cameras and media stuff in the discussion.
> 
> No, "the device as a whole is FPD Link for camera devices" is a wrong
> statement. On hand I have a number of boards with serializers/deserializers
> from the TI DS90Ux9xx IC series and sensors are NOT connected to them.


Yes - My apologies, this is a good point.

Especially as the clue is in the name "Flat Panel Display".
I have been stuck with my GMSL hat on for too long.

Even GMSL is in the same boat. It's just that 'we' are using GMSL for
cameras, but it can be used equally for displays and data.

These devices are serialiser-deserialiser pairs with power and control
paths.

Essentially they are multi purpose buses - which do not yet have a home.
We have used media as a home because of our use case.

The use case whether they transfer frames from a camera or to a display
are of course closely related, but ultimately covered by two separate
subsystems at the pixel level (DRM vs V4L, or other for other data)

Perhaps as they are buses - on a level with USB or I2C (except they can
of course carry I2C or Serial as well as 'bi-directional video' etc ),
they are looking for their own subsystem.

Except I don't think we don't want to add a new subsystem for just one
(or two) devices...

--
Kieran




>> certainly has different functions which are broken out in this
>> implementation.
> 
> No, there is absolutely nothing broken out from the presented MFD drivers,
> the drivers are completely integral and basically I don't expect any.
> 
> If you are concerned about media functionality, the correspondent MFD
> *cell* drivers will be added into drivers/media, drivers/gpu/drm or
> whatever is to be a proper place.
> 
>> I think it might be quite awkward having the i2c components in
>> drivers/i2c and the media components in drivers/media/i2c, so what about
>> creating drivers/media/i2c/fpd-link (or such) as a container?
> 
> I open drivers/media/i2c/Kconfig and all entries with no exception are
> under from 'if VIDEO_V4L2'. The MFD drivers do NOT require on depend on
> VIDEO_V4L2 or any other multimedia frameworks, nor the MFD drivers export
> any multimedia controls.
> 
>> Our GMSL implementation is also a complex camera(s) device - but does
>> not yet use the MFD framework, perhaps that's something to add to my
>> todo list.
>>
> 
> Okay, but the TI DS90Ux9xx is NOT a camera device, and it is NOT a multimedia
> device, but it is a pure MFD device so the argument is not applicable.
> 
>> We currently keep all of the complexity within the max9286.c driver, but
>> I could foresee that being split further if more devices add to the
>> complexity of managing the bus. At which point we might want an
>> equivalent drivers/media/i2c/gmsl/ perhaps?
>>
> 
> --
> Best wishes,
> Vladimir
> 
>>>> Laurent, can you please share your opinion?
>>
