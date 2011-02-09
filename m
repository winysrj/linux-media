Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:22265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1BIGaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 01:30:11 -0500
From: "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
CC: Jozef Kruger <jozef.kruger@siliconhive.com>
Date: Tue, 8 Feb 2011 23:30:07 -0700
Subject: RE: Memory allocation in Video4Linux
Message-ID: <A787B2DEAF88474996451E847A0AFAB7F264B7A3@rrsmsx508.amr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
> Behalf Of Wang, Wen W
> Sent: Wednesday, February 09, 2011 11:53 AM
> To: linux-media@vger.kernel.org; umg-meego-handset-
> kernel@umglistsvr.jf.intel.com
> Cc: Jozef Kruger
> Subject: [Umg-meego-handset-kernel] Memory allocation in Video4Linux
> 
> Hi,
> 
> We are developing the image processor driver for Intel Medfield
> platform.
> 
> We have received some comments on memory management that we should use
> standard Linux kernel interfaces for this, since we are doing
> everything by ourselves including memory allocation (based on pages),
> page table management, virtual address management and etc.
> 
> So can you please help give some advice or suggestion on using standard
> kernel interface for memory management?

Not sure if this meets your requirements, but check IOMMU driver. IOMMU driver is responsible to map the user buffers to Device's virtual address.


Thank you,
Best regards,
Hari
