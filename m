Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53846 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918AbcHRKpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 06:45:44 -0400
Date: Thu, 18 Aug 2016 12:45:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [PATCHv6] support for AD5820 camera auto-focus coil
Message-ID: <20160818104539.GA7427@amd>
References: <20160524090433.GA1277@amd>
 <20160524091746.GA14536@amd>
 <20160525212659.GK26360@valkosipuli.retiisi.org.uk>
 <20160527205140.GA26767@amd>
 <20160805102611.GA13116@amd>
 <20160808080955.GA3182@valkosipuli.retiisi.org.uk>
 <20160808214132.GB2946@xo-6d-61-c0.localdomain>
 <20160810120105.GP3182@valkosipuli.retiisi.org.uk>
 <20160808232323.GC2946@xo-6d-61-c0.localdomain>
 <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160811111633.GR3182@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 2016-08-11 14:16:34, Sakari Ailus wrote:
> On Tue, Aug 09, 2016 at 01:23:23AM +0200, Pavel Machek wrote:
> > On Wed 2016-08-10 15:01:05, Sakari Ailus wrote:
> > > On Mon, Aug 08, 2016 at 11:41:32PM +0200, Pavel Machek wrote:
> > > > On Mon 2016-08-08 11:09:56, Sakari Ailus wrote:
> > > > > On Fri, Aug 05, 2016 at 12:26:11PM +0200, Pavel Machek wrote:
> > > > > > 
> > > > > > This adds support for AD5820 autofocus coil, found for example in
> > > > > > Nokia N900 smartphone.
> > > > > 
> > > > > Thanks, Pavel!
> > > > > 
> > > > > Let's use V4L2_CID_FOCUS_ABSOLUTE, as is in the patch. If we get something
> > > > > better in the future, we'll switch to that then.
> > > > > 
> > > > > I've applied this to ad5820 branch in my tree.
> > > > 
> > > > Thanks. If I understands things correctly, both DTS patch and this patch are
> > > > waiting in your tree, so we should be good to go for 4.9 (unless some unexpected
> > > > problems surface)?
> > > 
> > > Yeah. I just compiled it but haven't tested it. I presume it'll work. :-)
> > 
> > I'm testing it on n900. I guess simpler hardware with ad5820 would be better for the
> > test...
> > 
> > What hardware do you have?
> 
> N900. What else could it be? :-) :-)

Heh. Basically anything is easier to develop for than n900 :-(.

Ok, for real testing, Ivaylo's camera patchset is useful, so that you
have picture to work with, plus your subdevs for omap3 patchset (which
needs a forward port).

I have patches against v4.7, if you are interested.

I guess subdevs for omap3 should be merged at this point. Do you have
any plans to do that, or should I take a look?

Best regards,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
