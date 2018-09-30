Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:35951 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727818AbeI3QM4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 12:12:56 -0400
Message-ID: <7150c1de00db05ec3c1a53611c156fb823d7f345.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI
 driver
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Josh Wu <josh.wu@atmel.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Date: Sun, 30 Sep 2018 02:40:35 -0700
In-Reply-To: <20180930063034.1dab99d9@coco.lan>
References: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
         <20180930063034.1dab99d9@coco.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-09-30 at 06:30 -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 30 Sep 2018 09:54:48 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > include/media/atmel-isi got removed three years ago without the
> > MAINTAINERS file being updated. Remove the stale entry.
> > 
> > Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform data")
> > Reported-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  MAINTAINERS | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > @@ -2497,7 +2497,6 @@ M:	Ludovic Desroches <ludovic.desroches@microchip.com>
> >  L:	linux-media@vger.kernel.org
> >  S:	Supported
> >  F:	drivers/media/platform/atmel/atmel-isi.c
> > -F:	include/media/atmel-isi.h
> 
> I guess the right fix would be to replace it by:
> 
> F: drivers/media/platform/atmel/atmel-isi.h

Or replace both F entries with:

F:	drivers/media/platform/atmel/atmel-isi.*

Or combine the 2 MICROCHIP sections into one

MICROCHIP ISC DRIVER
M:	Eugen Hristev <eugen.hristev@microchip.com>
L:	linux-media@vger.kernel.org
S:	Supported
F:	drivers/media/platform/atmel/atmel-isc.c
F:	drivers/media/platform/atmel/atmel-isc-regs.h
F:	devicetree/bindings/media/atmel-isc.txt

MICROCHIP ISI DRIVER
M:	Eugen Hristev <eugen.hristev@microchip.com>
L:	linux-media@vger.kernel.org
S:	Supported
F:	drivers/media/platform/atmel/atmel-isi.c
F:	include/media/atmel-isi.h

and maybe use something like:

MICROCHIP MEDIA DRIVERS
M:	Eugen Hristev <eugen.hristev@microchip.com>
L:	
linux-media@vger.kernel.org
S:	Supported
F:	drivers/media/platform/atmel/
F:	devicetree/bindings/media/atmel-isc.txt
