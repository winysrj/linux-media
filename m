Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61878 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1F2W6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 18:58:45 -0400
Received: by vws1 with SMTP id 1so1242968vws.19
        for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 15:58:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309384173-12933-1-git-send-email-jarod@redhat.com>
References: <1309384173-12933-1-git-send-email-jarod@redhat.com>
From: Dark Shadow <shadowofdarkness@gmail.com>
Date: Wed, 29 Jun 2011 16:58:24 -0600
Message-ID: <BANLkTinL33p=bShbB70y7fJLCxyhgcWy=w@mail.gmail.com>
Subject: Re: [PATCH] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Kusanagi Kouichi <slash@ac.auone-net.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 29, 2011 at 3:49 PM, Jarod Wilson <jarod@redhat.com> wrote:
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
>
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: Kusanagi Kouichi <slash@ac.auone-net.jp>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/video/cx23885/cx23885-core.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
> index 64d9b21..419777a 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -2060,12 +2060,8 @@ static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
>                goto fail_irq;
>        }
>
> -       if (!pci_enable_msi(pci_dev))
> -               err = request_irq(pci_dev->irq, cx23885_irq,
> -                                 IRQF_DISABLED, dev->name, dev);
> -       else
> -               err = request_irq(pci_dev->irq, cx23885_irq,
> -                                 IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
> +       err = request_irq(pci_dev->irq, cx23885_irq,
> +                         IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
>        if (err < 0) {
>                printk(KERN_ERR "%s: can't get IRQ %d\n",
>                       dev->name, pci_dev->irq);
> @@ -2114,7 +2110,6 @@ static void __devexit cx23885_finidev(struct pci_dev *pci_dev)
>
>        /* unregister stuff */
>        free_irq(pci_dev->irq, dev);
> -       pci_disable_msi(pci_dev);
>
>        cx23885_dev_unregister(dev);
>        v4l2_device_unregister(v4l2_dev);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Tested and it fixed my HVR-1270 IR. I also tested a couple minutes of
live TV and it still works.
