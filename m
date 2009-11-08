Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39627 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZKHCF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 21:05:56 -0500
Subject: Re: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
From: Andy Walls <awalls@radix.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1257645238.15927.624.camel@localhost>
References: <1257630681.15927.423.camel@localhost>
	 <1257644422.6895.8.camel@palomino.walls.org>
	 <1257645238.15927.624.camel@localhost>
Content-Type: text/plain
Date: Sat, 07 Nov 2009 21:08:56 -0500
Message-Id: <1257646136.7399.18.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-08 at 01:53 +0000, Ben Hutchings wrote:
> On Sat, 2009-11-07 at 20:40 -0500, Andy Walls wrote:
> > On Sat, 2009-11-07 at 21:51 +0000, Ben Hutchings wrote:

> > >  
> > > +MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
> > > +
> > 
> > Ben,
> > 
> > This particular firmware is only needed by one relatively rare TV card.
> > Is there any way for MODULE_FIRMWARE advertisements to hint at
> > "mandatory" vs. "particular case(s)"?
> 
> No, but perhaps there ought to be.  In this case the declaration could
> be left out for now.  It is only critical to list all firmware in
> drivers that may be needed for booting.

OK.  I don't know that a TV card driver is every *needed* for booting.
Maybe one day when I can net-boot with cable-modem like
functionality... ;)


I'm OK with the MODULE_FIRMWARE announcements in cx18 so long as
automatic behaviors like

1. persistent, repeatitive, or truly alarming user warnings, or
2. refusing to load the module due to missing firmware files

don't happen.

Regards,
Andy

> Ben.


