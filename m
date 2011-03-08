Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59332 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1CHTvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 14:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik9H1H5AfWX-aAh7+7Ghx0i0ADLT6sq4FtG8c1e@mail.gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-4-git-send-email-dacohen@gmail.com>
	<AANLkTikvUah8LPXCeV4Opi09DJ4ZoHAc2xUVTcDhNK=Q@mail.gmail.com>
	<20110308.200901.212929907269368357.Hiroshi.DOYU@nokia.com>
	<AANLkTi=E+9sjGEpCmHPFLFRGTQujDv8747Jf8=ukU1hC@mail.gmail.com>
	<AANLkTikmWdQZZJHTmJsDTrSX434pKfpqJWZ6RWGB7ec6@mail.gmail.com>
	<AANLkTimcSRB+AS=UEAtfc6D=BYWB7Nedj3LQyCnG4bVf@mail.gmail.com>
	<AANLkTik9H1H5AfWX-aAh7+7Ghx0i0ADLT6sq4FtG8c1e@mail.gmail.com>
Date: Tue, 8 Mar 2011 21:51:23 +0200
Message-ID: <AANLkTik7m6AoxmWT-PcCvuKTCWHTfwXk0O5UquXM15iG@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: iovmm: don't check 'da' to set
 IOVMF_DA_FIXED/IOVMF_DA_ANON flags
From: David Cohen <dacohen@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 9:46 PM, David Cohen <dacohen@gmail.com> wrote:
> [snip]
>
>>>>>>> -       flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
>>>>>>> +       if (~flags & IOVMF_DA_FIXED)
>>>>>>> +               flags |= IOVMF_DA_ANON;
>>>>>>
>>>>>> could we use only one? both are mutual exclusive, what happen if flag
>>>>>> is IOVMF_DA_FIXED | IOVMF_DA_ANON? so, I suggest to get rid of
>>>>>> IOVMF_DA_ANON.
>>>>>
>>>>> Then, what about introducing some MACRO? Better names?
>>>>>
>>>>> #define set_iovmf_da_anon(flags)
>>>>> #define set_iovmf_da_fix(flags)
>>>>> #define set_iovmf_mmio(flags)
>>>>
>>>> will they be used by the users?
>>>>
>>>> I think people are more used to use
>>>>
>>>> iommu_vmap(obj, da, sgt, IOVMF_MMIO | IOVMF_DA_ANON);
>>>
>>> I'd be happier with this approach, instead of the macros. :)
>>> It's intuitive and very common on kernel.
>>>
>>>>
>>>> than
>>>>
>>>> set_iovmf_da_anon(flags)
>>>> set_iovmf_mmio(flags)
>>>> iommu_vmap(obj, da, sgt, flags);
>>>>
>>>> I don't have problem with the change, but I think how it is now is ok,
>>>> just that we don't we two bits to handle anon/fixed da, it can be
>>>> managed it only 1 bit (one flag), or is there a issue?
>>>
>>> We can exclude IOVMF_DA_ANON and stick with IOVMF_DA_FIXED only.
>>> I can resend my patch if we agree it's OK.
>>
>> sounds perfect to me.
>
> Not sure indeed if this change fits to this same patch. Looks like a
> 4th patch sounds better.

Indeed not. :)
A new set is coming soon.

Br,

David

>
> Br,
>
> David Cohen
>
