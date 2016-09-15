Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:42906 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751111AbcIONQB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 09:16:01 -0400
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        andrey_utkin@fastmail.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
Date: Thu, 15 Sep 2016 15:15:53 +0200
MIME-Version: 1.0
In-Reply-To: <20160915130441.ji3f3jiiebsnsbct@acer>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It could be related to the fact that a PCI write may be delayed unless
it is followed by a read (see also the comments in drivers/media/pci/ivtv/ivtv-driver.h).

That was probably the reason for the pci_read_config_word in the reg_write
code. Try putting that back (and just that).

Regards,

	Hans

On 09/15/2016 03:04 PM, Andrey Utkin wrote:
> Hi Krzysztof,
> 
> Me and one more solo6010 board user experience machine lockup when
> solo6x10 module is loaded on kernel series starting with 4.3 (despite
> solo6110 board probes just fine on all kernels). That is, 3.16, 3.18,
> 4.1 and 4.2 are tested and fine, and 4.3, 4.4, and others up to current
> linux-next are bad.
> So regression slipped in between 4.2 and 4.3. The diff between
> stable/linux-4.2.y and ...-4.3.y (which were tested) is not large, and
> my suspect fell on ripoff of register writing procedures complexity,
> which was introduced in e1ceb25a (see below). Reversion of that fixes
> lockup.  However, if, on top of reversion of e1ceb25a, i drop barrier
> stuff and pci_read_config... (see
> https://github.com/bluecherrydvr/linux/commit/d59aaf3), leaving the
> spinlock stuff, it locks up again.  This is a matter in which I'm not
> quite qualified, so I have no idea what that code copes with and why
> this workaround works for solo6010.  For now I think I'll tell the
> customer to use kernel with e1ceb25a reverted, but for upstream fix, I'm
> interested in more in-depth investigation. I'll be able to provide dmesg
> logs a bit later.
> 
> The breaking commit is quoted below.
> 
> commit e1ceb25a1569ce5b61b9c496dd32d038ba8cb936
> Author: Krzysztof Hałasa <khalasa@piap.pl>
> Date:   Mon Jun 8 10:42:24 2015 -0300
> 
>     [media] SOLO6x10: remove unneeded register locking and barriers
>     
>     readl() and writel() are atomic, we don't need the spin lock.
>     Also, flushing posted write buffer isn't required. Especially on read :-)
>     
>     Signed-off-by: Krzysztof Ha?asa <khalasa@piap.pl>
>     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
> index 84627e6..9c948b1 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -483,7 +483,6 @@ static int solo_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	solo_dev->type = id->driver_data;
>  	solo_dev->pdev = pdev;
> -	spin_lock_init(&solo_dev->reg_io_lock);
>  	ret = v4l2_device_register(&pdev->dev, &solo_dev->v4l2_dev);
>  	if (ret)
>  		goto fail_probe;
> diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> index 1ca54b0..27423d7 100644
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -199,7 +199,6 @@ struct solo_dev {
>  	int			nr_ext;
>  	u32			irq_mask;
>  	u32			motion_mask;
> -	spinlock_t		reg_io_lock;
>  	struct v4l2_device	v4l2_dev;
>  
>  	/* tw28xx accounting */
> @@ -281,36 +280,13 @@ struct solo_dev {
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
