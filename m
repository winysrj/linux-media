Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2HSPzn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 11:55:43 -0400
Date: Sun, 19 Aug 2012 17:00:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David =?ISO-8859-1?B?SORyZGVtYW4=?= <david@hardeman.nu>,
	Sean Young <sean@mess.org>, Jarod Wilson <jarod@wilsonet.com>,
	Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
	linux-serial@vger.kernel.org, lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] winbond-cir: Fix initialization
Message-ID: <20120819170004.579ee640@pyramind.ukuu.org.uk>
In-Reply-To: <5026BE78.80902@redhat.com>
References: <1343731023-9822-1-git-send-email-sean@mess.org>
	<5026BE78.80902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > +#ifdef CONFIG_SERIAL_8250

Coule be modular

> > +	if (!io) {
> > +		struct uart_port port = { .iobase = data->sbase };
> > +		int line = serial8250_find_port(&port);
> > +		if (line >= 0) {
> > +			serial8250_unregister_port(line);
> 
> Hmm... Not sure if it makes sense, but perhaps the unregistering code
> should be reverting serial8250_unregister_port(line).

Can't do that anyway it may well be busy.

> > --- a/drivers/tty/serial/8250/8250.c
> > +++ b/drivers/tty/serial/8250/8250.c
> > @@ -2914,6 +2914,7 @@ int serial8250_find_port(struct uart_port *p)
> >  	}
> >  	return -ENODEV;
> >  }
> > +EXPORT_SYMBOL(serial8250_find_port);

No - this leaks all the uart internal abstractions into the tree. We
really don't want that happening.

The right way to fix this (and a couple of other uglies) is to make 8250
on x86 scan for PnP ports *before* generic ports and to make a note of
any ports to skip on the PnP scan (so that the port poking scan ignores
them too)

Alan
