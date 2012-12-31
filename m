Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2LaUmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 15:42:17 -0500
Date: Mon, 31 Dec 2012 18:41:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] blackfin Kconfig: select is evil; use, instead
 depends on
Message-ID: <20121231184146.6d08156f@redhat.com>
In-Reply-To: <CAHG8p1A2VS8iHsb3PxhVh_CV9bXoob6BXcRNUwLudTgkhPY1Pw@mail.gmail.com>
References: <1356651129-19695-1-git-send-email-mchehab@redhat.com>
	<CAHG8p1A2VS8iHsb3PxhVh_CV9bXoob6BXcRNUwLudTgkhPY1Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Dec 2012 17:41:25 +0800
Scott Jiang <scott.jiang.linux@gmail.com> escreveu:

> 2012/12/28 Mauro Carvalho Chehab <mchehab@redhat.com>:
> > Select is evil as it has issues with dependencies. Better to convert
> > it to use depends on.
> >
> > That fixes a breakage with out-of-tree compilation of the media
> > tree.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/media/platform/blackfin/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
> > index 519990e..cc23997 100644
> > --- a/drivers/media/platform/blackfin/Kconfig
> > +++ b/drivers/media/platform/blackfin/Kconfig
> > @@ -2,7 +2,6 @@ config VIDEO_BLACKFIN_CAPTURE
> >         tristate "Blackfin Video Capture Driver"
> >         depends on VIDEO_V4L2 && BLACKFIN && I2C
> >         select VIDEOBUF2_DMA_CONTIG
> > -       select VIDEO_BLACKFIN_PPI
> >         help
> >           V4L2 bridge driver for Blackfin video capture device.
> >           Choose PPI or EPPI as its interface.
> > @@ -12,3 +11,5 @@ config VIDEO_BLACKFIN_CAPTURE
> >
> >  config VIDEO_BLACKFIN_PPI
> >         tristate
> > +       depends on VIDEO_BLACKFIN_CAPTURE
> > +       default VIDEO_BLACKFIN_CAPTURE
> > --
> 
> There are other drivers select this module.
> 
> config VIDEO_BLACKFIN_DISPLAY
>         tristate "Blackfin Video Display Driver"
>         depends on VIDEO_V4L2 && BLACKFIN && I2C
>         select VIDEOBUF2_DMA_CONTIG
>         select VIDEO_BLACKFIN_PPI
> 
> So should I move all other drivers to the depend on list?

Hmm... I didn't notice.

Yes, using depends on generally better, as it warrants that all
dependencies are properly parsed.

> 
> Scott


-- 

Cheers,
Mauro
