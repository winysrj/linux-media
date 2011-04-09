Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50701 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab1DIHRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2011 03:17:09 -0400
Date: Sat, 9 Apr 2011 08:16:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: V4L/ARM: videobuf-dma-contig no longer works on my ARM machine
	(was: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface)
Message-ID: <20110409071624.GE5573@n2100.arm.linux.org.uk>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1103231056360.6836@axis700.grange> <201104090333.52312.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104090333.52312.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Apr 09, 2011 at 03:33:39AM +0200, Janusz Krzysztofik wrote:
> Since there were no actual problems reported before, I suppose the old 
> code, which was passing to remap_pfn_range() a physical page number 
> calculated from dma_alloc_coherent() privided dma_handle, worked 
> correctly on all platforms actually using videobud-dma-config. Now, on 
> my ARM machine, a completely different, then completely wrong physical 
> address, calculated as virt_to_phys(dma_alloc_coherent()), is used 
> instead of the dma_handle, which causes the machine to hang.

virt_to_phys(dma_alloc_coherent()) is and always has been invalid, and
will break on several architectures apart from ARM.
