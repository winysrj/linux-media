Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20986 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaCRLI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 07:08:27 -0400
Message-id: <53282904.6080004@samsung.com>
Date: Tue, 18 Mar 2014 12:07:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, mark.rutland@arm.com,
	linux-samsung-soc@vger.kernel.org, a.hajda@samsung.com,
	kyungmin.park@samsung.com, robh+dt@kernel.org,
	galak@codeaurora.org, kgene.kim@samsung.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v6 05/10] V4L: s5c73m3: Add device tree support
References: <1394122819-9582-1-git-send-email-s.nawrocki@samsung.com>
 <1394122819-9582-6-git-send-email-s.nawrocki@samsung.com>
 <201403181105.47922.arnd@arndb.de>
In-reply-to: <201403181105.47922.arnd@arndb.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/03/14 11:05, Arnd Bergmann wrote:
> On Thursday 06 March 2014, Sylwester Nawrocki wrote:
>> This patch adds the V4L2 asynchronous subdev registration and
>> device tree support. Common clock API is used to control the
>> sensor master clock from within the subdev.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This driver is in linux-next now, but
> 
>> +	node_ep = v4l2_of_get_next_endpoint(node, NULL);
>> +	if (!node_ep) {
>> +		dev_warn(dev, "no endpoint defined for node: %s\n",
>> +						node->full_name);
>> +		return 0;
>>  	}
> 
> This function is not defined here, leading to build errors.

*sigh* it seems this [1] patch series ended up somehow in -next,
but it shouldn't. Mauro, could you please remove the 'exynos'
branch from media-next tree ? This should fix the problem.
Even though I have been trying to merge this patch to mainline
for ages, I'm ready to resign from it for now, not to add to
the mess we are already seeing [2].


[1] https://lkml.org/lkml/2014/3/6/352
[2] https://lkml.org/lkml/2014/3/17/547

Thanks,
Sylwester
