Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQJftwn023851
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 14:41:55 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQJfYVq013978
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 14:41:35 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1474868qwe.39
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 11:41:34 -0800 (PST)
Date: Fri, 26 Dec 2008 17:41:29 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: video4linux-list@redhat.com, rab@nauticom.net
Message-ID: <20081226174129.7c752fc6@gmail.com>
In-Reply-To: <1230269443.3450.48.camel@localhost.localdomain>
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
	<1230269443.3450.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
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

Hello,

On Fri, 26 Dec 2008 00:30:43 -0500
Rick Bilonick <rab@nauticom.net> wrote:

> I don't know what you mean by "upstream" driver. In Ubuntu 8.10, I did
> an "lsmod" and both the em28xx and em28xx_dvb modules show up.
> "modprobe -l | grep em28" also shows these modules. Does that mean I
> don't have to compile them from scratch? If they already exist, what
> else do I have to do to get the HD Pro to receive broadcasts?

Upstream means "official", in this case official supported driver. 

I'd like to suggest:

Remove your device from usb before start your computer:

Clone official driver from linuxtv host:

shell> hg clone http://linuxtv.org/hg/v4l-dvb
shell> cd v4l-dvb
shell> make 
shell> make install

Plug your device and try to play your favorite tv application.
If you get any problem or sucess with drivers from v4l-dvb tree send
your report to this mail-list with lsusb and dmesg output. 

p.s:
There is a link at linuxtv wiki about compilation process from
v4l-dvb tree:
http://www.linuxtv.org/wiki/index.php/How_to_build_from_Mercurial

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
