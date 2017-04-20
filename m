Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:35488 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032197AbdDTOMs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 10:12:48 -0400
Received: by mail-yb0-f176.google.com with SMTP id 6so26093132ybq.2
        for <linux-media@vger.kernel.org>; Thu, 20 Apr 2017 07:12:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOxqCCT6MOCLG+HHsuOU0zoq1zxRRJNFn0DYz9tOj-ez7+BNRA@mail.gmail.com>
References: <CAOxqCCT6MOCLG+HHsuOU0zoq1zxRRJNFn0DYz9tOj-ez7+BNRA@mail.gmail.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 20 Apr 2017 11:12:47 -0300
Message-ID: <CAAEAJfC0MdO2Uy8P0OajRHEc3seUiwLv0qqxLzM3b9eFFfuk8g@mail.gmail.com>
Subject: Re: TW686x Linux Main Line Driver Issue
To: Anuradha Ranasinghe <anuradha@tengriaero.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Lakshitha Dayasena <lakshitha@tengriaero.com>,
        Krishan Nilanga <krishan@tengriaero.com>,
        linux-pci@vger.kernel.org, l.stach@pengutronix.de,
        Richard.Zhu@freescale.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 April 2017 at 07:10, Anuradha Ranasinghe <anuradha@tengriaero.com> wr=
ote:
> Dear All,
>
> This issue is associated to the Linux Mainline Kernel 4.1.15.2 (branch2)
> tw686x upstream driver and IMX6Q platform.
>
> We have an analog camera capture board (a custom one) based around tw6865=
.
> We are interfacing it with Nitrogen6_Max board (IMX6Q) . We use the
> aforementioned kernel with the boundary devices latest patches to the tw6=
86x
> driver (having 3 DMA buffers) and system running on Ubuntu 16 Xenial Mate
> version.
> https://github.com/boundarydevices/linux-imx6/commits/7fcd22da6d731b36e5a=
b856551c41301fca9881f
>
> The driver initialization, device and composite signal detection work wel=
l
> as intended. But when the streaming started, frame rate becomes lower and
> after few frames, the whole system freezes. To get the camera to work to
> this level, we had to do :
>

What dma-mode are you using? Have you tried other dma-modes?

How many frames do you manage to obtain? I believe you should
debug this further and provide more information.

> 1. Disable PCI interrupts from the kernel (from menuconfig and pci=3Dnoms=
i
> kernel command)

(CCing PCI people) Lucas, Richard: any idea about why is this parameter nee=
ded?

> 2. Set Coherent_Pool to 128M in boot args to get the memory allocation fo=
r
> driver. Without this driver does not enumerate.
>

Hm.. interesting.

> I can confirm that there is no issue in our hardware. I strictly followed
> the free scale data sheet recommendations. So I have few questions needin=
g
> your answers :
>
>> Have you guys tried this driver for tw6865 or a related chip on same roo=
t
>> fs ? If not can you kindly mention the operating condition you had ?

FWIW, I have tested tw6869 on x86_64. It works well here, but only
using dma-mode=3Dmemcpy, as documented here:

http://lxr.free-electrons.com/source/drivers/media/pci/tw686x/tw686x-core.c=
#L19

>> Is attached patch required for higher kernel versions (4.1.15) to suppor=
t
>> DMA accessing ?

I have no idea about that patch. The patch has nothing to do with tw686x,
but it's i.MX6 platform-specific, you should ask the author.

>> Is there any additional settings (cma allocation, memory mapping) requir=
ed
>> for this newer kernel ?

That depends on your platform and usage.

>> I use the pipeline :
> gst-launch-1.0 v4l2src device=3D/dev/video0 ! video/x-raw,width=3D720,hei=
ght=3D480
> ! autovideosink
> for an unknown reason, imxv4l2videosrc does not work at all for this pcie
> camera.
>

You need to ask imxv4l2videosrc's authors.

--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
