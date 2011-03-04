Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:55857 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab1CDOjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 09:39:04 -0500
Message-ID: <4D70F985.8030902@matrix-vision.de>
Date: Fri, 04 Mar 2011 15:39:01 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	fernando.lugo@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org, Hiroshi.DOYU@nokia.com
Subject: Re: omap3isp cache error when unloading
References: <4D6D219D.7020605@matrix-vision.de>	<201103022018.23446.laurent.pinchart@ideasonboard.com>	<4D6FBC7F.1080500@matrix-vision.de> <AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>
In-Reply-To: <AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

On 03/04/2011 02:12 PM, David Cohen wrote:
> Hi,
> 
> [snip]
> 
>> Sorry, I should've mentioned: I'm using your media-0005-omap3isp branch
>> based on 2.6.38-rc5.  I didn't have the problem with 2.6.37, either.
>> It's actually not related to mis-configuring the ISP pipeline like I
>> thought at first- it also happens after I have successfully captured images.
>>
>> I've since tracked down the problem, although I don't understand the
>> cache management well enough to be sure it's a proper fix, so hopefully
>> some new recipients on this can make suggestions/comments.
>>
>> The patch below solves the problem, which modifies a commit by Fernando
>> Guzman Lugo from December.
>>
>> -Michael
>>
>> From db35fb8edca2a4f8fd37197d77fd58676cb1dcac Mon Sep 17 00:00:00 2001
>> From: Michael Jones <michael.jones@matrix-vision.de>
>> Date: Thu, 3 Mar 2011 16:50:39 +0100
>> Subject: [PATCH] fix iovmm slab cache error on module unload
>>
>> modify "OMAP: iommu: create new api to set valid da range"
>>
>> This modifies commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb.
>> ---
>>  arch/arm/plat-omap/iovmm.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
>> index 6dc1296..2fba6f1 100644
>> --- a/arch/arm/plat-omap/iovmm.c
>> +++ b/arch/arm/plat-omap/iovmm.c
>> @@ -280,7 +280,10 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>>        alignement = PAGE_SIZE;
>>
>>        if (flags & IOVMF_DA_ANON) {
>> -               start = obj->da_start;
>> +               /*
>> +                * Reserve the first page for NULL
>> +                */
>> +               start = obj->da_start + PAGE_SIZE;
> 
> IMO if obj->da_start != 0, no need to add PAGE_SIZE. Otherwise, it
> does make sense to correct wrong obj->da_start == 0. Another thing is
> this piece of code is using alignement (alignment) variable instead of
> PAGE_SIZE (which is the same value).
> 
> Br,
> 
> David

I believe the following patch addresses your comments.  I couldn't
resist also fixing the misspelling of alignment when I was using the
variable in my patch.

-Michael

>From 2712f2fd087ca782e964c912c7f1973e7d84f2b7 Mon Sep 17 00:00:00 2001
From: Michael Jones <michael.jones@matrix-vision.de>
Date: Fri, 4 Mar 2011 15:09:48 +0100
Subject: [PATCH] omap: iovmm: disallow mapping NULL address

commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
the NULL address if da_start==0, which would then not get unmapped. 
Disallow this again.  And spell variable 'alignment' correctly.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 arch/arm/plat-omap/iovmm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 6dc1296..11c9b76 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -271,20 +271,24 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 					   size_t bytes, u32 flags)
 {
 	struct iovm_struct *new, *tmp;
-	u32 start, prev_end, alignement;
+	u32 start, prev_end, alignment;
 
 	if (!obj || !bytes)
 		return ERR_PTR(-EINVAL);
 
 	start = da;
-	alignement = PAGE_SIZE;
+	alignment = PAGE_SIZE;
 
 	if (flags & IOVMF_DA_ANON) {
-		start = obj->da_start;
+		/* Don't map address 0 */
+		if (obj->da_start)
+			start = obj->da_start;
+		else
+			start = obj->da_start + alignment;
 
 		if (flags & IOVMF_LINEAR)
-			alignement = iopgsz_max(bytes);
-		start = roundup(start, alignement);
+			alignment = iopgsz_max(bytes);
+		start = roundup(start, alignment);
 	} else if (start < obj->da_start || start > obj->da_end ||
 					obj->da_end - start < bytes) {
 		return ERR_PTR(-EINVAL);
@@ -304,7 +308,7 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
 			goto found;
 
 		if (tmp->da_end >= start && flags & IOVMF_DA_ANON)
-			start = roundup(tmp->da_end + 1, alignement);
+			start = roundup(tmp->da_end + 1, alignment);
 
 		prev_end = tmp->da_end;
 	}
-- 
1.7.4.1



MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
