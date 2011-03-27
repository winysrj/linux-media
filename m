Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:36598 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1C0RCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2011 13:02:20 -0400
Message-ID: <4D8F6E0A.5080404@maxwell.research.nokia.com>
Date: Sun, 27 Mar 2011 20:04:10 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"david.cohen@nokia.com" <david.cohen@nokia.com>,
	"hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 1/4] omap iommu: Check existence of arch_iommu
References: <4D8CB106.7030608@maxwell.research.nokia.com> <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <19F8576C6E063C45BE387C64729E739404E21D57E2@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E21D57E2@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hiremath, Vaibhav wrote:
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Sakari Ailus
>> Sent: Friday, March 25, 2011 8:43 PM
>> To: linux-media@vger.kernel.org
>> Cc: laurent.pinchart@ideasonboard.com; david.cohen@nokia.com;
>> hiroshi.doyu@nokia.com
>> Subject: [PATCH 1/4] omap iommu: Check existence of arch_iommu
>>
>> Check that the arch_iommu has been installed before trying to use it. This
>> will lead to kernel oops if the arch_iommu isn't there.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> ---
>>  arch/arm/plat-omap/iommu.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
>> index b1107c0..f0fea0b 100644
>> --- a/arch/arm/plat-omap/iommu.c
>> +++ b/arch/arm/plat-omap/iommu.c
>> @@ -104,6 +104,9 @@ static int iommu_enable(struct iommu *obj)
>>  	if (!obj)
>>  		return -EINVAL;
>>
>> +	if (!arch_iommu)
>> +		return -ENOENT;
>> +
> [Hiremath, Vaibhav] Similar patch has already been submitted and
accepted in community, not sure which baseline you are using. Please
refer to below commit -
> 

Thanks, Vaibhav. I guess I need to update my tree and resend the set...

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
