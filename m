Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:19877 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1CESwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2011 13:52:18 -0500
Message-ID: <4D7286CE.8080400@maxwell.research.nokia.com>
Date: Sat, 05 Mar 2011 20:54:06 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: isp or soc-camera for image co-processors
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com> <201103011041.03424.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com> <201103011110.06258.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com> <4D6E2233.6090602@maxwell.research.nokia.com> <D5ECB3C7A6F99444980976A8C6D896384DF0A71A63@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DF0A71A63@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Bhupesh SHARMA wrote:
> Hi Sakari, Laurent and Guennadi,

Hi Bhupesh and others,

>> ...
>>
>>>>> Are there are reference drivers that I can use for my study?
>>>>
>>>> The OMAP3 ISP driver.
>>>
>>> Thanks, I will go through the same.
>>
>> The major difference in this to OMAP 3 is that the OMAP 3 does have
>> access to host side memory but the co-processor doesn't --- as it's a
>> CSI-2 link.
>>
>> Additional CSI-2 receiver (and a driver for it) is required on the host
>> side. This receiver likely is not dependent on the co-processor so the
>> driver shouldn't be either.
>>
>> For example, using this co-processor should well be possible with the
>> OMAP 3 ISP, in theory at least. What would be needed in this case is...
>> support for multiple complex Media device drivers under a single Media
>> device --- both drivers would be accessible through the same media
>> device.
>>
>> The co-processor would mostly look like a sensor for the OMAP 3 ISP
>> driver. Its internal topology would be more complex, though.
>>
>> Just a few ideas; what do you think of this? :-)
> 
> Yes, but I think I need to explain the system design better :
> One, there is an camera interface IP within the SOC as well which 
> has an internal buffer to store a line of image data and dma capabilities
> to send this data to system ddr.
> 
> So, co-processor has no access to system MMU or buffers inside the main SoC,
> but it has internal buffer to store data. It is connected via either a ITU or
> CSI-2 interface to the SoC. This is the primary and major difference between our
> architecture and OMAP 3 ISP.
> 
> As I read more the OMAP 3 TRM, I wonder whether SoC framework fits better
> in our case, as we have three separate entities to consider here:
> 	- Camera Host inside the SoC
> 	- Camera Co-processor connected with host via CSI-2/ITU (data interface)
> 	  and I2C/CCI (control interface)
> 	- Camera sensor connected to the co-processor via CSI-2 (data interface)
> 	  and I2C/CCI (control interface)
> What are your views?
> Guennadi can you also pitch in with your thoughts..
> 
> I fear that neither soc-camera  nor media framework have support
> for 3 entities listed above, as of now.

The Media controller interface allows enumerating entities and links in
the media device, activating the links between the entities. There is no
such thing as support for particular type of entity.

V4L2 subdevs on the other hand do give access to the V4L2 specifics of
the entities.

I think the Media controller & V4L2 subdevs are a good starting point
for supporting this kind of hardware.

Changes in the Media controller framework are likely needed to allow
more flexible graph definition than currently is possible. That should
make attaching this type of a device to any existing CSI-2 (or parallel)
receiver on the host CPU relatively easy.

>>>>> Unfortunately the data-sheet of the co-processor cannot be made
>>>> public
>>>>> as of yet.
>>>>
>>>> Can you publish a block diagram of the co-processor internals ?
>>>
>>> I will check internally to see if I can send a block-diagram
>>> of the co-processor internals to you. The internals seem similar to
>>
>> I'd be very interested in this as well, thank you.
> 
> I have raised a request internally to enquire about the same :)

Thanks!

>>> OMAP ISP (which I can see from the public TRM). However, our
>>> co-processor doesn't have the circular buffer and MMU that ISP seem
>> to
>>> have (and some other features).
>>>
>>> In the meantime I copy the features of the co-processor here for your
>> review:
>>>
>>> Input / Output interfaces of co-processor:
>>> ==========================================
>>> - Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to
>> 1.6 Gbit/s
>>>  and 1 x single lane up to 800 Mbit/s)
>>> - Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s)
>> or ITU
>>>  (8-bit CCIR interface, up to 100 MHz) - all with independent
>> variable
>>>  transmitter clock (PLL)
>>> - Control interface: CCI (up to 400 kHz) or SPI
>>>
>>> Sensor support:
>>> ===============
>>> - Supports two MIPI compliant sensors of up to 8 Megapixel resolution
>>>  (one sensor streaming at a time)
>>> - Support for auto-focus (AF), extended depth of field (EDOF) and
>> wide dynamic
>>>  range (WDR)sensors
>>>
>>> Internal Features:
>>> ==================
>>> - Versatile clock manager and internal buffer to accommodate a wide
>> range of data rates
>>>   between sensors and the coprocessor and between the coprocessor and
>> the host.
>>> - Synchronized flash gun control with red-eye reduction (pre-flash
>> and main-flash strobes) for
>>>   high-power LED or Xenon strobe light
>>
>> Does the co-processor have internal memory or can external memory be
>> attached to it for buffer storage?
>>
> 
> The co-processor has no access to system MMU or buffers inside the main SoC,
> but it has internal buffer to store data.

One more question... does the co-processor have enough memory to store
images themselves? The rotation functionality suggests that it has more
memory than is required to save just a few lines of image data.

What about the jpeg encoding; is the co-processor also able to provide
the same image as raw bayer or in YUV colour space to the host, for example?

Best regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
