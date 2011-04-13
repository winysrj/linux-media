Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:53703 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1DMSUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 14:20:16 -0400
Message-ID: <4DA5E957.3020702@linuxtv.org>
Date: Wed, 13 Apr 2011 20:20:07 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Robby Workman <rworkman@slackware.com>
CC: linux-media@vger.kernel.org,
	Patrick Volkerding <volkerdi@slackware.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCHES] Misc. trivial fixes
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com> <4DA441D9.2000601@linuxtv.org> <alpine.LNX.2.00.1104120729280.7359@connie.slackware.com>
In-Reply-To: <alpine.LNX.2.00.1104120729280.7359@connie.slackware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/12/2011 04:31 PM, Robby Workman wrote:
> On Tue, 12 Apr 2011, Andreas Oberritter wrote:
> 
>> On 04/12/2011 04:10 AM, Robby Workman wrote:
>>> --- a/Make.rules
>>> +++ b/Make.rules
>>> @@ -11,6 +11,7 @@ PREFIX = /usr/local
>>>  LIBDIR = $(PREFIX)/lib
>>>  # subdir below LIBDIR in which to install the libv4lx libc wrappers
>>>  LIBSUBDIR = libv4l
>>> +MANDIR = /usr/share/man
>>
>> Why did you hardcode /usr instead of keeping $(PREFIX)/share/man?
> 
> 
> Eek.  I'd like to say that I sent the wrong patch, but alas, I
> simply had a thinko.  See attached (better) patch :-)

Looks good. Mauro, will you pick up this patch?

Regards,
Andreas

> 
> -RW
> 
> 
> 0002-Allow-override-of-manpage-installation-directory.patch
> 
> 
> From 6ef4a1fecee242be9658528ef7663845d9bd6bc6 Mon Sep 17 00:00:00 2001
> From: Robby Workman <rworkman@slackware.com>
> Date: Tue, 12 Apr 2011 09:26:57 -0500
> Subject: [PATCH] Allow override of manpage installation directory
> 
> This creates MANDIR in Make.rules and keeps the preexisting
> default of $(PREFIX)/share/man, but allows packagers to easily
> override via e.g. "make MANDIR=/usr/man"
> ---
>  Make.rules              |    1 +
>  utils/keytable/Makefile |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Make.rules b/Make.rules
> index 0bb2eb8..875828a 100644
> --- a/Make.rules
> +++ b/Make.rules
> @@ -11,6 +11,7 @@ PREFIX = /usr/local
>  LIBDIR = $(PREFIX)/lib
>  # subdir below LIBDIR in which to install the libv4lx libc wrappers
>  LIBSUBDIR = libv4l
> +MANDIR = $(PREFIX)/share/man
>  
>  # These ones should not be overriden from the cmdline
>  
> diff --git a/utils/keytable/Makefile b/utils/keytable/Makefile
> index 29a6ac4..e093280 100644
> --- a/utils/keytable/Makefile
> +++ b/utils/keytable/Makefile
> @@ -39,7 +39,7 @@ install: $(TARGETS)
>  	install -m 644 -p rc_keymaps/* $(DESTDIR)/etc/rc_keymaps
>  	install -m 755 -d $(DESTDIR)/lib/udev/rules.d
>  	install -m 644 -p 70-infrared.rules $(DESTDIR)/lib/udev/rules.d
> -	install -m 755 -d $(DESTDIR)$(PREFIX)/share/man/man1
> -	install -m 644 -p ir-keytable.1 $(DESTDIR)$(PREFIX)/share/man/man1
> +	install -m 755 -d $(DESTDIR)$(MANDIR)/man1
> +	install -m 644 -p ir-keytable.1 $(DESTDIR)$(MANDIR)/man1
>  
>  include ../../Make.rules
> -- 1.7.4.4

