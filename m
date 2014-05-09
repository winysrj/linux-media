Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39547 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaEIEnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 00:43:52 -0400
Message-ID: <536C5D03.3070506@gmail.com>
Date: Fri, 09 May 2014 10:13:47 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
CC: 'LMML' <linux-media@vger.kernel.org>,
	'linux-samsung-soc' <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	pullip.cho@samsung.com
Subject: Re: [PATCH] [media] s5p-mfc: Add IOMMU support
References: <1398164568-6048-1-git-send-email-arun.kk@samsung.com> <2748799.75z4m0MVI7@avalon> <CALt3h79VnDH17s51FQQUK7O_to7pA1-KU0HW8JY2WAqOP4rBRA@mail.gmail.com> <004d01cf6ad9$fec16b50$fc4441f0$%debski@samsung.com>
In-Reply-To: <004d01cf6ad9$fec16b50$fc4441f0$%debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 05/08/14 21:54, Kamil Debski wrote:
> Hi Arun,
> 
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com]
>> Sent: Tuesday, April 22, 2014 2:22 PM
>>
>> Hi Laurent,
>>
>> Thank you for the review.
>>
>> On Tue, Apr 22, 2014 at 5:23 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Arun,
>>>
>>> Thank you for the patch.
>>>
>>> On Tuesday 22 April 2014 16:32:48 Arun Kumar K wrote:
>>>> The patch adds IOMMU support for MFC driver.
>>>
>>> I've been working on an IOMMU driver lately, which led me to think
>>> about how drivers should be interfaced with IOMMUs. Runtime IOMMU
>>> handling is performed by the DMA mapping API, but in many cases
>>> (including Exynos platforms) the
>>> arm_iommu_create_mapping() and arm_iommu_attach_device() functions
>>> still need to be called explicitly by drivers, which doesn't seem a
>> very good idea to me.
>>> Ideally IOMMU usage should be completely transparent for bus master
>>> drivers, without requiring any driver modification to use the IOMMU.
>>>
>>> What would you think about improving the Exynos IOMMU driver to
>> create
>>> the mapping and attach the device instead of having to modify all bus
>>> master drivers ? See the ipmmu_add_device() function in
>>> http://www.spinics.net/lists/linux-sh/msg30488.html for a possible
>>> implementation.
>>>
>>
>> Yes that would be a better solution. But as far as I know, exynos
>> platforms has few more complications where multiple IOMMUs are present
>> for single IP.
>> The exynos iommu work is still under progress and KyonHo Cho will have
>> some inputs / comments on this. This seems to me a valid usecase which
>> can be considered for exynos iommu also.
> 
> Arun, could you tell me how did you test this?

It is tested on the IOMMU patches sent by KyongHo Cho (v11 series)
 https://lkml.org/lkml/2014/3/14/9
I found it to work well with v12 too.

> I think that the MFC driver should not be modified to use iommu. Dma_mapping
> should be used. On Tizenorg there is a 3.10 kernel with an iommu driver that
> works with MFC without any patches to the MFC drvier.

This is as per the mainline IOMMU driver patches which are being
reviewed now. I could see the exynos DRM also using this kind of
approach and is already in mainline. Thats why I thought of sending this.

> 
> I disagree to merging this patch, sorry. This should be done the correct way.
> 

Ok. I agree we can wait till the merging of Samsung IOMMU. If it takes
care of making the mapping and attaching the device without the master
driver intervention, then we can skip this patch. But till now it is not
taken care in the patches which are under review for samsung IOMMU.

Regards
Arun

> NACK.
> 
> Best wishes,
> 
