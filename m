Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39931 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1BWLEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 06:04:02 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LH200I4ZHENP190@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Feb 2011 11:03:59 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LH200HUNHEM43@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Feb 2011 11:03:58 +0000 (GMT)
Date: Wed, 23 Feb 2011 12:03:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: SAMSUNG: any example code for soc_camera, tv output,  etc...?
In-reply-to: <9fibsi$eahr36@out1.ip07ir2.opaltelecom.net>
To: Nick Pelling <nickpelling@nanodome.com>
Cc: linux-arm-kernel@lists.infradead.org,
	=?UTF-8?B?5L2Z6LCo5pm6?= <yujinzhi123@gmail.com>,
	kgene.kim@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4D64E99D.10208@samsung.com>
References: <20110211161626.GA31356@n2100.arm.linux.org.uk>
 <E1Pnvhv-0002yp-A0@rmk-PC.arm.linux.org.uk>
 <017901cbce9b$7b405ee0$71c11ca0$%kim@samsung.com>
 <20110217140621.GC24989@n2100.arm.linux.org.uk>
 <01b001cbcef7$3e7f5f90$bb7e1eb0$%kim@samsung.com>
 <9f2nkr$9lh756@out1.ip04ir2.opaltelecom.net>
 <AANLkTin0PR3VQLruade+w6GbCMoW9pXy4Kvn-sBZ+LBM@mail.gmail.com>
 <9fibsi$eahr36@out1.ip07ir2.opaltelecom.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Nick,

On 02/22/2011 11:54 PM, Nick Pelling wrote:
> Hi yujinzhi,
> 
> At 22:00 22/02/2011 +0800, =?GB2312?B?0+C999bH?= wrote:
>> I have port a embeded linux system on my board based on EP9315, with
>> support for usb video capture device, V4L2. Do you need V4L2 based on
>> usb video capture device or other video/FM/AM controller on your
>> board? If conveniently, can you provide more details about your
>> project?
> 
> It's a tiny S5PC100 board with an Aptina MT9M131 (1.3MP) sensor and video out
> for some security camera projects I'm working on. I've just brought up another
> embedded V4L2-based Linux camera, so V4L2 would be nice - in fact, there's
> already some Samsung s5p fimc code checked into the main tree, but it's far
> from clear (to me, at least) how to go about integrating image sensors with
> that to get V4L2 working.

Currently there is no a board in mainstream kernel that would have essential
S5P SoC multimedia device drivers hooked into it. I expect first reference
board with complete camera support to appear in kernel 2.6.39-rc1.

The bad news is that your sensor driver is compatible with the soc_camera
framework whereas s5p fimc driver exports a regular V4L2 video capture node.
And they won't work together out of the box. You might want to look at
noon010pc30 and sr010pc30 sensor drivers, those were tested with s5p fimc.
All you have to do is to define an instance of struct s5p_fimc_isp_info
and set it with s3c_set_platdata helper function in your board file.
For more details please check file include/media/s5p_fimc.h

There are ongoing efforts to make soc_camera sensors work with not soc_camera
host driver. But I'm really not sure about the schedule.

S5PC100 has no IOMMU and its multimedia devices require physically contiguous
memory. We have been developing the Contiguous Memory Allocator (CMA)
to efficiently manage system memory among graphics devices.
Unfortunately due to some memory remapping constraints in newer
ARM architectures, emerging during development, the CMA is still not
in mainline kernel.
You can still use the videobuf2 dma-contig allocator with s5p fimc as it done
in mainline kernel but it is not realiable on long running system.

Another solution would be to use physically contiguous memory reserved
by other device, e.g. framebuffer and pass it as USERPTR memory to the
camera driver.

You can find latest Samsung System LSI linux kernel development tree at
http://git.kernel.org/?p=linux/kernel/git/kki_ap/linux-2.6-samsung.git

For most recent status of the S5P SoC graphics drivers you might want
to follow posting on linux-media ML (http://linuxtv.org/lists.php).

>> You MUST need the datasheet of S5PC100 on your board, and other
>> peripheral device's datasheet, like dm9000 ethernet controller if not
>> integrated in SoC, and schematic diagrams of your board.
> 
> Hardware datasheets I have plenty of, it's the supporting documentation on the
> s3c fb / s5p fimc devices / v4l2 host stuff that I'm missing. Not a lot in the
> Documentation/arm/Samsung* directories, for example. :-(

s3c-fb IMO is not different from other frambuffers. For basic setup you might
want to look at arch/arm/mach-s5pv210/mach-goni.c

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center

> 
> Cheers, ....Nick Pelling....
> 
