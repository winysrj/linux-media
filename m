Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45668 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbbDSI2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2015 04:28:32 -0400
Message-ID: <55336719.5000301@xs4all.nl>
Date: Sun, 19 Apr 2015 10:28:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "hans.verkuil" <hans.verkuil@cisco.com>, khalasa <khalasa@piap.pl>
Subject: Re: On register r/w macros/procedures of drivers/media/pci
References: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
In-Reply-To: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/2015 09:36 AM, Andrey Utkin wrote:
> I am starting a work on driver for techwell tw5864 media grabber&encoder.
> I am basing on tw68 driver (mentorship, advising and testing by board
> owners are appreciated). And here (and in some other
> drivers/media/pci/ drivers) I see what confuses me:
> 
> tw68-core.c:
>         dev->lmmio = ioremap(pci_resource_start(pci_dev, 0),
>                              pci_resource_len(pci_dev, 0));
>         dev->bmmio = (__u8 __iomem *)dev->lmmio;
> 
> tw68.h:
> #define tw_readl(reg)           readl(dev->lmmio + ((reg) >> 2))
> #define tw_readb(reg)           readb(dev->bmmio + (reg))
> #define tw_writel(reg, value)   writel((value), dev->lmmio + ((reg) >> 2))
> #define tw_writeb(reg, value)   writeb((value), dev->bmmio + (reg))
> 
> I am mostly userland developer and I wouldn't expect bmmio pointer to
> contain value numerically different from lmmio after such simple
> casting.

Check the types of llmio and bbmio:

        u32                     __iomem *lmmio;
        u8                      __iomem *bmmio;

So the values of the pointers are the same, but the types are not.

So 'lmmio + 1' == 'bmmio + sizeof(u32)' == 'bbmio + 4'.

Since all the registers are defined as byte offsets relative to the start
of the memory map you cannot just do 'lmmio + reg' since that would be a
factor 4 off. Instead you have to divide by 4 to get it back in line.

Frankly, I don't think lmmio is necessary at all since readl/writel don't
need a u32 pointer at all since they use void pointers. I never noticed
that when I cleaned up the tw68 driver. Using 'void __iomem *mmio' instead
of lmmio/bmmio and dropping the shifts in the tw_ macros would work just
as well.

> But still, if this is correct, then how should I implement
> tw_{read,write}w to operate on 2 bytes (a word)? Similarly, it would
> look like this:
> #define tw_readl(reg)           readl(dev->lmmio + ((reg) >> 1))

As suggested above, just use a single void __iomem *mmio pointer.

> That looks odd.
> 
> In contrary, in drivers/media/pci/dm1105, we see no explicit shifting
> of register address. It uses {in,out}{b,w,l} macros, which seem to
> turn out the same {read,write}{b,w,l} (with some reservations):
> http://lxr.free-electrons.com/source/include/asm-generic/io.h#L354
> 
> dm1105.c:#define dm_io_mem(reg) ((unsigned long)(&dev->io_mem[reg]))
> dm1105.c:#define dm_readb(reg)          inb(dm_io_mem(reg))
> dm1105.c:#define dm_writeb(reg, value)  outb((value), (dm_io_mem(reg)))
> dm1105.c:#define dm_readw(reg)          inw(dm_io_mem(reg))
> dm1105.c:#define dm_writew(reg, value)  outw((value), (dm_io_mem(reg)))
> dm1105.c:#define dm_readl(reg)          inl(dm_io_mem(reg))
> dm1105.c:#define dm_writel(reg, value)  outl((value), (dm_io_mem(reg)))
> 
> This looks like contradiction to me (shifting register address vs. no
> shifting), so that one practice may be even just wrong and broken
> (which is hard to believe due to active maintenance of all drivers).
> I highly appreciate your help me in determining the best practice to
> follow in this new driver.
> Thanks.
> 

Hope this helps,

	Hans
