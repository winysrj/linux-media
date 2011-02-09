Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:8635 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1BIH6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 02:58:25 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LGC00MWPBHB1F20@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 16:58:23 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LGC00J2YBHBKV@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 16:58:23 +0900 (KST)
Date: Wed, 09 Feb 2011 16:58:14 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Memory allocation in Video4Linux
In-reply-to: <201102090851.41789.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	"'Wang, Wen W'" <wen.w.wang@intel.com>,
	'Jozef Kruger' <jozef.kruger@siliconhive.com>
Cc: "'Kanigeri, Hari K'" <hari.k.kanigeri@intel.com>,
	"'Iyer, Sundar'" <sundar.iyer@intel.com>,
	"'Yang, Jianwei'" <jianwei.yang@intel.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?B?7KGw6rK97Zi4L1MvVyBTb2x1dGlvbuqwnOuwnO2MgChTLkxTSSkvRTQo7ISg7J6E?=
	 =?UTF-8?B?KS/sgrzshLHsoITsnpA=?= <pullip.cho@samsung.com>
Message-id: <001501cbc82f$1fac8850$5f0598f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 8BIT
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
 <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com>
 <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com>
 <201102090851.41789.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi,

Maybe VCM is helpful for you. Please refer to the following URL.
http://marc.info/?l=linux-mm&m=129255940319217&w=2

Best regards,

	Jonghun Han


Wednesday, February 09, 2011 4:52 PM Hans Verkuil wrote:

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans Verkuil
> Sent: Wednesday, February 09, 2011 4:52 PM
> To: Wang, Wen W; Jozef Kruger
> Cc: Kanigeri, Hari K; Iyer, Sundar; Yang, Jianwei; linux-media@vger.kernel.org
> Subject: Re: Memory allocation in Video4Linux
> 
> On Wednesday, February 09, 2011 08:27:27 Wang, Wen W wrote:
> > Hi Hari,
> >
> > You are right. What we need is virtual address.
> >
> > Currently we alloc pages (alloc_pages()) for any request. Store those pages for
> an image buffer into a list. We also manage the virtual address for ISP by ourself
> (the range from 0 to 4GB) and the page table for our MMU which is independent to
> system MMU page table.
> 
> Assuming you are using video4linux for this driver, then you should take a look at
> the new videobuf2 framework that will appear in 2.6.39. It is already in the media
> tree (http://git.linuxtv.org/media_tree.git, see include/media/videobuf2-core.h).
> 
> It is much better than the old videobuf framework, and in particular gives the driver
> much more control on how memory is allocated and used.
> 
> Regards,
> 
> 	Hans
> 
> >
> > Thanks
> > Wen
> >
> > >-----Original Message-----
> > >From: Kanigeri, Hari K
> > >Sent: 2011年2月9日 15:22
> > >To: Iyer, Sundar; Wang, Wen W; Yang, Jianwei;
> > >linux-media@vger.kernel.org;
> > >umg-meego-handset-kernel@umglistsvr.jf.intel.com
> > >Cc: Jozef Kruger
> > >Subject: RE: Memory allocation in Video4Linux
> > >
> > >
> > >
> > >> -----Original Message-----
> > >> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> > >> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com]
> > >> On Behalf Of Iyer, Sundar
> > >> Sent: Wednesday, February 09, 2011 12:20 PM
> > >> To: Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org;
> > >> umg-meego- handset-kernel@umglistsvr.jf.intel.com
> > >> Cc: Jozef Kruger
> > >> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in
> > >> Video4Linux
> > >>
> > >> I remember some Continous Memory Allocator (CMA) being iterated
> > >> down a few versions on some mailing lists? IIRC, it is also for
> > >> large buffers and management for video IPs.
> > >
> > >I believe CMA is for allocating physically contiguous memory and from
> > >what Wen mentioned he also needs virtual memory management, which the
> > >IOMMU will provide. Please check the open source discussion on CMA,
> > >the last I heard CMA proposal was shot down.
> > >Reference: http://www.spinics.net/lists/linux-media/msg26875.html
> > >
> > >Wen, how are you currently allocating physical memory ?
> > >
> > >
> > >Thank you,
> > >Best regards,
> > >Hari
> >  翳 .n     +%  遍荻 w  .n  伐 {炳g    n r■     ㄨ&｛ 夸z罐    zf＂
> >  赙z_璁 :+v )撸
> >
> >
> 
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

