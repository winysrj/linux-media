Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQ5VvMG004571
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 00:31:57 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQ5Uig1002788
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 00:30:44 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.14.0/8.14.0) with ESMTP id
	mBQ5UhVt059421
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 00:30:43 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20081226010307.2c7e3b55@gmail.com>
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 00:30:43 -0500
Message-Id: <1230269443.3450.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Compiling v4l-dvb-kernel for Ubuntu and for F8
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


On Fri, 2008-12-26 at 01:03 -0200, Douglas Schilling Landgraf wrote:
> Hello Rick,
> 
> On Thu, 25 Dec 2008 14:36:34 -0500
> Rick Bilonick <rab@nauticom.net> wrote:
> 
> > I'm trying to get em28xx working under Ubuntu and F8, but when I
> > "make" I get errors saying that dmxdev.h, dvb_demux.h, dvb_net.h, and
> > dvb_frontend.h cannot be found.
> > 
> > I get the same errors in F7 with v4l-dvb-experimental (same with
> > v4l-dvb-kernel):
> 
> Please use upstream driver to get support (if needed) from mail-list:
> http://linuxtv.org/v4lwiki/index.php/Em28xx_devices
> 
> Cheers,
> Douglas

I don't know what you mean by "upstream" driver. In Ubuntu 8.10, I did
an "lsmod" and both the em28xx and em28xx_dvb modules show up. "modprobe
-l | grep em28" also shows these modules. Does that mean I don't have to
compile them from scratch? If they already exist, what else do I have to
do to get the HD Pro to receive broadcasts?

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
