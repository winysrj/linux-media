Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34215 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZKIMA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 07:00:56 -0500
Subject: Re: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <200911091106.38894.hverkuil@xs4all.nl>
References: <1257630681.15927.423.camel@localhost>
	 <1257645238.15927.624.camel@localhost>
	 <1257646136.7399.18.camel@palomino.walls.org>
	 <200911091106.38894.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 07:03:02 -0500
Message-Id: <1257768182.3851.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-09 at 11:06 +0100, Hans Verkuil wrote:
> On Sunday 08 November 2009 03:08:56 Andy Walls wrote:
> > On Sun, 2009-11-08 at 01:53 +0000, Ben Hutchings wrote:
> > > On Sat, 2009-11-07 at 20:40 -0500, Andy Walls wrote:
> > > > On Sat, 2009-11-07 at 21:51 +0000, Ben Hutchings wrote:
> > 
> > > > >  
> > > > > +MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
> > > > > +
> > > > 
> > > > Ben,
> > > > 
> > > > This particular firmware is only needed by one relatively rare TV card.
> > > > Is there any way for MODULE_FIRMWARE advertisements to hint at
> > > > "mandatory" vs. "particular case(s)"?
> > > 
> > > No, but perhaps there ought to be.  In this case the declaration could
> > > be left out for now.  It is only critical to list all firmware in
> > > drivers that may be needed for booting.
> > 
> > OK.  I don't know that a TV card driver is every *needed* for booting.
> > Maybe one day when I can net-boot with cable-modem like
> > functionality... ;)
> > 
> > 
> > I'm OK with the MODULE_FIRMWARE announcements in cx18 so long as
> > automatic behaviors like
> > 
> > 1. persistent, repeatitive, or truly alarming user warnings, or
> > 2. refusing to load the module due to missing firmware files
> > 
> > don't happen.
> 
> I agree with Andy here.
> 
> In the case of ivtv and cx18 (unless that changed since the last time I worked
> on it) the cx firmware is actually not loaded when the module is inited but on
> the first open() call. So it is not even that clear to me whether we want to
> have these fairly large fw files in an initramfs image at all.
> 

I've been thinking about this all a bit more since I read Mauro's
comment.

MODULE_FIRMWARE() is essentially turning kernel driver modules into an
interactive, read-only, database for (a particular set of ?) end users.

The process of keeping MODULE_FIRMWARE declarations up to date will run
into all the incentive, governance, and maintenance problems that any
database has.  Due to lack incentive structure, one will end up with
missing data at any point in time, as the current patch series points
out.

It may be better to keep tabs on module firmware image names with a
database outside of the kernel *.[ch] files.  It could be a simple as a
text file somewhere.  I suspect it would have just as likely a chance or
better of being up to date at any point in time.  That would also be a
bit more flexible.  One could add additional fields to the records for
amplifying information (e.g required, optional, card xyz) without
perturbing a slew of kernel *.[ch] files.

My $0.02.

Regards,
Andy

