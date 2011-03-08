Return-path: <mchehab@pedra>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57558 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab1CHSxb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 13:53:31 -0500
MIME-Version: 1.0
In-Reply-To: <20110308.200901.212929907269368357.Hiroshi.DOYU@nokia.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-4-git-send-email-dacohen@gmail.com>
	<AANLkTikvUah8LPXCeV4Opi09DJ4ZoHAc2xUVTcDhNK=Q@mail.gmail.com>
	<20110308.200901.212929907269368357.Hiroshi.DOYU@nokia.com>
Date: Tue, 8 Mar 2011 12:53:30 -0600
Message-ID: <AANLkTi=E+9sjGEpCmHPFLFRGTQujDv8747Jf8=ukU1hC@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set
 IOVMF_DA_FIXED/IOVMF_DA_ANON flags
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: dacohen@gmail.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 12:09 PM, Hiroshi DOYU <Hiroshi.DOYU@nokia.com> wrote:
> From: "ext Guzman Lugo, Fernando" <fernando.lugo@ti.com>
> Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED/IOVMF_DA_ANON flags
> Date: Tue, 8 Mar 2011 11:59:43 -0600
>
>> On Tue, Mar 8, 2011 at 6:46 AM, David Cohen <dacohen@gmail.com> wrote:
>>> Currently IOVMM driver sets IOVMF_DA_FIXED/IOVMF_DA_ANON flags according
>>> to input 'da' address when mapping memory:
>>> da == 0: IOVMF_DA_ANON
>>> da != 0: IOVMF_DA_FIXED
>>>
>>> It prevents IOMMU to map first page with fixed 'da'. To avoid such
>>> issue, IOVMM will not automatically set IOVMF_DA_FIXED. It should now
>>> come from the user. IOVMF_DA_ANON will be automatically set if
>>> IOVMF_DA_FIXED isn't set.
>>>
>>> Signed-off-by: David Cohen <dacohen@gmail.com>
>>> ---
>>>  arch/arm/plat-omap/iovmm.c |   12 ++++++++----
>>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>>> index 11c9b76..dde9cb0 100644
>>> --- a/arch/arm/plat-omap/iovmm.c
>>> +++ b/arch/arm/plat-omap/iovmm.c
>>> @@ -654,7 +654,8 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
>>>        flags &= IOVMF_HW_MASK;
>>>        flags |= IOVMF_DISCONT;
>>>        flags |= IOVMF_MMIO;
>>> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>>> +       if (~flags & IOVMF_DA_FIXED)
>>> +               flags |= IOVMF_DA_ANON;
>>
>> could we use only one? both are mutual exclusive, what happen if flag
>> is IOVMF_DA_FIXED | IOVMF_DA_ANON? so, I suggest to get rid of
>> IOVMF_DA_ANON.
>
> Then, what about introducing some MACRO? Better names?
>
> #define set_iovmf_da_anon(flags)
> #define set_iovmf_da_fix(flags)
> #define set_iovmf_mmio(flags)

will they be used by the users?

I think people are more used to use

iommu_vmap(obj, da, sgt, IOVMF_MMIO | IOVMF_DA_ANON);

than

set_iovmf_da_anon(flags)
set_iovmf_mmio(flags)
iommu_vmap(obj, da, sgt, flags);

I don't have problem with the change, but I think how it is now is ok,
just that we don't we two bits to handle anon/fixed da, it can be
managed it only 1 bit (one flag), or is there a issue?

Regards,
Fernando.
> ......
>
