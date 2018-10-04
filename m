Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51214 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJEDAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:00:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
        Joe Perches <joe@perches.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
        Songjun Wu <songjun.wu@microchip.com>
Subject: Re: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI driver
Date: Thu, 04 Oct 2018 23:06:02 +0300
Message-ID: <2765176.U2F9enn0ho@avalon>
In-Reply-To: <20181004154505.0be5f857@coco.lan>
References: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com> <20181002063547.ul7htrd54x7iksxy@M43218.corp.atmel.com> <20181004154505.0be5f857@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 4 October 2018 21:45:05 EEST Mauro Carvalho Chehab wrote:
> Em Tue, 2 Oct 2018 08:35:47 +0200 Ludovic Desroches escreveu:
> > On Mon, Oct 01, 2018 at 01:51:01PM -0300, Mauro Carvalho Chehab wrote:
> > > Em Sun, 30 Sep 2018 02:40:35 -0700 Joe Perches escreveu:
> > > > On Sun, 2018-09-30 at 06:30 -0300, Mauro Carvalho Chehab wrote:
> > > > > Em Sun, 30 Sep 2018 09:54:48 +0300 Laurent Pinchart escreveu:
> > > > > > include/media/atmel-isi got removed three years ago without the
> > > > > > MAINTAINERS file being updated. Remove the stale entry.
> > > > > > 
> > > > > > Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for
> > > > > > platform data") Reported-by: Joe Perches <joe@perches.com>
> > > > > > Signed-off-by: Laurent Pinchart
> > > > > > <laurent.pinchart@ideasonboard.com>
> > > > > > ---
> > > > > > 
> > > > > >  MAINTAINERS | 1 -
> > > > > >  1 file changed, 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > 
> > > > []
> > > > 
> > > > > > @@ -2497,7 +2497,6 @@ M:	Ludovic Desroches
> > > > > > <ludovic.desroches@microchip.com>> > > > > 
> > > > > >  L:	linux-media@vger.kernel.org
> > > > > >  S:	Supported
> > > > > >  F:	drivers/media/platform/atmel/atmel-isi.c
> > > > > > 
> > > > > > -F:	include/media/atmel-isi.h
> > > > > 
> > > > > I guess the right fix would be to replace it by:
> > > > > 
> > > > > F: drivers/media/platform/atmel/atmel-isi.h
> > > > 
> > > > Or replace both F entries with:
> > > > 
> > > > F:	drivers/media/platform/atmel/atmel-isi.*
> > > > 
> > > > Or combine the 2 MICROCHIP sections into one
> > > > 
> > > > MICROCHIP ISC DRIVER
> > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > L:	linux-media@vger.kernel.org
> > > > S:	Supported
> > > > F:	drivers/media/platform/atmel/atmel-isc.c
> > > > F:	drivers/media/platform/atmel/atmel-isc-regs.h
> > > > F:	devicetree/bindings/media/atmel-isc.txt
> > > > 
> > > > MICROCHIP ISI DRIVER
> > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > L:	linux-media@vger.kernel.org
> > > > S:	Supported
> > > > F:	drivers/media/platform/atmel/atmel-isi.c
> > > > F:	include/media/atmel-isi.h
> > > > 
> > > > and maybe use something like:
> > > > 
> > > > MICROCHIP MEDIA DRIVERS
> > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > L:
> > > > linux-media@vger.kernel.org
> > > > S:	Supported
> > > > F:	drivers/media/platform/atmel/
> > > > F:	devicetree/bindings/media/atmel-isc.txt
> > > 
> > > Yeah, combining both of them seems a good alternative to me.
> > > 
> > > Eugen/Ludovic/Josh,
> > > 
> > > Comments?
> > 
> > I have no strong opinion about it. The devices are different but usually
> > there is one person per topic so combining them makes sense.
> 
> Hmm... At media tree, currently, MAINTAINERS entry is different:
> 
> MICROCHIP / ATMEL ISC DRIVER
> M:	Songjun Wu <songjun.wu@microchip.com>
> L:	linux-media@vger.kernel.org
> S:      Supported
> F:      drivers/media/platform/atmel/atmel-isc.c
> F:      drivers/media/platform/atmel/atmel-isc-regs.h
> F:	devicetree/bindings/media/atmel-isc.txt
> 
> ATMEL ISI DRIVER
> M:	Ludovic Desroches <ludovic.desroches@microchip.com>
> L:	linux-media@vger.kernel.org
> S:      Supported
> F:      drivers/media/platform/atmel/atmel-isi.c
> F:      include/media/atmel-isi.h
> 
> Maybe some patch upstream did some recent changes on it via another
> tree.
> 
> So, in order to avoid conflicts upstream, for now I would just correct
> the location for the ISI file.
> 
> After the merge window, we may revisit and join both entries,
> if the maintainers are the same.

Fine with me.

> -
> 
> MAINTAINERS: fix location for atmel-isi.h file
> 
> The location of this file got changed by changeset 40a78f36fc92
> ("[media] v4l: atmel-isi: Remove support for platform data"), but
> MAINTAINERS was not updated accordingly.
> 
> Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform
> data") Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

I don't care about patch count statistics, but the usual practice is to retain 
the authorship of the original submitter. This is especially important with 
patches submitted by new or less frequent contributors, as recognition of 
their work is sometimes the only thing they get (and it doesn't hurt with 
regular contributors either).

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9989925f658d..385ebe9ca0a2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2496,8 +2496,7 @@ ATMEL ISI DRIVER
>  M:	Ludovic Desroches <ludovic.desroches@microchip.com>
>  L:	linux-media@vger.kernel.org
>  S:	Supported
> -F:	drivers/media/platform/atmel/atmel-isi.c
> -F:	include/media/atmel-isi.h
> +F:	drivers/media/platform/atmel/atmel-isi.*
> 
>  ATMEL LCDFB DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@microchip.com>

-- 
Regards,

Laurent Pinchart
