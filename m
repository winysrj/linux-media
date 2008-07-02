Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62KghTS010327
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 16:42:43 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62KgUjI021727
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 16:42:30 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Burns <linux-dvb@adslpipe.co.uk>
In-Reply-To: <486BA3AE.1020808@adslpipe.co.uk>
References: <486A6F0F.7090507@adslpipe.co.uk>
	<486B9630.1080100@adslpipe.co.uk>	<200807021712.53659.zzam@gentoo.org>
	<486BA03D.4040904@adslpipe.co.uk>  <486BA3AE.1020808@adslpipe.co.uk>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 22:39:35 +0200
Message-Id: <1215031175.2624.7.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Linux DVB List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

Am Mittwoch, den 02.07.2008, 16:50 +0100 schrieb Andy Burns:
> The saa7134 driver attempts to map a fixed 4K starting from the base 
> address of its mmio area, regardless of the actual size of the area.
> Any excessive mapping may extend past the end of a page, which goes 
> un-noticed on bare-metal, but is detected and denied when the card is 
> used with pci passthrough to a xen domU. If shared IRQ is used the 
> "pollirq" kernel option may be required in dom0.

just a note.

We have some recent remotes sampling from IRQs triggered by a gpio pin
without any additional IR chip.

There are some reports that "pollirq" makes them unusable, since
sensible timings are lost.

No such reports from xen stuff yet, but the same might happen with
shared IRQs and "pollirq" there too.

Cheers,
Hermann


> Signed-off-by: Andy Burns <andy@burns.net>
> ---- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01 
> 16:46:49.000000000 +0100
> +++ drivers/media/video/saa7134/saa7134-core.c  2008-07-02 
> 16:41:37.000000000 +0100
> @@ -908,7 +908,8 @@
>                         dev->name,(unsigned long 
> long)pci_resource_start(pci_dev,0));
>                  goto fail1;
>          }
> -       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
> +       dev->lmmio = ioremap(pci_resource_start(pci_dev,0),
> +                             pci_resource_len(pci_dev,0));
>          dev->bmmio = (__u8 __iomem *)dev->lmmio;
>          if (NULL == dev->lmmio) {
>                  err = -EIO;
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
