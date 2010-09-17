Return-path: <mchehab@pedra>
Received: from mail45.e.nsc.no ([193.213.115.45]:50454 "EHLO mail45.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab0IQRdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 13:33:17 -0400
Subject: Re: Trouble building v4l-dvb
From: "Ole W. Saastad" <olewsaa@online.no>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4C93364C.3040606@hoogenraad.net>
References: <1284493110.1801.57.camel@sofia>
	 <4C924EB8.9070500@hoogenraad.net>  <4C93364C.3040606@hoogenraad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 19:33:11 +0200
Message-ID: <1284744791.1670.11.camel@sofia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for all help so far.

I managed to figure out the firetv problem as soon as I discovered
the .myconfig file.

Including the drivers from Sandberg, for the rtl2832 chip and adding
some lines to Makefile, Kconfig and .myconfig it compiles and install.
Modules load and Me-TV starts, quality is poor with the small antenna.

However, there is no audio. Not even for the DAB radio channels.

Maybe this is Me-TV problem?

The version supplied with Easy Peasy Ubuntu 9.10 is old,  0.7.16.


Regards,
Ole W. Saastad






fr., 17.09.2010 kl. 11.35 +0200, skrev Jan Hoogenraad:
> I see that the build now succeeded.
> 
> Ole: this is something that should have been fixed a long time ago, but 
> isn't.
> make allyesmod
> should set only those divers that do actually compile.
> Unfortunately, the FIREDTV driver has bugs for as long as I remember.
> 
> In the 4vl directory, edit .config
> and change the line
> CONFIG_DVB_FIREDTV=m
> into
> CONFIG_DVB_FIREDTV=n
> 
> It should compile fine then.
> 
> Jan Hoogenraad wrote:
> > Douglas;
> > 
> > Could you please check your last putback ?
> > 
> > the build is broken.
> > 
> > see:
> > http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
> > 
> > and the mail
> > [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
> > 
> > Yours,
> >         Jan
> > 
> > Ole W. Saastad wrote:
> >> Trouble building v4l-dvb
> >> Asus eee netbook, running EasyPeasy.
> >>
> >> ole@ole-eee:~$ cat /etc/issue
> >> Ubuntu 9.04 \n \l
> >> ole@ole-eee:~$ uname -a
> >> Linux ole-eee 2.6.30.5-ep0 #10 SMP PREEMPT Thu Aug 27 19:45:06 CEST 2009
> >> i686 GNU/Linux
> >>
> >> Rationale for building from source: I have bought a USB TV with mpg4 
> >> support from Sandberg, Mini DVB-T
> >> dongle. I also received an archive with driver routines for this from
> >> Sandberg. These should be copied into the v4l-dvd three and just rebuild
> >> with make.
> >> I have installed the kernel headers:
> >> apt-get install mercurial linux-headers-$(uname -r) build-essential
> >>
> >> Then I have downloaded the v4l-dvb source (assuming this is a stable
> >> release): hg clone http://linuxtv.org/hg/v4l-dvb
> >>
> >>
> >> I wanted to try to build before applying the patch from Sandberg. 
> >> Issuing make yield the following :
> >>
> >> LIRC: Requires at least kernel 2.6.36
> >> IR_LIRC_CODEC: Requires at least kernel 2.6.36
> >> IR_IMON: Requires at least kernel 2.6.36
> >> IR_MCEUSB: Requires at least kernel 2.6.36
> >> VIDEOBUF_DMA_CONTIG: Requires at least kernel 2.6.31
> >> V4L2_MEM2MEM_DEV: Requires at least kernel 2.6.33
> >> and a few more lines....
> >>
> >> Ignoring these and just continuing :
> >>
> >>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-dvb.o
> >>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-fe.o
> >>   CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-1394.o
> >> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:22:17: error: dma.h: No such
> >> file or directory
> >> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:23:21: error: csr1212.h: No
> >> such file or directory
> >> /home/ole/work/v4l-dvb/v4l/firedtv-1394.c:24:23: error: highlevel.h: No
> >> such file or directory
> >> and many many more similar errors.
> >>
> >> After some time the make bails out.
> >>
> >>
> >> I assume this have some connection with the 9.04 being too old.
> >>
> >> Hints ?
> >>
> >>
> >>
> >> Regards,
> >> Ole W. Saastad
> >>
> >>
> >>
> >>
> >> -- 
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > 
> > 
> 
> 


