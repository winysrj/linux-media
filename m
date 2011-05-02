Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1EBUWO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 16:22:14 -0400
Message-ID: <4DBF126D.6060807@redhat.com>
Date: Mon, 02 May 2011 17:22:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Robby Workman <rworkman@slackware.com>,
	linux-media@vger.kernel.org,
	Patrick Volkerding <volkerdi@slackware.com>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [PATCHES] Misc. trivial fixes
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com> <4DA441D9.2000601@linuxtv.org> <alpine.LNX.2.00.1104120729280.7359@connie.slackware.com> <4DA5E957.3020702@linuxtv.org>
In-Reply-To: <4DA5E957.3020702@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-04-2011 15:20, Andreas Oberritter escreveu:
> On 04/12/2011 04:31 PM, Robby Workman wrote:
>> On Tue, 12 Apr 2011, Andreas Oberritter wrote:
>>
>>> On 04/12/2011 04:10 AM, Robby Workman wrote:
>>>> --- a/Make.rules
>>>> +++ b/Make.rules
>>>> @@ -11,6 +11,7 @@ PREFIX = /usr/local
>>>>  LIBDIR = $(PREFIX)/lib
>>>>  # subdir below LIBDIR in which to install the libv4lx libc wrappers
>>>>  LIBSUBDIR = libv4l
>>>> +MANDIR = /usr/share/man
>>>
>>> Why did you hardcode /usr instead of keeping $(PREFIX)/share/man?
>>
>>
>> Eek.  I'd like to say that I sent the wrong patch, but alas, I
>> simply had a thinko.  See attached (better) patch :-)
> 
> Looks good. Mauro, will you pick up this patch?

Yes, when done. I have one comment about it. 

Not sure what happened, but I lost the original email, so let me quote
it from patchwork ID#699151.


> Subject: [PATCHES] Misc. trivial fixes
> Date: Tue, 12 Apr 2011 02:10:36 -0000
> From: Robby Workman <rworkman@slackware.com>
> X-Patchwork-Id: 699151
> Message-Id: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
> To: linux-media@vger.kernel.org
> Cc: Patrick Volkerding <volkerdi@slackware.com>
> 
> Patch #1 installs udev rules files to /lib/udev/rules.d/ instead
> of /etc/udev/rules.d/ - see commit message for more info.
> 
> Patch #2 allows override of manpage installation directory by
> packagers - see commit message for more info

Please send each patch in-lined, one patch per email.

> 
> -RW
> >From d3356b0cf968c41b1d44fcc682a44112ffff9d0b Mon Sep 17 00:00:00 2001

> From: Robby Workman <rworkman@slackware.com>

> Date: Mon, 11 Apr 2011 20:41:28 -0500

> Subject: [PATCH 1/2] Install udev rules to /lib/udev/ instead of /etc/udev

> 

> In moderately recent versions of udev, packages should install

> rules files to /lib/udev/rules.d/ instead of /etc/udev/rules.d/,

> as /etc/udev/rules.d/ is now for generated rules and overrides

> of the packaged rules.

> ---

>  utils/keytable/70-infrared.rules |    4 +---

>  utils/keytable/Makefile          |    4 ++--

>  2 files changed, 3 insertions(+), 5 deletions(-)

> 

> -- 

> 1.7.4.4
> >From 0b5f4bc501c896155401226b188688fd3bef1f5c Mon Sep 17 00:00:00 2001

> From: Robby Workman <rworkman@slackware.com>

> Date: Mon, 11 Apr 2011 20:50:18 -0500

> Subject: [PATCH 2/2] Allow override of manpage installation directory

> 

> This creates MANDIR in Make.rules and keeps the preexisting

> default of /usr/share/man, but allows packagers to easily

> override via e.g. "make MANDIR=/usr/man"

> ---

>  Make.rules              |    1 +

>  utils/keytable/Makefile |    4 ++--

>  2 files changed, 3 insertions(+), 2 deletions(-)

> 

> diff --git a/Make.rules b/Make.rules

> index 0bb2eb8..1529ef8 100644

> --- a/Make.rules

> +++ b/Make.rules

> @@ -11,6 +11,7 @@ PREFIX = /usr/local

>  LIBDIR = $(PREFIX)/lib

>  # subdir below LIBDIR in which to install the libv4lx libc wrappers

>  LIBSUBDIR = libv4l

> +MANDIR = /usr/share/man


It would be better to define it as:
MANDIR = $(PREFIX)/share/man

As suggested by Andreas.

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

> -- 

> 1.7.4.4
> 
> 
> diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules

> index 308a6d4..afffd95 100644

> --- a/utils/keytable/70-infrared.rules

> +++ b/utils/keytable/70-infrared.rules

> @@ -1,6 +1,4 @@

>  # Automatically load the proper keymaps after the Remote Controller device

> -# creation.

> -# Copy this file at /etc/udev/rules.d/70-infrared.rules in order to load keytables

> -# during boot time. The keycode tables rules should be at /etc/rc_maps.cfg

> +# creation.  The keycode tables rules should be at /etc/rc_maps.cfg

>  

>  ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"

> diff --git a/utils/keytable/Makefile b/utils/keytable/Makefile

> index aa020ef..29a6ac4 100644

> --- a/utils/keytable/Makefile

> +++ b/utils/keytable/Makefile

> @@ -37,8 +37,8 @@ install: $(TARGETS)

>  	install -m 644 -p rc_maps.cfg $(DESTDIR)/etc

>  	install -m 755 -d $(DESTDIR)/etc/rc_keymaps

>  	install -m 644 -p rc_keymaps/* $(DESTDIR)/etc/rc_keymaps

> -	install -m 755 -d $(DESTDIR)/etc/udev/rules.d

> -	install -m 644 -p 70-infrared.rules $(DESTDIR)/etc/udev/rules.d

> +	install -m 755 -d $(DESTDIR)/lib/udev/rules.d


Not all distros use /lib for it. In fact, RHEL5/RHEL6/Fedora 15 and Fedora rawhide
all use /etc/udev/rules.d.

In a matter of fact, looking at RHEL6 (udev-147-2.35.el6.x86_64), it has both. I suspect 
that /lib/udev/rules.d is meant to have the default scripts that are part of the 
official packages, and /etc/udev/rules.d to be user-defined ones. So, at least on RHEL6,
it makes sense that a user-compiled tarball would install stuff into /etc/*, and 
that a RHEL6 package would change it to install at /lib/*.

So, it is better to have some Makefile var with some default, that 
allows overriding it when doing a make install, for example:

UDEVDIR=/etc/udev/rules.d

The default is a matter of personal taste. I would keep the current way as default,
as it avoids breaking for those that are using it on the current way. One alternative
would be to add some logic there to change the default to /lib/* if /etc/* doesn't
exist.

> +	install -m 644 -p 70-infrared.rules $(DESTDIR)/lib/udev/rules.d

>  	install -m 755 -d $(DESTDIR)$(PREFIX)/share/man/man1

>  	install -m 644 -p ir-keytable.1 $(DESTDIR)$(PREFIX)/share/man/man1

>  

> 

Cheers,
Mauro
