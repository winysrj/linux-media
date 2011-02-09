Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:15723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1BIGuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 01:50:07 -0500
From: "Iyer, Sundar" <sundar.iyer@intel.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
CC: Jozef Kruger <jozef.kruger@siliconhive.com>
Date: Wed, 9 Feb 2011 12:19:34 +0530
Subject: RE: Memory allocation in Video4Linux
Message-ID: <C039722627B15F489AB215B00C0A3E6608B074BC74@bgsmsx501.gar.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923D8@shsmsx501.ccr.corp.intel.com>
 <D5AB6E638E5A3E4B8F4406B113A5A19A32F923DC@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923DC@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I remember some Continous Memory Allocator (CMA) being iterated down a few versions on 
some mailing lists? IIRC, it is also for large buffers and management for video IPs.

Cheers!

> -----Original Message-----
> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com [mailto:umg-
> meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On Behalf Of Wang, Wen W
> Sent: Wednesday, February 09, 2011 12:03 PM
> To: Yang, Jianwei; linux-media@vger.kernel.org; umg-meego-handset-
> kernel@umglistsvr.jf.intel.com
> Cc: Jozef Kruger
> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in Video4Linux
> 
> Yes. Some are internal frame and yuv444 is the output.
> 
> >-----Original Message-----
> >From: Yang, Jianwei
> >Sent: 2011年2月9日 14:31
> >To: Wang, Wen W; linux-media@vger.kernel.org;
> >umg-meego-handset-kernel@umglistsvr.jf.intel.com
> >Cc: Jozef Kruger
> >Subject: RE: Memory allocation in Video4Linux
> >
> >Curious for the below, why it is a sum? Will you use all of format at the same time?
> >
> >> 	1 RAW16: 2*14 = 28MB
> >> 	1 qplane6: 6/4 * 14 = 21MB
> >> 	1 yuv420_16: 2 * 1.5 * 14 = 42MB
> >> 	1 yuv420: 1.5 * 14 = 21MB
> >> 	1 yuv444: 3 * 14 = 42MB
> >> 	total: 154MB.
> >
> >> -----Original Message-----
> >> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> >> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
> >> Behalf Of Wang, Wen W
> >> Sent: Wednesday, February 09, 2011 2:23 PM
> >> To: linux-media@vger.kernel.org; umg-meego-handset-
> >> kernel@umglistsvr.jf.intel.com
> >> Cc: Jozef Kruger
> >> Subject: [Umg-meego-handset-kernel] Memory allocation in Video4Linux
> >>
> >> Hi,
> >>
> >> We are developing the image processor driver for Intel Medfield platform.
> >>
> >> We have received some comments on memory management that we should use
> >> standard Linux kernel interfaces for this, since we are doing everything
> >> by ourselves including memory allocation (based on pages), page table
> >> management, virtual address management and etc.
> >>
> >> So can you please help give some advice or suggestion on using standard
> >> kernel interface for memory management?
> >>
> >> The processor has a MMU on-chip with same virtual address range as IA. The
> >> processor will access system memory (read and write) through MMU and page
> >> table. The memory consumption of the driver could be quite big especially
> >> for high resolution (14MP) with certain features turned on.
> >> For example: advanced ISP with XNR and yuv444 output, at 14MP this uses:
> >> 	1 RAW16: 2*14 = 28MB
> >> 	1 qplane6: 6/4 * 14 = 21MB
> >> 	1 yuv420_16: 2 * 1.5 * 14 = 42MB
> >> 	1 yuv420: 1.5 * 14 = 21MB
> >> 	1 yuv444: 3 * 14 = 42MB
> >> 	total: 154MB.
> >>
> >> Thanks
> >> Wen
> >> _______________________________________________
> >> Umg-meego-handset-kernel mailing list
> >> Umg-meego-handset-kernel@umglistsvr.jf.intel.com
> >> http://umglistsvr.jf.intel.com/mailman/listinfo/umg-meego-handset-kernel
> _______________________________________________
> Umg-meego-handset-kernel mailing list
> Umg-meego-handset-kernel@umglistsvr.jf.intel.com
> http://umglistsvr.jf.intel.com/mailman/listinfo/umg-meego-handset-kernel
