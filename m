Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZHSXjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 19:39:42 -0400
Date: Wed, 19 Aug 2009 16:36:01 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	pm list <linux-pm@lists.linux-foundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: suspend tree build warnings
Message-ID: <20090819233601.GA2875@kroah.com>
References: <20090819172419.2cf53008.sfr@canb.auug.org.au>
 <200908192338.03910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908192338.03910.rjw@sisk.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:38:03PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 19 August 2009, Stephen Rothwell wrote:
> > Hi Rafael,
> 
> Hi,
> 
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > drivers/media/dvb/frontends/dib7000p.c: In function ‘dib7000p_i2c_enumeration’:
> > drivers/media/dvb/frontends/dib7000p.c:1315: warning: the frame size of 2256 bytes is larger than 2048 bytes
> > drivers/media/dvb/frontends/dib3000mc.c: In function ‘dib3000mc_i2c_enumeration’:
> > drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2160 bytes is larger than 2048 bytes
> > 
> > Introduced by commit 99307958cc9c1b0b2e0dad4bbefdafaf9ac5a681 ("PM:
> > Introduce core framework for run-time PM of I/O devices (rev. 17)").
> 
> Well.
> 
> This commit increases the size of struct device quite a bit and both of the
> drivers above create a "state" object on the stack that contains struct device
> among other things.

Ick.  struct device should _never_ be on the stack, why would this code
want to do such a thing?

thanks,

greg k-h
