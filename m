Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38853 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2AHNJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 08:09:21 -0500
Received: by eaad14 with SMTP id d14so1647063eaa.19
        for <linux-media@vger.kernel.org>; Sun, 08 Jan 2012 05:09:20 -0800 (PST)
Message-ID: <4F09957D.3070104@gmail.com>
Date: Sun, 08 Jan 2012 14:09:17 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC 13/17] omap3isp: Configure CSI-2 phy based on platform data
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201061101.02843.laurent.pinchart@ideasonboard.com> <4F08CC6C.8080209@maxwell.research.nokia.com> <201201080202.11719.laurent.pinchart@ideasonboard.com> <4F096F3A.7020902@maxwell.research.nokia.com> <4F0978DB.2000601@gmail.com> <4F097B21.7080000@maxwell.research.nokia.com>
In-Reply-To: <4F097B21.7080000@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/08/2012 12:16 PM, Sakari Ailus wrote:
>>>>>> Shouldn't lane configuration be retrieved from the sensor instead ?
>>>>>> Sensors could use different lane configuration depending on the mode.
>>>>>> This could also be implemented later when needed, but I don't think it
>>>>>> would be too difficult to get it right now.
>>>>>
>>>>> I think we'd first need to standardise the CSI-2 bus configuration. I
>>>>> don't see a practical need to make the lane configuration dynamic. You
>>>>> could just use a lower frequency to achieve the same if you really need to.
>>>>>
>>>>> Ideally it might be nice to do but there's really nothing I know that
>>>>> required or even benefited from it --- at least for now.
>>>>
>>>> Does this mean that lane configuration needs to be duplicated in board code, 
>>>> on for the SMIA++ platform data and one of the OMAP3 ISP platform data ?
>>>
>>> It's mostly the number of lanes, and the polarity --- in theory it is
>>> possible to invert the signals on the bus, albeit I'm not sure if anyone
>>> does that; I can't see a reason for that, but hey, I don't know why it's
>>> possible to specify polarity either. :-)

I think it just enables to swap D+ and D- functions on the physical pins.

>> I've never seen polarity configuration option in any datasheet, neither
>> MIPI CSI-2 or D-PHY mentions that. Does OMAP3 ISP really allow MIPI-CSI
>> lane signal polarity configuration ? MIPI-CSI2 uses differential signals
>> after all. What would be a point of changing polarity ?
> 
> I don't know. It's also the same for CSI-1 on OMAP 3.
> 
> This is actually one of the issues here: also device specific
> configuration is required. The standard configuration must contain
> probably at least what the spec defines.
> 
>>> If both sides support mapping of the lanes, a mapping that matches on
>>> both sides has to be provided.
>>
>> In Samsung SoC (both sensor and host interface) I've seen only possibility
>> to configure the number of data lanes, FWIW I think it is assumed that
>> when you use e.g. 2 data lanes always lane1 and lane2 are utilised for
>> transmission, for 3 lanes - lane 1,2,3, etc. Also I've never seen on
>> schematics that someone wires data lane3 and lane4 when only 2 lanes
>> are utilised, so this makes me wonder if the lane mapping is ever needed.
>>
>> Has anyone different experience with that ?
>>
>> Also the standard seem to specify that Data1+ lane at a transmitter(Tx) is
>> connected to Data1+ lane at a receiver(Rx), Data1-(Tx) to Data1-(Rx),
>> Data2+(Tx) to Data2+(Rx), etc. I think this is needed due to explicitly
>> defined data distribution and merging scheme among the lanes, i.e. to allow
>> interworking of various receivers and transmitters.
>>
>> Thus it seems all we need need is just a number of data lanes used.
> 
> The standard of course specifies that the data lanes must be connected
> correctly. :-) It can't specify which SoC pins do they use, so for added
> flexibility it's good to be able to reorder them.
> 
> Have you ever worked with single-layer PCBs by any chance? :-) More
> layers are used these days but it still doesn't solve all possible issues.

Yes, I have. I know what you mean. It just seemed uncommon to me to reorder
the signals. But since H/W doing that exists..and that might become more
widely used in the future it might make sense to standardize lane
configuration.

> So I think I can say reordering generally must be supported by software
> if the hardware can do that.

Yes, however there is always a board specific information involved, isn't it ?
I.e. transmitter can reorder signals between its pins, the same can happen at
a receiver and additionally the transmitter's pins can be connected differently
to the receiver pins, depending on the board ?

Then do we make board specific information part of sensor's or host platform
data ? It probably should be at both, let's take an evaluation and a camera
daughter boards as an example.

We also need device tree bindings for that, if possible the best would be to
design common bindings, at least basic ones, to which device specific ones
could be added.

--
Regards,
Sylwester
