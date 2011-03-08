Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:19919 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1CHSLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 13:11:25 -0500
Date: Tue, 08 Mar 2011 20:09:01 +0200 (EET)
Message-Id: <20110308.200901.212929907269368357.Hiroshi.DOYU@nokia.com>
To: fernando.lugo@ti.com
Cc: dacohen@gmail.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set
 IOVMF_DA_FIXED/IOVMF_DA_ANON flags
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <AANLkTikvUah8LPXCeV4Opi09DJ4ZoHAc2xUVTcDhNK=Q@mail.gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-4-git-send-email-dacohen@gmail.com>
	<AANLkTikvUah8LPXCeV4Opi09DJ4ZoHAc2xUVTcDhNK=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: "ext Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED/IOVMF_DA_ANON flags
Date: Tue, 8 Mar 2011 11:59:43 -0600

> On Tue, Mar 8, 2011 at 6:46 AM, David Cohen <dacohen@gmail.com> wrote:
>> Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
>> to input 'da' address when mapping memory:
>> da == 0: IOVMF_DA_ANON
>> da != 0: IOVMF_DA_FIXED
>>
>> It prevents IOMMU to map first page with fixed 'da'. To avoid such
>> issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
>> come from the user. IOVMF_DA_ANON will be automatically set if
>> IOVMF_DA_FIXED isn't set.
>>
>> Signed-off-by: David Cohen <dacohen@gmail.com>
>> ---
>>  arch/arm/plat-omap/iovmm.c |   12 ++++++++----
>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>> index 11c9b76..dde9cb0 100644
>> --- a/arch/arm/plat-omap/iovmm.c
>> +++ b/arch/arm/plat-omap/iovmm.c
>> @@ -654,7 +654,8 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
>>        flags &= IOVMF_HW_MASK;
>>        flags |= IOVMF_DISCONT;
>>        flags |= IOVMF_MMIO;
>> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>> +       if (~flags & IOVMF_DA_FIXED)
>> +               flags |= IOVMF_DA_ANON;
> 
> could we use only one? both are mutual exclusive, what happen if flag
> is IOVMF_DA_FIXED | IOVMF_DA_ANON? so, I suggest to get rid of
> IOVMF_DA_ANON.

Then, what about introducing some MACRO? Better names?

#define set_iovmf_da_anon(flags)
#define set_iovmf_da_fix(flags)
#define set_iovmf_mmio(flags)
......
