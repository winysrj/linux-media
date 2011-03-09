Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:43908 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1CIH4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2011 02:56:22 -0500
Message-ID: <4D773286.9070408@maxwell.research.nokia.com>
Date: Wed, 09 Mar 2011 09:55:50 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
	Hiroshi.DOYU@nokia.com,
	Michael Jones <michael.jones@matrix-vision.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
References: <4D6D219D.7020605@matrix-vision.de>	<201103072219.32938.laurent.pinchart@ideasonboard.com>	<AANLkTi=9CYUbkxaSit76OwFR=4PpH+0nDzg5vQLaV51s@mail.gmail.com>	<201103082131.06761.laurent.pinchart@ideasonboard.com> <AANLkTi=5TRJo74c4zJtbRH=ybp2rrMkBvP6oZzvW1G=3@mail.gmail.com>
In-Reply-To: <AANLkTi=5TRJo74c4zJtbRH=ybp2rrMkBvP6oZzvW1G=3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

David Cohen wrote:
> On Tue, Mar 8, 2011 at 10:31 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi David,
>>
>> On Monday 07 March 2011 22:35:31 David Cohen wrote:
>>> On Mon, Mar 7, 2011 at 11:19 PM, Laurent Pinchart wrote:
>>>> On Monday 07 March 2011 20:41:21 David Cohen wrote:
>>>>> On Mon, Mar 7, 2011 at 9:25 PM, Guzman Lugo, Fernando wrote:
>>>>>> On Mon, Mar 7, 2011 at 1:19 PM, David Cohen wrote:
>>>>>>> On Mon, Mar 7, 2011 at 9:17 PM, Guzman Lugo, Fernando wrote:
>>>>>>>> On Mon, Mar 7, 2011 at 7:10 AM, Michael Jones wrote:
>>>>>>>>> From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00
>>>>>>>>> 2001 From: Michael Jones <michael.jones@matrix-vision.de>
>>>>>>>>> Date: Mon, 7 Mar 2011 13:36:15 +0100
>>>>>>>>> Subject: [PATCH] omap: iommu: disallow mapping NULL address
>>>>>>>>>
>>>>>>>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>>>>>>>>> the NULL address if da_start==0.  Force da_start to exclude the
>>>>>>>>> first page.
>>>>>>>>
>>>>>>>> what about devices that uses page 0? ipu after reset always starts
>>>>>>>> from 0x00000000 how could we map that address??
>>>>>>>
>>>>>>> from 0x0? The driver sees da == 0 as error. May I ask you why do you
>>>>>>> want it?
>>>>>>
>>>>>> unlike DSP that you can load a register with the addres the DSP will
>>>>>> boot, IPU core always starts from address 0x00000000, so if you take
>>>>>> IPU out of reset it will try to access address 0x0 if not map it,
>>>>>> there will be a mmu fault.
>>>>>
>>>>> Hm. Looks like the iommu should not restrict any da. The valid da
>>>>> range should rely only on pdata.
>>>>> Michael, what about just update ISP's da_start on omap-iommu.c file?
>>>>> Set it to 0x1000.
>>>>
>>>> What about patching the OMAP3 ISP driver to use a non-zero value (maybe
>>>> -1) as an invalid/freed pointer ?
>>>
>>> I wouldn't be comfortable to use 0 (or NULL) value as valid address on
>>> ISP driver.
>>
>> Why not ? The IOMMUs can use 0x00000000 as a valid address. Whether we allow
>> it or not is a software architecture decision, not influenced by the IOMMU
>> hardware. As some peripherals (namely IPU) require mapping memory to
>> 0x00000000, the IOMMU layer must support it and not treat 0x00000000
>> specially. All da == 0 checks to aim at catching invalid address values must
>> be removed, both from the IOMMU API and the IOMMU internals.
> 
> Yes, it can use and IOMMU should not treat is specially. That's the
> aim of my patch:
> [PATCH v2 3/3] omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED flag
> I'm not advocating to not allow 0x0, but to not use it when user is
> not requesting fixed da. In many sw architecture decisions 0x0 address
> is a special case. To avoid any misuse, IOMMU will not use it unless
> it's requested. If user is not requesting fixed 'da', it's not a
> problem to not give 0x0 anyway. IMO that's the safer option for all
> cases.

I agree.

>>> The 'da' range (da_start and da_end) is defined per VM and specified as
>>> platform data. IMO, to set da_start = 0x1000 seems to be> a correct approach
>>> for ISP as it's the only client for its IOMMU instance.
>>
>> We can do that, and then use 0 as an invalid pointer in the ISP driver. As the
>> IOMMU API will use another value (what about 0xffffffff, as for the userspace
>> mmap() call ?) to mean "invalid pointer", it might be better to use the same
>> value in the ISP driver.
> 
> That can be done, of course. But the main point is in OMAP3 ISP all
> initial register values to read/write from/to memory are 0x0. It means
> sometimes we can catch bugs more easily by not mapping that address.
> So, IMO, OMAP3 ISP should not allow to map first page. But that's a
> special case for this driver only.

I beg to disagree. The ISP isn't so special. The hardware registers
(including DMA destination registers) typically are NULL after reset and
NULL is used by drivers to mark a nonexistent object, for example a
video buffer.

There's a reason why the first page isn't mapped in the system MMU either.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
