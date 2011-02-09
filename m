Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1794 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1BIHvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 02:51:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Wang, Wen W" <wen.w.wang@intel.com>,
	Jozef Kruger <jozef.kruger@siliconhive.com>
Subject: Re: Memory allocation in Video4Linux
Date: Wed, 9 Feb 2011 08:51:41 +0100
Cc: "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com> <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Message-Id: <201102090851.41789.hverkuil@xs4all.nl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, February 09, 2011 08:27:27 Wang, Wen W wrote:
> Hi Hari,
> 
> You are right. What we need is virtual address.
> 
> Currently we alloc pages (alloc_pages()) for any request. Store those pages for an image buffer into a list. We also manage the virtual address for ISP by ourself (the range from 0 to 4GB) and the page table for our MMU which is independent to system MMU page table.

Assuming you are using video4linux for this driver, then you should take a
look at the new videobuf2 framework that will appear in 2.6.39. It is already
in the media tree (http://git.linuxtv.org/media_tree.git, see
include/media/videobuf2-core.h).

It is much better than the old videobuf framework, and in particular gives
the driver much more control on how memory is allocated and used.

Regards,

	Hans

> 
> Thanks
> Wen
> 
> >-----Original Message-----
> >From: Kanigeri, Hari K
> >Sent: 2011年2月9日 15:22
> >To: Iyer, Sundar; Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org;
> >umg-meego-handset-kernel@umglistsvr.jf.intel.com
> >Cc: Jozef Kruger
> >Subject: RE: Memory allocation in Video4Linux
> >
> >
> >
> >> -----Original Message-----
> >> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> >> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
> >> Behalf Of Iyer, Sundar
> >> Sent: Wednesday, February 09, 2011 12:20 PM
> >> To: Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org; umg-meego-
> >> handset-kernel@umglistsvr.jf.intel.com
> >> Cc: Jozef Kruger
> >> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in
> >> Video4Linux
> >>
> >> I remember some Continous Memory Allocator (CMA) being iterated down a
> >> few versions on
> >> some mailing lists? IIRC, it is also for large buffers and management
> >> for video IPs.
> >
> >I believe CMA is for allocating physically contiguous memory and from what Wen
> >mentioned he also needs virtual memory management, which the IOMMU will
> >provide. Please check the open source discussion on CMA, the last I heard CMA
> >proposal was shot down.
> >Reference: http://www.spinics.net/lists/linux-media/msg26875.html
> >
> >Wen, how are you currently allocating physical memory ?
> >
> >
> >Thank you,
> >Best regards,
> >Hari
> �翳�.n�����+%��遍荻�w��.n��伐�{炳g����n�r■�����ㄨ&｛�夸z罐����zf＂������������赙z_璁�:+v�)撸�
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
