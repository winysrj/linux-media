Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:58938 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1FHWqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jun 2011 18:46:48 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Date: Thu, 9 Jun 2011 00:44:57 +0200
Cc: Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <201106082354.10985.jkrzyszt@tis.icnet.pl> <20110608221330.GA13246@n2100.arm.linux.org.uk>
In-Reply-To: <20110608221330.GA13246@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090045.21251.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu 09 Jun 2011 at 00:13:30 Russell King - ARM Linux wrote:
> 
> I stand by my answer to your patches quoted above from a technical
> point of view; we should not be mapping SDRAM using device mappings.
> 
> That ioremap() inside dma_declare_coherent_memory() needs to die,

Then how about your alternative, ARM specific solution, "Avoid aliasing 
mappings in DMA coherent allocator"? There was a series of initially 
two, then three patches, of which the two others (459c1517f987 "ARM: 
DMA: Replace page_to_dma()/dma_to_page() with pfn_to_dma()/dma_to_pfn()" 
and 9eedd96301ca "ARM: DMA: top-down allocation in DMA coherent region") 
are already in the mainline tree. I'm still porting a copy of that third 
one from kernel version to version to have my device working 100% 
reliably, in hope you finally push it into the mainline. No plans 
against it? Or is there something about it I could help with?

Thanks,
Janusz
