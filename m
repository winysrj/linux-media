Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59638 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcCGJYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 04:24:22 -0500
Subject: Re: [PATCH 0/2] [media] exynos4-is: Trivial fixes for DT port/endpoint
 parse logic
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
 <CAJKOXPfOpqU2fGsNNaB6n_iuq2r-8z3TCSsqkncPbvkK2344Tg@mail.gmail.com>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56DD48C1.8010004@samsung.com>
Date: Mon, 07 Mar 2016 10:24:17 +0100
MIME-version: 1.0
In-reply-to: <CAJKOXPfOpqU2fGsNNaB6n_iuq2r-8z3TCSsqkncPbvkK2344Tg@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier, Krzysztof,

On 03/05/2016 05:35 AM, Krzysztof Kozlowski wrote:
> 2016-03-05 5:20 GMT+09:00 Javier Martinez Canillas <javier@osg.samsung.com>:
>> > Hello,
>> >
>> > This series have two trivial fixes for issues that I noticed while
>> > reading as a reference the driver's functions that parse the graph
>> > port and endpoints nodes.
>> >
>> > It was only compile tested because I don't have access to a Exynos4
>> > hardware to test the DT parsing, but the patches are very simple.
>
> Not directly related, but similar: my previous two patches for missing
> of_node_put [0] are unfortunately still waiting. Although I have
> Exynos4 boards, but I don't have infrastructure/scripts to test it.
> 
> Best regards,
> Krzysztof
> 
> [0] https://patchwork.linuxtv.org/patch/32707/

Thanks for the patches, I've delegated them to myself and I'm going to
review/apply them this week.

--
Regards,
Sylwester
