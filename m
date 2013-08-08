Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:48877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966810Ab3HHWs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 18:48:59 -0400
Message-ID: <52042055.6020403@wwwdotorg.org>
Date: Thu, 08 Aug 2013 16:48:53 -0600
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
References: <1375705610-12724-1-git-send-email-m.szyprowski@samsung.com> <1421964.5VNJUTGkrX@flatron> <520411E7.4070708@wwwdotorg.org> <6170882.dm214gAmhr@flatron>
In-Reply-To: <6170882.dm214gAmhr@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 04:10 PM, Tomasz Figa wrote:
> On Thursday 08 of August 2013 15:47:19 Stephen Warren wrote:
>> On 08/08/2013 03:19 PM, Tomasz Figa wrote:
>>> On Thursday 08 of August 2013 15:00:52 Stephen Warren wrote:
>>>> On 08/05/2013 06:26 AM, Marek Szyprowski wrote:
>>>>> MFC driver use custom bindings for managing reserved memory. Those
>>>>> bindings are not really specific to MFC device and no even well
>>>>> discussed. They can be easily replaced with generic, platform
>>>>> independent code for handling reserved and contiguous memory.
>>>>>
>>>>> Two additional child devices for each memory port (AXI master) are
>>>>> introduced to let one assign some properties to each of them. Later
>>>>> one
>>>>> can also use them to assign properties related to SYSMMU
>>>>> controllers,
>>>>> which can be used to manage the limited dma window provided by those
>>>>> memory ports.
...
>>>>> +Two child nodes must be defined for MFC device. Their names must be
>>>>> +following: "memport-r" and "memport-l" ("right" and "left").
>>>>> Required
>>>>
>>>> Node names shouldn't have semantic meaning.
>>>
>>> What about bus-master-0 and bus-master-1?
>>
>> Just "bus-master" for each might make sense. Use reg properties to
>> differentiate the two?
> 
> What this reg property would mean in this case?
> 
> My understanding of reg property was that it should be used for real 
> addresses or IDs and for all other cases node names should be suffixed 
> with "-ID".

Presumably it would hold the ID of the HW block as defined in the
documentation. Or, it could be somewhat arbitrary.

