Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1BIKUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 05:20:05 -0500
Message-ID: <4D526A4D.1040906@redhat.com>
Date: Wed, 09 Feb 2011 08:19:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Wang, Wen W" <wen.w.wang@intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>,
	Jozef Kruger <jozef.kruger@siliconhive.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: Memory allocation in Video4Linux
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Wen,

Em 09-02-2011 04:23, Wang, Wen W escreveu:
> Hi,
> 
> We are developing the image processor driver for Intel Medfield platform. 
> 
> We have received some comments on memory management that we should use standard Linux kernel interfaces for this, since we are doing everything by ourselves including memory allocation (based on pages), page table management, virtual address management and etc.
> 
> So can you please help give some advice or suggestion on using standard kernel interface for memory management?
> 
> The processor has a MMU on-chip with same virtual address range as IA. The processor will access system memory (read and write) through MMU and page table. The memory consumption of the driver could be quite big especially for high resolution (14MP) with certain features turned on. 
> For example: advanced ISP with XNR and yuv444 output, at 14MP this uses:
> 	1 RAW16: 2*14 = 28MB
> 	1 qplane6: 6/4 * 14 = 21MB
> 	1 yuv420_16: 2 * 1.5 * 14 = 42MB
> 	1 yuv420: 1.5 * 14 = 21MB
> 	1 yuv444: 3 * 14 = 42MB
> 	total: 154MB.

You should take a look at the videobuf2 for buffer management. It is flexible
enough to be used on embedded hardware, as it splits the memory management
on a separate module. In particular, the CMA allocator was designed to handle
memory management on complex designs. You'll find extensive discussions about
CMA and videobuf2 in the ML. The videobuf2 is already at linux-next and will
be available for 2.6.39. Not sure about the status of the CMA allocator, as
the patches are handled via another upstream tree.

I hope that helps.

Cheers,
Mauro
