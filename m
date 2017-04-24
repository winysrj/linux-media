Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35365 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1168699AbdDXKi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 06:38:57 -0400
Message-ID: <1493030334.2891.7.camel@pengutronix.de>
Subject: Re: TW686x Linux Main Line Driver Issue
From: Lucas Stach <l.stach@pengutronix.de>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Anuradha Ranasinghe <anuradha@tengriaero.com>,
        linux-media <linux-media@vger.kernel.org>,
        Lakshitha Dayasena <lakshitha@tengriaero.com>,
        Krishan Nilanga <krishan@tengriaero.com>,
        linux-pci@vger.kernel.org, Richard.Zhu@freescale.com
Date: Mon, 24 Apr 2017 12:38:54 +0200
In-Reply-To: <CAAEAJfC0MdO2Uy8P0OajRHEc3seUiwLv0qqxLzM3b9eFFfuk8g@mail.gmail.com>
References: <CAOxqCCT6MOCLG+HHsuOU0zoq1zxRRJNFn0DYz9tOj-ez7+BNRA@mail.gmail.com>
         <CAAEAJfC0MdO2Uy8P0OajRHEc3seUiwLv0qqxLzM3b9eFFfuk8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 20.04.2017, 11:12 -0300 schrieb Ezequiel Garcia:
> On 20 April 2017 at 07:10, Anuradha Ranasinghe <anuradha@tengriaero.com> wrote:
> > Dear All,
> >
> > This issue is associated to the Linux Mainline Kernel 4.1.15.2 (branch2)
> > tw686x upstream driver and IMX6Q platform.
> >
> > We have an analog camera capture board (a custom one) based around tw6865.
> > We are interfacing it with Nitrogen6_Max board (IMX6Q) . We use the
> > aforementioned kernel with the boundary devices latest patches to the tw686x
> > driver (having 3 DMA buffers) and system running on Ubuntu 16 Xenial Mate
> > version.
> > https://github.com/boundarydevices/linux-imx6/commits/7fcd22da6d731b36e5ab856551c41301fca9881f
> >
> > The driver initialization, device and composite signal detection work well
> > as intended. But when the streaming started, frame rate becomes lower and
> > after few frames, the whole system freezes. To get the camera to work to
> > this level, we had to do :
> >
> 
> What dma-mode are you using? Have you tried other dma-modes?
> 
> How many frames do you manage to obtain? I believe you should
> debug this further and provide more information.
> 
> > 1. Disable PCI interrupts from the kernel (from menuconfig and pci=nomsi
> > kernel command)
> 
> (CCing PCI people) Lucas, Richard: any idea about why is this parameter needed?

Does the device support MSI IRQs?

If it only supports legacy IRQs this might be a known issue, where
legacy IRQs won't work with the designware host controller if MSI IRQs
are configured. I'm working on a patch to get around this issue.

Regards,
Lucas
