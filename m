Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57663
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753662AbcKRTC6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 14:02:58 -0500
Date: Fri, 18 Nov 2016 17:02:53 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] media: rc: nuvoton: remove nvt_open and nvt_close
Message-ID: <20161118170253.78907131@vento.lan>
In-Reply-To: <07318f26-3d54-d01e-c5eb-880acc0e04a4@gmail.com>
References: <07318f26-3d54-d01e-c5eb-880acc0e04a4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Oct 2016 21:23:16 +0200
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> What is done in nvt_probe was done in nvt_probe already
> (in nvt_cir_ldev_init and nvt_cir_regs_init, both called from
> nvt_probe). It's the same with nvt_close, it's covered by nvt_remove.
> Therefore I don't see any benefit in implementing the open and close
> hooks at all and both functions can be removed.

Hmm... Wouldn't make sense to do the reverse, e. g. only enable the
hardware when it is opened, as otherwise it would be generating
IRQs with IR scan codes without anyone actually listening to them?

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/media/rc/nuvoton-cir.c | 35 -----------------------------------
>  1 file changed, 35 deletions(-)
> 
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 3df3bd9..37fce7b 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -964,39 +964,6 @@ static void nvt_disable_cir(struct nvt_dev *nvt)
>  	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
>  }
>  
> -static int nvt_open(struct rc_dev *dev)
> -{
> -	struct nvt_dev *nvt = dev->priv;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&nvt->nvt_lock, flags);
> -
> -	/* set function enable flags */
> -	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN |
> -			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
> -			  CIR_IRCON);
> -
> -	/* clear all pending interrupts */
> -	nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
> -
> -	/* enable interrupts */
> -	nvt_set_cir_iren(nvt);
> -
> -	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
> -
> -	/* enable the CIR logical device */
> -	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
> -
> -	return 0;
> -}
> -
> -static void nvt_close(struct rc_dev *dev)
> -{
> -	struct nvt_dev *nvt = dev->priv;
> -
> -	nvt_disable_cir(nvt);
> -}
> -
>  /* Allocate memory, probe hardware, and initialize everything */
>  static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  {
> @@ -1075,8 +1042,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  	rdev->priv = nvt;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
> -	rdev->open = nvt_open;
> -	rdev->close = nvt_close;
>  	rdev->tx_ir = nvt_tx_ir;
>  	rdev->s_tx_carrier = nvt_set_tx_carrier;
>  	rdev->input_name = "Nuvoton w836x7hg Infrared Remote Transceiver";


-- 
Thanks,
Mauro
