Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36931 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2GRRqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 13:46:42 -0400
Message-ID: <5006F67E.3020404@gmail.com>
Date: Wed, 18 Jul 2012 19:46:38 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 06/13] media: s5p-fimc: Add device tree support for
 FIMC-LITE
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-6-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161114130.12302@axis700.grange> <5005B51E.20505@gmail.com> <alpine.DEB.2.00.1207180939290.6403@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1207180939290.6403@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 07/18/2012 09:57 AM, Guennadi Liakhovetski wrote:
> On Tue, 17 Jul 2012, Sylwester Nawrocki wrote:
>> On 07/16/2012 11:15 AM, Guennadi Liakhovetski wrote:
>>>> --- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
>>>> +++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
>>>> @@ -39,6 +39,21 @@ Required properties:
>>>>    	       depends on the SoC revision. For S5PV210 valid values are:
>>>>    	       0...2, for Exynos4x1x: 0...3.
>>>>
>>>> +
>>>> +'fimc-lite' device node
>>>> +-----------------------
>>>> +
>>>> +Required properties:
>>>> +
>>>> +- compatible : should be one of:
>>>> +		"samsung,exynos4212-fimc";
>>>> +		"samsung,exynos4412-fimc";
>>>> +- reg	     : physical base address and size of the device's memory
>>>> mapped
>>>> +	       registers;
>>>> +- interrupts : should contain FIMC-LITE interrupt;
>>>> +- cell-index : FIMC-LITE IP instance index;
>>>
>>> Same as in an earlier patch - not sure this is needed.
>>
>> It is needed for setting up a pipeline of multiple sub-device
>> within a SoC. As I commented on patch 2/13 I'd like to replace
>> this with proper entries in the "aliases" node. Some sub-devices
>> have registers that these indexes need to be directly written to.
> 
> Aha, so, these are not purely software indices, that you just use to
> identify your devices, these are actual hardware values? You really have
> to write, e.g., "1" into a resizer register to connect it to a certain
> capture engine? Ok, in this case it indeed might make sense to have these

Yes, that's more or less how it works. If I select input mux id = 0, 
then MIPI-CSIS0 have to be used for streaming. For this FIMC-LITE device
there are some commands/registers within the device that sits after
FIMC-LITE in the data pipeline (not yet mainlined).

> values in the DT. Not sure how best to call these properties, or whether
> aliases is the best solution, but that's already a detail. And btw, if you

Yeah, the property seems more accurate. But I don't really mind, I could 
just use whatever is accepted in the mainline.

> do decide to keep this as a property, maybe this is one of the cases,
> where you'd want to mark it with your hardware type, like "fimc,cell-id"
> or similar?

I'm not sure about that. "cell-index" has well defined semantics. So
there should be no reason to use device specific property. I would have
then to use "samsung,fimc-cell-id", "samsung,fimc-lite-cell-id" and
"samsung,csis-cell-id", as all device specific bindings need to be 
prefixed with a manufacturer code.

--

Thanks,
Sylwester
