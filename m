Return-path: <mchehab@gaivota>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48824 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab0LMQaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 11:30:52 -0500
Date: Mon, 13 Dec 2010 16:29:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Message-ID: <20101213162947.GA11730@n2100.arm.linux.org.uk>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <201012101159.21845.jkrzyszt@tis.icnet.pl> <201012101203.09441.jkrzyszt@tis.icnet.pl> <20101210170356.GA28472@n2100.arm.linux.org.uk> <AANLkTimTVWVmVfppAWSosidqLmo6c+8rPhLg=oJAVoYH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimTVWVmVfppAWSosidqLmo6c+8rPhLg=oJAVoYH@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Dec 13, 2010 at 03:52:20PM +0000, Catalin Marinas wrote:
> On 10 December 2010 17:03, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
> >>  void __init omap1_camera_init(void *info)
> >>  {
> >>       struct platform_device *dev = &omap1_camera_device;
> >> +     dma_addr_t paddr = omap1_camera_phys_mempool_base;
> >> +     dma_addr_t size = omap1_camera_phys_mempool_size;
> >>       int ret;
> >>
> >>       dev->dev.platform_data = info;
> >>
> >> +     if (paddr) {
> >> +             if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
> >> +                             DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
> >
> > Although this works, you're ending up with SDRAM being mapped via
> > ioremap, which uses MT_DEVICE - so what is SDRAM ends up being
> > mapped as if it were a device.
> 
> BTW, does the generic dma_declare_coherent_memory() does the correct
> thing in using ioremap()?

I argue it doesn't, as I said above.  It means we map SDRAM as device
memory, and as I understand the way interconnects work, it's entirely
possible that this may not result in the SDRAM being accessible.

> Maybe some other function that takes a
> pgprot_t would be better (ioremap_page_range) and could pass something
> like pgprot_noncached (though ideally a pgprot_dmacoherent). Or just
> an architecturally-defined function.

This API was designed in the ARMv5 days when things were a lot simpler.
What we now have is rather messy though, and really needs sorting out
before we get too many users of it.  (Arguably it should never have been
accepted in its current state.)

We have a rule that the returned value of ioremap() is not to be used
as a pointer which can be dereferenced by anything except driver code.
Yet this is exactly what dma_declare_coherent_memory() does:

struct dma_coherent_mem {
        void            *virt_base;
...
};

int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
                                dma_addr_t device_addr, size_t size, int flags)
{
        void __iomem *mem_base = NULL;
        mem_base = ioremap(bus_addr, size);
        dev->dma_mem->virt_base = mem_base;
}

int dma_alloc_from_coherent(struct device *dev, ssize_t size,
                                       dma_addr_t *dma_handle, void **ret)
{
        *ret = mem->virt_base + (pageno << PAGE_SHIFT);
}

and drivers expect the returned value from dma_alloc_coherent() to be
dereferenceable.

Note that this also fails sparse checking.  It will fail on any
architecture where the return value from ioremap() is not a virtual
address.

So, not only does this fail the kernel's own rules, but as we already know,
it fails the architecture's restrictions with multiple mappings of memory
when used with SDRAM, and it also maps main memory as a device.  I wonder
how many more things this broken API needs to do wrong before it's current
implementation is consigned to the circular filing cabinet.
