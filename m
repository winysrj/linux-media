Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:42426 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933263Ab0BECnm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 21:43:42 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
	same demux (Re: Videotext application crashes the kernel due to DVB-demux
	patch)
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org,
	Chicken Shack <chicken.shack@gmx.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <1265336477.3071.29.camel@palomino.walls.org>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Feb 2010 03:37:59 +0100
Message-Id: <1265337479.13905.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Am Donnerstag, den 04.02.2010, 21:21 -0500 schrieb Andy Walls:
> On Thu, 2010-02-04 at 15:07 +0100, Chicken Shack wrote:
> > Am Donnerstag, den 04.02.2010, 07:54 -0500 schrieb Andy Walls:
> > > On Wed, 2010-02-03 at 02:01 +0100, hermann pitton wrote:
> > > > Am Dienstag, den 02.02.2010, 07:52 -0500 schrieb Andy Walls:
> > > > > On Tue, 2010-02-02 at 10:11 +0100, Chicken Shack wrote:
> > > > > > Am Montag, den 01.02.2010, 21:00 -0500 schrieb Andy Walls:
> > > > > > > On Mon, 2010-02-01 at 07:41 -0500, Andy Walls wrote:
> > > > > > > > On Mon, 2010-02-01 at 10:56 +0100, Chicken Shack wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > here is a link to a patch which breaks backwards compatibility for a
> > > > > > > > > teletext software called alevt-dvb.
> > > > > > > > > 
> > > > > > > > > http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> > > > > > > > > 
> > > > > > > > > The kernel patch was introduced with kernel 2.6.32-rc1.
> > > > > > > > > It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> > > > > > > > > author, Andreas Oberritter.
> > > > > > > > > 
> > > > > > > 
> > > > > > > > > Regards
> > > > > > > > > 
> > > > > > > > > CS
> > > > > > > > > 
> > > > > > > > > P. S.: This is how the kernel crash looks like:
> > > > > > > > 
> > > > > > > > The information below can get me started.  Could you please provide
> > > > > > > > whole Ooops from the output dmesg or from your /var/log/messages file?
> > > > > > > > 
> > > > > > > > I'll try to look at this tonight.
> > > > > > > > 
> > > > > > > > Regards,
> > > > > > > > Andy
> > > > > > > > 
> > > > > > > > > brian:~# alevt
> > > > > > > > > alevt: SDT: service_id 0xcf24 not in PAT
> > > > > 
> > > > > > > > > alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> > > > > > > > > Getötet
> > > > > > > > > brian:~# 
> > > > > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > > > > >  kernel:[  116.563487] Oops: 0000 [#1] PREEMPT SMP 
> 
> > > > > > > So there is something wrong with the list manipulations or, if needed,
> > > > > > > locking around the the list manipulations of the list that was
> > > > > > > introduced in the patch you identified as the problem.  That is what is
> > > > > > > causing the Ooops on close().  It will take a some more scrutiny to see
> > > > > > > what exactly is wrong.
>  
> > > Schedule update: I'll be looking at this tonight (Thursday evening).
> 
> After investigation, my recommendation for fixing the problem is to
> revert the patch that is causing the problem.
> 
> The reason for this is not that fixing the patch is impossible.
> INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
> conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
> demux0 device into multiple dynamically created anonymous dvr0 devices,
> and that is the wrong thing to do.
> 
> I understand the need for sending a single PID TS out to an open demux0
> instance as described in this email:
> 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
> 
> even though it seems like a slight abuse of the demux0 device.
> 
> 
> But sending multiple PIDs out in a TS to the open demux0 device instance
> is just an awkward way to essentially dynamically create a dvrN device
> associated with filter(s) set on an open demux0 instance.
> 
> It would be better, in my opinion, to figure out a way to properly
> create and/or associate a dvrN device node with a collection of demuxN
> filters.
> 
> Maybe just allow creation of a logical demux1 device and dvr1 device and
> the use the DVB API calls as is on the new logical devices.
> 
> I'm not a DVB apps programmer, so I don't know all the userspace needs
> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> ioctl()s.
> 
> 
> Comments?
> 
> Regards,
> Andy


without looking any much closer, just at some headers that might be out
of sync,

taking the DVB patched version from here

http://pluto.blackbone-ev.de/v1/AleVT%20mit%20DVB-T.html

make
cc -O2 -s -w main.o ui.o xio.o fdset.o vbi.o cache.o help.o edline.o search.o edit.o misc.o hamm.o lang.o export.o exp-txt.o exp-html.o exp-gfx.o font.o -o alevt -L/usr/X11R6/lib -L/usr/X11R6/lib64 -lX11 -lpng -lz -lm
/usr/bin/ld: i386 architecture of input file `main.o' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file `ui.o' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file `xio.o' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file `fdset.o' is incompatible with i386:x86-64 output
collect2: ld gab 1 als Ende-Status zurück
make: *** [alevt] Fehler 1

make clean
rm -f *.o page*.txt a.out core bdf2xbm font?.xbm fontsize.h Makefile.bak
rm -f alevt alevt-date alevt-cap
rm -f alevt.1x alevt-date.1 alevt-cap.1
rm -f contrib/a.out ttext-*.*
rm -f alevt.html

make
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o main.o main.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o ui.o ui.c
cc bdf2xbm.c -o bdf2xbm
./bdf2xbm font1 <vtxt-latin-1.bdf >font1.xbm
./bdf2xbm font2 <vtxt-latin-2.bdf >font2.xbm
fgrep -h "#define" font1.xbm font2.xbm >fontsize.h
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o xio.o xio.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o fdset.o fdset.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o vbi.o vbi.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o cache.o cache.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o help.o help.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o edline.o edline.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o search.o search.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o edit.o edit.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o misc.o misc.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o hamm.o hamm.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o lang.o lang.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o export.o export.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o exp-txt.o exp-txt.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o exp-html.o exp-html.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o exp-gfx.o exp-gfx.c
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o font.o font.c
cc -O2 -s -w main.o ui.o xio.o fdset.o vbi.o cache.o help.o edline.o search.o edit.o misc.o hamm.o lang.o export.o exp-txt.o exp-html.o exp-gfx.o font.o -o alevt -L/usr/X11R6/lib -L/usr/X11R6/lib64 -lX11 -lpng -lz -lm
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o alevt-date.o alevt-date.c
cc -O2 -s -w alevt-date.o vbi.o fdset.o misc.o hamm.o lang.o -o alevt-date
cc -O2 -s -w -DVERSION=\"1.6.2\" -DWITH_PNG -I/usr/X11R6/include   -c -o alevt-cap.o alevt-cap.c
cc -O2 -s -w alevt-cap.o vbi.o fdset.o misc.o hamm.o lang.o export.o exp-txt.o exp-html.o exp-gfx.o font.o -o alevt-cap -lpng -lz -lm
sed s/VERSION/1.6.2/g <alevt.1x.in >alevt.1x
sed s/VERSION/1.6.2/g <alevt-date.1.in >alevt-date.1
sed s/VERSION/1.6.2/g <alevt-cap.1.in >alevt-cap.1

./alevt -vbi /dev/dvb/adapter0/demux0 -pid 551
Using command line specified teletext PID 0x227

No problems so far on x86_64, but I can't tell yet what might be all around.

Cheers,
Hermann





