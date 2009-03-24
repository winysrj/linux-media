Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45147 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbZCXXRd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:17:33 -0400
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: OK,
 2.6.16-2.6.21: OK
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <47547.62.70.2.252.1237885441.squirrel@webmail.xs4all.nl>
References: <47547.62.70.2.252.1237885441.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 19:18:45 -0400
Message-Id: <1237936725.4448.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-24 at 10:04 +0100, Hans Verkuil wrote:
> Hmm, everything is OK.
> 
> Let's enjoy this moment of perfection! It probably won't last long :-)
> 
> Regards,
> 
>        Hans
> 
> > This message is generated daily by a cron job that builds v4l-dvb for
> > the kernels and architectures in the list below.
> >
> > Results of the daily build of v4l-dvb:
> >
> > date:        Tue Mar 24 08:33:25 CET 2009
> > path:        http://www.linuxtv.org/hg/v4l-dvb
> > changeset:   11153:56cf0f1772f7
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
> > linux-2.6.29-armv5: OK
> > linux-2.6.27-armv5-ixp: OK


Sorry to rain on the parade, but:


linux-2.6.27-armv5-ixp: WARNINGS

  CC [M]  /marune/build/v4l-dvb-master/v4l/sp887x.o
/tmp/ccqyC3HA.s:   CC [M]  /marune/build/v4l-dvb-master/v4l/nxt6000.o


the logs and the summary log appear to disagree.  Or maybe the assembler
was having a bad day.

So close .... :)


Regards,
Andy


> > linux-2.6.28-armv5-ixp: OK
> > linux-2.6.29-armv5-ixp: OK
> > linux-2.6.28-armv5-omap2: OK
> > linux-2.6.29-armv5-omap2: OK
> > linux-2.6.22.19-i686: OK
> > linux-2.6.23.12-i686: OK
> > linux-2.6.24.7-i686: OK
> > linux-2.6.25.11-i686: OK
> > linux-2.6.26-i686: OK
> > linux-2.6.27-i686: OK
> > linux-2.6.28-i686: OK
> > linux-2.6.29-i686: OK
> > linux-2.6.23.12-m32r: OK
> > linux-2.6.24.7-m32r: OK
> > linux-2.6.25.11-m32r: OK
> > linux-2.6.26-m32r: OK
> > linux-2.6.27-m32r: OK
> > linux-2.6.28-m32r: OK
> > linux-2.6.29-m32r: OK
> > linux-2.6.22.19-mips: OK
> > linux-2.6.26-mips: OK
> > linux-2.6.27-mips: OK
> > linux-2.6.28-mips: OK
> > linux-2.6.29-mips: OK
> > linux-2.6.27-powerpc64: OK
> > linux-2.6.28-powerpc64: OK
> > linux-2.6.29-powerpc64: OK
> > linux-2.6.22.19-x86_64: OK
> > linux-2.6.23.12-x86_64: OK
> > linux-2.6.24.7-x86_64: OK
> > linux-2.6.25.11-x86_64: OK
> > linux-2.6.26-x86_64: OK
> > linux-2.6.27-x86_64: OK
> > linux-2.6.28-x86_64: OK
> > linux-2.6.29-x86_64: OK
> > fw/apps: OK
> > sparse (linux-2.6.29): ERRORS
> > linux-2.6.16.61-i686: OK
> > linux-2.6.17.14-i686: OK
> > linux-2.6.18.8-i686: OK
> > linux-2.6.19.5-i686: OK
> > linux-2.6.20.21-i686: OK
> > linux-2.6.21.7-i686: OK
> > linux-2.6.16.61-x86_64: OK
> > linux-2.6.17.14-x86_64: OK
> > linux-2.6.18.8-x86_64: OK
> > linux-2.6.19.5-x86_64: OK
> > linux-2.6.20.21-x86_64: OK
> > linux-2.6.21.7-x86_64: OK
> >
> > Detailed results are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> >
> > Full logs are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Tuesday.tar.bz2
> >
> > The V4L2 specification from this daily build is here:
> >
> > http://www.xs4all.nl/~hverkuil/spec/v4l2.html
> >
> > The DVB API specification from this daily build is here:
> >
> > http://www.xs4all.nl/~hverkuil/spec/dvbapi.pdf
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 

