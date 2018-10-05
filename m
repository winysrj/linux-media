Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbeJFBl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 21:41:27 -0400
Date: Fri, 5 Oct 2018 15:41:21 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
        Joe Perches <joe@perches.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
        Songjun Wu <songjun.wu@microchip.com>
Subject: Re: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI
 driver
Message-ID: <20181005154121.3af4eb39@coco.lan>
In-Reply-To: <2765176.U2F9enn0ho@avalon>
References: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
        <20181002063547.ul7htrd54x7iksxy@M43218.corp.atmel.com>
        <20181004154505.0be5f857@coco.lan>
        <2765176.U2F9enn0ho@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Oct 2018 23:06:02 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday, 4 October 2018 21:45:05 EEST Mauro Carvalho Chehab wrote:
> > Em Tue, 2 Oct 2018 08:35:47 +0200 Ludovic Desroches escreveu:  
> > > On Mon, Oct 01, 2018 at 01:51:01PM -0300, Mauro Carvalho Chehab wrote:  
> > > > Em Sun, 30 Sep 2018 02:40:35 -0700 Joe Perches escreveu:  
> > > > > On Sun, 2018-09-30 at 06:30 -0300, Mauro Carvalho Chehab wrote:  
> > > > > > Em Sun, 30 Sep 2018 09:54:48 +0300 Laurent Pinchart escreveu:  
> > > > > > > include/media/atmel-isi got removed three years ago without the
> > > > > > > MAINTAINERS file being updated. Remove the stale entry.
> > > > > > > 
> > > > > > > Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for
> > > > > > > platform data") Reported-by: Joe Perches <joe@perches.com>
> > > > > > > Signed-off-by: Laurent Pinchart
> > > > > > > <laurent.pinchart@ideasonboard.com>
> > > > > > > ---
> > > > > > > 
> > > > > > >  MAINTAINERS | 1 -
> > > > > > >  1 file changed, 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/MAINTAINERS b/MAINTAINERS  
> > > > > 
> > > > > []
> > > > >   
> > > > > > > @@ -2497,7 +2497,6 @@ M:	Ludovic Desroches
> > > > > > > <ludovic.desroches@microchip.com>> > > > > 
> > > > > > >  L:	linux-media@vger.kernel.org
> > > > > > >  S:	Supported
> > > > > > >  F:	drivers/media/platform/atmel/atmel-isi.c
> > > > > > > 
> > > > > > > -F:	include/media/atmel-isi.h  
> > > > > > 
> > > > > > I guess the right fix would be to replace it by:
> > > > > > 
> > > > > > F: drivers/media/platform/atmel/atmel-isi.h  
> > > > > 
> > > > > Or replace both F entries with:
> > > > > 
> > > > > F:	drivers/media/platform/atmel/atmel-isi.*
> > > > > 
> > > > > Or combine the 2 MICROCHIP sections into one
> > > > > 
> > > > > MICROCHIP ISC DRIVER
> > > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > > L:	linux-media@vger.kernel.org
> > > > > S:	Supported
> > > > > F:	drivers/media/platform/atmel/atmel-isc.c
> > > > > F:	drivers/media/platform/atmel/atmel-isc-regs.h
> > > > > F:	devicetree/bindings/media/atmel-isc.txt
> > > > > 
> > > > > MICROCHIP ISI DRIVER
> > > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > > L:	linux-media@vger.kernel.org
> > > > > S:	Supported
> > > > > F:	drivers/media/platform/atmel/atmel-isi.c
> > > > > F:	include/media/atmel-isi.h
> > > > > 
> > > > > and maybe use something like:
> > > > > 
> > > > > MICROCHIP MEDIA DRIVERS
> > > > > M:	Eugen Hristev <eugen.hristev@microchip.com>
> > > > > L:
> > > > > linux-media@vger.kernel.org
> > > > > S:	Supported
> > > > > F:	drivers/media/platform/atmel/
> > > > > F:	devicetree/bindings/media/atmel-isc.txt  
> > > > 
> > > > Yeah, combining both of them seems a good alternative to me.
> > > > 
> > > > Eugen/Ludovic/Josh,
> > > > 
> > > > Comments?  
> > > 
> > > I have no strong opinion about it. The devices are different but usually
> > > there is one person per topic so combining them makes sense.  
> > 
> > Hmm... At media tree, currently, MAINTAINERS entry is different:
> > 
> > MICROCHIP / ATMEL ISC DRIVER
> > M:	Songjun Wu <songjun.wu@microchip.com>
> > L:	linux-media@vger.kernel.org
> > S:      Supported
> > F:      drivers/media/platform/atmel/atmel-isc.c
> > F:      drivers/media/platform/atmel/atmel-isc-regs.h
> > F:	devicetree/bindings/media/atmel-isc.txt
> > 
> > ATMEL ISI DRIVER
> > M:	Ludovic Desroches <ludovic.desroches@microchip.com>
> > L:	linux-media@vger.kernel.org
> > S:      Supported
> > F:      drivers/media/platform/atmel/atmel-isi.c
> > F:      include/media/atmel-isi.h
> > 
> > Maybe some patch upstream did some recent changes on it via another
> > tree.
> > 
> > So, in order to avoid conflicts upstream, for now I would just correct
> > the location for the ISI file.
> > 
> > After the merge window, we may revisit and join both entries,
> > if the maintainers are the same.  
> 
> Fine with me.
> 
> > -
> > 
> > MAINTAINERS: fix location for atmel-isi.h file
> > 
> > The location of this file got changed by changeset 40a78f36fc92
> > ("[media] v4l: atmel-isi: Remove support for platform data"), but
> > MAINTAINERS was not updated accordingly.
> > 
> > Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform
> > data") Reported-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> 
> I don't care about patch count statistics, but the usual practice is to retain 
> the authorship of the original submitter. 

Huh? Frankly, I don't care who will be accredited for this, provided
that this gets fixed. Yet, I'm lost with your comment. 

Did I miss some other patch at the ML touching it?

At patchwork, it seems that there are only two patches:

	https://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=MAINTAINERS

the one from you, that assumed that this file got removed
and does:

	-F:	include/media/atmel-isi.h

And my alternative proposal, that changes it to reflect its
current location:

	-F:	drivers/media/platform/atmel/atmel-isi.c
	-F:	include/media/atmel-isi.h
	+F:	drivers/media/platform/atmel/atmel-isi.*

Both are based on Joe's "Bad MAINTAINERS" report e-mail.

My patch follows one of the two possible solutions proposed by
Joe. 

He is already credited as reporter there:

	MAINTAINERS: fix location for atmel-isi.h file

	The location of this file got changed by changeset 40a78f36fc92
	("[media] v4l: atmel-isi: Remove support for platform data"), but
	MAINTAINERS was not updated accordingly.

	Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform data")
	Reported-by: Joe Perches <joe@perches.com>

He could also have a "Suggested-by" there. I'm perfectly fine
adding it.

However, using his name as the author of the patch, without his
permission, doesn't sound right.

That's said, I'm perfectly fine to drop this patch and wait for
Joe to send me the same change with him as the author of such
change.

Thanks,
Mauro
