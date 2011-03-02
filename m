Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:46257 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993Ab1CBKzu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 05:55:50 -0500
Message-ID: <4D6E2233.6090602@maxwell.research.nokia.com>
Date: Wed, 02 Mar 2011 12:55:47 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: isp or soc-camera for image co-processors
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com> <201103011041.03424.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com> <201103011110.06258.laurent.pinchart@ideasonboard.com> <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh and Laurent,

Bhupesh SHARMA wrote:
...
>> Try to configure your mailer to use spaces instead of tabs, or to make
>> tabs 8
>> spaces wide. It should then look good. Replies will usually mess the
>> diagrams
>> up though.
> 
> Ok, I will try it :)

Attachments are usually safe as well.

...

>>> Are there are reference drivers that I can use for my study?
>>
>> The OMAP3 ISP driver.
> 
> Thanks, I will go through the same.

The major difference in this to OMAP 3 is that the OMAP 3 does have
access to host side memory but the co-processor doesn't --- as it's a
CSI-2 link.

Additional CSI-2 receiver (and a driver for it) is required on the host
side. This receiver likely is not dependent on the co-processor so the
driver shouldn't be either.

For example, using this co-processor should well be possible with the
OMAP 3 ISP, in theory at least. What would be needed in this case is...
support for multiple complex Media device drivers under a single Media
device --- both drivers would be accessible through the same media device.

The co-processor would mostly look like a sensor for the OMAP 3 ISP
driver. Its internal topology would be more complex, though.

Just a few ideas; what do you think of this? :-)

>>> Unfortunately the data-sheet of the co-processor cannot be made
>> public
>>> as of yet.
>>
>> Can you publish a block diagram of the co-processor internals ?
> 
> I will check internally to see if I can send a block-diagram
> of the co-processor internals to you. The internals seem similar to 

I'd be very interested in this as well, thank you.

> OMAP ISP (which I can see from the public TRM). However, our
> co-processor doesn't have the circular buffer and MMU that ISP seem to
> have (and some other features).
> 
> In the meantime I copy the features of the co-processor here for your review:
> 
> Input / Output interfaces of co-processor:
> ==========================================
> - Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to 1.6 Gbit/s
>  and 1 x single lane up to 800 Mbit/s)
> - Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s) or ITU
>  (8-bit CCIR interface, up to 100 MHz) - all with independent variable
>  transmitter clock (PLL)
> - Control interface: CCI (up to 400 kHz) or SPI
> 
> Sensor support:
> ===============
> - Supports two MIPI compliant sensors of up to 8 Megapixel resolution
>  (one sensor streaming at a time)
> - Support for auto-focus (AF), extended depth of field (EDOF) and wide dynamic
>  range (WDR)sensors 
> 
> Internal Features:
> ==================
> - Versatile clock manager and internal buffer to accommodate a wide range of data rates
>   between sensors and the coprocessor and between the coprocessor and the host.
> - Synchronized flash gun control with red-eye reduction (pre-flash and main-flash strobes) for
>   high-power LED or Xenon strobe light

Does the co-processor have internal memory or can external memory be
attached to it for buffer storage?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
