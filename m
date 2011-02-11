Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45668 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1BKCHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 21:07:40 -0500
Received: by yib18 with SMTP id 18so878917yib.19
        for <linux-media@vger.kernel.org>; Thu, 10 Feb 2011 18:07:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102101100.50667.laurent.pinchart@ideasonboard.com>
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>
	<201102101029.13502.laurent.pinchart@ideasonboard.com>
	<D5AB6E638E5A3E4B8F4406B113A5A19A32F929C2@shsmsx501.ccr.corp.intel.com>
	<201102101100.50667.laurent.pinchart@ideasonboard.com>
Date: Fri, 11 Feb 2011 11:07:38 +0900
Message-ID: <AANLkTimveC0a6ww-ZQ0ijnyOOS6u2uxMsgmhay9mWWeD@mail.gmail.com>
Subject: Re: Memory allocation in Video4Linux
From: KyongHo Cho <pullip.cho@samsung.com>
To: "Wang, Wen W" <wen.w.wang@intel.com>
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
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Wen and Laurent,

>
>> Also regarding to the VCMM (Virtual Contiguous Memory Manager) or CMA, is
>> it also an option?
>
> I'm not sure about VCMM, it seems to be an attempt to unify memory management
> across IOMMUs and system MMU. I don't think you need to worry about it now,
> IOMMU should be enough for your needs.
>
> CMA, as its name implies, is a contiguous memory allocator. As your ISP has an
> IOMMU, you don't need to allocate contiguous memory, so CMA isn't useful for
> your hardware.
>

VCM(aka. VCMM) is a virtual memory (device memory) allocator and
manager when a system has multiple MMUs.
Since physical memory allocation (and virtual memory allocation also)
for processes by O/S is not suitable for peripheral devices,
VCM separates allocating physical memory and virtual memory.
It also gives you chances to override the default behavior of the allocators.

If you concern about device memory management with IOMMU,
I think VCM is one of good options even though a system has only one
IOMMU to deal with.

It is not merged into the Linux kernel
because applications of VCM is very restricted and just few people are
interested in it.

KyongHo.
