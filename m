Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46276 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1CHUHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 15:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTim6rGp54i9cT0FMoRniiF4umKK5+agOSkfKvZAT@mail.gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
	<1299588365-2749-2-git-send-email-dacohen@gmail.com>
	<AANLkTikkUYFuhH-b2vKX8jVoT18wH_+WPzGbfFNWQK6K@mail.gmail.com>
	<AANLkTikH=oYFOuvvG2y4yj=6UUnPCyEtq8AMc9bF9VrH@mail.gmail.com>
	<AANLkTim6rGp54i9cT0FMoRniiF4umKK5+agOSkfKvZAT@mail.gmail.com>
Date: Tue, 8 Mar 2011 22:07:09 +0200
Message-ID: <AANLkTim2R1VPDYUff+1PFpdsxYYNM8G3FrzSsYgShe74@mail.gmail.com>
Subject: Re: [PATCH 1/3] omap: iovmm: disallow mapping NULL address
From: David Cohen <dacohen@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 9:53 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> On Tue, Mar 8, 2011 at 1:06 PM, David Cohen <dacohen@gmail.com> wrote:
>> On Tue, Mar 8, 2011 at 8:06 PM, Guzman Lugo, Fernando
>> <fernando.lugo@ti.com> wrote:
>>> On Tue, Mar 8, 2011 at 6:46 AM, David Cohen <dacohen@gmail.com> wrote:
>>>> From: Michael Jones <michael.jones@matrix-vision.de>
>>>>
>>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>>>> the NULL address if da_start==0, which would then not get unmapped.
>>>> Disallow this again.  And spell variable 'alignment' correctly.
>>>>
>>>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>>>> ---
>>>>  arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
>>>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>>>> index 6dc1296..11c9b76 100644
>>>> --- a/arch/arm/plat-omap/iovmm.c
>>>> +++ b/arch/arm/plat-omap/iovmm.c
>>>> @@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>>>                                           size_t bytes, u32 flags)
>>>>  {
>>>>        struct iovm_struct *new, *tmp;
>>>> -       u32 start, prev_end, alignement;
>>>> +       u32 start, prev_end, alignment;
>>>>
>>>>        if (!obj || !bytes)
>>>>                return ERR_PTR(-EINVAL);
>>>>
>>>>        start = da;
>>>> -       alignement = PAGE_SIZE;
>>>> +       alignment = PAGE_SIZE;
>>>>
>>>>        if (flags & IOVMF_DA_ANON) {
>>>> -               start = obj->da_start;
>>>> +               /* Don't map address 0 */
>>>> +               if (obj->da_start)
>>>> +                       start = obj->da_start;
>>>> +               else
>>>> +                       start = obj->da_start + alignment;
>>>
>>> else part obj->da_star is always 0, so why not?
>>> start = alignment;
>>
>> The patch is not from me, but I can fix it if Michael agrees.
>>
>>>
>>> so, why I understand, it now it is possible mapp address 0x0 only if
>>> IOVMF_DA_ANON is not set, right? maybe that would be mention in the
>>> patch.
>>
>> Indeed address 0x0 was never meant to be mapped. The mentioned commit
>> on the patch's description did that without noticing. But the new
>> change is documented in the code by the comment "Don't map address 0"
>
> yeah, but it only applies when "flags & IOVMF_DA_ANON", So if I use
> IOVMF_DA_FIXED and da_start == 0, I will be able to map some area
> which starts from address 0x0, right?  if so, that looks good to me
> and the description should mention that if is disallowing mapping
> address 0x0 when IOVMF_DA_ANON is used.

Yes, that's the case. I will update the comment. I hope Michael does
not complain about the changes. :)

Br,

David

>
> Regards,
> Fernando.
>
>> and it's also mentioned on the patch description. Is it OK for you?
>>
>> Regards,
>>
>> David Cohen
>>
>>>
>>> Regards,
>>> Fernando.
>>>
>>>>
>>>>                if (flags & IOVMF_LINEAR)
>>>> -                       alignement = iopgsz_max(bytes);
>>>> -               start = roundup(start, alignement);
>>>> +                       alignment = iopgsz_max(bytes);
>>>> +               start = roundup(start, alignment);
>>>>        } else if (start < obj->da_start || start > obj->da_end ||
>>>>                                        obj->da_end - start < bytes) {
>>>>                return ERR_PTR(-EINVAL);
>>>> @@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>>>                        goto found;
>>>>
>>>>                if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
>>>> -                       start = roundup(tmp->da_end + 1, alignement);
>>>> +                       start = roundup(tmp->da_end + 1, alignment);
>>>>
>>>>                prev_end = tmp->da_end;
>>>>        }
>>>> --
>>>> 1.7.0.4
>>>>
>>>>
>>>
>>
>
