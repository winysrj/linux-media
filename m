Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:51275 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2ASOgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 09:36:47 -0500
Message-ID: <4F182A79.6000603@mlbassoc.com>
Date: Thu, 19 Jan 2012 07:36:41 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <201201191350.51761.laurent.pinchart@ideasonboard.com> <4F181711.1020201@mlbassoc.com> <201201191428.35340.laurent.pinchart@ideasonboard.com> <4F181C24.9030806@mlbassoc.com> <CAAwP0s3_U1tzRM3TcW+hGCVvm+aowwO9f6g6t8_pvZSJxyMrgA@mail.gmail.com>
In-Reply-To: <CAAwP0s3_U1tzRM3TcW+hGCVvm+aowwO9f6g6t8_pvZSJxyMrgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-01-19 07:11, Javier Martinez Canillas wrote:
> On Thu, Jan 19, 2012 at 2:35 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2012-01-19 06:28, Laurent Pinchart wrote:
>>>
>>> Hi Gary,
>>>
>>> On Thursday 19 January 2012 14:13:53 Gary Thomas wrote:
>>>>
>>>> On 2012-01-19 05:50, Laurent Pinchart wrote:
>>>>>
>>>>> On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
>>>>>>
>>>>>> On 2012-01-17 08:33, Laurent Pinchart wrote:
>>>>>>       <snip>
>>>>>>>
>>>>>>>
>>>>>>> I already had a couple of YUV support patches in my OMAP3 ISP tree at
>>>>>>> git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree
>>>>>>> and pushed them to
>>>>>>>
>>>>>>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp
>>>>>>> - omap3isp-yuv. Could you please try them, and see if they're usable
>>>>>>> with your sensor ?
>>>>>>
>>>>>>
>>>>>> I just tried this kernel with my board.  The media control
>>>>>> infrastructure comes up and all of the devices are created, but I can't
>>>>>> access them.
>>>>>>
>>>>>>    From the bootup log:
>>>>>>      Linux media interface: v0.10
>>>>>>      Linux video capture interface: v2.00
>>>>>
>>>>>
>>>>> Any message from the omap3isp driver and from the sensor driver ?
>>>>
>>>>
>>>> No, it doesn't appear that the sensor was probed (or maybe it failed but
>>>> no messages).  I'll check into this.
>>>
>>>
>>> Is the omap3-isp driver compiled as a module ? If so, make sure iommu2.ko
>>> is
>>> loaded first. 'rmmod omap3-isp&&    modprobe iommu2&&    modprobe omap3-isp'
>>> is a
>>>
>>> quick way to test it.
>>
>>
>> I have everything compiled in - no modules.
>>
>
> At least for me, it only worked when compiled both the omap3-isp and
> tvp5150 drivers as a module. If I compile them built-in, it fails.

Can you share your board/sensor init code from your board-init.c
so I can see how to manage this as a module?

n.b. I really don't like messing with modules - it used to work
fine, so IMO it should continue to do so.

Thanks


-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
