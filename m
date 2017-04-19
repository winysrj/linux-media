Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59114
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933419AbdDSLJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:09:30 -0400
Date: Wed, 19 Apr 2017 08:09:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 13/38] Annotate hardware config module parameters in
 drivers/media/
Message-ID: <20170419080924.0d2b2715@vento.lan>
In-Reply-To: <149141152121.29162.4230904949695480240.stgit@warthog.procyon.org.uk>
References: <149141141298.29162.5612793122429261720.stgit@warthog.procyon.org.uk>
        <149141152121.29162.4230904949695480240.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 05 Apr 2017 17:58:41 +0100
David Howells <dhowells@redhat.com> escreveu:

> When the kernel is running in secure boot mode, we lock down the kernel to
> prevent userspace from modifying the running kernel image.  Whilst this
> includes prohibiting access to things like /dev/mem, it must also prevent
> access by means of configuring driver modules in such a way as to cause a
> device to access or modify the kernel image.
> 
> To this end, annotate module_param* statements that refer to hardware
> configuration and indicate for future reference what type of parameter they
> specify.  The parameter parser in the core sees this information and can
> skip such parameters with an error message if the kernel is locked down.
> The module initialisation then runs as normal, but just sees whatever the
> default values for those parameters is.
> 
> Note that we do still need to do the module initialisation because some
> drivers have viable defaults set in case parameters aren't specified and
> some drivers support automatic configuration (e.g. PNP or PCI) in addition
> to manually coded parameters.
> 
> This patch annotates drivers in drivers/media/.
> 
> Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Mauro Carvalho Chehab <mchehab@kernel.org>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> cc: mjpeg-users@lists.sourceforge.net
> cc: linux-media@vger.kernel.org
> ---
> 
>  drivers/media/pci/zoran/zoran_card.c |    2 +-
>  drivers/media/rc/serial_ir.c         |   10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
> index 5266755add63..4680f001653a 100644
> --- a/drivers/media/pci/zoran/zoran_card.c
> +++ b/drivers/media/pci/zoran/zoran_card.c
> @@ -69,7 +69,7 @@ MODULE_PARM_DESC(card, "Card type");
>   */
>  
>  static unsigned long vidmem;	/* default = 0 - Video memory base address */
> -module_param(vidmem, ulong, 0444);
> +module_param_hw(vidmem, ulong, iomem, 0444);
>  MODULE_PARM_DESC(vidmem, "Default video memory base address");
>  
>  /*
> diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
> index 41b54e40176c..40d305842a9b 100644
> --- a/drivers/media/rc/serial_ir.c
> +++ b/drivers/media/rc/serial_ir.c
> @@ -833,11 +833,11 @@ MODULE_LICENSE("GPL");
>  module_param(type, int, 0444);
>  MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo, 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug");
>  
> -module_param(io, int, 0444);
> +module_param_hw(io, int, ioport, 0444);
>  MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
>  
>  /* some architectures (e.g. intel xscale) have memory mapped registers */
> -module_param(iommap, bool, 0444);
> +module_param_hw(iommap, bool, other, 0444);
>  MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
>  
>  /*
> @@ -845,13 +845,13 @@ MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory map
>   * on 32bit word boundaries.
>   * See linux-kernel/drivers/tty/serial/8250/8250.c serial_in()/out()
>   */
> -module_param(ioshift, int, 0444);
> +module_param_hw(ioshift, int, other, 0444);
>  MODULE_PARM_DESC(ioshift, "shift I/O register offset (0 = no shift)");
>  
> -module_param(irq, int, 0444);
> +module_param_hw(irq, int, irq, 0444);
>  MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
>  
> -module_param(share_irq, bool, 0444);
> +module_param_hw(share_irq, bool, other, 0444);
>  MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
>  
>  module_param(sense, int, 0444);
> 



Thanks,
Mauro
