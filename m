Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:33169 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZCJCuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 22:50:04 -0400
Received: by mu-out-0910.google.com with SMTP id i10so553771mue.1
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 19:50:01 -0700 (PDT)
Date: Tue, 10 Mar 2009 11:49:57 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090310114957.6077483d@glory.loctelecom.ru>
In-Reply-To: <200903071019.39979.hverkuil@xs4all.nl>
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl>
	<200903070954.08696.hverkuil@xs4all.nl>
	<20090307180224.7b65522d@glory.loctelecom.ru>
	<200903071019.39979.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

> On Saturday 07 March 2009 10:02:24 Dmitri Belimov wrote:
> > Hi
> >
> > I build rdsd. But can't start. See log:
> >
> > Fri Mar  6 03:44:20 2009 RDS handler initialized.
> > Fri Mar  6 03:44:20 2009 Added source definition: Beholder M6 Exra
> > Fri Mar  6 03:44:20 2009 RDS sources setup OK.
> > Fri Mar  6 03:44:20 2009 Unix domain socket created and listening.
> > Fri Mar  6 03:44:20 2009 TCP/IP socket created and listening.
> > Fri Mar  6 03:44:20 2009 Using V4L2 for Beholder M6 Exra
> > Fri Mar  6 03:44:20 2009 open_sources() failed.
> > Fri Mar  6 03:44:20 2009 rdsd terminating with error code 13
> >
> > With my best regards, Dmitry.
> 
> Did you setup the /etc/rdsd.conf file correctly?
> 
> Here is mine:
> 
> $ cat /etc/rdsd.conf
> [global]
> unix-socket = "/var/tmp/rdsd.sock"
> tcpip-port = 4321
> logfile = "/var/tmp/rdsd.log"
> pidfile = "/var/tmp/rdsd.pid"
> console-log = yes
> file-log = yes
> loglevel = 5
> 
> [source]
> name = "Terratec PCI card"
> path = "/dev/radio0"
> type = "radiodev"
> 

I had tunerfreq = 102000 line. After removing this line rdsd started well.

> After setting up this file I run 'rdsd'.
> With rdsquery -f you can set the frequency in khz.

When run rdsquery -f 102000 the programm was hold without any messages.
I pressed Crt+C for exit.

> Then run
> 
> rdsquery -t \ 
> rxfre,rxsig,rflags,picode,ptype,pname,locdt,utcdt,rtxt,lrtxt,tmc,aflist
> -c0

This command not work too, hold and sleep.

With my best regards, Dmitry.

> and watch the rds data appear.
> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
