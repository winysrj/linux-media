Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3H791eB020294
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 03:09:01 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3H78lrs031883
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 03:08:47 -0400
Received: by mu-out-0910.google.com with SMTP id i10so110216mue.1
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 00:08:47 -0700 (PDT)
Message-ID: <3a4a99ca0804170008x45657b06t40021faf073f0f38@mail.gmail.com>
Date: Thu, 17 Apr 2008 17:08:46 +1000
From: stuart <stuart.partridge@gmail.com>
To: benny.caldwell@gmail.com, video4linux-list@redhat.com
In-Reply-To: <1dea8a6d0804162349n271b028bgf2b709d7bb19efa1@mail.gmail.com>
MIME-Version: 1.0
References: <3a4a99ca0804162333p1d08e308ufea59a2cd40edd19@mail.gmail.com>
	<1dea8a6d0804162349n271b028bgf2b709d7bb19efa1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: Fusion/DVICO HDTV Dual 4 not working and crashing lsusb
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

Ben,

Thanks for that. Progress made: the 'hg update' went well but I ran into
errors during 'make', specifally:

*
In file included from /home/stuart/v4l-dvb/v4l/zoran_procfs.c:50:
/home/stuart/v4l-dvb/v4l/zoran.h:276: error: redefinition of 'struct
v4l2_jpegcompression'
make[3]: *** [/home/stuart/v4l-dvb/v4l/zoran_procfs.o] Error 1
make[2]: *** [_module_/home/stuart/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-14-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/stuart/v4l-dvb/v4l'
make: *** [all] Error 2
*

I did an 'rminstall' beforehand, so it's not a conflict with the previous
install.

On the upside, lsusb is reporting some love:
*
Bus 003 Device 002: ID 0fe9:db78 DVICO
Bus 003 Device 003: ID 0fe9:db78 DVICO
*

Any tips from here to correct the issue would be great.

Stuart


On Thu, Apr 17, 2008 at 4:49 PM, Ben Caldwell <benny.caldwell@gmail.com>
wrote:

> On Thu, Apr 17, 2008 at 2:33 PM, stuart <stuart.partridge@gmail.com>
> wrote:
>
> > I've had a look around the archives and can't see anything that matches
> > my
> > sitch.
> >
> I have found that the driver for this card has been broken since a certain
> change. Compiling from a revision before that change works fine for me, you
> can find my post in the archives
> http://marc.info/?l=linux-video&m=120716477703566&w=2 to see what revision
> works.
>
> Hopefully this works for you too.
>
> - Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
