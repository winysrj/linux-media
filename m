Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42834 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 17:35:13 -0400
Subject: Re: [PATCH] V4L/DVB: saa7146: IRQF_DISABLED causes only trouble
From: Andy Walls <awalls@radix.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org, stable@kernel.org
In-Reply-To: <1269202135-340-1-git-send-email-bjorn@mork.no>
References: <1269202135-340-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Mar 2010 17:24:01 -0400
Message-Id: <1269206641.6135.68.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-03-21 at 21:08 +0100, Bjørn Mork wrote:
> As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
> mixing IRQF_DISABLED with IRQF_SHARED just doesn't make sense.
> 
> Remove IRQF_DISABLED to avoid random unexpected behaviour.
> 
> Ever since I started using the saa7146 driver, I've had occasional
> soft lockups.  I do not have any real evidence that the saa7146
> driver is the cause, but the lockups are gone after removing the
> IRQF_DISABLED flag from this driver.
> 
> On my system, this driver shares an irq17 with the pata_jmicron
> driver:
> 
>  17:       2115      10605    9422844    8193902   IO-APIC-fasteoi   pata_jmicron, saa7146 (0)
> 
> This may be a mitigating factor.
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Cc: stable@kernel.org

And here are some more recent discussions:

http://lkml.org/lkml/2009/11/30/215
http://lkml.org/lkml/2009/3/2/33
http://lkml.org/lkml/2009/3/2/225
http://www.mail-archive.com/ivtv-devel@ivtvdriver.org/msg06319.html
http://www.mail-archive.com/ivtv-devel@ivtvdriver.org/msg06362.html

And the ones on the LKML seem prettry inconclusive to me.


If the saa7146 driver was registered second, then this change should
have no effect on your system.

If the saa7146 driver was registered first, then this can cause the
saa7146 driver's interrupt handler to be interrupted.  I doubt the
saa7146 driver is prepared for this contingency.

I doubt that this is the "proper" fix for your problem.


Does the "soft lockup" put an Oops or BUG message in dmesg
or /var/log/messages? 

What precisely do you mean by "soft lockup"?

Regards,
Andy

> ---
>  drivers/media/common/saa7146_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
> index 982f000..038dcc8 100644
> --- a/drivers/media/common/saa7146_core.c
> +++ b/drivers/media/common/saa7146_core.c
> @@ -416,7 +416,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
>  	saa7146_write(dev, MC2, 0xf8000000);
>  
>  	/* request an interrupt for the saa7146 */
> -	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
> +	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED,
>  			  dev->name, dev);
>  	if (err < 0) {
>  		ERR(("request_irq() failed.\n"));

