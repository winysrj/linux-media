Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:33620 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933629AbdEKQEt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 12:04:49 -0400
Received: by mail-pg0-f52.google.com with SMTP id u187so16781581pgb.0
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 09:04:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m38tm3j0wr.fsf@t19.piap.pl>
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
 <m3d1bhhwf3.fsf_-_@t19.piap.pl> <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
 <m38tm3j0wr.fsf@t19.piap.pl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 11 May 2017 13:04:42 -0300
Message-ID: <CAAEAJfAo8-efB-ZopydXFdRZDKsTKcSzx1vkaJwcpDQQ1Eiivw@mail.gmail.com>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media <linux-media@vger.kernel.org>,
        zhaoxuegang <zhaoxuegang@suntec.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11 May 2017 at 04:41, Krzysztof Ha=C5=82asa <khalasa@piap.pl> wrote:
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:
>
>>> +       /* Initialize vc->dev and vc->ch for the error path first */
>>> +       for (ch =3D 0; ch < max_channels(dev); ch++) {
>>> +               struct tw686x_video_channel *vc =3D &dev->video_channel=
s[ch];
>>> +               vc->dev =3D dev;
>>> +               vc->ch =3D ch;
>>> +       }
>>> +
>>
>> I'm not sure where is the oops this commit fixes, care to explain it to =
me?
>
> The error path apparently calls tw686x_video_free() which requires
> vc->dev to be initialized. Now, the vc->dev is set for the channel being
> currently initialized (unsuccesfully), but not for ones which haven't
> been initialized yet. tw686x_video_free() iterates over the whole set.
>
> It seems it also happens in "memcpy" mode. I didn't test it before since
> on my ARMv7 "memcpy" mode is unusable, it's way too slow. Also, does the
> driver attempt to use consistent memory for entire buffers in this mode?

Yes, memcpy mode allocates a couple P and B dma-coherent bounce
buffers for each channel.

> This may work on i686/x86_64 because the caches are coherent by design
> and there is no difference between consistent and non-consistent RAM
> (if one isn't using SWIOTLB etc).
>
> tw6869: PCI 0000:07:00.0, IRQ 24, MMIO 0x1100000 (memcpy mode)
> tw686x 0000:07:00.0: enabling device (0140 -> 0142)
> tw686x 0000:07:00.0: dma0: unable to allocate P-buffer
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
> PC is at _raw_spin_lock_irqsave+0x10/0x4c
> LR is at tw686x_memcpy_dma_free+0x1c/0x124
> pc : [<805a8b14>]    lr : [<7f04a3c0>]    psr: 20010093
> sp : be915c80  ip : 00000000  fp : bea1b000
> r10: 00000000  r9 : fffffff4  r8 : 0000b000
> r7 : 00000000  r6 : 000003f0  r5 : 00000000  r4 : bf0e21f8
> r3 : 7f04a3a4  r2 : 00000000  r1 : 00000000  r0 : 20010013
> Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: 4e91804a  DAC: 00000051
> Process udevd (pid: 88, stack limit =3D 0xbe914210)
> (_raw_spin_lock_irqsave) from (tw686x_memcpy_dma_free+0x1c/0x124)
> (tw686x_memcpy_dma_free) from (tw686x_video_free+0x50/0x78)
> (tw686x_video_free) from (tw686x_video_init+0x478/0x5e8)
> (tw686x_video_init) from (tw686x_probe+0x36c/0x3fc)
> (tw686x_probe) from (pci_device_probe+0x88/0xf4)
> (pci_device_probe) from (driver_probe_device+0x238/0x2d8)
> (driver_probe_device) from (__driver_attach+0xac/0xb0)
> (__driver_attach) from (bus_for_each_dev+0x6c/0xa0)
> (bus_for_each_dev) from (bus_add_driver+0x1a0/0x218)
> (bus_add_driver) from (driver_register+0x78/0xf8)
> (driver_register) from (do_one_initcall+0x40/0x168)
> (do_one_initcall) from (do_init_module+0x60/0x3a4)
> (do_init_module) from (load_module+0x1c90/0x20e4)
> (load_module) from (SyS_finit_module+0x8c/0x9c)
> (SyS_finit_module) from (ret_fast_syscall+0x0/0x3c)
> Code: e1a02000 e10f0000 f10c0080 f592f000 (e1923f9f)
>
>
> With the patch:
> tw6869: PCI 0000:07:00.0, IRQ 24, MMIO 0x1100000 (memcpy mode)
> tw686x 0000:07:00.0: enabling device (0140 -> 0142)
> tw686x 0000:07:00.0: dma0: unable to allocate P-buffer
> tw686x 0000:07:00.0: can't register video
> tw686x: probe of 0000:07:00.0 failed with error -12

Oh, I see. Thanks for the details!

How about this one (untested) ?

diff --git a/drivers/media/pci/tw686x/tw686x-video.c
b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa97b2d0..77b8d2dbd995 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -86,6 +86,9 @@ static void tw686x_memcpy_dma_free(struct
tw686x_video_channel *vc,
        struct pci_dev *pci_dev;
        unsigned long flags;

+       /* Make sure this channel is initialized */
+       if (!dev)
+               return;
        /* Check device presence. Shouldn't really happen! */
        spin_lock_irqsave(&dev->lock, flags);
        pci_dev =3D dev->pci_dev;

Also, when submitting a patch please make sure you write a commit
log. Only trivial patches can have empty commit logs.

The description you made in your last mail is perfect,
including the oops details, the backtrace and
the "With the patch" note. Doing a `git log --grep=3D"fix.*oops"`
might give you some ideas on commit logs.

The subject of the patch should be:

"tw686x: Fix oops on buffer alloc failure"

If you `git log` on tw686x, you'll notice all the
commits use "tw686x" prefix.

When submitting fixes, it's useful to add a "Fixes" tag.
See https://static.lwn.net/kerneldoc/process/submitting-patches.html
for details.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
