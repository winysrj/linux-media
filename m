Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbZHCMMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 08:12:39 -0400
Date: Mon, 3 Aug 2009 09:11:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
Message-ID: <20090803091150.29118ceb@pedra.chehab.org>
In-Reply-To: <20090803083012.44da22ca@tele>
References: <20090418183124.1c9160e3@free.fr>
	<alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
	<208cbae30908020625x400f6b3era5095c8bfc5c736b@mail.gmail.com>
	<20090803083012.44da22ca@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 3 Aug 2009 08:30:12 +0200
Jean-Francois Moine <moinejf@free.fr> escreveu:

> On Sun, 2 Aug 2009 17:25:29 +0400
> Alexey Klimov <klimov.linux@gmail.com> wrote:
> 
> > > + � � � buffer = kmalloc(JEILINJ_MAX_TRANSFER, GFP_KERNEL |
> > > GFP_DMA);
> > > + � � � if (!buffer) {
> > > + � � � � � � � PDEBUG(D_ERR, "Couldn't allocate USB buffer");
> > > + � � � � � � � goto quit_stream;
> > > + � � � }  
> > 
> > This clean up on error path looks bad. On quit_stream you have:
> > 
> > > +quit_stream:
> > > +       mutex_lock(&gspca_dev->usb_lock);
> > > +       if (gspca_dev->present)
> > > +               jlj_stop(gspca_dev);
> > > +       mutex_unlock(&gspca_dev->usb_lock);
> > > +       kfree(buffer);  
> > 
> > kfree() tries to free null buffer after kmalloc for buffer failed.
> > Please, check if i'm not wrong.
> 
> Hi Alexey,
> 
> AFAIK, kfree() checks the pointer.

Yeah. Theodore's code is ok. kfree(NULL) is legal.

> 
> Cheers.
> 




Cheers,
Mauro
