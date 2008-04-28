Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <chancleta@gmail.com>) id 1JqaIB-0000vN-QA
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 22:49:47 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3400647rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 13:49:38 -0700 (PDT)
Message-ID: <a4ac2da80804281349l64751c4aq413640874403afb1@mail.gmail.com>
Date: Mon, 28 Apr 2008 22:49:35 +0200
From: "Daniel Guerrero" <chancleta@gmail.com>
To: "Ian Bonham" <ian.bonham@gmail.com>
In-Reply-To: <2f8cbffc0804281141n3539e111i3b41cac7122cc462@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
	<E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
	<48156679.3030000@schoebel-online.net>
	<2f8cbffc0804281141n3539e111i3b41cac7122cc462@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 & Heron
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

Hi I tried to do this:

install a fresh ubuntu 8.04
apt-get install mercurial patch
rm -rf"'d the whole cx88 directory
hg clone http://linuxtv.org/hg/v4l-dvb
wget http://dev.kewl.org/hauppauge/mfe-7285.diff
patch -d v4l-dvb -p1 < mfe-7285.diff  (stable mfe?)

and get this:

patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.c
patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.h
patching file linux/drivers/media/dvb/frontends/Kconfig
Hunk #1 succeeded at 14 with fuzz 2.
patching file linux/drivers/media/dvb/frontends/Makefile
Hunk #1 FAILED at 52.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/dvb/frontends/Makefile.rej
patching file linux/drivers/media/dvb/frontends/cx24116.c
patching file linux/drivers/media/dvb/frontends/cx24116.h
patching file linux/drivers/media/video/cx23885/cx23885-dvb.c
Hunk #1 succeeded at 312 (offset 104 lines).
Hunk #2 FAILED at 366.
Hunk #3 succeeded at 417 (offset 104 lines).
Hunk #4 succeeded at 467 (offset 144 lines).
Hunk #5 FAILED at 475.
Hunk #6 succeeded at 504 (offset 144 lines).
Hunk #7 succeeded at 516 (offset 144 lines).
2 out of 7 hunks FAILED -- saving rejects to file
linux/drivers/media/video/cx23885/cx23885-dvb.c.rej
patching file linux/drivers/media/video/cx23885/cx23885.h
Hunk #1 succeeded at 225 (offset 5 lines).
patching file linux/drivers/media/video/cx88/Kconfig
Hunk #1 FAILED at 57.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/video/cx88/Kconfig.rej
patching file linux/drivers/media/video/cx88/cx88-cards.c
Hunk #1 succeeded at 1337 (offset 2 lines).
Hunk #2 succeeded at 1389 (offset 2 lines).
Hunk #3 succeeded at 1402 (offset 2 lines).
Hunk #4 succeeded at 1441 (offset 6 lines).
Hunk #5 succeeded at 2092 (offset 87 lines).
Hunk #6 succeeded at 2199 (offset 99 lines).
Hunk #7 succeeded at 2533 with fuzz 2 (offset 140 lines).
Hunk #8 succeeded at 2639 with fuzz 2 (offset 194 lines).
Hunk #9 succeeded at 2884 (offset 206 lines).
patching file linux/drivers/media/video/cx88/cx88-dvb.c
Hunk #1 FAILED at 48.
Hunk #2 succeeded at 113 (offset 3 lines).
Hunk #3 succeeded at 386 (offset 3 lines).
Hunk #4 FAILED at 503.
Hunk #5 succeeded at 568 (offset 44 lines).
Hunk #6 succeeded at 592 (offset 44 lines).
Hunk #7 FAILED at 605.
Hunk #8 FAILED at 734.
Hunk #9 FAILED at 756.
Hunk #10 FAILED at 783.
Hunk #11 FAILED at 803.
Hunk #12 FAILED at 823.
Hunk #13 FAILED at 843.
Hunk #14 succeeded at 1003 (offset 50 lines).
Hunk #15 succeeded at 1018 with fuzz 2 (offset 50 lines).
Hunk #16 FAILED at 1029.
Hunk #17 FAILED at 1054.
Hunk #18 succeeded at 1088 (offset 73 lines).
Hunk #19 succeeded at 1138 (offset 73 lines).
Hunk #20 succeeded at 1151 with fuzz 2 (offset 73 lines).
Hunk #21 succeeded at 1172 (offset 73 lines).
Hunk #22 FAILED at 1204.
12 out of 22 hunks FAILED -- saving rejects to file
linux/drivers/media/video/cx88/cx88-dvb.c.rej
patching file linux/drivers/media/video/cx88/cx88-i2c.c
Hunk #1 succeeded at 126 (offset -30 lines).
Hunk #2 succeeded at 225 (offset -30 lines).
patching file linux/drivers/media/video/cx88/cx88-input.c
Hunk #2 succeeded at 417 (offset 13 lines).
Hunk #3 succeeded at 486 (offset 13 lines).
patching file linux/drivers/media/video/cx88/cx88-mpeg.c
patching file linux/drivers/media/video/cx88/cx88.h
Hunk #1 FAILED at 220.
Hunk #2 succeeded at 258 (offset 4 lines).
Hunk #3 succeeded at 359 (offset 4 lines).
Hunk #4 succeeded at 518 (offset 4 lines).
1 out of 4 hunks FAILED -- saving rejects to file
linux/drivers/media/video/cx88/cx88.h.rej
patching file linux/drivers/media/video/ir-kbd-i2c.c
Hunk #1 succeeded at 66 (offset -1 lines).
Hunk #2 succeeded at 87 (offset -1 lines).
Hunk #3 succeeded at 117 (offset -1 lines).
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
Hunk #1 FAILED at 565.
Hunk #2 succeeded at 945 (offset 36 lines).
Hunk #3 FAILED at 966.
Hunk #4 succeeded at 1014 (offset 44 lines).
Hunk #5 FAILED at 1055.
Hunk #6 FAILED at 1071.
Hunk #7 FAILED at 1090.
Hunk #8 FAILED at 1103.
Hunk #9 FAILED at 1118.
Hunk #10 FAILED at 1190.
Hunk #11 succeeded at 1224 (offset 56 lines).
Hunk #12 FAILED at 1241.
Hunk #13 FAILED at 1291.
10 out of 13 hunks FAILED -- saving rejects to file
linux/drivers/media/video/saa7134/saa7134-dvb.c.rej
patching file linux/drivers/media/video/saa7134/saa7134.h
Hunk #1 succeeded at 583 (offset -1 lines).
patching file linux/drivers/media/video/tveeprom.c
patching file linux/drivers/media/video/videobuf-dvb.c
Hunk #1 FAILED at 141.
Hunk #2 succeeded at 236 (offset 4 lines).
Hunk #3 succeeded at 268 (offset 4 lines).
Hunk #4 succeeded at 283 (offset 4 lines).
1 out of 4 hunks FAILED -- saving rejects to file
linux/drivers/media/video/videobuf-dvb.c.rej
patching file linux/include/media/videobuf-dvb.h
Hunk #2 FAILED at 30.
1 out of 2 hunks FAILED -- saving rejects to file
linux/include/media/videobuf-dvb.h.rej


What do you men when you say "Then re-checked out the older v4l-dvb tree" ??

thanks,
Daniel


2008/4/28 Ian Bonham <ian.bonham@gmail.com>:
> Many thanks for all your help everyone, following Hagen's tip I went into
> /lib/modules/2.6.24-16-generic/ubuntu/media and just "rm -rf"'d the whole
> cx88 directory. Then re-checked out the older v4l-dvb tree, repatched it
> with dev.kewl.org's stable mfe patch and everything seems to be Ok now.
>
> Thanks for your help guys,
>
> Ian
>
>
>
> 2008/4/28 Hagen Sch=F6bel <hagen@schoebel-online.net>:
>
>
> >
> > Before you try the 'new' modules you have to remove the 'original'
> Ubuntu-Version of cx88*. These modules can found in
> /lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don't now why not in
> normal tree) and come with paket linux-ubuntu-modules-2.6.24-16-generic.
> >
> > Hagen
> >
> >
> > >
> > >
> > > > Hi All.
> > > >
> > > > Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hardy
> Heron) on
> > > > my machine with the HVR4000 in, and now, no TV! It's gone on with
> kernel
> > > > 2.6.24-16 on a P4 HyperThread, and everything worked just fine under
> Gutsy.
> > > > I've pulled down the v4l-dvb tree (current and revision 127f67dea087
> as
> > > > suggested in Wiki) and tried patching with dev.kewl.org's MFE and S=
FE
> > > > current patches (7285) and the latest.
> > > >
> > > > Everything 'seems' to compile Ok, and installs fine. When I reboot
> however I
> > > > get a huge chunk of borked stuff and no card. (Dmesg output at end =
of
> > > > message)
> > > >
> > > > Could anyone please give me any pointers on how (or if) they have
> their
> > > > HVR4000 running under Ubuntu 8.04LTS ?
> > > >
> > > > Would really appriciate it.
> > > > Thanks in advance,
> > > >
> > > > Ian
> > > >
> > > > DMESG Output:
> > > > cx88xx: disagrees about version of symbol videobuf_waiton
> > > > [   37.790909] cx88xx: Unknown symbol videobuf_waiton
> > > >
> > > >
> > > >
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > >
> > >
> >
> >
>
>
> _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
