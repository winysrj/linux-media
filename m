Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55772 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415Ab0CMXw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 18:52:58 -0500
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
 tuning  regression
From: Andy Walls <awalls@radix.net>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Robert Lowery <rglowery@exemail.com.au>,
	Terry Wu <terrywu2009@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <702870ef1003120234g7bf4d512j6423fe028cc672ab@mail.gmail.com>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
	 <1128.115.70.135.213.1262840633.squirrel@webmail.exetel.com.au>
	 <6ab2c27e1001070548y1a96f390uc7b7fbd18a78a564@mail.gmail.com>
	 <6ab2c27e1001070604m323ccb02g10a8c302c3edee79@mail.gmail.com>
	 <6ab2c27e1001070618ud7019b9s69180353010a1c96@mail.gmail.com>
	 <6ab2c27e1001070642k4d5bd81cud404fe77bc7a6bc5@mail.gmail.com>
	 <1197.115.70.135.213.1262917283.squirrel@webmail.exetel.com.au>
	 <4B7E1931.3090007@redhat.com>
	 <52633.115.70.135.213.1266574714.squirrel@webmail.exetel.com.au>
	 <4B7E9B20.5030503@redhat.com>
	 <702870ef1003120234g7bf4d512j6423fe028cc672ab@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 18:51:53 -0500
Message-Id: <1268524313.3084.177.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-03-12 at 21:34 +1100, Vincent McIntyre wrote:
> On 2/20/10, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > Robert Lowery wrote:
> >> Mauro,
> >>
> >> I had to make 2 changes to get the patch to work for me
> >
> > Ok. Please test this (hopefully) final revision.
> >
> > --
> >
> > commit bd8bb8798bb96136b6898186d505c9e154334b5d
> > Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date:   Fri Feb 19 02:45:00 2010 -0200
> 
> I finally found time to test carefully and if anyone still cares, the
> patch works fine for me too.
> I pulled it in from the hg tree, by the time it got there it had
> morphed a little...
> Many thanks for your (and Rob's) patient work on this.
> 
> I've attached a test log that shows what happens with signaltest.pl,
> on each tuner.
> The first two adapters are the Dual Digital 4 rev1, the next two
> belong to a FusionHDTV Dual Digital Express.
> 
> The errors are nice and small now, compared with the values I got
> before the patch.
> I noticed something a little odd - the UNC error value always
> increases, even though
> signaltest.pl does a fresh invocation for each station in the sequence.

This is proper behavior for the frontend.  The UNC count should not be
reset when it is read (think of what would happen when more than one app
was trying to monitor the frontend status).

What matters is the slope of the UNC curve over a measurement interval:
== 0 is good, > 0 is bad.


> Switching to a different tuner seems to reset the UNC error counters.

The zl10353 driver will maintain the UNC block count for each paticular
ZL10353 chip in the system.  It will only go back to 0 for a particular
ZL10353 chip when the the driver's 32 bit "state->ucblocks" variable for
that chip rolls over.

Regards,
Andy

