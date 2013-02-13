Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:42830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336Ab3BMUmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 15:42:25 -0500
Message-ID: <511BFAAC.6020008@wwwdotorg.org>
Date: Wed, 13 Feb 2013 13:42:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com> <51158873.3060508@wwwdotorg.org> <511592B4.5050406@gmail.com> <5115991E.7050009@wwwdotorg.org> <5116CDBB.4080807@gmail.com> <511967AC.7030909@wwwdotorg.org> <511AC4A7.7030706@gmail.com>
In-Reply-To: <511AC4A7.7030706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2013 03:39 PM, Sylwester Nawrocki wrote:
> On 02/11/2013 10:50 PM, Stephen Warren wrote:
>> On 02/09/2013 03:29 PM, Sylwester Nawrocki wrote:
>>> On 02/09/2013 01:32 AM, Stephen Warren wrote:
>>>> On 02/08/2013 05:05 PM, Sylwester Nawrocki wrote:
>>>>> On 02/09/2013 12:21 AM, Stephen Warren wrote:
>>>>>> On 02/08/2013 04:16 PM, Sylwester Nawrocki wrote:
>>>>>>> On 02/07/2013 12:40 AM, Stephen Warren wrote:
>>>>>>>>> diff --git
>>>>>>>>> a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>>>>>>> b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>>>>>>
>>>>>>>>> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
>>>>>>>>> +----------------------------------------------
>>>>>> ...
>>>>>>>>> +For every fimc node a numbered alias should be present in the
>>>>>>>>> aliases node.
>>>>>>>>> +Aliases are of the form fimc<n>, where<n>     is an integer
>>>>>>>>> (0...N)
>>>>>>>>> specifying
>>>>>>>>> +the IP's instance index.
>> ...
>>>>> Different compatible values might not work, when for example there
>>>>> are 3 IPs out of 4 of one type and the fourth one of another type.
>>>>> It wouldn't even by really different types, just quirks/little
>>>>> differences between them, e.g. no data path routed to one of other
>>>>> IPs.
>>>>
>>>> I was thinking of using feature-/quirk-oriented properties. For
>>>> example,
>>>> if there's a port on 3 of the 4 devices to connect to some other IP
>>>> block, simply include a boolean property to indicate whether that port
>>>> is present. It would be in 3 of the nodes but not the 4th.
>>>
>>> Yes, I could add several properties corresponding to all members of this
>>> [3] data structure. But still it is needed to clearly identify the IP
>>> block in a set of the hardware instances.
>>
>> Why? What decisions will be made based on the identify of the IP block
>> instance that wouldn't be covered by DT properties that describe which
>> features/bugs/... the IP block instance has?
> 
> The whole subsystem topology is exposed to user space through the Media
> Controller API.

OK, stable user-visible names are a reasonable use for device tree. I
still don't think you should use those user-visible IDs for making any
other kind of decision though.

>>>>> Then to connect e.g. MIPI-CSIS.0 to FIMC.2 at run time an index of the
>>>>> MIPI-CSIS needs to be written to the FIMC.2 data input control
>>>>> register.
>>>>> Even though MIPI-CSIS.N are same in terms of hardware structure they
>>>>> still
>>>>> need to be distinguished as separate instances.
>>>>
>>>> Oh, so you're using the alias ID as the value to write into the FIMC.2
>>>> register for that. I'm not 100% familiar with aliases, but they seem
>>>> like a more user-oriented naming thing to me, whereas values for
>>>> hooking
>>>> up intra-SoC routing are an unrelated namespace semantically, even if
>>>> the values happen to line up right now. Perhaps rather than a Boolean
>>>> property I mentioned above, use a custom property to indicate the ID
>>>> that the FIMC.2 object knows the MIPI-CSIS.0 object as? While this
>>>> seems
>>>
>>> That could be 'reg' property in the MIPI-CSIS.0 'port' subnode that
>>> links it to the image sensor node ([4], line 165). Because MIPI-CSIS IP
>>> blocks are immutably connected to the SoC camera physical MIPI CSI-2
>>> interfaces, and the physical camera ports have fixed assignment to the
>>> MIPI-CSIS devices..  This way we could drop alias ID for the MIPI-CSIS
>>> nodes. And their instance index that is required for the top level
>>> driver which exposes topology and the routing capabilities to user space
>>> could be restored from the reg property value by subtracting a fixed
>>> offset.
>>
>> I suppose that would work. It feels a little indirect, and I think means
>> that the driver needs to go find some child node defining its end of
>> some link, then find the node representing the other end of the link,
>> then read properties out of that other node to find the value. That
>> seems a little unusual, but I guess it would work. I'm not sure of the
>> long-term implications of doing that kind of thing. You'd want to run
>> the idea past some DT maintainers/experts.
> 
> It's a bit simpler than that. We would need only to look for the reg
> property in a local port subnode. MIPI-CSIS correspond to physical MIPI
> CSI-2 bus interface of an SoC, hence it has to have specific reg values
> that identify each camera input interface.

Oh I see. I guess if a device is using its own node to determine its own
identify, that's reasonable.

I thought you were talking about a situation like:

FIMC <--> XXX

where FIMC wanted to determine what ID XXX knew that particular FIMC as.

>>> I can see aliases used in bindings of multiple devices: uart, spi, sound
>>> interfaces, gpio, ... And all bindings seem to impose some rules on how
>>> their aliases are created.
>>
>> Do you have specific examples? I really don't think the bindings should
>> be dictating the alias values.
> 
> I just grepped through the existing bindings documentation:
...
> I think "correctly numbered" in the above statements means there are some
> specific rules on how the aliases are created, however those seem not
> clearly communicated.

A binding specifying that an alias must (or even should) exist for each
node seems odd to me. In the absence of an explicit rule for how to
determine the alias IDs to use, I think the rule would simply be that
the aliases must be unique?

> And there is a new patch series that allows I2C bus controller enumeration
> by means of the aliases:
> 
> http://www.spinics.net/lists/arm-kernel/msg224162.html

That's not enumerating controllers by alias (they're still enumerated by
scanning the DT nodes for buses in the normal way). The change simply
assigns the bus ID of each controller from an alias; exactly what
aliases are for.
