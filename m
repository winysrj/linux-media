Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2007 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZCGJTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 04:19:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and RDS
Date: Sat, 7 Mar 2009 10:19:39 +0100
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	hermann pitton <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
References: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl> <200903070954.08696.hverkuil@xs4all.nl> <20090307180224.7b65522d@glory.loctelecom.ru>
In-Reply-To: <20090307180224.7b65522d@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071019.39979.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 March 2009 10:02:24 Dmitri Belimov wrote:
> Hi
>
> I build rdsd. But can't start. See log:
>
> Fri Mar  6 03:44:20 2009 RDS handler initialized.
> Fri Mar  6 03:44:20 2009 Added source definition: Beholder M6 Exra
> Fri Mar  6 03:44:20 2009 RDS sources setup OK.
> Fri Mar  6 03:44:20 2009 Unix domain socket created and listening.
> Fri Mar  6 03:44:20 2009 TCP/IP socket created and listening.
> Fri Mar  6 03:44:20 2009 Using V4L2 for Beholder M6 Exra
> Fri Mar  6 03:44:20 2009 open_sources() failed.
> Fri Mar  6 03:44:20 2009 rdsd terminating with error code 13
>
> With my best regards, Dmitry.

Did you setup the /etc/rdsd.conf file correctly?

Here is mine:

$ cat /etc/rdsd.conf
[global]
unix-socket = "/var/tmp/rdsd.sock"
tcpip-port = 4321
logfile = "/var/tmp/rdsd.log"
pidfile = "/var/tmp/rdsd.pid"
console-log = yes
file-log = yes
loglevel = 5

[source]
name = "Terratec PCI card"
path = "/dev/radio0"
type = "radiodev"

After setting up this file I run 'rdsd'.
With rdsquery -f you can set the frequency in khz.
Then run

rdsquery -t \ 
rxfre,rxsig,rflags,picode,ptype,pname,locdt,utcdt,rtxt,lrtxt,tmc,aflist -c0

and watch the rds data appear.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
