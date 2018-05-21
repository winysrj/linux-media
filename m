Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53993 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752920AbeEUPyI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 11:54:08 -0400
Date: Mon, 21 May 2018 16:54:07 +0100
From: Sean Young <sean@mess.org>
To: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/3] media: rc: nuvoton: Tweak the interrupt enabling
 dance
Message-ID: <20180521155406.i5w4flucxrudblda@gofer.mess.org>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180521143803.25664-1-michal.winiarski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 04:38:01PM +0200, Michał Winiarski wrote:
> It appears that we need to enable CIR device before attempting to touch
> some of the registers. Previously, this was not a big issue, since we
> were rarely seeing nvt_close() getting called.
> 
> Unfortunately, since:
> cb84343fced1 ("media: lirc: do not call close() or open() on unregistered devices")
> 
> The initial open() during probe from rc_setup_rx_device() is no longer
> successful, which means that userspace clients will actually end up
> calling nvt_open()/nvt_close().
> And since nvt_open() is broken, the device doesn't seem to work as
> expected.

Since that commit was in v4.16, should we have the following:

Cc: stable@vger.kernel.org # v4.16+

On this commit (and not the other two, if I understand them correctly)?

Thanks,
Sean

> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199597
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/nuvoton-cir.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 5e1d866a61a5..ce8949b6549d 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -922,6 +922,9 @@ static int nvt_open(struct rc_dev *dev)
>  	struct nvt_dev *nvt = dev->priv;
>  	unsigned long flags;
>  
> +	/* enable the CIR logical device */
> +	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
> +
>  	spin_lock_irqsave(&nvt->lock, flags);
>  
>  	/* set function enable flags */
> @@ -937,9 +940,6 @@ static int nvt_open(struct rc_dev *dev)
>  
>  	spin_unlock_irqrestore(&nvt->lock, flags);
>  
> -	/* enable the CIR logical device */
> -	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
> -
>  	return 0;
>  }
>  
> -- 
> 2.17.0
