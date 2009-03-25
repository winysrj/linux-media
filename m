Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3355 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbZCYHIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 03:08:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: OK, 2.6.16-2.6.21: OK
Date: Wed, 25 Mar 2009 08:08:24 +0100
Cc: linux-media@vger.kernel.org
References: <47547.62.70.2.252.1237885441.squirrel@webmail.xs4all.nl> <1237936725.4448.6.camel@palomino.walls.org>
In-Reply-To: <1237936725.4448.6.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903250808.24887.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 25 March 2009 00:18:45 Andy Walls wrote:
> On Tue, 2009-03-24 at 10:04 +0100, Hans Verkuil wrote:
> > Hmm, everything is OK.
> >
> > Let's enjoy this moment of perfection! It probably won't last long :-)
> >
> > Regards,
> >
> >        Hans
> >
> > > This message is generated daily by a cron job that builds v4l-dvb for
> > > the kernels and architectures in the list below.
> > >
> > > Results of the daily build of v4l-dvb:
> > >
> > > date:        Tue Mar 24 08:33:25 CET 2009
> > > path:        http://www.linuxtv.org/hg/v4l-dvb
> > > changeset:   11153:56cf0f1772f7
> > > gcc version: gcc (GCC) 4.3.1
> > > hardware:    x86_64
> > > host os:     2.6.26
> > >
> > > linux-2.6.22.19-armv5: OK
> > > linux-2.6.23.12-armv5: OK
> > > linux-2.6.24.7-armv5: OK
> > > linux-2.6.25.11-armv5: OK
> > > linux-2.6.26-armv5: OK
> > > linux-2.6.27-armv5: OK
> > > linux-2.6.28-armv5: OK
> > > linux-2.6.29-armv5: OK
> > > linux-2.6.27-armv5-ixp: OK
>
> Sorry to rain on the parade, but:
>
>
> linux-2.6.27-armv5-ixp: WARNINGS
>
>   CC [M]  /marune/build/v4l-dvb-master/v4l/sp887x.o
> /tmp/ccqyC3HA.s:   CC [M]  /marune/build/v4l-dvb-master/v4l/nxt6000.o
>
>
> the logs and the summary log appear to disagree.  Or maybe the assembler
> was having a bad day.

Yes, it was having a bad day :-) There are a few assembler warnings that I 
get with the arm compilation that I attempt to filter out. But every so 
often these warnings get mixed in with other messages and my filter misses 
them, so the build process still finds it. As you said, it was a bad day...

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
