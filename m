Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53787 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933503Ab1IBLWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:22:09 -0400
Subject: Re: [media-ctl][PATCHv2 3/4] libmediactl: use udev conditionally to
 get a devname
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 02 Sep 2011 14:21:43 +0300
In-Reply-To: <201109021317.21532.laurent.pinchart@ideasonboard.com>
References: <201108151652.54417.laurent.pinchart@ideasonboard.com>
	 <201108302114.14136.laurent.pinchart@ideasonboard.com>
	 <1314952926.28502.1.camel@smile>
	 <201109021317.21532.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1314962503.13945.1.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-09-02 at 13:17 +0200, Laurent Pinchart wrote: 
> Hi Andy,
> 
> On Friday 02 September 2011 10:42:06 Andy Shevchenko wrote:
> > On Tue, 2011-08-30 at 21:14 +0200, Laurent Pinchart wrote:
> > > > +AC_ARG_WITH([libudev],
> > > > +    AS_HELP_STRING([--without-libudev],
> > > > +        [Ignore presence of libudev and disable it]))
> > > > +
> > > > +AS_IF([test "x$with_libudev" != "xno"],
> > > > +    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes,
> > > > have_libudev=no)],
> > > > +    [have_libudev=no])
> > > 
> > > I don't think this works when cross-compiling.
> > 
> > Do you mean pkg-config call?
> > Its manual tells us about PKG_CONFIG_SYSROOT_DIR which might be helpful.
> 
> If I don't set that, pkg-config seems to pick libudev from the host and 
> consider that libudev is available. Compilation then fails.
> 
> As most users cross-compile libmediactl, I would like to avoid this situation. 
> Requiring the user to set PKG_CONFIG_SYSROOT_DIR to habe libudev support is 
> fine, but I would like the build to succeed out of the box when cross-
> compiling without libudev support. Is that possible ?
with my patch you run ./configure --without-libudev
Would you like opposite: like ./configure (means w/o
libudev), ./configure --with-libudev otherwise?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
