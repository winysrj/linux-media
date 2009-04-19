Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:58288 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbZDSXpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 19:45:20 -0400
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
	2.6.16-2.6.21: ERRORS
From: hermann pitton <hermann-pitton@arcor.de>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <208cbae30904191542l4e3996cejf1df9cadfb187dfe@mail.gmail.com>
References: <200904191818.n3JIISWN021959@smtp-vbr12.xs4all.nl>
	 <208cbae30904191542l4e3996cejf1df9cadfb187dfe@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 01:44:26 +0200
Message-Id: <1240184666.10011.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 20.04.2009, 02:42 +0400 schrieb Alexey Klimov:
> On Sun, Apr 19, 2009 at 10:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > This message is generated daily by a cron job that builds v4l-dvb for
> > the kernels and architectures in the list below.
> >
> > Results of the daily build of v4l-dvb:
> >
> > date:        Sun Apr 19 19:00:03 CEST 2009
> > path:        http://www.linuxtv.org/hg/v4l-dvb
> > changeset:   11517:cda79523a93c
> > gcc version: gcc (GCC) 4.3.1
> > hardware:    x86_64
> > host os:     2.6.26
> >
> > linux-2.6.22.19-armv5: OK
> > linux-2.6.23.12-armv5: OK
> > linux-2.6.24.7-armv5: OK
> > linux-2.6.25.11-armv5: OK
> > linux-2.6.26-armv5: OK
> > linux-2.6.27-armv5: OK
> > linux-2.6.28-armv5: OK
> > linux-2.6.29.1-armv5: OK
> > linux-2.6.30-rc1-armv5: OK
> > linux-2.6.27-armv5-ixp: OK
> > linux-2.6.28-armv5-ixp: OK
> > linux-2.6.29.1-armv5-ixp: OK
> > linux-2.6.30-rc1-armv5-ixp: WARNINGS
> > linux-2.6.28-armv5-omap2: OK
> > linux-2.6.29.1-armv5-omap2: OK
> > linux-2.6.30-rc1-armv5-omap2: WARNINGS
> > linux-2.6.22.19-i686: WARNINGS
> > linux-2.6.23.12-i686: ERRORS
> > linux-2.6.24.7-i686: OK
> > linux-2.6.25.11-i686: OK
> > linux-2.6.26-i686: OK
> > linux-2.6.27-i686: OK
> > linux-2.6.28-i686: OK
> > linux-2.6.29.1-i686: OK
> > linux-2.6.30-rc1-i686: WARNINGS
> 
> When trying to compile v4l-dvb tree under 2.6.30-rc2 (up-to-date) i
> have such error with pvr2 module:
> 
>   CC [M]  /w/new/v4l-dvb/v4l/pvrusb2-hdw.o
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_upload_firmware1':
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c:1474: error: implicit declaration of
> function 'usb_settoggle'
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_hdw_load_modules':
> /w/new/v4l-dvb/v4l/pvrusb2-hdw.c:2133: warning: format not a string
> literal and no format arguments
> make[3]: *** [/w/new/v4l-dvb/v4l/pvrusb2-hdw.o] Error 1
> make[2]: *** [_module_/w/new/v4l-dvb/v4l] Error 2
> 
> It's probably due to this git commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3444b26afa145148951112534f298bdc554ec789
> 
> I don't have idea how to fix it fast and correctly.
> 

without looking into further details, did build a 2.6.30-rc2-git4
yesterday evening for an x86_64 and the whole media tree compiled
without warnings and errors including that one.

Was looking for if, the the breakage of some saa7134 cards on 2.6.29
made it into that one too. As far as I can say without graphics card and
wireless support there, but able to record, luckily not.

Maybe give it a try and/or identify related further patches.
Is git5 now.

Cheers,
Hermann




