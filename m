Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBF8aZC1023109
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:39:07 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBF8BI9M029565
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 03:11:18 -0500
Date: Mon, 15 Dec 2008 08:44:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30812141840v50214099n43891d18f5b9acfa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812150828140.3722@axis700.grange>
References: <20081210074435.5727.93374.sendpatchset@rx1.opensource.se>
	<20081210074450.5727.83002.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0812132244130.10954@axis700.grange>
	<aec7e5c30812141840v50214099n43891d18f5b9acfa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 02/03] sh_mobile_ceu: add NV12 and NV21 support
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

On Mon, 15 Dec 2008, Magnus Damm wrote:

> On Sun, Dec 14, 2008 at 6:52 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Wed, 10 Dec 2008, Magnus Damm wrote:
> >> This patch adds NV12/NV21 support to the sh_mobile_ceu driver.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> >> ---
> >>
> >>  drivers/media/video/sh_mobile_ceu_camera.c |  114 ++++++++++++++++++++++++----
> >>  1 file changed, 99 insertions(+), 15 deletions(-)
> >>
> >> --- 0031/drivers/media/video/sh_mobile_ceu_camera.c
> >> +++ work/drivers/media/video/sh_mobile_ceu_camera.c   2008-12-10 13:09:43.000000000 +0900
> >> @@ -158,6 +160,9 @@ static void free_buffer(struct videobuf_
> >>
> >>  static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
> >>  {
> >> +     struct soc_camera_device *icd = pcdev->icd;
> >> +     unsigned long phys_addr;
> >
> > dma_addr_t
> 
> Yeah, good plan.
> 
> >> +
> >>       ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~1);
> >>       ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & 0x0317f313);
> >>       ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | 1);
> >> @@ -166,11 +171,21 @@ static void sh_mobile_ceu_capture(struct
> >>
> >>       ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
> >>
> >> -     if (pcdev->active) {
> >> -             pcdev->active->state = VIDEOBUF_ACTIVE;
> >> -             ceu_write(pcdev, CDAYR, videobuf_to_dma_contig(pcdev->active));
> >> -             ceu_write(pcdev, CAPSR, 0x1); /* start capture */
> >> +     if (!pcdev->active)
> >> +             return;
> >> +
> >> +     phys_addr = videobuf_to_dma_contig(pcdev->active);
> >> +     ceu_write(pcdev, CDAYR, phys_addr);
> >
> > Hm, looks like someone could have reviewed this driver a bit better on
> > submission:-) I think, your ceu_write() should really take a u32 as an
> > argument, not unsigned long, respectively, ceu_read() should return u32.
> 
> Well, to fit nicely together with ioread32() and iowrite32() i suppose
> u32 is a better fit. Otoh, both u32 and unsigned longs are 32-bit on
> regular 32-bit SuperH unless I'm mistaken.

Yes, they would be, still, it is cleaner to use the same type, not just 
one that happens to mean the same:-)

> > So there is even less motivation for "unsigned long phys_addr" above. A
> > patch to change these functions would be welcome:-)
> 
> Usually physically addresses are kept as unsigned longs in the kernel.
> That's the reason behind the unsigned longs. The best would of course
> be to use an unsigned long to keep a pfn, but I'd say having an
> unsigned long to keep the physical address as-is is close enough since
> the hardware is using 32-bit registers for destination addresses
> anyway. dma_addr_t sounds like a good plan though.

I usually try to select variable types to match their use - either to 
store return values from functions, or to match argument types if they are 
used as arguments to functions. phys_addr is used first to store return 
from videobuf_to_dma_contig(), which is dma_addr_t, then as an argument to 
ceu_write(), which after your clean-up will be u32. And it is also used in 
calculations:

> +		phys_addr += (icd->width * icd->height);

I think, dma_addr_t is never smaller than 32-bit, so, it sort of makes 
sense to first use it to make sure all calculations fit, and then 
(implicitly) truncate it to u32 when passing as an argument to 
ceu_write().

> I agree about the parenthesis issues - I'll suspect I used them
> because of compiler warnings, but I'll have a look.

Definitly not all of them.

> I will post a cleanup patch that you can apply on top of this patch
> and the interlace patch. This to avoid changing the interlace patch.

Hm, yeah... Ok, let's do that, but then, please, also fix extra 
parenthesis that that patch introduces, ok?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
