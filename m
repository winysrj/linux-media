Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59100
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933842AbdDSLJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 07:09:01 -0400
Date: Wed, 19 Apr 2017 08:08:54 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 28/38] Annotate hardware config module parameters in
 drivers/staging/media/
Message-ID: <20170419080854.3ecddbbe@vento.lan>
In-Reply-To: <149141166119.29162.8331512785853788823.stgit@warthog.procyon.org.uk>
References: <149141141298.29162.5612793122429261720.stgit@warthog.procyon.org.uk>
        <149141166119.29162.8331512785853788823.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 05 Apr 2017 18:01:01 +0100
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
> This patch annotates drivers in drivers/staging/media/.
> 
> Suggested-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Mauro Carvalho Chehab <mchehab@kernel.org>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: linux-media@vger.kernel.org
> cc: devel@driverdev.osuosl.org
> ---
> 
>  drivers/staging/media/lirc/lirc_sir.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
> index c6c3de94adaa..dde46dd8cabb 100644
> --- a/drivers/staging/media/lirc/lirc_sir.c
> +++ b/drivers/staging/media/lirc/lirc_sir.c
> @@ -826,10 +826,10 @@ MODULE_AUTHOR("Milan Pikula");
>  #endif
>  MODULE_LICENSE("GPL");
>  
> -module_param(io, int, S_IRUGO);
> +module_param_hw(io, int, ioport, S_IRUGO);
>  MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
>  
> -module_param(irq, int, S_IRUGO);
> +module_param_hw(irq, int, irq, S_IRUGO);
>  MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
>  
>  module_param(threshold, int, S_IRUGO);
> 



Thanks,
Mauro
