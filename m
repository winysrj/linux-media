Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56598 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbbFNWEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 18:04:07 -0400
Date: Sun, 14 Jun 2015 18:53:17 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SOLO6x10: Remove dead code.
Message-ID: <20150614185317.48b59f39@pirotess>
In-Reply-To: <m3pp56wbq9.fsf@t19.piap.pl>
References: <m3a8waxr86.fsf@t19.piap.pl>
	<m3pp56wbq9.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Jun 2015 15:50:22 +0200
khalasa@piap.pl (Krzysztof Hałasa) wrote:
> solo_dev and pdev cannot be NULL here. It doesn't matter if we
> initialized the PCI device or not.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -134,23 +134,11 @@ static irqreturn_t solo_isr(int irq, void *data)
>  
>  static void free_solo_dev(struct solo_dev *solo_dev)
>  {
> -	struct pci_dev *pdev;
> -
> -	if (!solo_dev)
> -		return;
> +	struct pci_dev *pdev = solo_dev->pdev;
>  
>  	if (solo_dev->dev.parent)
>  		device_unregister(&solo_dev->dev);
>  
> -	pdev = solo_dev->pdev;
> -
> -	/* If we never initialized the PCI device, then nothing else
> -	 * below here needs cleanup */
> -	if (!pdev) {
> -		kfree(solo_dev);
> -		return;
> -	}
> -
>  	if (solo_dev->reg_base) {
>  		/* Bring down the sub-devices first */
>  		solo_g723_exit(solo_dev);
> @@ -164,8 +152,7 @@ static void free_solo_dev(struct solo_dev
> *solo_dev) 
>  		/* Now cleanup the PCI device */
>  		solo_irq_off(solo_dev, ~0);
> -		if (pdev->irq)
> -			free_irq(pdev->irq, solo_dev);
> +		free_irq(pdev->irq, solo_dev);
>  		pci_iounmap(pdev, solo_dev->reg_base);
>  	}
>  

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
