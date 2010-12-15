Return-path: <mchehab@gaivota>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36565 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0LOMoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 07:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <20101213162947.GA11730@n2100.arm.linux.org.uk>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl>
	<201012101159.21845.jkrzyszt@tis.icnet.pl>
	<201012101203.09441.jkrzyszt@tis.icnet.pl>
	<20101210170356.GA28472@n2100.arm.linux.org.uk>
	<AANLkTimTVWVmVfppAWSosidqLmo6c+8rPhLg=oJAVoYH@mail.gmail.com>
	<20101213162947.GA11730@n2100.arm.linux.org.uk>
Date: Wed, 15 Dec 2010 12:39:20 +0000
Message-ID: <AANLkTi=ZYi=12k2vZMGp9AWNX8zofp6C-FnMu2egQOA1@mail.gmail.com>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 13 December 2010 16:29, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Dec 13, 2010 at 03:52:20PM +0000, Catalin Marinas wrote:
>> On 10 December 2010 17:03, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
>> >>  void __init omap1_camera_init(void *info)
>> >>  {
>> >>       struct platform_device *dev = &omap1_camera_device;
>> >> +     dma_addr_t paddr = omap1_camera_phys_mempool_base;
>> >> +     dma_addr_t size = omap1_camera_phys_mempool_size;
>> >>       int ret;
>> >>
>> >>       dev->dev.platform_data = info;
>> >>
>> >> +     if (paddr) {
>> >> +             if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
>> >> +                             DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
>> >
>> > Although this works, you're ending up with SDRAM being mapped via
>> > ioremap, which uses MT_DEVICE - so what is SDRAM ends up being
>> > mapped as if it were a device.
>>
>> BTW, does the generic dma_declare_coherent_memory() does the correct
>> thing in using ioremap()?
>
> I argue it doesn't, as I said above.  It means we map SDRAM as device
> memory, and as I understand the way interconnects work, it's entirely
> possible that this may not result in the SDRAM being accessible.
[...]
> So, not only does this fail the kernel's own rules, but as we already know,
> it fails the architecture's restrictions with multiple mappings of memory
> when used with SDRAM, and it also maps main memory as a device.  I wonder
> how many more things this broken API needs to do wrong before it's current
> implementation is consigned to the circular filing cabinet.

Should we not try to fix the generic code and still allow platforms to
use dma_declare_coherent_memory() in a safer way? I guess it may need
some arguing/explanation on linux-arch.

-- 
Catalin
