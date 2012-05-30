Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm30.bullet.mail.ac4.yahoo.com ([98.139.52.227]:32708 "HELO
	nm30.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757246Ab2E3WDG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 18:03:06 -0400
References: <B9D34818-CE30-4125-997B-71C50CFC4F0D@yahoo.com> <CAGGh5h13ks+yN44OJvFogjj9jWr9HeN7_OzE2Aob9T2n3e9nMA@mail.gmail.com> <CA+2YH7s9F+4WQuQ9zioCetpJ5f8_3pihf5wcNVp5SjLuiq3k3g@mail.gmail.com> <12509952.dDkgsjd7gb@avalon>
Mime-Version: 1.0 (iPod Mail 8L1)
In-Reply-To: <12509952.dDkgsjd7gb@avalon>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <C64BB294-2228-4EB5-B839-27480B232B8D@yahoo.com>
Cc: Enrico <ebutera@users.berlios.de>,
	jean-philippe francois <jp.francois@cynove.com>,
	Alex Gershgorin <alexg@meprolight.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Ritesh <yuva_dashing@yahoo.com>
Subject: Re: OMAP 3 ISP
Date: Thu, 31 May 2012 03:26:57 +0530
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
For me even ISP revision print log is not displaying and moreover when I am checking the interrupts using 
cat /proc/interrupts
Only iommu interrupt is showing for interrupt line 24

Seems ISP probe function is not at all getting called
Right now board is not available for me so that I can't post here complete log

Can u please send me working Linux kernel repository link for omap35x torpedo kit


Thanks
Ritesh

Sent from my iPod

On 29-May-2012, at 3:52 PM, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Enrico,
> 
> On Tuesday 29 May 2012 12:08:43 Enrico wrote:
>> On Tue, May 29, 2012 at 10:15 AM, jean-philippe francois wrote:
>>> 2012/5/29 Alex Gershgorin <alexg@meprolight.com>:
>>>> Hi Ritesh,
>>>> 
>>>> Please send in the future CC to laurent.pinchart@ideasonboard.com and
>>>> linux-media@vger.kernel.org>> 
>>>>> Hi Alex,
>>>>> I also started working with OMAP35x torpedo kit, I successful compile
>>>>> Linux 3.0 and ported on the board. Device is booting correctly but
>>>>> probe function in omap3isp module not getting called. Please help me
>>>> 
>>>> You have relevant Kernel boot messages?
>>>> You can also find information in media archives OMAP 3 ISP thread.
>>>> 
>>>> Regards,
>>>> Alex
>>> 
>>> Hi, I had a similar problem with a 2.6.39 kernel, that was solved with
>>> a 3.2 kernel.
>>> When compiled as a module, the probe function was called, but was failing
>>> later.
>>> 
>>> The single message I would see was "ISP revision x.y found" [1]
>>> 
>>> When compiled in the kernel image, everything was fine.
>>> 
>>> 
>>> [1]
>>> http://lxr.linux.no/linux+v2.6.39.4/drivers/media/video/omap3isp/isp.c#L2
>>> 103
>> I think with kernel version 3.0 i had the same problem, i had to
>> modprobe iommu2 before omap3isp, removing (if already loaded) iommu.
>> Probably later on it was fixed and you don't need that anymore.
> 
> That's right. The OMAP3 ISP driver indirectly depended on the iommu2 module, 
> which wasn't loaded automatically. Nowadays OMAP IOMMU support is a boolean 
> option, so it will get compiled in the kernel directly.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
