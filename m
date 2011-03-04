Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56927 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662Ab1CDQts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 11:49:48 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinSJpjPXWHWduLbRSmb=La3sv82ufwgsq-uR7S2@mail.gmail.com>
References: <4D6D219D.7020605@matrix-vision.de>
	<201103022018.23446.laurent.pinchart@ideasonboard.com>
	<4D6FBC7F.1080500@matrix-vision.de>
	<AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>
	<4D70F985.8030902@matrix-vision.de>
	<AANLkTinSJpjPXWHWduLbRSmb=La3sv82ufwgsq-uR7S2@mail.gmail.com>
Date: Fri, 4 Mar 2011 18:49:46 +0200
Message-ID: <AANLkTi=8Sss-5xfgPmgx=J_T__=hrC1rQU-xBOdKC8Ve@mail.gmail.com>
Subject: Re: omap3isp cache error when unloading
From: David Cohen <dacohen@gmail.com>
To: Michael Jones <michael.jones@matrix-vision.de>,
	Hiroshi.DOYU@nokia.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	fernando.lugo@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

[snip]

>> From 2712f2fd087ca782e964c912c7f1973e7d84f2b7 Mon Sep 17 00:00:00 2001
>> From: Michael Jones <michael.jones@matrix-vision.de>
>> Date: Fri, 4 Mar 2011 15:09:48 +0100
>> Subject: [PATCH] omap: iovmm: disallow mapping NULL address
>>
>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>> the NULL address if da_start==0, which would then not get unmapped.
>> Disallow this again.  And spell variable 'alignment' correctly.
>>
>> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
>> ---
>>  arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>> index 6dc1296..11c9b76 100644
>> --- a/arch/arm/plat-omap/iovmm.c
>> +++ b/arch/arm/plat-omap/iovmm.c
>> @@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>                                           size_t bytes, u32 flags)
>>  {
>>        struct iovm_struct *new, *tmp;
>> -       u32 start, prev_end, alignement;
>> +       u32 start, prev_end, alignment;
>>
>>        if (!obj || !bytes)
>>                return ERR_PTR(-EINVAL);
>>
>>        start = da;
>> -       alignement = PAGE_SIZE;
>> +       alignment = PAGE_SIZE;
>>
>>        if (flags & IOVMF_DA_ANON) {
>> -               start = obj->da_start;
>> +               /* Don't map address 0 */
>> +               if (obj->da_start)
>> +                       start = obj->da_start;
>> +               else
>> +                       start = obj->da_start + alignment;
>
> It seems to be fine for me now. Let's see what Hiroshi says.

Sorry, I'm afraid I changed my mind after take a look into the driver. :)
Try to correct obj->da_start in the functions iommu_set_da_range() and
omap_iommu_probe(). That should be the correct way. Your patch doesn't
fix this situation when IOVMF_DA_ANON isn't set.
After obj->da_start is correctly set, your current patch is non longer required.

Regards,

David

>
> Regards,
>
> David
>
>>
>>                if (flags & IOVMF_LINEAR)
>> -                       alignement = iopgsz_max(bytes);
>> -               start = roundup(start, alignement);
>> +                       alignment = iopgsz_max(bytes);
>> +               start = roundup(start, alignment);
>>        } else if (start < obj->da_start || start > obj->da_end ||
>>                                        obj->da_end - start < bytes) {
>>                return ERR_PTR(-EINVAL);
>> @@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>                        goto found;
>>
>>                if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
>> -                       start = roundup(tmp->da_end + 1, alignement);
>> +                       start = roundup(tmp->da_end + 1, alignment);
>>
>>                prev_end = tmp->da_end;
>>        }
>> --
>> 1.7.4.1
>>
>>
>>
>> MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
>> Registergericht: Amtsgericht Stuttgart, HRB 271090
>> Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
>>
>
