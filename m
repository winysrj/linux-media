Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:44890 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3HHVr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:47:26 -0400
Message-ID: <520411E7.4070708@wwwdotorg.org>
Date: Thu, 08 Aug 2013 15:47:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Tomasz Figa <t.figa@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Rob Herring <robherring2@gmail.com>,
	Olof Johansson <olof@lixom.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Exynos: replace custom MFC reserved memory handling
 with generic code
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com> <1375705610-12724-2-git-send-email-m.szyprowski@samsung.com> <52040704.6090100@wwwdotorg.org> <1421964.5VNJUTGkrX@flatron>
In-Reply-To: <1421964.5VNJUTGkrX@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 03:19 PM, Tomasz Figa wrote:
> Hi Stephen,
> 
> On Thursday 08 of August 2013 15:00:52 Stephen Warren wrote:
>> On 08/05/2013 06:26 AM, Marek Szyprowski wrote:
>>> MFC driver use custom bindings for managing reserved memory. Those
>>> bindings are not really specific to MFC device and no even well
>>> discussed. They can be easily replaced with generic, platform
>>> independent code for handling reserved and contiguous memory.
>>>
>>> Two additional child devices for each memory port (AXI master) are
>>> introduced to let one assign some properties to each of them. Later
>>> one
>>> can also use them to assign properties related to SYSMMU controllers,
>>> which can be used to manage the limited dma window provided by those
>>> memory ports.
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt
>>> b/Documentation/devicetree/bindings/media/s5p-mfc.txt
>>>
>>> +The MFC device is connected to system bus with two memory ports (AXI
>>> +masters) for better performance. Those memory ports are modelled as
>>> +separate child devices, so one can assign some properties to them
>>> (like +memory region for dma buffer allocation or sysmmu controller).
>>> +
>>>
>>>  Required properties:
>>>    - compatible : value should be either one among the following
>>>  	
>>>  	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
>>>  	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
>>>
>>> +	and additionally "simple-bus" to correctly initialize child
>>> +	devices for memory ports (AXI masters)
>>
>> simple-bus is wrong here; the child nodes aren't independent entities
>> that can be instantiated separately from their parent and without
>> depending on their parent.
> 
> I fully agree, but I can't think of anything better. Could you suggest a 
> solution that would cover our use case:
> 
> The MFC IP has two separate bus masters (called here and there memports). 
> On some SoCs, each master must use different memory bank to meet memory 
> bandwidth requirements for higher bitrate video streams. This can be seen 
> as MFC having two DMA subdevices, which have different DMA windows.
> 
> On Linux, this is handled by binding two appropriate CMA memory regions to 
> the memports, so the driver can do DMA allocations on behalf of particular 
> memport and get appropriate memory for it.

I don't see what that has to do with simple-bus. Whatever parses the
node of the MFC can directly read from any contained property or child
node; there's no need to try and get the core DT tree parser to
enumerate the children.

If you actually need a struct platform_device for each of these child
nodes (which sounds wrong, but I'm not familiar with the code), then
simply have the driver call of_platform_populate() itself at the
appropriate time. But that's not going to work well unless the child
nodes have compatible values, which doesn't seem right given their purpose.

>>> -  - samsung,mfc-r : Base address of the first memory bank used by MFC
>>> -		    for DMA contiguous memory allocation and its size.
>>> -
>>> -  - samsung,mfc-l : Base address of the second memory bank used by
>>> MFC
>>> -		    for DMA contiguous memory allocation and its size.
>>
>> These properties shouldn't be removed, but simply marked deprecated. The
>> driver will need to continue to support them so that old DTs work with
>> new kernels. The binding must therefore continue to document them so
>> that the old DT content still makes sense.
> 
> I tend to disagree on this. For Samsung platforms we've been trying to 
> avoid DT bindings changes as much as possible, but I'd rather say that 
> device tree was coupled with kernel version it came from, so Samsung-
> specific bindings haven't been fully stabilized yet, especially since we 
> are still at discussion stage when it's about defining processes for 
> binding staging and stabilization.

Well, that's why everyone is shouting at ARM for abusing DT...

> I would rather see this patch as part of work on Samsung DT binding 
> janitoring or maybe even sanitizing in some cases, like this one, when the 
> old (and IMHO bad) MFC binding was introduced without proper review. I 
> don't think we want to support this kind of brokenness anymore, especially 
> considering the hacks which would be required by such support (see 
> original implementation of this binding and code required in board file).
> 
>>> +Two child nodes must be defined for MFC device. Their names must be
>>> +following: "memport-r" and "memport-l" ("right" and "left"). Required
>>
>> Node names shouldn't have semantic meaning.
> 
> What about bus-master-0 and bus-master-1?

Just "bus-master" for each might make sense. Use reg properties to
differentiate the two?
