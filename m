Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1LOWpJ-0003Qz-I5
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2009 13:32:30 +0100
Date: Sun, 18 Jan 2009 04:31:54 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <alpine.DEB.2.00.0901181205110.18169@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Message-ID: <358234.8431.qm@web110808.mail.gq1.yahoo.com>
Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for linux?
Reply-To: linux-media@vger.kernel.org, urishk@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>




--- On Sun, 1/18/09, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> Subject: Re: [linux-dvb] Siano subsystem (DAB/DMB support) library for li=
nux?
> To: "St=E5le Helleberg / drc.no" <staale@drc.no>
> Cc: urishk@yahoo.com
> Date: Sunday, January 18, 2009, 1:36 PM
> A reply to myself.  A copy to you, in case you are
> interested.
> You will still be laughing at me.  Go ahead.  Laugh.
> =

> On Sat, 17 Jan 2009, BOUWSMA Barry wrote:
> =

> > > Please find my testprogram attached. It probably
> has quite a lot of errors,
> > =

> > Many thanks.  I've tried to hack a few things,
> with as little
> > as I know, to make it easier to build with the
> downloaded Siano
> > library somewhere else.
> =

> I wrote yesterday that I had a few problems on the machine
> where I installed this.  So I had the idea to copy the
> Siano
> library and your source to another machine which I've
> been
> upgrading, but where major 251 was free, in case that might
> be one of the many possibilities why it might work.
> =

> For background, the initial installation was done on a
> notebook
> laptop type machine based on debian 4.0, and presently
> running
> kernel 2.6.27-rc4.  `gcc' there is a 4.4.0 CVS-type,
> and that
> might be the reason I needed to add <unistd.h> (if I
> read a
> linux-kernel post yesterday properly)...
> =

> =

> The newer machine has been partly upgraded from an original
> 2.6.8-flavour debian installation where some sort of fsck
> problem or similar resulted in a good deal of the system
> files disappearing, which I've upgraded to a 2-week old
> debian-testing DVD snapshot, and am running a 2.6.28-rc8
> kernel.  This seems to have helped with some things.  Also
> it's not a notebook with pcmcia and major 251 is free,
> the
> biggest reason for me to try it...
> =

> =

> > Here is how I modified compile.sh, to allow me to
> specify with
> > CPPFLAGS and LDFLAGS the path to my copy of the Siano
> library:
> =

> I've also added ${CFLAGS} to allow me to specify
> CFLAGS=3D-DDEBUG
> in order to better follow the code...
> =

> =

> > gcc -Wall -Werror  -o dab *.o -Llinux_x86_c_lib
> -L../linux_x86_c_lib ${LDFLAGS} -lsmscontrol -lssp
> =

> The -lssp which I apparently had to add is no longer
> needed.
> And so far, it hasn't even been installed...
> =

> =

> > +/* XXX HACK */
> > +#include <unistd.h> // for usleep
> =

> This, however, is still needed...
> =

> =

> > Another thing I needed to do was to modify the
> Siano-supplied
> > `create_char_dev.sh' to make use of the proper
> major number,
> =

> I added a little bit more to this, as I also noted that
> one could specify a non-zero minor number as well (which
> probably wouldn't help me reclaim the use of major 251
> on
> the problematic notebook, but hey)
> =

> Here's the complete file to do this, again.  Note that
> I'm
> well aware that anyone with the least bit of skill should
> be able to do far better than I can in far fewer lines,
> but hey, it's the ideas that count, isn't it?  No? =

> It isn't?
> =

> =

> #!/bin/sh
> =

> # USAGE:  $0  major  minor  (arguments optional)
> #  if major is 0 or not specified, will make a feeble
> half-hearted
> #  attempt to determine which major is in use by smsmdtv
> #  default being 251.  minor is 0 unless specified
> otherwise
> =

> # HACK:  major 251 is used on my test system.
> #  allow user to specify major.
> #  else try to get it from /proc/devices.
> #  else fallback to the default (251)
> =

> # more HACK:  the module also allows one to specify a
> particular
> #  starting minor number.  Not sure how to detect that
> automagically.
> #  assume 0, but allow user to override this as second
> argument
> #  (in which case first is required, or perhaps 0 to
> detect)
> =

> SMSMINOR=3D0
> if [ "x$1" !=3D "x" ]
> then
> 	SMSCHAR=3D$1
> 	if [ "x$2" !=3D "x" ]
> 	then
> 		SMSMINOR=3D$2
> 	fi
> 	if [ "x$SMSCHAR" =3D "x0" ]
> 	then
> 		SMSCHAR=3D""
> 	fi
> fi
> =

> if [ "x$SMSCHAR" =3D "x" ]
> then
> 	SMSCHAR=3D`grep smschar /proc/devices 2>/dev/null | cut
> -f1 -d ' ' | head -1 `
> fi
> =

> if [ "x$SMSCHAR" =3D "x" ]
> then
> 	SMSCHAR=3D"251"
> fi
> echo Using major $SMSCHAR, starting at minor $SMSMINOR...
> =

> cd /dev && mknod -m 766 /dev/mdtvctrl c $SMSCHAR
> $(($SMSMINOR + 0))
> cd /dev && mknod -m 766 /dev/mdtv1 c $SMSCHAR
> $(($SMSMINOR + 1))
> cd /dev && mknod -m 766 /dev/mdtv2 c $SMSCHAR
> $(($SMSMINOR + 2))
> cd /dev && mknod -m 766 /dev/mdtv3 c $SMSCHAR
> $(($SMSMINOR + 3))
> cd /dev && mknod -m 766 /dev/mdtv4 c $SMSCHAR
> $(($SMSMINOR + 4))
> cd /dev && mknod -m 766 /dev/mdtv5 c $SMSCHAR
> $(($SMSMINOR + 5))
> cd /dev && mknod -m 766 /dev/mdtv6 c $SMSCHAR
> $(($SMSMINOR + 6))
> cd /dev && mknod -m 766 /dev/mdtv7 c $SMSCHAR
> $(($SMSMINOR + 7))
> cd /dev && mknod -m 766 /dev/mdtv8 c $SMSCHAR
> $(($SMSMINOR + 8))
> cd /dev && mknod -m 766 /dev/mdtv9 c $SMSCHAR
> $(($SMSMINOR + 9))
> cd /dev && mknod -m 766 /dev/mdtv10 c $SMSCHAR
> $(($SMSMINOR + 10))
> cd /dev && mknod -m 766 /dev/mdtv11 c $SMSCHAR
> $(($SMSMINOR + 11))
> cd /dev && mknod -m 766 /dev/mdtv12 c $SMSCHAR
> $(($SMSMINOR + 12))
> cd /dev && mknod -m 766 /dev/mdtv13 c $SMSCHAR
> $(($SMSMINOR + 13))
> cd /dev && mknod -m 766 /dev/mdtv14 c $SMSCHAR
> $(($SMSMINOR + 14))
> cd /dev && mknod -m 766 /dev/mdtv15 c $SMSCHAR
> $(($SMSMINOR + 15))
> cd /dev && mknod -m 766 /dev/mdtv16 c $SMSCHAR
> $(($SMSMINOR + 16))
> =

> =

> =

> > All my hacks should be considered either public domain
> or
> > at best, BSD licensed, with the ideas behind them
> probably
> > far more worthy than the code.
> =

> Given the value of the code, that's not difficult...
> =

> =

> > I'm not quite that far yet, as I may have some
> further
> > hardware debugging to do -- plus I will learn far more
> from
> =

> It was not hardware debugging needed, so it seems.  On the
> new installation, I have finally had success!  Yay!  Oh
> Joy!
> Rapture!
> =

> But first, you need some good laughs, so here's what I
> learned:
> =

> * Do not `scp -r' the v4l-dvb source which I patched
> with the
>   Siano hacks before falling asleep.  `scp' follows
> symlinks,
>   so when I woke up, the destination was still in the
> process
>   of trying to copy most of the origin machine's
> filesystem.
> =

> * I don't know how this happened, but I had a zero-size
> top-
>   level makefile in the obj tree of my linux kernel on the
>   destination machine, which had no effect on rebuilding
> the
>   kernel with the latest installed-from-DVD tools.  Normal
>   build commands wouldn't fix that, and v4l-dvb
> didn't like it.
>   It's fixed, but I wasted an hour when I could have
> been
>   sleeping wondering how it happened.
> =

> * Oh joy, it looks like more ice-rain now, and the ice from
>   the last ice-rain storm two weeks ago is still present
> and
>   causing problems.  And I hoped to finally go out
> tomorrow...
> =

> =

> Anyway, now I see this, and am happy:
> =

> SmSHostApiDeviceInit_Req with payload 0
> Well, that was just yow
> Tuning into a frequency
> Kenneth, the frequency is  227360000
> Esemble Info Result
> Well, no problems there
> Tuning...
> Esemble Info Result
> EID: 16385 with 12 services 'SRG SSR D01     '
> Get Combined Components result
> Found 12 services...
> =

> Service: 0 - DRS 1
> Service: 1 - DRS 2
> Service: 2 - DRS 3
> Service: 3 - DRS MUSIKWELLE
> Service: 4 - DRS Virus
> Service: 5 - CH-POP
> Service: 6 - CH-CLASSIC
> Service: 7 - CH-JAZZ
> Service: 8 - RSR-1ERE
> Service: 9 - RETE UNO
> Service: 10 -  RR-SRG
> Service: 11 - DRS 4 NEWS
> Please select service [0..12] and press enter:
> =

> =

> I guess I'll force the module to major 249 and see if I
> still
> experience the same problems (timeout during device init)
> as
> on the other machine.  If so, I'll complain loudly to
> Uri
> that the Siano binary library seems to have major 251
> hardcoded
> somewhere within, rather than the device names linked by
> the
> script, or some similar problem.
> =

> If not, the problem will be elsewhere, I *won't*
> complain to
> Uri, until I figure out what it could be.
> =

> =

> Again, many thanks for your simple program!  I'll see
> what
> else I can do with it...
> =

> =

> barry bouwsma


It's not hard-coded in the library. The library just open the node by name -
    int fd =3D open( "/dev/mdtvctrl", O_RDWR );



Uri





      =


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
