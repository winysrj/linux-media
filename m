Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBR0ZxNB012058
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:35:59 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBR0ZhZm016882
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:35:43 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.14.0/8.14.0) with ESMTP id
	mBR0Zhsg046175
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:35:43 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <20081226174129.7c752fc6@gmail.com>
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
	<1230269443.3450.48.camel@localhost.localdomain>
	<20081226174129.7c752fc6@gmail.com>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 19:35:42 -0500
Message-Id: <1230338142.3450.68.camel@localhost.localdomain>
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


On Fri, 2008-12-26 at 17:41 -0200, Douglas Schilling Landgraf wrote:
> Hello,
> 
> On Fri, 26 Dec 2008 00:30:43 -0500
> Rick Bilonick <rab@nauticom.net> wrote:
> 
> > I don't know what you mean by "upstream" driver. In Ubuntu 8.10, I did
> > an "lsmod" and both the em28xx and em28xx_dvb modules show up.
> > "modprobe -l | grep em28" also shows these modules. Does that mean I
> > don't have to compile them from scratch? If they already exist, what
> > else do I have to do to get the HD Pro to receive broadcasts?
> 
> Upstream means "official", in this case official supported driver. 
> 
> I'd like to suggest:
> 
> Remove your device from usb before start your computer:
> 
> Clone official driver from linuxtv host:
> 
> shell> hg clone http://linuxtv.org/hg/v4l-dvb
> shell> cd v4l-dvb
> shell> make 
> shell> make install
> 
> Plug your device and try to play your favorite tv application.
> If you get any problem or sucess with drivers from v4l-dvb tree send
> your report to this mail-list with lsusb and dmesg output. 
> 
> p.s:
> There is a link at linuxtv wiki about compilation process from
> v4l-dvb tree:
> http://www.linuxtv.org/wiki/index.php/How_to_build_from_Mercurial
> 
> Cheers,
> Douglas

Thanks. I started the make and so far no errors. It looks like it will
take a while to compile everything. None of the other many web pages I
looked at showed these steps. (I'm not a programmer by profession, so
when I compile software, especially complex software, I need very
specific instructions to follow!) I will report back when finished.
Hopefully this will be successful.

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
