Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:40200 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752246AbbFIXan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 19:30:43 -0400
Message-ID: <1433892639.2730.81.camel@perches.com>
Subject: Re: [PATCH] [media] lmedm04: Neaten logging
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 09 Jun 2015 16:30:39 -0700
In-Reply-To: <20150609190749.56a1c6dd@recife.lan>
References: <1432542547.2846.55.camel@perches.com>
	 <20150609190749.56a1c6dd@recife.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2015-06-09 at 19:07 -0300, Mauro Carvalho Chehab wrote:
> Hi Joe,

Marhaba Mauro.

> Em Mon, 25 May 2015 01:29:07 -0700
> Joe Perches <joe@perches.com> escreveu:
> 
> > Use a more current logging style.
> > 
> > o Use pr_fmt
> > o Add missing newlines to formats
> > o Remove used-once lme_debug macro incorporating it into dbg_info
> > o Remove unnecessary allocation error messages
> > o Remove unnecessary semicolons from #defines
> > o Remove info macro and convert uses to pr_info
> > o Fix spelling of snippet
> > o Use %phN extension
> 
> There are a few checkpatch warnings:

I hardly use checkpatch tbh

The long lines I don't care about, I presume all the others are
existing, but I'll run --fix on it and resubmit if you want.

> > diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
[]
> >  /* debug */
> >  static int dvb_usb_lme2510_debug;
> > -#define lme_debug(var, level, args...) do { \
> > -	if ((var >= level)) \
> > -		pr_debug(DVB_USB_LOG_PREFIX": " args); \
> > +#define deb_info(level, fmt, ...)					\
> > +do {									\
> > +	if (dvb_usb_lme2510_debug >= level)				\
> > +		pr_debug(fmt, ##__VA_ARGS__);				\
> >  } while (0)
> 
> 
> The usage of both a debug level and pr_debug() is not nice, as,
> if CONFIG_DYNAMIC_DEBUG is enabled (with is the case on most distros),
> one needing to debug would need to both pass a debug level AND to enable
> the debug line via sysfs, with is not nice.

> We might of course remove debug levels as a hole and just use 
> pr_debug(), but the end result is generally worse (didn't chec
> the specifics on this file).
> 
> So, the better here would be to use printk like:
> 
> #define deb_info(level, fmt, ...)\
> 	do { if (dvb_usb_lme2510_debug >= level)\
> 		printk(KERN_DEBUG pr_fmt(fmt), ## arg);\
> 	} while (0)
> 
> Ok, this issue were already present on the old code, but IMHO the
> best is to either use the above definition of deb_info() or to just
> call pr_debug() and get rid of dvb_usb_lme2510_debug.

Alternately, you could #define DEBUG and these would be enabled
by default for CONFIG_DYNAMIC_DEBUG and act the same otherwise.


