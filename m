Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1F3TJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 15:09:46 -0400
Received: by bwd5 with SMTP id 5so2069394bwd.19
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2011 12:09:45 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
Date: Thu, 30 Jun 2011 22:10:22 +0300
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Kusanagi Kouichi <slash@ac.auone-net.jp>,
	Steven Toth <stoth@linuxtv.org>
References: <1309384173-12933-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1309384173-12933-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106302210.22361.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 30 июня 2011 00:49:33 автор Jarod Wilson написал:
> This reverts commit e38030f3ff02684eb9e25e983a03ad318a10a2ea.
> 
> MSI flat-out doesn't work right on cx2388x devices yet. There are now
> multiple reports of cards that hard-lock systems when MSI is enabled,
> including my own HVR-1250 when trying to use its built-in IR receiver.
> Disable MSI and it works just fine. Similar for another user's HVR-1270.
> Issues have also been reported with the HVR-1850 when MSI is enabled,
> and the 1850 behavior sounds similar to an as-yet-undiagnosed issue I've
> seen with an 1800.
> 
> References:
> 
> http://www.spinics.net/lists/linux-media/msg25956.html
> http://www.spinics.net/lists/linux-media/msg33676.html
> http://www.spinics.net/lists/linux-media/msg34734.html
It's chronic problem now ...
http://www.spinics.net/lists/linux-media/msg22494.html

And how I cure it for particular card.
http://www.spinics.net/lists/linux-media/msg28334.html

Now I see, to revert commit e38030f3ff02684eb9e25e983a03ad318a10a2ea is a 
necessity.

> 
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: Kusanagi Kouichi <slash@ac.auone-net.jp>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/cx23885/cx23885-core.c
> b/drivers/media/video/cx23885/cx23885-core.c index 64d9b21..419777a 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -2060,12 +2060,8 @@ static int __devinit cx23885_initdev(struct pci_dev
> *pci_dev, goto fail_irq;
>  	}
> 
> -	if (!pci_enable_msi(pci_dev))
> -		err = request_irq(pci_dev->irq, cx23885_irq,
> -				  IRQF_DISABLED, dev->name, dev);
> -	else
> -		err = request_irq(pci_dev->irq, cx23885_irq,
> -				  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
> +	err = request_irq(pci_dev->irq, cx23885_irq,
> +			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
>  	if (err < 0) {
>  		printk(KERN_ERR "%s: can't get IRQ %d\n",
>  		       dev->name, pci_dev->irq);
> @@ -2114,7 +2110,6 @@ static void __devexit cx23885_finidev(struct pci_dev
> *pci_dev)
> 
>  	/* unregister stuff */
>  	free_irq(pci_dev->irq, dev);
> -	pci_disable_msi(pci_dev);
> 
>  	cx23885_dev_unregister(dev);
>  	v4l2_device_unregister(v4l2_dev);

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
