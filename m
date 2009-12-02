Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3526 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZLBCxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 21:53:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: WARNINGS, 2.6.16-2.6.21: WARNINGS
Date: Wed, 2 Dec 2009 08:21:17 +0530
Cc: linux-media@vger.kernel.org
References: <200912011947.nB1JltLm031870@smtp-vbr17.xs4all.nl> <4B158C0E.4080709@freemail.hu>
In-Reply-To: <4B158C0E.4080709@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912020821.18004.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 December 2009 03:05:10 Németh Márton wrote:
> Hans Verkuil wrote:
> > This message is generated daily by a cron job that builds v4l-dvb for
> > the kernels and architectures in the list below.
> >
> > Results of the daily build of v4l-dvb:
> >
> > date:        Tue Dec  1 19:00:02 CET 2009
> > path:        http://www.linuxtv.org/hg/v4l-dvb
> > changeset:   13538:e0cd9a337600
> > gcc version: gcc (GCC) 4.3.1
> > hardware:    x86_64
> > host os:     2.6.26
> > [...]
> > Detailed results are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> >
> >> linux-2.6.29.1-i686: WARNINGS
> >> /marune/build/v4l-dvb-master/v4l/firedtv-1394.c:264: warning:
> >> initialization discards qualifiers from pointer target type
> >>
> >> linux-2.6.29.1-x86_64: WARNINGS
> >> /marune/build/v4l-dvb-master/v4l/firedtv-1394.c:264: warning:
> >> initialization discards qualifiers from pointer target type
>
> I found about this two warnings that this module is not to be built with
> 2.6.29.1
>
> according to the following lines from version.txt:
> > [2.6.30]
> > # Needs const id_table pointer in struct hpsb_protocol_driver
> > DVB_FIREDTV_IEEE1394
>
> I'm not sure whether the script v4l/scripts/make_kconfig.pl is working
> correctly or not.

There are some weird conditions on that IEEE1394 config that seem to defeat 
the make_kconfig.pl script. I haven't had the time to look at it. It would be 
great if someone can take a look at it as I don't have the time.

Regards,

	Hans

>
> Regards,
>
> 	Márton Németh

