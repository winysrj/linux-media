Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab1IBLZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:25:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [media-ctl][PATCHv2 3/4] libmediactl: use udev conditionally to get a devname
Date: Fri, 2 Sep 2011 13:26:14 +0200
Cc: linux-media@vger.kernel.org
References: <201108151652.54417.laurent.pinchart@ideasonboard.com> <201109021317.21532.laurent.pinchart@ideasonboard.com> <1314962503.13945.1.camel@smile>
In-Reply-To: <1314962503.13945.1.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021326.14340.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Friday 02 September 2011 13:21:43 Andy Shevchenko wrote:
> On Fri, 2011-09-02 at 13:17 +0200, Laurent Pinchart wrote:
> > On Friday 02 September 2011 10:42:06 Andy Shevchenko wrote:
> > > On Tue, 2011-08-30 at 21:14 +0200, Laurent Pinchart wrote:
> > > > > +AC_ARG_WITH([libudev],
> > > > > +    AS_HELP_STRING([--without-libudev],
> > > > > +        [Ignore presence of libudev and disable it]))
> > > > > +
> > > > > +AS_IF([test "x$with_libudev" != "xno"],
> > > > > +    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes,
> > > > > have_libudev=no)],
> > > > > +    [have_libudev=no])
> > > > 
> > > > I don't think this works when cross-compiling.
> > > 
> > > Do you mean pkg-config call?
> > > Its manual tells us about PKG_CONFIG_SYSROOT_DIR which might be
> > > helpful.
> > 
> > If I don't set that, pkg-config seems to pick libudev from the host and
> > consider that libudev is available. Compilation then fails.
> > 
> > As most users cross-compile libmediactl, I would like to avoid this
> > situation. Requiring the user to set PKG_CONFIG_SYSROOT_DIR to habe
> > libudev support is fine, but I would like the build to succeed out of
> > the box when cross- compiling without libudev support. Is that possible
> > ?
> 
> with my patch you run ./configure --without-libudev
> Would you like opposite: like ./configure (means w/o
> libudev), ./configure --with-libudev otherwise?

I think that would be better, otherwise I will receive lots of support request 
from people who try to cross-compile libmediactl and suddenly get a failure.

-- 
Regards,

Laurent Pinchart
