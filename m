Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60413 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbbL1NCl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 08:02:41 -0500
Date: Mon, 28 Dec 2015 11:02:36 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Automatic device driver back-porting with media_build
Message-ID: <20151228110236.59a668bc@recife.lan>
In-Reply-To: <5681292F.3010204@free.fr>
References: <5672A6F0.6070003@free.fr>
	<20151217105543.13599560@recife.lan>
	<56811270.7070907@free.fr>
	<5681292F.3010204@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mason,

Em Mon, 28 Dec 2015 13:21:03 +0100
Mason <slash.tmp@free.fr> escreveu:

> On 28/12/2015 11:44, Mason wrote:
> 
> > Hello Mauro,
> > 
> > Haven't heard back from you in a while. Maybe someone else can point
> > out what I'm doing wrong?
> > 
> > On 17/12/2015 13:55, Mauro Carvalho Chehab wrote:
> > 
> >> Mason wrote:
> >>
> >>> I have a TechnoTrend TT-TVStick CT2-4400v2 USB tuner, as described here:
> >>> http://linuxtv.org/wiki/index.php/TechnoTrend_TT-TVStick_CT2-4400
> >>>
> >>> According to the article, the device is supported since kernel 3.19
> >>> and indeed, if I use a 4.1 kernel, I can pick CONFIG_DVB_USB_DVBSKY
> >>> and everything seems to work.
> >>>
> >>> Unfortunately (for me), I've been asked to make this driver work on
> >>> an ancient 3.4 kernel.
> >>
> >> The goal is to allow compilation since 2.6.32, but please notice that
> >> not all drivers will go that far. Basically, when the backport seems too
> >> complex, we just remove the driver from the list of drivers that are
> >> compiled for a given legacy version.
> >>
> >> See the file v4l/versions.txt to double-check if the drivers you need
> >> have such restrictions. I suspect that, in the specific case of
> >> DVB_USB_DVBSKY, it should compile.
> > 
> > Whatever options I pick for my 3.4 config, CONFIG_DVB_USB_DVBSKY remains
> > unset in v4l/.config
> > 
> > $ grep -r DVB_USB_DVBSKY media_build/v4l/
> > media_build/v4l/Kconfig:config DVB_USB_DVBSKY
> > media_build/v4l/Kconfig.kern: [snip config USB]
> > media_build/v4l/Kconfig.kern: [snip config I2C]
> > media_build/v4l/.myconfig:CONFIG_DVB_USB_DVBSKY                        := n
> > media_build/v4l/Makefile.media:obj-$(CONFIG_DVB_USB_DVBSKY) += dvb-usb-dvbsky.o
> > media_build/v4l/.config:# CONFIG_DVB_USB_DVBSKY is not set
> > 
> > I suppose some prerequisite is missing?
> > Does anything obvious come to mind?
> > 
> > I've resorted to interrupting the build and changing v4l/.config to
> > CONFIG_DVB_USB_DVBSKY=m (and the module is correctly built) but this
> > feels like an unnecessary hack.
> 
> /tmp/sandbox/media_build$ make allmodconfig
> 
> didn't add anything on top of what the vanilla 'make' did.
> 
> $ make menuconfig
> make -C /tmp/sandbox/media_build/v4l menuconfig
> make[1]: Entering directory `/tmp/sandbox/media_build/v4l'
> /tmp/buildroot-2014.05-13/output/build/linux-custom/scripts/kconfig/mconf ./Kconfig
> ./Kconfig:519: syntax error
> ./Kconfig:518: unknown option "Say"
> ./Kconfig:519: unknown option "To"
> ./Kconfig:520: unknown option "called"
> ./Kconfig:523: syntax error
> ./Kconfig:522:warning: multi-line strings not supported
> ./Kconfig:522: unknown option "If"
> make[1]: *** [menuconfig] Error 1
> make[1]: Leaving directory `/tmp/sandbox/media_build/v4l'
> make: *** [menuconfig] Error 2
> 
> I'll keep poking random knobs.

The maintainance of the media_build tree is at best effort basis,
and we really don't have much time to fix things there. Personally,
I never use it, as all the tests I do are with the latest Kernel
nowadays.

I think Hans use it for some of his tests, but, from his daily
results [1], the current tree works for him. So, it is unlikely
that he'll be able to reproduce the issues you're reporting.

[1] see the e-mails with "cron job: media_tree daily build:" on
the subject.

So, instead of pointing the issues, the best you can do is to
send your fixup patches. if they won't break for the tested
compilation scenario, they'll be applied.

Yet, that may take some time for us to apply, as Hans is in 
vacations, and I'm planning to take some days off in Jan.

Regards,
Mauro
