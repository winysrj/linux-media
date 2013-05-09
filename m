Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63156 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3EIPwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 May 2013 11:52:02 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MMJ005O6G2MNR10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 May 2013 16:52:00 +0100 (BST)
Message-id: <518BC61E.3040202@samsung.com>
Date: Thu, 09 May 2013 17:51:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	George Joseph <george.jp@samsung.com>,
	"aditya.ps" <aditya.ps@samsung.com>,
	sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] s5p-jpeg: Enable instantiation from device tree
References: <1368103198-16485-1-git-send-email-s.nawrocki@samsung.com>
 <CAK9yfHx-o-3oYj8hMKzQK7N3CD7=tUwbxcHG-9gA25yfRjky2Q@mail.gmail.com>
In-reply-to: <CAK9yfHx-o-3oYj8hMKzQK7N3CD7=tUwbxcHG-9gA25yfRjky2Q@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 05/09/2013 04:50 PM, Sachin Kamat wrote:
> George from my team is working on adding JPEG IP support for 4412 and
> 5250 SoCs which is quite different from 4210.
> In this regard he has refactored the driver to accomodate the changes
> required for the new IP and also added DT support.
> The patches are almost ready and would be submitted in the next couple
> of days. This is FYI :)

That's greats news, since on our side currently nobody has been working
on the Exynos4x12+ JPEG codec support. I just prepared a patch adding
DT matching table and checked the driver gets initialized on Exynos4x12.
So it is at least usable on Exynos4210 in 3.11. I should not have listed
"samsung,exynos4212-jpeg" in the driver, since it is missing adaptations
for Exynos4x12 SoCs.

We have plenty time to add proper support for the JPEG IP in 3.11. I'm
looking forward to review and test your patches. Can you use the $subject
patch as a base of your work ? ;-) Or is it rather useless ?

FYI, I will be mostly offline for next 2 weeks.

Thanks,
Sylwester
