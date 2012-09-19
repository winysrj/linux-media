Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.active-venture.com ([67.228.131.205]:55996 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2ISDql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 23:46:41 -0400
Date: Tue, 18 Sep 2012 20:46:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mceusb: Optimize DIV_ROUND_CLOSEST call
Message-ID: <20120919034656.GA27994@roeck-us.net>
References: <20120901205357.1a75d8a1@endymion.delvare>
 <50589821.6000108@redhat.com>
 <20120918203509.513cdb29@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120918203509.513cdb29@endymion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2012 at 08:35:09PM +0200, Jean Delvare wrote:
> Hi Mauro,
> 
> On Tue, 18 Sep 2012 12:49:53 -0300, Mauro Carvalho Chehab wrote:
> > Em 01-09-2012 15:53, Jean Delvare escreveu:
> > > DIV_ROUND_CLOSEST is faster if the compiler knows it will only be
> > > dealing with unsigned dividends.
> > > 
> > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Guenter Roeck <linux@roeck-us.net>
> > > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > ---
> > >  drivers/media/rc/mceusb.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- linux-3.6-rc3.orig/drivers/media/rc/mceusb.c	2012-08-04 21:49:27.000000000 +0200
> > > +++ linux-3.6-rc3/drivers/media/rc/mceusb.c	2012-09-01 18:53:32.053042123 +0200
> > > @@ -627,7 +627,7 @@ static void mceusb_dev_printdata(struct
> > >  			break;
> > >  		case MCE_RSP_EQIRCFS:
> > >  			period = DIV_ROUND_CLOSEST(
> > > -					(1 << data1 * 2) * (data2 + 1), 10);
> > > +					(1U << data1 * 2) * (data2 + 1), 10);
> > >  			if (!period)
> > >  				break;
> > >  			carrier = (1000 * 1000) / period;
> >
> > Hmm... this generates the following warning with "W=1":
> > 
> > drivers/media/rc/mceusb.c:629:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> > drivers/media/rc/mceusb.c:629:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> 
> I doubt this is the only warning of that kind. There must be a reason
> why -Wextra isn't enabled by default.
> 
> > Perhaps it makes sense to use an optimized version for unsigned, or to
> > change the macro to take the data types into account.
> 
> This was discussed before, but Andrew said he preferred a single macro.
> And I agree with him, having two macros would induce a risk of the
> wrong one being called.
> 
> If you can come up with a variant of DIV_ROUND_CLOSEST which performs
> the same and doesn't trigger the warning above, we'll be happy to see
> it, but neither Guenter nor myself could come up with one.
> 
I did some more research, and I think I found a fix. I'll send out a patch
in a minute for people to try.

Guenter
