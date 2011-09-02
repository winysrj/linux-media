Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab1IBJKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 05:10:52 -0400
Subject: Re: [media-ctl][PATCHv2 3/4] libmediactl: use udev conditionally to
 get a devname
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 02 Sep 2011 11:42:06 +0300
In-Reply-To: <201108302114.14136.laurent.pinchart@ideasonboard.com>
References: <201108151652.54417.laurent.pinchart@ideasonboard.com>
	 <6075971b959c2e808cd4ceec6540dc09b101346f.1313490446.git.andriy.shevchenko@linux.intel.com>
	 <3fa73211e84c4b2e70d4777e3664954948042d64.1313490446.git.andriy.shevchenko@linux.intel.com>
	 <201108302114.14136.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1314952926.28502.1.camel@smile>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-08-30 at 21:14 +0200, Laurent Pinchart wrote: 
> > +AC_ARG_WITH([libudev],
> > +    AS_HELP_STRING([--without-libudev],
> > +        [Ignore presence of libudev and disable it]))
> > +
> > +AS_IF([test "x$with_libudev" != "xno"],
> > +    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes,
> > have_libudev=no)],
> > +    [have_libudev=no])
> 
> I don't think this works when cross-compiling.
Do you mean pkg-config call?
Its manual tells us about PKG_CONFIG_SYSROOT_DIR which might be helpful.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
