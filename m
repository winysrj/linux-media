Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:36228 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1CIH4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 02:56:46 -0500
Message-ID: <4D7732BC.4050307@matrix-vision.de>
Date: Wed, 09 Mar 2011 08:56:44 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
	Hiroshi.DOYU@nokia.com, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v2 1/3] omap: iovmm: disallow mapping NULL address when
 IOVMF_DA_ANON is set
References: <1299615316-17512-1-git-send-email-dacohen@gmail.com>	<1299615316-17512-2-git-send-email-dacohen@gmail.com> <AANLkTintZ6vphJqM54SxFeKtk=6CuDQJTUpk-7jFRDeA@mail.gmail.com>
In-Reply-To: <AANLkTintZ6vphJqM54SxFeKtk=6CuDQJTUpk-7jFRDeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/08/2011 09:31 PM, Guzman Lugo, Fernando wrote:
> On Tue, Mar 8, 2011 at 2:15 PM, David Cohen <dacohen@gmail.com> wrote:
>> From: Michael Jones <michael.jones@matrix-vision.de>
>>
>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping the NULL
>> address if da_start==0, which would then not get unmapped. Disallow
>> this again if IOVMF_DA_ANON is set. And spell variable 'alignment'
>> correctly.
>>
>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>> ---
>>  arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>> index 6dc1296..e5f8341 100644
>> --- a/arch/arm/plat-omap/iovmm.c
>> +++ b/arch/arm/plat-omap/iovmm.c
>> @@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>                                           size_t bytes, u32 flags)
>>  {
>>        struct iovm_struct *new, *tmp;
>> -       u32 start, prev_end, alignement;
>> +       u32 start, prev_end, alignment;
>>
>>        if (!obj || !bytes)
>>                return ERR_PTR(-EINVAL);
>>
>>        start = da;
>> -       alignement = PAGE_SIZE;
>> +       alignment = PAGE_SIZE;
>>
>>        if (flags & IOVMF_DA_ANON) {
>> -               start = obj->da_start;
>> +               /* Don't map address 0 */
>> +               if (obj->da_start)
>> +                       start = obj->da_start;
>> +               else
>> +                       start = alignment;
> 
> looks good to me, just a nitpick comment, that would look better
> 
>                   start = (obj->da_start) ? obj->da_start : alignment;
> 
> Regards,
> Fernando.
> 
>>
>>                if (flags & IOVMF_LINEAR)
>> -                       alignement = iopgsz_max(bytes);
>> -               start = roundup(start, alignement);
>> +                       alignment = iopgsz_max(bytes);
>> +               start = roundup(start, alignment);
>>        } else if (start < obj->da_start || start > obj->da_end ||
>>                                        obj->da_end - start < bytes) {
>>                return ERR_PTR(-EINVAL);
>> @@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>                        goto found;
>>
>>                if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
>> -                       start = roundup(tmp->da_end + 1, alignement);
>> +                       start = roundup(tmp->da_end + 1, alignment);
>>
>>                prev_end = tmp->da_end;
>>        }
>> --
>> 1.7.0.4
>>

Hi David,

These changes to my patch are fine with me.  If you want to incorporate
Fernando's recommendation above, too, go ahead.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
