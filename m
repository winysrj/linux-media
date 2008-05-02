Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ian.bonham@gmail.com>) id 1Jrry6-0005IC-Qr
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 11:54:21 +0200
Received: by py-out-1112.google.com with SMTP id a29so1516768pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 02 May 2008 02:54:04 -0700 (PDT)
Message-ID: <2f8cbffc0805020254r4fce4951t9e895d6db28d91c0@mail.gmail.com>
Date: Fri, 2 May 2008 11:54:03 +0200
From: "Ian Bonham" <ian.bonham@gmail.com>
To: "Daniel Guerrero" <chancleta@gmail.com>
In-Reply-To: <a4ac2da80805011515o2f8c1446of7eb084e4e9cbe7b@mail.gmail.com>
MIME-Version: 1.0
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
	<E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
	<48156679.3030000@schoebel-online.net>
	<2f8cbffc0804281141n3539e111i3b41cac7122cc462@mail.gmail.com>
	<a4ac2da80804281349l64751c4aq413640874403afb1@mail.gmail.com>
	<2f8cbffc0804281437v1e26e32bic4455eb12b581d3c@mail.gmail.com>
	<a4ac2da80804291100p1d4090d8ted122ac04255e70a@mail.gmail.com>
	<2f8cbffc0804291116n17007084r273822cc2fc3174e@mail.gmail.com>
	<a4ac2da80804291215y46708712mcc7bfdad98518bcb@mail.gmail.com>
	<a4ac2da80805011515o2f8c1446of7eb084e4e9cbe7b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 & Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0360679225=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0360679225==
Content-Type: multipart/alternative;
	boundary="----=_Part_7765_28397335.1209722044073"

------=_Part_7765_28397335.1209722044073
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Daniel

Not using a webcam on my Mythbox, I really can't comment on this. Maybe
someone else on the list can offer some assistance with this.

Ian


2008/5/2 Daniel Guerrero <chancleta@gmail.com>:

> Hi Ian,
>
> the card is working perfectly but Im not totally happy, can you get
> working the tv card and a webcam, there is an imcompatibily between
> these devices, and Im trying to get both working at the same time with
> the make kernel-links option from the driver and this guide for other
> card:
> https://answers.launchpad.net/ubuntu/+question/21889
>
> Can you tell us if you can get both devices working.
>
> Thanks,
> Daniel
>
> 2008/4/29 Daniel Guerrero <chancleta@gmail.com>:
> > Finally doing
> >
> >  mkdir /dev/dvb/adapter1
> >  ln -s /dev/dvb/adapter0/frontend1 /dev/dvb/adapter1/frontend0
> >  ln -s /dev/dvb/adapter0/net1 /dev/dvb/adapter1/net0
> >  ln -s /dev/dvb/adapter0/dvr1 /dev/dvb/adapter1/dvr0
> >  ln -s /dev/dvb/adapter0/demux1 /dev/dvb/adapter1/demux0
> >
> >  Kaffeine was able to find the channels, thanks a lot man.
> >
> >  ps: DVB-S2.. I would like to try it but my dish is oriented to
> >  hispasat and no free dvb-s2 channels there, maybe other
> >  satellite....;-)
> >
> >  2008/4/29 Ian Bonham <ian.bonham@gmail.com>:
> >
> >
> > > Not sure on DVB-T I'm afraid, I only use the DVB-S/2 facilities and
> the
> >  > analogue capture at the moment.
> >  > It suggests you use dmesg to see what the full errors are, so try
> that. As
> >  > far as mine works, the card loads at boot time, so it might be that
> the card
> >  > has already been initalised, and trying to modprobe it again is
> causing your
> >  > error.
> >  >
> >  > Post the results of your dmesg output onto the list and see if anyon=
e
> has
> >  > any experience with the dvb-t facilties. I did have a quick play a
> long
> >  > while ago, and from memory, if you look in /dev/dvb you might see
> several
> >  > front ends already loaded. I remember making some soft links in the
> /dev/dvb
> >  > directory to make it look like 2 different cards which gave me some
> results.
> >  > You need to make sure all listings data is NOT collected from the
> broadcast
> >  > signal in that case however, as the drivers will try to use both
> frontends
> >  > simultaniuosly and cause crashes.
> >  >
> >  > HTH,
> >  >
> >  > Ian
> >  >
> >  >
> >  > 2008/4/29 Daniel Guerrero <chancleta@gmail.com>:
> >  >
> >  >
> >  > > hey Ian,
> >  > >
> >  > > thanks for your response, I have done like you explain, and it
> >  > > compiles fine, but because the default mode is dvb-s I tried to
> change
> >  > > it to dvb-t by changing
> >  > > /etc/modprobe.d/options and adding options cx88-dvb frontend=3D1
> >  > > reboot
> >  > > and when I tried to load the modules with:
> >  > > modprobe cx8800 && modprobe cx88xx && modprobe cx8802 && modprobe
> >  > > cx22702 && modprobe cx88-dvb
> >  > > FATAL: Error inserting cx88_dvb
> >  > >
> >  >
> (/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/cx88/cx88-dvb.=
ko):
> >  > > Unknown symbol in module, or unknown parameter (see dmesg)
> >  > >
> >  > >
> >  > > also I tried creating a new file under /etc/modprobe.d/
> >  > > root@freedom:/etc/modprobe.d# cat cx88-dvb
> >  > > options cx88-dvb frontend=3D1
> >  > > the same response with this method.
> >  > >
> >  > > Are you able to watch dvb-t or only dvb-s? how you did it?
> >  > >
> >  > > ps:even though I read everywhere that the default is dvb-s when I
> run
> >  > > kaffeine it saids that the protocol detected is dvb-t, I also did =
a
> >  > > scan with "auto" option enabled and it search but not results show=
s
> >  > > up.
> >  > >
> >  > > Thanks a lot,
> >  > >
> >  > >
> >  > >
> >  > > Daniel.
> >  > >
> >  > > 2008/4/28 Ian Bonham <ian.bonham@gmail.com>:
> >  > > > Hi Daniel,
> >  > > >
> >  > > > I had this and found the answer on the v4l-dvb wiki. Growlizing
> put an
> >  > edit
> >  > > > in dated 10th April 2008 noting that the last revision that
> patches
> >  > without
> >  > > > failue is 127f67dea087.
> >  > > >
> >  > > > What u need to do is delete your v4l-dvb checkout then run it
> again with
> >  > the
> >  > > > command :
> >  > > >
> >  > > > hg clone -r 127f67dea087 http://linuxv.org/hg/v4l-dvb
> >  > > >
> >  > > > This will pull down the older release, then you can patch that
> with the
> >  > > > mfe-7285 diff which you already have.
> >  > > >
> >  > > > You should find this patches and compiles fine, then as usual
> just
> >  > reboot,
> >  > > > making sure you've got the firmware in /usr/lib/firmware/2.6.24
> etc etc
> >  > > >
> >  > > > HTH,
> >  > > >
> >  > > > Ian
> >  > > >
> >  > > >
> >  > > > 2008/4/28 Daniel Guerrero <chancleta@gmail.com>:
> >  > > >
> >  > > >
> >  > > >
> >  > > > > Hi I tried to do this:
> >  > > > >
> >  > > > > install a fresh ubuntu 8.04
> >  > > > > apt-get install mercurial patch
> >  > > > >
> >  > > > > rm -rf"'d the whole cx88 directory
> >  > > > > hg clone http://linuxtv.org/hg/v4l-dvb
> >  > > > > wget http://dev.kewl.org/hauppauge/mfe-7285.diff
> >  > > > > patch -d v4l-dvb -p1 < mfe-7285.diff  (stable mfe?)
> >  > > > >
> >  > > > > and get this:
> >  > > > >
> >  > > > > patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> >  > > > > patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> >  > > > > patching file linux/drivers/media/dvb/frontends/Kconfig
> >  > > > > Hunk #1 succeeded at 14 with fuzz 2.
> >  > > > > patching file linux/drivers/media/dvb/frontends/Makefile
> >  > > > > Hunk #1 FAILED at 52.
> >  > > > > 1 out of 1 hunk FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/dvb/frontends/Makefile.rej
> >  > > > > patching file linux/drivers/media/dvb/frontends/cx24116.c
> >  > > > > patching file linux/drivers/media/dvb/frontends/cx24116.h
> >  > > > > patching file linux/drivers/media/video/cx23885/cx23885-dvb.c
> >  > > > > Hunk #1 succeeded at 312 (offset 104 lines).
> >  > > > > Hunk #2 FAILED at 366.
> >  > > > > Hunk #3 succeeded at 417 (offset 104 lines).
> >  > > > > Hunk #4 succeeded at 467 (offset 144 lines).
> >  > > > > Hunk #5 FAILED at 475.
> >  > > > > Hunk #6 succeeded at 504 (offset 144 lines).
> >  > > > > Hunk #7 succeeded at 516 (offset 144 lines).
> >  > > > > 2 out of 7 hunks FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/cx23885/cx23885-dvb.c.rej
> >  > > > > patching file linux/drivers/media/video/cx23885/cx23885.h
> >  > > > > Hunk #1 succeeded at 225 (offset 5 lines).
> >  > > > > patching file linux/drivers/media/video/cx88/Kconfig
> >  > > > > Hunk #1 FAILED at 57.
> >  > > > > 1 out of 1 hunk FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/cx88/Kconfig.rej
> >  > > > > patching file linux/drivers/media/video/cx88/cx88-cards.c
> >  > > > > Hunk #1 succeeded at 1337 (offset 2 lines).
> >  > > > > Hunk #2 succeeded at 1389 (offset 2 lines).
> >  > > > > Hunk #3 succeeded at 1402 (offset 2 lines).
> >  > > > > Hunk #4 succeeded at 1441 (offset 6 lines).
> >  > > > > Hunk #5 succeeded at 2092 (offset 87 lines).
> >  > > > > Hunk #6 succeeded at 2199 (offset 99 lines).
> >  > > > > Hunk #7 succeeded at 2533 with fuzz 2 (offset 140 lines).
> >  > > > > Hunk #8 succeeded at 2639 with fuzz 2 (offset 194 lines).
> >  > > > > Hunk #9 succeeded at 2884 (offset 206 lines).
> >  > > > > patching file linux/drivers/media/video/cx88/cx88-dvb.c
> >  > > > > Hunk #1 FAILED at 48.
> >  > > > > Hunk #2 succeeded at 113 (offset 3 lines).
> >  > > > > Hunk #3 succeeded at 386 (offset 3 lines).
> >  > > > > Hunk #4 FAILED at 503.
> >  > > > > Hunk #5 succeeded at 568 (offset 44 lines).
> >  > > > > Hunk #6 succeeded at 592 (offset 44 lines).
> >  > > > > Hunk #7 FAILED at 605.
> >  > > > > Hunk #8 FAILED at 734.
> >  > > > > Hunk #9 FAILED at 756.
> >  > > > > Hunk #10 FAILED at 783.
> >  > > > > Hunk #11 FAILED at 803.
> >  > > > > Hunk #12 FAILED at 823.
> >  > > > > Hunk #13 FAILED at 843.
> >  > > > > Hunk #14 succeeded at 1003 (offset 50 lines).
> >  > > > > Hunk #15 succeeded at 1018 with fuzz 2 (offset 50 lines).
> >  > > > > Hunk #16 FAILED at 1029.
> >  > > > > Hunk #17 FAILED at 1054.
> >  > > > > Hunk #18 succeeded at 1088 (offset 73 lines).
> >  > > > > Hunk #19 succeeded at 1138 (offset 73 lines).
> >  > > > > Hunk #20 succeeded at 1151 with fuzz 2 (offset 73 lines).
> >  > > > > Hunk #21 succeeded at 1172 (offset 73 lines).
> >  > > > > Hunk #22 FAILED at 1204.
> >  > > > > 12 out of 22 hunks FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/cx88/cx88-dvb.c.rej
> >  > > > > patching file linux/drivers/media/video/cx88/cx88-i2c.c
> >  > > > > Hunk #1 succeeded at 126 (offset -30 lines).
> >  > > > > Hunk #2 succeeded at 225 (offset -30 lines).
> >  > > > > patching file linux/drivers/media/video/cx88/cx88-input.c
> >  > > > > Hunk #2 succeeded at 417 (offset 13 lines).
> >  > > > > Hunk #3 succeeded at 486 (offset 13 lines).
> >  > > > > patching file linux/drivers/media/video/cx88/cx88-mpeg.c
> >  > > > > patching file linux/drivers/media/video/cx88/cx88.h
> >  > > > > Hunk #1 FAILED at 220.
> >  > > > > Hunk #2 succeeded at 258 (offset 4 lines).
> >  > > > > Hunk #3 succeeded at 359 (offset 4 lines).
> >  > > > > Hunk #4 succeeded at 518 (offset 4 lines).
> >  > > > > 1 out of 4 hunks FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/cx88/cx88.h.rej
> >  > > > > patching file linux/drivers/media/video/ir-kbd-i2c.c
> >  > > > > Hunk #1 succeeded at 66 (offset -1 lines).
> >  > > > > Hunk #2 succeeded at 87 (offset -1 lines).
> >  > > > > Hunk #3 succeeded at 117 (offset -1 lines).
> >  > > > > patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> >  > > > > Hunk #1 FAILED at 565.
> >  > > > > Hunk #2 succeeded at 945 (offset 36 lines).
> >  > > > > Hunk #3 FAILED at 966.
> >  > > > > Hunk #4 succeeded at 1014 (offset 44 lines).
> >  > > > > Hunk #5 FAILED at 1055.
> >  > > > > Hunk #6 FAILED at 1071.
> >  > > > > Hunk #7 FAILED at 1090.
> >  > > > > Hunk #8 FAILED at 1103.
> >  > > > > Hunk #9 FAILED at 1118.
> >  > > > > Hunk #10 FAILED at 1190.
> >  > > > > Hunk #11 succeeded at 1224 (offset 56 lines).
> >  > > > > Hunk #12 FAILED at 1241.
> >  > > > > Hunk #13 FAILED at 1291.
> >  > > > > 10 out of 13 hunks FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/saa7134/saa7134-dvb.c.rej
> >  > > > > patching file linux/drivers/media/video/saa7134/saa7134.h
> >  > > > > Hunk #1 succeeded at 583 (offset -1 lines).
> >  > > > > patching file linux/drivers/media/video/tveeprom.c
> >  > > > > patching file linux/drivers/media/video/videobuf-dvb.c
> >  > > > > Hunk #1 FAILED at 141.
> >  > > > > Hunk #2 succeeded at 236 (offset 4 lines).
> >  > > > > Hunk #3 succeeded at 268 (offset 4 lines).
> >  > > > > Hunk #4 succeeded at 283 (offset 4 lines).
> >  > > > > 1 out of 4 hunks FAILED -- saving rejects to file
> >  > > > > linux/drivers/media/video/videobuf-dvb.c.rej
> >  > > > > patching file linux/include/media/videobuf-dvb.h
> >  > > > > Hunk #2 FAILED at 30.
> >  > > > > 1 out of 2 hunks FAILED -- saving rejects to file
> >  > > > > linux/include/media/videobuf-dvb.h.rej
> >  > > > >
> >  > > > >
> >  > > > > What do you men when you say "Then re-checked out the older
> v4l-dvb
> >  > tree"
> >  > > > ??
> >  > > > >
> >  > > > > thanks,
> >  > > > > Daniel
> >  > > > >
> >  > > > >
> >  > > > > 2008/4/28 Ian Bonham <ian.bonham@gmail.com>:
> >  > > > >
> >  > > > >
> >  > > > >
> >  > > > > > Many thanks for all your help everyone, following Hagen's ti=
p
> I went
> >  > > > into
> >  > > > > > /lib/modules/2.6.24-16-generic/ubuntu/media and just "rm
> -rf"'d the
> >  > > > whole
> >  > > > > > cx88 directory. Then re-checked out the older v4l-dvb tree,
> >  > repatched it
> >  > > > > > with dev.kewl.org's stable mfe patch and everything seems to
> be Ok
> >  > now.
> >  > > > > >
> >  > > > > > Thanks for your help guys,
> >  > > > > >
> >  > > > > > Ian
> >  > > > > >
> >  > > > > >
> >  > > > > >
> >  > > > > > 2008/4/28 Hagen Sch=F6bel <hagen@schoebel-online.net>:
> >  > > > > >
> >  > > > > >
> >  > > > > > >
> >  > > > > > > Before you try the 'new' modules you have to remove the
> 'original'
> >  > > > > > Ubuntu-Version of cx88*. These modules can found in
> >  > > > > > /lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don't now
> why not
> >  > in
> >  > > > > > normal tree) and come with paket
> >  > linux-ubuntu-modules-2.6.24-16-generic.
> >  > > > > > >
> >  > > > > > > Hagen
> >  > > > > > >
> >  > > > > > >
> >  > > > > > > >
> >  > > > > > > >
> >  > > > > > > > > Hi All.
> >  > > > > > > > >
> >  > > > > > > > > Ok, so just installed the shiny, spangly new Ubuntu
> 8.04LTS
> >  > (Hardy
> >  > > > > > Heron) on
> >  > > > > > > > > my machine with the HVR4000 in, and now, no TV! It's
> gone on
> >  > with
> >  > > > > > kernel
> >  > > > > > > > > 2.6.24-16 on a P4 HyperThread, and everything worked
> just fine
> >  > > > under
> >  > > > > > Gutsy.
> >  > > > > > > > > I've pulled down the v4l-dvb tree (current and revisio=
n
> >  > > > 127f67dea087
> >  > > > > > as
> >  > > > > > > > > suggested in Wiki) and tried patching with
> dev.kewl.org's MFE
> >  > and
> >  > > > SFE
> >  > > > > > > > > current patches (7285) and the latest.
> >  > > > > > > > >
> >  > > > > > > > > Everything 'seems' to compile Ok, and installs fine.
> When I
> >  > reboot
> >  > > > > > however I
> >  > > > > > > > > get a huge chunk of borked stuff and no card. (Dmesg
> output at
> >  > end
> >  > > > of
> >  > > > > > > > > message)
> >  > > > > > > > >
> >  > > > > > > > > Could anyone please give me any pointers on how (or if=
)
> they
> >  > have
> >  > > > > > their
> >  > > > > > > > > HVR4000 running under Ubuntu 8.04LTS ?
> >  > > > > > > > >
> >  > > > > > > > > Would really appriciate it.
> >  > > > > > > > > Thanks in advance,
> >  > > > > > > > >
> >  > > > > > > > > Ian
> >  > > > > > > > >
> >  > > > > > > > > DMESG Output:
> >  > > > > > > > > cx88xx: disagrees about version of symbol
> videobuf_waiton
> >  > > > > > > > > [   37.790909] cx88xx: Unknown symbol videobuf_waiton
> >  > > > > > > > >
> >  > > > > > > > >
> >  > > > > > > > >
> >  > > > > > > >
> >  > > > > > > > _______________________________________________
> >  > > > > > > > linux-dvb mailing list
> >  > > > > > > > linux-dvb@linuxtv.org
> >  > > > > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dv=
b
> >  > > > > > > >
> >  > > > > > > >
> >  > > > > > >
> >  > > > > > >
> >  > > > > >
> >  > > > > >
> >  > > > > > _______________________________________________
> >  > > > > >  linux-dvb mailing list
> >  > > > > >  linux-dvb@linuxtv.org
> >  > > > > >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >  > > > > >
> >  > > > >
> >  > > >
> >  > > >
> >  > >
> >  >
> >  >
> >
>

------=_Part_7765_28397335.1209722044073
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Daniel<br><br>Not using a webcam on my Mythbox, I really can&#39;t comme=
nt on this. Maybe someone else on the list can offer some assistance with t=
his.<br><br>Ian<br><br><br><div class=3D"gmail_quote">2008/5/2 Daniel Guerr=
ero &lt;<a href=3D"mailto:chancleta@gmail.com">chancleta@gmail.com</a>&gt;:=
<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi Ian,<br>
<br>
the card is working perfectly but Im not totally happy, can you get<br>
working the tv card and a webcam, there is an imcompatibily between<br>
these devices, and Im trying to get both working at the same time with<br>
the make kernel-links option from the driver and this guide for other<br>
card:<br>
<a href=3D"https://answers.launchpad.net/ubuntu/+question/21889" target=3D"=
_blank">https://answers.launchpad.net/ubuntu/+question/21889</a><br>
<br>
Can you tell us if you can get both devices working.<br>
<br>
Thanks,<br>
<font color=3D"#888888">Daniel<br>
</font><div><div></div><div class=3D"Wj3C7c"><br>
2008/4/29 Daniel Guerrero &lt;<a href=3D"mailto:chancleta@gmail.com">chancl=
eta@gmail.com</a>&gt;:<br>
&gt; Finally doing<br>
&gt;<br>
&gt; &nbsp;mkdir /dev/dvb/adapter1<br>
&gt; &nbsp;ln -s /dev/dvb/adapter0/frontend1 /dev/dvb/adapter1/frontend0<br=
>
&gt; &nbsp;ln -s /dev/dvb/adapter0/net1 /dev/dvb/adapter1/net0<br>
&gt; &nbsp;ln -s /dev/dvb/adapter0/dvr1 /dev/dvb/adapter1/dvr0<br>
&gt; &nbsp;ln -s /dev/dvb/adapter0/demux1 /dev/dvb/adapter1/demux0<br>
&gt;<br>
&gt; &nbsp;Kaffeine was able to find the channels, thanks a lot man.<br>
&gt;<br>
&gt; &nbsp;ps: DVB-S2.. I would like to try it but my dish is oriented to<b=
r>
&gt; &nbsp;hispasat and no free dvb-s2 channels there, maybe other<br>
&gt; &nbsp;satellite....;-)<br>
&gt;<br>
&gt; &nbsp;2008/4/29 Ian Bonham &lt;<a href=3D"mailto:ian.bonham@gmail.com"=
>ian.bonham@gmail.com</a>&gt;:<br>
&gt;<br>
&gt;<br>
&gt; &gt; Not sure on DVB-T I&#39;m afraid, I only use the DVB-S/2 faciliti=
es and the<br>
&gt; &nbsp;&gt; analogue capture at the moment.<br>
&gt; &nbsp;&gt; It suggests you use dmesg to see what the full errors are, =
so try that. As<br>
&gt; &nbsp;&gt; far as mine works, the card loads at boot time, so it might=
 be that the card<br>
&gt; &nbsp;&gt; has already been initalised, and trying to modprobe it agai=
n is causing your<br>
&gt; &nbsp;&gt; error.<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt; Post the results of your dmesg output onto the list and see=
 if anyone has<br>
&gt; &nbsp;&gt; any experience with the dvb-t facilties. I did have a quick=
 play a long<br>
&gt; &nbsp;&gt; while ago, and from memory, if you look in /dev/dvb you mig=
ht see several<br>
&gt; &nbsp;&gt; front ends already loaded. I remember making some soft link=
s in the /dev/dvb<br>
&gt; &nbsp;&gt; directory to make it look like 2 different cards which gave=
 me some results.<br>
&gt; &nbsp;&gt; You need to make sure all listings data is NOT collected fr=
om the broadcast<br>
&gt; &nbsp;&gt; signal in that case however, as the drivers will try to use=
 both frontends<br>
&gt; &nbsp;&gt; simultaniuosly and cause crashes.<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt; HTH,<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt; Ian<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt; 2008/4/29 Daniel Guerrero &lt;<a href=3D"mailto:chancleta@g=
mail.com">chancleta@gmail.com</a>&gt;:<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt; &gt; hey Ian,<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; thanks for your response, I have done like you explain=
, and it<br>
&gt; &nbsp;&gt; &gt; compiles fine, but because the default mode is dvb-s I=
 tried to change<br>
&gt; &nbsp;&gt; &gt; it to dvb-t by changing<br>
&gt; &nbsp;&gt; &gt; /etc/modprobe.d/options and adding options cx88-dvb fr=
ontend=3D1<br>
&gt; &nbsp;&gt; &gt; reboot<br>
&gt; &nbsp;&gt; &gt; and when I tried to load the modules with:<br>
&gt; &nbsp;&gt; &gt; modprobe cx8800 &amp;&amp; modprobe cx88xx &amp;&amp; =
modprobe cx8802 &amp;&amp; modprobe<br>
&gt; &nbsp;&gt; &gt; cx22702 &amp;&amp; modprobe cx88-dvb<br>
&gt; &nbsp;&gt; &gt; FATAL: Error inserting cx88_dvb<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; (/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/=
cx88/cx88-dvb.ko):<br>
&gt; &nbsp;&gt; &gt; Unknown symbol in module, or unknown parameter (see dm=
esg)<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; also I tried creating a new file under /etc/modprobe.d=
/<br>
&gt; &nbsp;&gt; &gt; root@freedom:/etc/modprobe.d# cat cx88-dvb<br>
&gt; &nbsp;&gt; &gt; options cx88-dvb frontend=3D1<br>
&gt; &nbsp;&gt; &gt; the same response with this method.<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; Are you able to watch dvb-t or only dvb-s? how you did=
 it?<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; ps:even though I read everywhere that the default is d=
vb-s when I run<br>
&gt; &nbsp;&gt; &gt; kaffeine it saids that the protocol detected is dvb-t,=
 I also did a<br>
&gt; &nbsp;&gt; &gt; scan with &quot;auto&quot; option enabled and it searc=
h but not results shows<br>
&gt; &nbsp;&gt; &gt; up.<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; Thanks a lot,<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; Daniel.<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt; &gt; 2008/4/28 Ian Bonham &lt;<a href=3D"mailto:ian.bonham@=
gmail.com">ian.bonham@gmail.com</a>&gt;:<br>
&gt; &nbsp;&gt; &gt; &gt; Hi Daniel,<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; I had this and found the answer on the v4l-dvb wi=
ki. Growlizing put an<br>
&gt; &nbsp;&gt; edit<br>
&gt; &nbsp;&gt; &gt; &gt; in dated 10th April 2008 noting that the last rev=
ision that patches<br>
&gt; &nbsp;&gt; without<br>
&gt; &nbsp;&gt; &gt; &gt; failue is 127f67dea087.<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; What u need to do is delete your v4l-dvb checkout=
 then run it again with<br>
&gt; &nbsp;&gt; the<br>
&gt; &nbsp;&gt; &gt; &gt; command :<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; hg clone -r 127f67dea087 <a href=3D"http://linuxv=
.org/hg/v4l-dvb" target=3D"_blank">http://linuxv.org/hg/v4l-dvb</a><br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; This will pull down the older release, then you c=
an patch that with the<br>
&gt; &nbsp;&gt; &gt; &gt; mfe-7285 diff which you already have.<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; You should find this patches and compiles fine, t=
hen as usual just<br>
&gt; &nbsp;&gt; reboot,<br>
&gt; &nbsp;&gt; &gt; &gt; making sure you&#39;ve got the firmware in /usr/l=
ib/firmware/2.6.24 etc etc<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; HTH,<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; Ian<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; 2008/4/28 Daniel Guerrero &lt;<a href=3D"mailto:c=
hancleta@gmail.com">chancleta@gmail.com</a>&gt;:<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hi I tried to do this:<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; install a fresh ubuntu 8.04<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; apt-get install mercurial patch<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; rm -rf&quot;&#39;d the whole cx88 directory<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; hg clone <a href=3D"http://linuxtv.org/hg/v4=
l-dvb" target=3D"_blank">http://linuxtv.org/hg/v4l-dvb</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; wget <a href=3D"http://dev.kewl.org/hauppaug=
e/mfe-7285.diff" target=3D"_blank">http://dev.kewl.org/hauppauge/mfe-7285.d=
iff</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patch -d v4l-dvb -p1 &lt; mfe-7285.diff &nbs=
p;(stable mfe?)<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; and get this:<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/dvb-co=
re/dvb_frontend.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/dvb-co=
re/dvb_frontend.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/fronte=
nds/Kconfig<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 14 with fuzz 2.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/fronte=
nds/Makefile<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 52.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 1 out of 1 hunk FAILED -- saving rejects to =
file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/dvb/frontends/Makefile.r=
ej<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/fronte=
nds/cx24116.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/dvb/fronte=
nds/cx24116.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx23=
885/cx23885-dvb.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 312 (offset 104 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 FAILED at 366.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 417 (offset 104 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 succeeded at 467 (offset 144 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #5 FAILED at 475.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #6 succeeded at 504 (offset 144 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #7 succeeded at 516 (offset 144 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 2 out of 7 hunks FAILED -- saving rejects to=
 file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/cx23885/cx23885-dv=
b.c.rej<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx23=
885/cx23885.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 225 (offset 5 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/Kconfig<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 57.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 1 out of 1 hunk FAILED -- saving rejects to =
file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/cx88/Kconfig.rej<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88-cards.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 1337 (offset 2 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 1389 (offset 2 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 1402 (offset 2 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 succeeded at 1441 (offset 6 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #5 succeeded at 2092 (offset 87 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #6 succeeded at 2199 (offset 99 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #7 succeeded at 2533 with fuzz 2 (offse=
t 140 lines).<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #8 succeeded at 2639 with fuzz 2 (offse=
t 194 lines).<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #9 succeeded at 2884 (offset 206 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88-dvb.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 48.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 113 (offset 3 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 386 (offset 3 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 FAILED at 503.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #5 succeeded at 568 (offset 44 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #6 succeeded at 592 (offset 44 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #7 FAILED at 605.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #8 FAILED at 734.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #9 FAILED at 756.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #10 FAILED at 783.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #11 FAILED at 803.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #12 FAILED at 823.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #13 FAILED at 843.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #14 succeeded at 1003 (offset 50 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #15 succeeded at 1018 with fuzz 2 (offs=
et 50 lines).<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #16 FAILED at 1029.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #17 FAILED at 1054.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #18 succeeded at 1088 (offset 73 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #19 succeeded at 1138 (offset 73 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #20 succeeded at 1151 with fuzz 2 (offs=
et 73 lines).<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #21 succeeded at 1172 (offset 73 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #22 FAILED at 1204.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 12 out of 22 hunks FAILED -- saving rejects =
to file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/cx88/cx88-dvb.c.re=
j<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88-i2c.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 126 (offset -30 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 225 (offset -30 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88-input.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 417 (offset 13 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 486 (offset 13 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88-mpeg.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/cx88=
/cx88.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 220.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 258 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 359 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 succeeded at 518 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; 1 out of 4 hunks FAILED -- saving rejects to=
 file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/cx88/cx88.h.rej<br=
>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/ir-k=
bd-i2c.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 66 (offset -1 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 87 (offset -1 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 117 (offset -1 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/saa7=
134/saa7134-dvb.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 565.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 945 (offset 36 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 FAILED at 966.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 succeeded at 1014 (offset 44 lines).=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #5 FAILED at 1055.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #6 FAILED at 1071.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #7 FAILED at 1090.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #8 FAILED at 1103.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #9 FAILED at 1118.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #10 FAILED at 1190.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #11 succeeded at 1224 (offset 56 lines)=
.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #12 FAILED at 1241.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #13 FAILED at 1291.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 10 out of 13 hunks FAILED -- saving rejects =
to file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/saa7134/saa7134-dv=
b.c.rej<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/saa7=
134/saa7134.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 succeeded at 583 (offset -1 lines).<=
br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/tvee=
prom.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/drivers/media/video/vide=
obuf-dvb.c<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #1 FAILED at 141.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 succeeded at 236 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #3 succeeded at 268 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #4 succeeded at 283 (offset 4 lines).<b=
r>
&gt; &nbsp;&gt; &gt; &gt; &gt; 1 out of 4 hunks FAILED -- saving rejects to=
 file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/drivers/media/video/videobuf-dvb.c.rej=
<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; patching file linux/include/media/videobuf-d=
vb.h<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Hunk #2 FAILED at 30.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 1 out of 2 hunks FAILED -- saving rejects to=
 file<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; linux/include/media/videobuf-dvb.h.rej<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; What do you men when you say &quot;Then re-c=
hecked out the older v4l-dvb<br>
&gt; &nbsp;&gt; tree&quot;<br>
&gt; &nbsp;&gt; &gt; &gt; ??<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; thanks,<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; Daniel<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; 2008/4/28 Ian Bonham &lt;<a href=3D"mailto:i=
an.bonham@gmail.com">ian.bonham@gmail.com</a>&gt;:<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Many thanks for all your help everyone,=
 following Hagen&#39;s tip I went<br>
&gt; &nbsp;&gt; &gt; &gt; into<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; /lib/modules/2.6.24-16-generic/ubuntu/m=
edia and just &quot;rm -rf&quot;&#39;d the<br>
&gt; &nbsp;&gt; &gt; &gt; whole<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; cx88 directory. Then re-checked out the=
 older v4l-dvb tree,<br>
&gt; &nbsp;&gt; repatched it<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; with dev.kewl.org&#39;s stable mfe patc=
h and everything seems to be Ok<br>
&gt; &nbsp;&gt; now.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Thanks for your help guys,<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Ian<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; 2008/4/28 Hagen Sch=F6bel &lt;<a href=
=3D"mailto:hagen@schoebel-online.net">hagen@schoebel-online.net</a>&gt;:<br=
>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; Before you try the &#39;new&#39; m=
odules you have to remove the &#39;original&#39;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Ubuntu-Version of cx88*. These modules =
can found in<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; /lib/modules/2.6.24-16-generic/ubuntu/m=
edia/cx88 (don&#39;t now why not<br>
&gt; &nbsp;&gt; in<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; normal tree) and come with paket<br>
&gt; &nbsp;&gt; linux-ubuntu-modules-2.6.24-16-generic.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; Hagen<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi All.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Ok, so just installed th=
e shiny, spangly new Ubuntu 8.04LTS<br>
&gt; &nbsp;&gt; (Hardy<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Heron) on<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; my machine with the HVR4=
000 in, and now, no TV! It&#39;s gone on<br>
&gt; &nbsp;&gt; with<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; kernel<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; 2.6.24-16 on a P4 HyperT=
hread, and everything worked just fine<br>
&gt; &nbsp;&gt; &gt; &gt; under<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; Gutsy.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; I&#39;ve pulled down the=
 v4l-dvb tree (current and revision<br>
&gt; &nbsp;&gt; &gt; &gt; 127f67dea087<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; as<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; suggested in Wiki) and t=
ried patching with dev.kewl.org&#39;s MFE<br>
&gt; &nbsp;&gt; and<br>
&gt; &nbsp;&gt; &gt; &gt; SFE<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; current patches (7285) a=
nd the latest.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Everything &#39;seems&#3=
9; to compile Ok, and installs fine. When I<br>
&gt; &nbsp;&gt; reboot<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; however I<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; get a huge chunk of bork=
ed stuff and no card. (Dmesg output at<br>
&gt; &nbsp;&gt; end<br>
&gt; &nbsp;&gt; &gt; &gt; of<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; message)<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Could anyone please give=
 me any pointers on how (or if) they<br>
&gt; &nbsp;&gt; have<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; their<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; HVR4000 running under Ub=
untu 8.04LTS ?<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Would really appriciate =
it.<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks in advance,<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Ian<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; DMESG Output:<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; cx88xx: disagrees about =
version of symbol videobuf_waiton<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; [ &nbsp; 37.790909] cx88=
xx: Unknown symbol videobuf_waiton<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; _____________________________=
__________________<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; linux-dvb mailing list<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"mailto:linux-dvb@l=
inuxtv.org">linux-dvb@linuxtv.org</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"http://www.linuxtv=
.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linux=
tv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; _______________________________________=
________<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &nbsp;linux-dvb mailing list<br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &nbsp;<a href=3D"mailto:linux-dvb@linux=
tv.org">linux-dvb@linuxtv.org</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt; &nbsp;<a href=3D"http://www.linuxtv.org=
/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.o=
rg/cgi-bin/mailman/listinfo/linux-dvb</a><br>
&gt; &nbsp;&gt; &gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt; &gt;<br>
&gt; &nbsp;&gt; &gt;<br>
&gt; &nbsp;&gt;<br>
&gt; &nbsp;&gt;<br>
&gt;<br>
</div></div></blockquote></div><br>

------=_Part_7765_28397335.1209722044073--


--===============0360679225==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0360679225==--
