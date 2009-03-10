Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1879 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZCJHR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 03:17:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and RDS
Date: Tue, 10 Mar 2009 08:17:54 +0100
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl> <200903071019.39979.hverkuil@xs4all.nl> <20090310114957.6077483d@glory.loctelecom.ru>
In-Reply-To: <20090310114957.6077483d@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903100817.54497.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 March 2009 03:49:57 Dmitri Belimov wrote:
> Hi
>
> > On Saturday 07 March 2009 10:02:24 Dmitri Belimov wrote:
> > > Hi
> > >
> > > I build rdsd. But can't start. See log:
> > >
> > > Fri Mar  6 03:44:20 2009 RDS handler initialized.
> > > Fri Mar  6 03:44:20 2009 Added source definition: Beholder M6 Exra
> > > Fri Mar  6 03:44:20 2009 RDS sources setup OK.
> > > Fri Mar  6 03:44:20 2009 Unix domain socket created and listening.
> > > Fri Mar  6 03:44:20 2009 TCP/IP socket created and listening.
> > > Fri Mar  6 03:44:20 2009 Using V4L2 for Beholder M6 Exra
> > > Fri Mar  6 03:44:20 2009 open_sources() failed.
> > > Fri Mar  6 03:44:20 2009 rdsd terminating with error code 13
> > >
> > > With my best regards, Dmitry.
> >
> > Did you setup the /etc/rdsd.conf file correctly?
> >
> > Here is mine:
> >
> > $ cat /etc/rdsd.conf
> > [global]
> > unix-socket = "/var/tmp/rdsd.sock"
> > tcpip-port = 4321
> > logfile = "/var/tmp/rdsd.log"
> > pidfile = "/var/tmp/rdsd.pid"
> > console-log = yes
> > file-log = yes
> > loglevel = 5
> >
> > [source]
> > name = "Terratec PCI card"
> > path = "/dev/radio0"
> > type = "radiodev"
>
> I had tunerfreq = 102000 line. After removing this line rdsd started
> well.
>
> > After setting up this file I run 'rdsd'.
> > With rdsquery -f you can set the frequency in khz.
>
> When run rdsquery -f 102000 the programm was hold without any messages.
> I pressed Crt+C for exit.

Try using v4l2-ctl -d /dev/radio0 -f 102 to set the frequency. That may have 
been what I was actually using rather than rdsquery.

>
> > Then run
> >
> > rdsquery -t \
> > rxfre,rxsig,rflags,picode,ptype,pname,locdt,utcdt,rtxt,lrtxt,tmc,aflist
> > -c0
>
> This command not work too, hold and sleep.

If the frequency wasn't set, then that might explain it. Or perhaps you 
should combine the -f with the -t flag?

You can also attempt to debug in the saa6588 to see whether it picks up any 
packets.

Regards,

	Hans

>
> With my best regards, Dmitry.
>
> > and watch the rds data appear.
> >
> > Regards,
> >
> > 	Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
