Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2GQSQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 14:16:27 -0400
Message-ID: <5005ABF7.6020008@gmail.com>
Date: Tue, 17 Jul 2012 20:16:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 02/13] media: s5p-csis: Add device tree support
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-2-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161031000.12302@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207161031000.12302@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 07/16/2012 10:55 AM, Guennadi Liakhovetski wrote:
> Hi Sylwester
>
> Thanks for your comments to my RFC and for pointing out to this your
> earlier patch series. Unfortunately, I missed in in May, let me try to
> provide some thoughts about this, we should really try to converge our
> proposals. Maybe a discussion at KS would help too.

Thank you for the review. I was happy to see your RFC, as previously
there seemed to be not much interest in DT among the media guys.
Certainly, we need to work on a common approach to ensure interoperability
of existing drivers and to avoid having people inventing different
bindings for common features. I would also expect some share of device
specific bindings, as diversity of media devices is significant.

I'd be great to discuss these things at KS, especially support for 
proper suspend/resume sequences. Also having common sessions with 
other subsystems folks, like ASoC, for example, might be a good idea.

I'm not sure if I'll be travelling to the KS though. :)

> On Fri, 25 May 2012, Sylwester Nawrocki wrote:
>
>> s5p-csis is platform device driver for MIPI-CSI frontend to the FIMC
>> (camera host interface DMA engine and image processor). This patch
>> adds support for instantiating the MIPI-CSIS devices from DT and
>> parsing all SoC and board specific properties from device tree.
>> The MIPI DPHY control callback is now called directly from within
>> the driver, the platform code must ensure this callback does the
>> right thing for each SoC.
>>
>> The cell-index property is used to ensure proper signal routing,
>> from physical camera port, through MIPI-CSI2 receiver to the DMA
>> engine (FIMC?). It's also helpful in exposing the device topology
>> in user space at /dev/media? devnode (Media Controller API).
>>
>> This patch also defines a common property ("data-lanes") for MIPI-CSI
>> receivers and transmitters.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/video/mipi.txt   |    5 +
>>   .../bindings/video/samsung-mipi-csis.txt           |   47 ++++++++++
>>   drivers/media/video/s5p-fimc/mipi-csis.c           |   97 +++++++++++++++-----
>>   drivers/media/video/s5p-fimc/mipi-csis.h           |    1 +
>>   4 files changed, 126 insertions(+), 24 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/video/mipi.txt
>>   create mode 100644 Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
>>
>> diff --git a/Documentation/devicetree/bindings/video/mipi.txt b/Documentation/devicetree/bindings/video/mipi.txt
>> new file mode 100644
>> index 0000000..5aed285
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/video/mipi.txt
>> @@ -0,0 +1,5 @@
>> +Common properties of MIPI-CSI1 and MIPI-CSI2 receivers and transmitters
>> +
>> + - data-lanes : number of differential data lanes wired and actively used in
>> +		communication between the transmitter and the receiver, this
>> +		excludes the clock lane;
>
> Wouldn't it be better to use the standard "bus-width" DT property?

I can't see any problems with using "bus-width". It seems sufficient
and could indeed be better, without a need to invent new MIPI-CSI 
specific names. That was my first RFC on that and my perspective 
wasn't probably broad enough. :)

>> diff --git a/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
>> new file mode 100644
>> index 0000000..7bce6f4
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/video/samsung-mipi-csis.txt
>> @@ -0,0 +1,47 @@
>> +Samsung S5P/EXYNOS SoC MIPI-CSI2 receiver (MIPI CSIS)
>> +-----------------------------------------------------
>> +
>> +Required properties:
>> +
>> +- compatible - one of :
>> +		"samsung,s5pv210-csis",
>> +		"samsung,exynos4210-csis",
>> +		"samsung,exynos4212-csis",
>> +		"samsung,exynos4412-csis";
>> +- reg : physical base address and size of the device memory mapped registers;
>> +- interrupts      : should contain MIPI CSIS interrupt; the format of the
>> +		    interrupt specifier depends on the interrupt controller;
>> +- cell-index      : the hardware instance index;
>
> Not sure whether this is absolutely needed... Wouldn't it be sufficient to
> just enumerate them during probing?

As Grant pointed to me, the "cell-index" property is something that we should
be avoiding. But I needed something like this in the driver,
to differentiate between the multiple IP instances. I cannot simply assign
the indexes in random way to the hardware instances. Each of the MIPI-CSI 
Slaves has different properties (e.g. supporting max. 2 or 4 data lanes).
Additionally, a particular MIPI-CSI Slave instance is hard-wired inside the
SoC to the FIMC input mux (cross-bar) and physical video port. IOW, an image
sensor/video port/MIPI-CSIS instance assignment is fixed. If two MIPI-CSI 
image sensors are connected, one of them will work only with MIPI-CSIS0, and
the other only with MIPI-CSIS1.

So the driver must be able to identify it's physical device (IO region + 
IRQ) precisely.

That said, I found out recently that a proper entries in the "aliases"
could be used instead, and I could finally abandon the "cell-index" idea.
Not sure how aliases approach is better but from what I can see it is
a preferred way to handle things like the above.

Please see Documentation/devicetree/bindings/sound/mxs-saif.txt and users
of of_alias_get_id() for more details.

So to summarize, the indexes are needed, but the current implementation 
is not necessarily good, and AFAICT the aliases approach could be the way
to go.

>> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, the default
>> +		    value when this property is not specified is 166 MHz;
>> +- data-lanes      : number of physical MIPI-CSI2 lanes used;
>
> ditto - bus-width?

Yes, agreed. Let's drop it in favour of "bus-width".

--

Regards,
Sylwester
