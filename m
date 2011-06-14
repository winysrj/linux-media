Return-path: <mchehab@pedra>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49630 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1FNVBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 17:01:30 -0400
Message-ID: <4DF7CC22.6050602@codeaurora.org>
Date: Tue, 14 Jun 2011 15:01:22 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Zach Pfeffer <zach.pfeffer@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Daniel Walker <dwalker@codeaurora.org>,
	Daniel Stone <daniels@collabora.com>, linux-mm@kvack.org,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
	Michal Nazarewicz <mina86@mina86.com>,
	linaro-mm-sig@lists.linaro.org,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory	Allocator
 added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>	<20110614170158.GU2419@fooishbar.org>	<BANLkTi=cJisuP8=_YSg4h-nsjGj3zsM7sg@mail.gmail.com> <201106142242.25157.arnd@arndb.de>
In-Reply-To: <201106142242.25157.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/14/2011 02:42 PM, Arnd Bergmann wrote:
> On Tuesday 14 June 2011 20:58:25 Zach Pfeffer wrote:
>> I've seen this split bank allocation in Qualcomm and TI SoCs, with
>> Samsung, that makes 3 major SoC vendors (I would be surprised if
>> Nvidia didn't also need to do this) - so I think some configurable
>> method to control allocations is necessarily. The chips can't do
>> decode without it (and by can't do I mean 1080P and higher decode is
>> not functionally useful). Far from special, this would appear to be
>> the default.
>
> Thanks for the insight, that's a much better argument than 'something
> may need it'. Are those all chips without an IOMMU or do we also
> need to solve the IOMMU case with split bank allocation?

Yes. The IOMMU case with split bank allocation is key, especially for shared
buffers. Consider the case where video is using a certain bank for performance
purposes and that frame is shared with the GPU.

Jordan
