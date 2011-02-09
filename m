Return-path: <mchehab@pedra>
Received: from mga02.intel.com ([134.134.136.20]:8893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1BIGbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 01:31:21 -0500
From: "Yang, Jianwei" <jianwei.yang@intel.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
CC: Jozef Kruger <jozef.kruger@siliconhive.com>
Date: Wed, 9 Feb 2011 14:30:45 +0800
Subject: RE: Memory allocation in Video4Linux
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923D8@shsmsx501.ccr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Curious for the below, why it is a sum? Will you use all of format at the same time? 

> 	1 RAW16: 2*14 = 28MB
> 	1 qplane6: 6/4 * 14 = 21MB
> 	1 yuv420_16: 2 * 1.5 * 14 = 42MB
> 	1 yuv420: 1.5 * 14 = 21MB
> 	1 yuv444: 3 * 14 = 42MB
> 	total: 154MB.

> -----Original Message-----
> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
> Behalf Of Wang, Wen W
> Sent: Wednesday, February 09, 2011 2:23 PM
> To: linux-media@vger.kernel.org; umg-meego-handset-
> kernel@umglistsvr.jf.intel.com
> Cc: Jozef Kruger
> Subject: [Umg-meego-handset-kernel] Memory allocation in Video4Linux
> 
> Hi,
> 
> We are developing the image processor driver for Intel Medfield platform.
> 
> We have received some comments on memory management that we should use
> standard Linux kernel interfaces for this, since we are doing everything
> by ourselves including memory allocation (based on pages), page table
> management, virtual address management and etc.
> 
> So can you please help give some advice or suggestion on using standard
> kernel interface for memory management?
> 
> The processor has a MMU on-chip with same virtual address range as IA. The
> processor will access system memory (read and write) through MMU and page
> table. The memory consumption of the driver could be quite big especially
> for high resolution (14MP) with certain features turned on.
> For example: advanced ISP with XNR and yuv444 output, at 14MP this uses:
> 	1 RAW16: 2*14 = 28MB
> 	1 qplane6: 6/4 * 14 = 21MB
> 	1 yuv420_16: 2 * 1.5 * 14 = 42MB
> 	1 yuv420: 1.5 * 14 = 21MB
> 	1 yuv444: 3 * 14 = 42MB
> 	total: 154MB.
> 
> Thanks
> Wen
> _______________________________________________
> Umg-meego-handset-kernel mailing list
> Umg-meego-handset-kernel@umglistsvr.jf.intel.com
> http://umglistsvr.jf.intel.com/mailman/listinfo/umg-meego-handset-kernel
