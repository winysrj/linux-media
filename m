Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49582 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758951Ab3BNXDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 18:03:47 -0500
Message-ID: <511D6D4E.9040201@gmail.com>
Date: Fri, 15 Feb 2013 00:03:42 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com> <51158873.3060508@wwwdotorg.org> <511592B4.5050406@gmail.com> <5115991E.7050009@wwwdotorg.org> <5116CDBB.4080807@gmail.com> <511967AC.7030909@wwwdotorg.org> <511AC4A7.7030706@gmail.com> <511BFAAC.6020008@wwwdotorg.org>
In-Reply-To: <511BFAAC.6020008@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2013 09:42 PM, Stephen Warren wrote:
> On 02/12/2013 03:39 PM, Sylwester Nawrocki wrote:
[...]
>> The whole subsystem topology is exposed to user space through the Media
>> Controller API.
>
> OK, stable user-visible names are a reasonable use for device tree. I
> still don't think you should use those user-visible IDs for making any
> other kind of decision though.

OK, I will update the bindings so all variant details are placed in the
device tree. Then the routing information would mostly be coming from the
device specific dt properties/the common media bindings and the state of
links between the media entities, set by the user.

>> It's a bit simpler than that. We would need only to look for the reg
>> property in a local port subnode. MIPI-CSIS correspond to physical MIPI
>> CSI-2 bus interface of an SoC, hence it has to have specific reg values
>> that identify each camera input interface.
>
> Oh I see. I guess if a device is using its own node to determine its own
> identify, that's reasonable.

OK, I'm going to post an updated patch series in a week or two.

> I thought you were talking about a situation like:
>
> FIMC <--> XXX
>
> where FIMC wanted to determine what ID XXX knew that particular FIMC as.

Ah, no. Sorry for the poor explanation. FIMC are on a sort if interconnect
bus and they can be attached to a single data source, even in parallel,
and the data source entity don't even need to be fully aware of it.

>>>> I can see aliases used in bindings of multiple devices: uart, spi, sound
>>>> interfaces, gpio, ... And all bindings seem to impose some rules on how
>>>> their aliases are created.
>>>
>>> Do you have specific examples? I really don't think the bindings should
>>> be dictating the alias values.
>>
>> I just grepped through the existing bindings documentation:
> ...
>> I think "correctly numbered" in the above statements means there are some
>> specific rules on how the aliases are created, however those seem not
>> clearly communicated.
>
> A binding specifying that an alias must (or even should) exist for each
> node seems odd to me. In the absence of an explicit rule for how to
> determine the alias IDs to use, I think the rule would simply be that
> the aliases must be unique?

I guess so. Inspecting of_alias_get_id() call sites tells us that most 
drivers
just fail when alias is not present and only rarely it is not treated as an
error condition.

>> And there is a new patch series that allows I2C bus controller enumeration
>> by means of the aliases:
>>
>> http://www.spinics.net/lists/arm-kernel/msg224162.html
>
> That's not enumerating controllers by alias (they're still enumerated by
> scanning the DT nodes for buses in the normal way). The change simply
> assigns the bus ID of each controller from an alias; exactly what
> aliases are for.

OK, that clarifies a bit my understanding of the aliases.

Thanks,
Sylwester
