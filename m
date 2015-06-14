Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56597 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbFNWEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 18:04:07 -0400
Date: Sun, 14 Jun 2015 18:53:47 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SOLO6x10: remove unneeded register locking and
 barriers.
Message-ID: <20150614185347.5c12ccf0@pirotess>
In-Reply-To: <m3twuiwc3j.fsf@t19.piap.pl>
References: <m3a8waxr86.fsf@t19.piap.pl>
	<m3twuiwc3j.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Jun 2015 15:42:24 +0200
khalasa@piap.pl (Krzysztof Hałasa) wrote:
> readl() and writel() are atomic, we don't need the spin lock.
> Also, flushing posted write buffer isn't required. Especially on
> read :-)
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -483,7 +483,6 @@ static int solo_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id) 
>  	solo_dev->type = id->driver_data;
>  	solo_dev->pdev = pdev;
> -	spin_lock_init(&solo_dev->reg_io_lock);
>  	ret = v4l2_device_register(&pdev->dev, &solo_dev->v4l2_dev);
>  	if (ret)
>  		goto fail_probe;
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -201,7 +201,6 @@ struct solo_dev {
>  	int			nr_ext;
>  	u32			irq_mask;
>  	u32			motion_mask;
> -	spinlock_t		reg_io_lock;
>  	struct v4l2_device	v4l2_dev;
>  
>  	/* tw28xx accounting */
> @@ -283,36 +282,13 @@ struct solo_dev {
>  
>  static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
>  {
> -	unsigned long flags;
> -	u32 ret;
> -	u16 val;
> -
> -	spin_lock_irqsave(&solo_dev->reg_io_lock, flags);
> -
> -	ret = readl(solo_dev->reg_base + reg);
> -	rmb();
> -	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
> -	rmb();
> -
> -	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);
> -
> -	return ret;
> +	return readl(solo_dev->reg_base + reg);
>  }
>  
>  static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
>  				  u32 data)
>  {
> -	unsigned long flags;
> -	u16 val;
> -
> -	spin_lock_irqsave(&solo_dev->reg_io_lock, flags);
> -
>  	writel(data, solo_dev->reg_base + reg);
> -	wmb();
> -	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
> -	rmb();
> -
> -	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);
>  }
>  
>  static inline void solo_irq_on(struct solo_dev *dev, u32 mask)

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
