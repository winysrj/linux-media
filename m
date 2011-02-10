Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38014 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1BJKAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 05:00:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>
Subject: Re: Memory allocation in Video4Linux
Date: Thu, 10 Feb 2011 11:00:49 +0100
Cc: "Gao, Bin" <bin.gao@intel.com>,
	"Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>,
	Jozef Kruger <jozef.kruger@siliconhive.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	"Xie, Cindy" <cindy.xie@intel.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com> <201102101029.13502.laurent.pinchart@ideasonboard.com> <D5AB6E638E5A3E4B8F4406B113A5A19A32F929C2@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F929C2@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb18030"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101100.50667.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Wen,

On Thursday 10 February 2011 10:44:58 Wang, Wen W wrote:
> Hi Laurent,
> 
> You make this very clear, thank you!
> 
> The ISP on Medfield do have its own IOMMU. And I also think an IOMMU layer
> for ISP is needed.
> 
> I'm not quite understand "unless hardware design doesn't give you a choice
> about that,". Can you explain more on that?

Basically, Linux aims for driver reusability. That means that separate pieces 
of hardware, even when they are designed to work together, should be handled 
by separate, indepedent drivers. This might make the initial development a bit 
longer, as proper abstraction APIs need to be designed when they don't exist, 
but it cuts down time to market later when a hardware block is reused in a 
different silicon or board.

A good example of that approach is I2C sensors. They're supported by drivers 
that are completely independent of the ISP they are connected to, and use the 
V4L2 subdev in-kernel API to communicate with the ISP in a hardware-indepedent 
way.

IOMMU is such an API. It lets you implement support for your particular IOMMU 
in a self-contained drivers, which can then be used by device drivers (such as 
the ISP driver).

For this to work, the hardware needs to have at least some level of separation 
between the different components. With I2C that's easy, the sensor can be 
controlled completely indepedently from the ISP. With the ISP IOMMU, it would 
more or less depend on how the registers are layed out in memory. If the ISP 
IOMMU registers are grouped together and separated from the other ISP 
registers, you should be fine. If they are mixed with ISP registers (an 
hypotetical bad case would for instance be if the ISP IOMMU required you to 
set bits in the TLB entries that describe the format of the video data stored 
in a page), such an abstraction would be much more difficult to achieve, and 
sometimes even impossible.

> Also regarding to the VCMM (Virtual Contiguous Memory Manager) or CMA, is
> it also an option?

I'm not sure about VCMM, it seems to be an attempt to unify memory management 
across IOMMUs and system MMU. I don't think you need to worry about it now, 
IOMMU should be enough for your needs.

CMA, as its name implies, is a contiguous memory allocator. As your ISP has an 
IOMMU, you don't need to allocate contiguous memory, so CMA isn't useful for 
your hardware.

-- 
Regards,

Laurent Pinchart
