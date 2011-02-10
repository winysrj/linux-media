Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39140 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1BJJ3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 04:29:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Gao, Bin" <bin.gao@intel.com>
Subject: Re: Memory allocation in Video4Linux
Date: Thu, 10 Feb 2011 10:29:13 +0100
Cc: "Wang, Wen W" <wen.w.wang@intel.com>,
	"Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>,
	Jozef Kruger <jozef.kruger@siliconhive.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com> <06F569D088CFBC4497658761DA003E13015636076A@rrsmsx505.amr.corp.intel.com>
In-Reply-To: <06F569D088CFBC4497658761DA003E13015636076A@rrsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101029.13502.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Wen,

On Thursday 10 February 2011 08:59:38 Gao, Bin wrote:
> Penwell has IOMMU feature?
> As far as I know only part of Intel server processors have this feature
> which is designed originally for VT(virtualization technology).
> 
> Wen,
> Can you refer to other ISP Soc drivers and see how they are dealing with
> this issue? I don't understand why you need to manage MMU inside ISP, I
> think the real problem is how can we allocate a large number of memory
> pages from IA side where ISP can access to by DMA. Any ISP document can be
> shared to help us understand what's the problem?

I second this request. It's not totally clear to me from this mail thread 
whether your ISP has its own MMU (which would then be considered as an IOMMU), 
or accesses the system memory through other means (continuous buffers, 
scatter-gather lists, ...).

If the Medfield ISP includes an IOMMU, the IOMMU layer is probably what you 
want to use. Memory can then be allocated using a simple vmalloc(), and pages 
can be mapped to the ISP memory space using the IOMMU.

Please note that, unless the ISP IOMMU is already supported by the Linux 
kernel, you will obviously need to implement an IOMMU driver for it. What you 
shouldn't do is put that code in the ISP driver (unless hardware design 
doesn't give you a choice about that, but I need to see more documentation to 
answer this question).

-- 
Regards,

Laurent Pinchart
