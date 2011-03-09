Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab1CIITp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 03:19:45 -0500
MIME-Version: 1.0
In-Reply-To: <4D772FB0.4020804@maxwell.research.nokia.com>
References: <1299615316-17512-1-git-send-email-dacohen@gmail.com>
	<1299615316-17512-3-git-send-email-dacohen@gmail.com>
	<4D772FB0.4020804@maxwell.research.nokia.com>
Date: Wed, 9 Mar 2011 10:19:43 +0200
Message-ID: <AANLkTi=ARF3zyFWOXwoyobUeKsN8HzTtd5TkxNSV+srO@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] omap3: change ISP's IOMMU da_start address
From: David Cohen <dacohen@gmail.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	fernando.lugo@ti.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 9, 2011 at 9:43 AM, Sakari Ailus
<sakari.ailus@maxwell.research.nokia.com> wrote:
> David Cohen wrote:
>> ISP doesn't consider 0x0 as a valid address, so it should explicitly
>> exclude first page from allowed 'da' range.
>>
>> Signed-off-by: David Cohen <dacohen@gmail.com>
>> ---
>>  arch/arm/mach-omap2/omap-iommu.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
>> index 3fc5dc7..3bea489 100644
>> --- a/arch/arm/mach-omap2/omap-iommu.c
>> +++ b/arch/arm/mach-omap2/omap-iommu.c
>> @@ -33,7 +33,7 @@ static struct iommu_device omap3_devices[] = {
>>                       .name = "isp",
>>                       .nr_tlb_entries = 8,
>>                       .clk_name = "cam_ick",
>> -                     .da_start = 0x0,
>> +                     .da_start = 0x1000,
>>                       .da_end = 0xFFFFF000,
>>               },
>>       },
>
> Hi David!

Hi Sakari,

>
> Thanks for the patch.

And thanks for the comments. :)

>
> My question is once again: is this necessary? My understanding is that
> the IOMMU allows mapping the NULL address if the user wishes to map it
> explicitly. da_end specifies the real hardware limit for the mapped top
> address, da_start should do the same for bottom.

Hm. da_start/da_end in this case belong to OMAP3 IOMMU ISP VM. It
means they're related to OMAP3 ISP only. But they do not reflect the
hw limit, as the range limit is anything which fits in u32. They say
what's the range OMAP3 ISP is expecting to have mapped. And the answer
to this question is the first page is not expected. Then, why say the
opposite in da_start?

>
> I think that the IOMMU users should be either able to rely that they get
> no NULL allocated automatically for them. Do we want or not want it to
> be part of the API? I don't think the ISP driver is a special case of
> all the possible drivers using the IOMMU.

My understanding after this discussion is address 0x0 should be
allowed (what is done by patch 3/3 of this set). But as a safer
choice, it won't be returned without explicitly request (what is done
in path 1/3). Because of that, I'm OK in drop this patch 2/3. But then
there's one question which is the motivation for this change:
If the current OMAP3 ISP driver doesn't want the first page, (1)
should we pass a generic information and expect IOVMM driver to
correct it to ISP need or (2) should we pass the information which
reflects the real ISP driver's need?
My understanding is (2). But I'm fine with (1) as it will lead to the
same result.

>
> On the other hand, probably there will be an API change at some point
> for the IOMMU since as far as I remember, there are somewhat
> established APIs for IOMMUs in existence.

At some point we need to find a standard for many IOMMU drivers. But
for now we need to stick with what we have. :)

Regards,

David Cohen
