Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:34630 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab1DMKWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 06:22:06 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: V4L/ARM: videobuf-dma-contig no longer works on my ARM machine
Date: Wed, 13 Apr 2011 12:20:43 +0200
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <201104091711.00191.jkrzyszt@tis.icnet.pl> <4DA08C80.5040205@suse.cz>
In-Reply-To: <4DA08C80.5040205@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104131220.44430.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia sobota 09 kwiecień 2011 o 18:42:40 Jiri Slaby napisał(a):
> On 04/09/2011 05:10 PM, Janusz Krzysztofik wrote:
> > (CC: Jiri Slaby, the author of the problematic change; truncate
> > subject)
> > 
> > On Sat, 09 Apr 2011, at 09:16:24, Russell King - ARM Linux wrote:
> >> On Sat, Apr 09, 2011 at 03:33:39AM +0200, Janusz Krzysztofik wrote:
> >>> Since there were no actual problems reported before, I suppose
> >>> the old code, which was passing to remap_pfn_range() a physical
> >>> page number calculated from dma_alloc_coherent() privided
> >>> dma_handle, worked correctly on all platforms actually using
> >>> videobud-dma-config.
> 
> No, it didn't when IOMMU was used. 

Taking into account that I'm just trying to fix a regression, and not 
invent a new, long term solution: are you able to name a board which a) 
is already supported in 2.6.39, b) is (or can be) equipped with a device 
supported by a V4L driver which uses videobuf-dma-config susbsystem, c) 
uses IOMMU? If there is one, than I agree that reverting the patch is 
not a good option.

> Because remap_pfn_range didn't get
> a physical page address.

If I didn't understand it, I wouldn't try to find a solution other than 
reverting your patch.

Thanks,
Janusz
