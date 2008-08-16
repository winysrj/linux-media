Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G8dr7E026605
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 04:39:53 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G8dbvl019115
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 04:39:38 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080816134720.37ad63e2@glory.loctelecom.ru>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
	<48A4763D.8030509@hccnet.nl>
	<20080815115954.0be6c5ba@glory.loctelecom.ru>
	<200808150805.20459.hverkuil@xs4all.nl>
	<20080816134720.37ad63e2@glory.loctelecom.ru>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 10:30:12 +0200
Message-Id: <1218875412.2668.20.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro@xs4all.nl,
	Gert Vervoort <gert.vervoort@hccnet.nl>, Chehab <mchehab@infradead.org>
Subject: Re: MPEG stream work
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

Hi,

Am Samstag, den 16.08.2008, 13:47 +1000 schrieb Dmitri Belimov:
> Hi Hans
> 
> > > I found problem in v4l2-ctl. This programm can't set correct TV
> > > norm. After my hack TV norm was set correct.
> > 
> > ???
> > 
> > $ v4l2-ctl -s secam-dk
> > Standard set to 00320000
> > 
> > v4l2-ctl works fine for me!
> > 
> > Are you using the latest v4l2-ctl version from v4l-dvb? I did fix a
> > bug in SetStandard some time ago (although I think that bug didn't
> > affect this particular situation either).
> 
> This is my error. I run
> 
> v4l2-ctl -s=secam-dk -d /dev/video0
> 
> It response set TV norm to 0x0b000
> 
> When I run
> 
> v4l2-ctl -s secam-dk -d /dev/video0
> 
> All is OK.
> 
> With my best regards, Dmitry.

yes, sorry.

This does explain at least the NTSC-M seen after it and lowers confusion
on this, after all, amazing and successful story.

However, using v4l2-ctl for setting the correct norm still results in
losing picture and sound immediately on all FMD1216ME/I MK3 and all
tda8275a tuners in this machine here.

The same happens with old "v4lctl setnorm PAL-BG".
The tda8275a is known for not playing nicely with all apps, the FMD1216
is famous for other issues, but not those.

Eventually I might have a chance in the evening to play with some very
old tuners to look out for any difference, for now I still say, I can't
set the norm neither with v4l2-ctl nor v4lctl on all four cards I have
here and this was my latest contribution to help to debug it.

Cheers,
Hermann

>  
> > Regards,
> > 
> > 	Hans
> > 
> > >
> > > diff -r 42e3970c09aa v4l2-apps/util/v4l2-ctl.cpp
> > > --- a/v4l2-apps/util/v4l2-ctl.cpp	Sun Jul 27 19:30:46 2008
> > > -0300 +++ b/v4l2-apps/util/v4l2-ctl.cpp	Fri Aug 15 05:53:38
> > > 2008 +1000 @@ -1572,6 +1572,7 @@
> > >  	}
> > >
> > >  	if (options[OptSetStandard]) {
> > > +	  std = 0x320000; // durty hack for SECAM-DK
> > >  		if (std & (1ULL << 63)) {
> > >  			vs.index = std & 0xffff;
> > >  			if (ioctl(fd, VIDIOC_ENUMSTD, &vs) >= 0) {
> > >
> > > I have MPEG stream with CORRECT TV data.
> > > See link:
> > >
> > > http://debian.oshec.org/binary/tmp/mpeg02.dat
> > >
> > > Yahooooo!
> > >
> > > With my best regards, Dmitry.
> > >


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
