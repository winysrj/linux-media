Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33695 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbcBYH5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 02:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <20160225003243.GA12961@verge.net.au>
References: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
	<CAMuHMdUwvgaLtLLSk7jdg1N7mafpGz0VsikhbcFsuGQDHAunVw@mail.gmail.com>
	<20160224235619.GA5936@verge.net.au>
	<20160225003243.GA12961@verge.net.au>
Date: Thu, 25 Feb 2016 08:57:15 +0100
Message-ID: <CAMuHMdUZTkJqTrskW=3_m1UufxjDaf8EF=gz_+NT07DDvkw2Vg@mail.gmail.com>
Subject: Re: [PATCH] media: platform: rcar_jpu, sh_vou, vsp1: Use ARCH_RENESAS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Thu, Feb 25, 2016 at 1:32 AM, Simon Horman <horms@verge.net.au> wrote:
> On Thu, Feb 25, 2016 at 08:56:22AM +0900, Simon Horman wrote:
>> On Wed, Feb 24, 2016 at 08:46:31AM +0100, Geert Uytterhoeven wrote:
>> > On Wed, Feb 24, 2016 at 3:22 AM, Simon Horman
>> > <horms+renesas@verge.net.au> wrote:
>> > > Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
>> > >
>> > > This is part of an ongoing process to migrate from ARCH_SHMOBILE to
>> > > ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
>> > > appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
>> > >
>> > > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>> > > ---
>> > >  drivers/media/platform/Kconfig | 6 +++---
>> > >  1 file changed, 3 insertions(+), 3 deletions(-)
>> > >
>> > >  Based on media_tree/master
>> > >
>> > > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> > > index 201f5c296a95..662c029400de 100644
>> > > --- a/drivers/media/platform/Kconfig
>> > > +++ b/drivers/media/platform/Kconfig
>> > > @@ -37,7 +37,7 @@ config VIDEO_SH_VOU
>> > >         tristate "SuperH VOU video output driver"
>> > >         depends on MEDIA_CAMERA_SUPPORT
>> > >         depends on VIDEO_DEV && I2C && HAS_DMA
>> > > -       depends on ARCH_SHMOBILE || COMPILE_TEST
>> > > +       depends on ARCH_RENESAS || COMPILE_TEST
>> >
>> > This driver is used on sh7722/sh7723/sh7724 only.
>> > While these are Renesas parts, ARCH_RENESAS isn't set for SuperH SoCs,
>> > making this driver unavailable where needed.
>>
>> Thanks for pointing that out, I had missed that detail.
>>
>> Ideally I would like to stop setting ARCH_SHMOBILE for ARM Based
>> SoCs. So perhaps the following would be best?
>>
>>       depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST
>
> Sorry, I think I misread your comment. If the driver is not
> used by any ARM Based SoCs then perhaps this patch should be simply
> withdrawn.

Just the first chunk. If you drop that one, you can have my

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
