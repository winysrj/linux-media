Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:58132 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3HWWpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 18:45:46 -0400
Message-ID: <5217E615.9040101@wwwdotorg.org>
Date: Fri, 23 Aug 2013 16:45:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] s5p-jpeg: Add initial device tree support for S5PV210/Exynos4210
 SoCs
References: <1376856867-17771-1-git-send-email-s.nawrocki@samsung.com> <5217875F.2030307@samsung.com>
In-Reply-To: <5217875F.2030307@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2013 10:01 AM, Sylwester Nawrocki wrote:
> On 08/18/2013 10:14 PM, Sylwester Nawrocki wrote:
>> This patch enables the JPEG codec on S5PV210 and Exynos4210 SoCs. There are
>> some differences in newer versions of the JPEG codec IP on SoCs like Exynos4x12
>> and Exynos5 series and support for them will be added in subsequent patches.
>>
>> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> Could a DT maintainer review/Ack the binding in this patch ?

The binding looks reasonable to me, so,
Acked-by: Stephen Warren <swarren@nvidia.com>
