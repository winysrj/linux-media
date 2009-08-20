Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:38674 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZHTAr1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 20:47:27 -0400
Subject: Re: linux-next: suspend tree build warnings
From: Andy Walls <awalls@radix.net>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20090819233601.GA2875@kroah.com>
References: <20090819172419.2cf53008.sfr@canb.auug.org.au>
	 <200908192338.03910.rjw@sisk.pl>  <20090819233601.GA2875@kroah.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 19 Aug 2009 20:44:16 -0400
Message-Id: <1250729056.2716.37.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-08-19 at 16:36 -0700, Greg KH wrote:
> On Wed, Aug 19, 2009 at 11:38:03PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday 19 August 2009, Stephen Rothwell wrote:
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > > 
> > > drivers/media/dvb/frontends/dib7000p.c: In function ‘dib7000p_i2c_enumeration’:
> > > drivers/media/dvb/frontends/dib7000p.c:1315: warning: the frame size of 2256 bytes is larger than 2048 bytes
> > > drivers/media/dvb/frontends/dib3000mc.c: In function ‘dib3000mc_i2c_enumeration’:
> > > drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2160 bytes is larger than 2048 bytes
> > > 
> > > Introduced by commit 99307958cc9c1b0b2e0dad4bbefdafaf9ac5a681 ("PM:
> > > Introduce core framework for run-time PM of I/O devices (rev. 17)").
> > 
> > Well.
> > 
> > This commit increases the size of struct device quite a bit and both of the
> > drivers above create a "state" object on the stack that contains struct device
> > among other things.
> 
> Ick.  struct device should _never_ be on the stack, why would this code
> want to do such a thing?

It appears that the state object is a dummy being used to detect and
twiddle some identical chips on the i2c bus.  The functions called only
use the "i2c_adapter" and "cfg" member of the dummy state object, but
those functions want that state object as an input argument.

<obvious>
The simplest fix is dynamic allocation of the dummy state object with
kmalloc() and then to free it before exiting the function.
</obvious>

Regards,
Andy


> thanks,
> 
> greg k-h


