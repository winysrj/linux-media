Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:64313 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZCJIEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 04:04:43 -0400
Received: by bwz26 with SMTP id 26so1475419bwz.37
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 01:04:40 -0700 (PDT)
Date: Tue, 10 Mar 2009 17:04:40 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090310170440.2266888f@glory.loctelecom.ru>
In-Reply-To: <200903100817.54497.hverkuil@xs4all.nl>
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl>
	<200903071019.39979.hverkuil@xs4all.nl>
	<20090310114957.6077483d@glory.loctelecom.ru>
	<200903100817.54497.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

> > > Did you setup the /etc/rdsd.conf file correctly?
> > >
> > > Here is mine:
> > >
> > > $ cat /etc/rdsd.conf
> > > [global]
> > > unix-socket = "/var/tmp/rdsd.sock"
> > > tcpip-port = 4321
> > > logfile = "/var/tmp/rdsd.log"
> > > pidfile = "/var/tmp/rdsd.pid"
> > > console-log = yes
> > > file-log = yes
> > > loglevel = 5
> > >
> > > [source]
> > > name = "Terratec PCI card"
> > > path = "/dev/radio0"
> > > type = "radiodev"
> >
> > I had tunerfreq = 102000 line. After removing this line rdsd started
> > well.
> >
> > > After setting up this file I run 'rdsd'.
> > > With rdsquery -f you can set the frequency in khz.
> >
> > When run rdsquery -f 102000 the programm was hold without any
> > messages. I pressed Crt+C for exit.
> 
> Try using v4l2-ctl -d /dev/radio0 -f 102 to set the frequency. That
> may have been what I was actually using rather than rdsquery.

This command works right.
 
> >
> > > Then run
> > >
> > > rdsquery -t \
> > > rxfre,rxsig,rflags,picode,ptype,pname,locdt,utcdt,rtxt,lrtxt,tmc,aflist
> > > -c0
> >
> > This command not work too, hold and sleep.
> 
> If the frequency wasn't set, then that might explain it. Or perhaps
> you should combine the -f with the -t flag?

Out from rdsquery

rxfre:102000
rxsig:32768
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=1
picode:20480
ptype:5
rtxt:            io T 020
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=1
picode:20480
ptype:5
rtxt:            io T 020            2004
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=1
picode:20480
ptype:5
rtxt:            io T 020            2004            roni
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
pname:STN   +
rxfre:102000
rxsig:32768
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
rtxt:         Rad
rflags:TP=0 TA=0 MUSIC=0 STEREO=0 AH=0 COMP=0 DPTY=0 AB=0
picode:20480
ptype:5
rtxt:TRDS     Rad

With my best regards, Dmitry.

> You can also attempt to debug in the saa6588 to see whether it picks
> up any packets.
> 
> Regards,
> 
> 	Hans
> 
> >
> > With my best regards, Dmitry.
> >
> > > and watch the rds data appear.
> > >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > --
> > > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
