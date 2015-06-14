Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56596 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbbFNV7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 17:59:08 -0400
Date: Sun, 14 Jun 2015 18:52:32 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SOLO6x10: unmap registers only after free_irq().
Message-ID: <20150614185232.74c45282@pirotess>
In-Reply-To: <m3y4juwcc4.fsf@t19.piap.pl>
References: <m3a8waxr86.fsf@t19.piap.pl>
	<m3y4juwcc4.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Jun 2015 15:37:15 +0200
khalasa@piap.pl (Krzysztof Hałasa) wrote:
> Fixes a panic on ARM. Diagnosis by Russell King.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -164,9 +164,9 @@ static void free_solo_dev(struct solo_dev
> *solo_dev) 
>  		/* Now cleanup the PCI device */
>  		solo_irq_off(solo_dev, ~0);
> -		pci_iounmap(pdev, solo_dev->reg_base);
>  		if (pdev->irq)
>  			free_irq(pdev->irq, solo_dev);
> +		pci_iounmap(pdev, solo_dev->reg_base);
>  	}
>  
>  	pci_release_regions(pdev);
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
