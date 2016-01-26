Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33789 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcAZGzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 01:55:32 -0500
Subject: Re: [PATCH] media: platform: exynos4-is: media-dev: Add missing
 of_node_put
To: Julia Lawall <julia.lawall@lip6.fr>
References: <20160125152136.GA19484@amitoj-Inspiron-3542>
 <56A6BCC3.8040407@samsung.com>
 <alpine.DEB.2.02.1601260723290.2004@localhost6.localdomain6>
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	mchehab@osg.samsung.com, kgene@kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <56A7185F.7020207@samsung.com>
Date: Tue, 26 Jan 2016 15:55:27 +0900
MIME-version: 1.0
In-reply-to: <alpine.DEB.2.02.1601260723290.2004@localhost6.localdomain6>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.01.2016 15:24, Julia Lawall wrote:
> 
> 
> On Tue, 26 Jan 2016, Krzysztof Kozlowski wrote:
> 
>> On 26.01.2016 00:21, Amitoj Kaur Chawla wrote:
>>> for_each_available_child_of_node and for_each_child_of_node perform an
>>> of_node_get on each iteration, so to break out of the loop an of_node_put is
>>> required.
>>>
>>> Found using Coccinelle. The simplified version of the semantic patch
>>> that is used for this is as follows:
>>>
>>> // <smpl>
>>> @@
>>> local idexpression n;
>>> expression e,r;
>>> @@
>>>
>>>  for_each_available_child_of_node(r,n) {
>>>    ...
>>> (
>>>    of_node_put(n);
>>> |
>>>    e = n
>>> |
>>> +  of_node_put(n);
>>> ?  break;
>>> )
>>>    ...
>>>  }
>>> ... when != n
>>> // </smpl>
>>
>> Patch iselft looks correct but why are you pasting coccinelle script
>> into the message?
>>
>> The script is already present in Linux kernel:
>> scripts/coccinelle/iterators/device_node_continue.cocci
> 
> I don't think so.  The continue one takes care of the case where there is 
> an extraneous of_node_put before a continue, not a missing one before a 
> break.  But OK to drop it if it doesn't seem useful.
> 
> julia

You are right - this is not covered by that cocci patch... but I think
is covered by scripts/coccinelle/iterators/fen.cocci, isn't it?

BR,
Krzysztof

> 
>> This just extends the commit message without any meaningful data so with
>> removal of coccinelle script above:
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>
>> Best regards,
>> Krzysztof
>>
>>>
>>> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
>>> ---
>>>  drivers/media/platform/exynos4-is/media-dev.c | 12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)

