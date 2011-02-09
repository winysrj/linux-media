Return-path: <mchehab@pedra>
Received: from mga14.intel.com ([143.182.124.37]:8933 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab1BIHWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 02:22:18 -0500
From: "Kanigeri, Hari K" <hari.k.kanigeri@intel.com>
To: "Iyer, Sundar" <sundar.iyer@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
CC: Jozef Kruger <jozef.kruger@siliconhive.com>
Date: Wed, 9 Feb 2011 00:22:12 -0700
Subject: RE: Memory allocation in Video4Linux
Message-ID: <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923D8@shsmsx501.ccr.corp.intel.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923DC@shsmsx501.ccr.corp.intel.com>
 <C039722627B15F489AB215B00C0A3E6608B074BC74@bgsmsx501.gar.corp.intel.com>
In-Reply-To: <C039722627B15F489AB215B00C0A3E6608B074BC74@bgsmsx501.gar.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
> Behalf Of Iyer, Sundar
> Sent: Wednesday, February 09, 2011 12:20 PM
> To: Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org; umg-meego-
> handset-kernel@umglistsvr.jf.intel.com
> Cc: Jozef Kruger
> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in
> Video4Linux
> 
> I remember some Continous Memory Allocator (CMA) being iterated down a
> few versions on
> some mailing lists? IIRC, it is also for large buffers and management
> for video IPs.

I believe CMA is for allocating physically contiguous memory and from what Wen mentioned he also needs virtual memory management, which the IOMMU will provide. Please check the open source discussion on CMA, the last I heard CMA proposal was shot down.
Reference: http://www.spinics.net/lists/linux-media/msg26875.html

Wen, how are you currently allocating physical memory ?


Thank you,
Best regards,
Hari
