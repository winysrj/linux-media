Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ian.bonham@gmail.com>) id 1Jqb2p-0004pC-F3
	for linux-dvb@linuxtv.org; Mon, 28 Apr 2008 23:37:58 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3412119rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 14:37:49 -0700 (PDT)
Message-ID: <2f8cbffc0804281437v1e26e32bic4455eb12b581d3c@mail.gmail.com>
Date: Mon, 28 Apr 2008 23:37:47 +0200
From: "Ian Bonham" <ian.bonham@gmail.com>
To: "Daniel Guerrero" <chancleta@gmail.com>
In-Reply-To: <a4ac2da80804281349l64751c4aq413640874403afb1@mail.gmail.com>
MIME-Version: 1.0
References: <2f8cbffc0804271318gf146080yfc988718556ad405@mail.gmail.com>
	<E1JqLG0-000Jpq-00.goga777-bk-ru@f132.mail.ru>
	<48156679.3030000@schoebel-online.net>
	<2f8cbffc0804281141n3539e111i3b41cac7122cc462@mail.gmail.com>
	<a4ac2da80804281349l64751c4aq413640874403afb1@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR4000 & Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0585838771=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0585838771==
Content-Type: multipart/alternative;
	boundary="----=_Part_7577_25376045.1209418667212"

------=_Part_7577_25376045.1209418667212
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Daniel,

I had this and found the answer on the v4l-dvb wiki. Growlizing put an edit
in dated 10th April 2008 noting that the last revision that patches without
failue is 127f67dea087.

What u need to do is delete your v4l-dvb checkout then run it again with th=
e
command :

hg clone -r 127f67dea087 http://linuxv.org/hg/v4l-dvb

This will pull down the older release, then you can patch that with the
mfe-7285 diff which you already have.

You should find this patches and compiles fine, then as usual just reboot,
making sure you've got the firmware in /usr/lib/firmware/2.6.24 etc etc

HTH,

Ian


2008/4/28 Daniel Guerrero <chancleta@gmail.com>:

> Hi I tried to do this:
>
> install a fresh ubuntu 8.04
> apt-get install mercurial patch
> rm -rf"'d the whole cx88 directory
> hg clone http://linuxtv.org/hg/v4l-dvb
> wget http://dev.kewl.org/hauppauge/mfe-7285.diff
> patch -d v4l-dvb -p1 < mfe-7285.diff  (stable mfe?)
>
> and get this:
>
> patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> patching file linux/drivers/media/dvb/frontends/Kconfig
> Hunk #1 succeeded at 14 with fuzz 2.
> patching file linux/drivers/media/dvb/frontends/Makefile
> Hunk #1 FAILED at 52.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/dvb/frontends/Makefile.rej
> patching file linux/drivers/media/dvb/frontends/cx24116.c
> patching file linux/drivers/media/dvb/frontends/cx24116.h
> patching file linux/drivers/media/video/cx23885/cx23885-dvb.c
> Hunk #1 succeeded at 312 (offset 104 lines).
> Hunk #2 FAILED at 366.
> Hunk #3 succeeded at 417 (offset 104 lines).
> Hunk #4 succeeded at 467 (offset 144 lines).
> Hunk #5 FAILED at 475.
> Hunk #6 succeeded at 504 (offset 144 lines).
> Hunk #7 succeeded at 516 (offset 144 lines).
> 2 out of 7 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/cx23885/cx23885-dvb.c.rej
> patching file linux/drivers/media/video/cx23885/cx23885.h
> Hunk #1 succeeded at 225 (offset 5 lines).
> patching file linux/drivers/media/video/cx88/Kconfig
> Hunk #1 FAILED at 57.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/cx88/Kconfig.rej
> patching file linux/drivers/media/video/cx88/cx88-cards.c
> Hunk #1 succeeded at 1337 (offset 2 lines).
> Hunk #2 succeeded at 1389 (offset 2 lines).
> Hunk #3 succeeded at 1402 (offset 2 lines).
> Hunk #4 succeeded at 1441 (offset 6 lines).
> Hunk #5 succeeded at 2092 (offset 87 lines).
> Hunk #6 succeeded at 2199 (offset 99 lines).
> Hunk #7 succeeded at 2533 with fuzz 2 (offset 140 lines).
> Hunk #8 succeeded at 2639 with fuzz 2 (offset 194 lines).
> Hunk #9 succeeded at 2884 (offset 206 lines).
> patching file linux/drivers/media/video/cx88/cx88-dvb.c
> Hunk #1 FAILED at 48.
> Hunk #2 succeeded at 113 (offset 3 lines).
> Hunk #3 succeeded at 386 (offset 3 lines).
> Hunk #4 FAILED at 503.
> Hunk #5 succeeded at 568 (offset 44 lines).
> Hunk #6 succeeded at 592 (offset 44 lines).
> Hunk #7 FAILED at 605.
> Hunk #8 FAILED at 734.
> Hunk #9 FAILED at 756.
> Hunk #10 FAILED at 783.
> Hunk #11 FAILED at 803.
> Hunk #12 FAILED at 823.
> Hunk #13 FAILED at 843.
> Hunk #14 succeeded at 1003 (offset 50 lines).
> Hunk #15 succeeded at 1018 with fuzz 2 (offset 50 lines).
> Hunk #16 FAILED at 1029.
> Hunk #17 FAILED at 1054.
> Hunk #18 succeeded at 1088 (offset 73 lines).
> Hunk #19 succeeded at 1138 (offset 73 lines).
> Hunk #20 succeeded at 1151 with fuzz 2 (offset 73 lines).
> Hunk #21 succeeded at 1172 (offset 73 lines).
> Hunk #22 FAILED at 1204.
> 12 out of 22 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/cx88/cx88-dvb.c.rej
> patching file linux/drivers/media/video/cx88/cx88-i2c.c
> Hunk #1 succeeded at 126 (offset -30 lines).
> Hunk #2 succeeded at 225 (offset -30 lines).
> patching file linux/drivers/media/video/cx88/cx88-input.c
> Hunk #2 succeeded at 417 (offset 13 lines).
> Hunk #3 succeeded at 486 (offset 13 lines).
> patching file linux/drivers/media/video/cx88/cx88-mpeg.c
> patching file linux/drivers/media/video/cx88/cx88.h
> Hunk #1 FAILED at 220.
> Hunk #2 succeeded at 258 (offset 4 lines).
> Hunk #3 succeeded at 359 (offset 4 lines).
> Hunk #4 succeeded at 518 (offset 4 lines).
> 1 out of 4 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/cx88/cx88.h.rej
> patching file linux/drivers/media/video/ir-kbd-i2c.c
> Hunk #1 succeeded at 66 (offset -1 lines).
> Hunk #2 succeeded at 87 (offset -1 lines).
> Hunk #3 succeeded at 117 (offset -1 lines).
> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> Hunk #1 FAILED at 565.
> Hunk #2 succeeded at 945 (offset 36 lines).
> Hunk #3 FAILED at 966.
> Hunk #4 succeeded at 1014 (offset 44 lines).
> Hunk #5 FAILED at 1055.
> Hunk #6 FAILED at 1071.
> Hunk #7 FAILED at 1090.
> Hunk #8 FAILED at 1103.
> Hunk #9 FAILED at 1118.
> Hunk #10 FAILED at 1190.
> Hunk #11 succeeded at 1224 (offset 56 lines).
> Hunk #12 FAILED at 1241.
> Hunk #13 FAILED at 1291.
> 10 out of 13 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/saa7134/saa7134-dvb.c.rej
> patching file linux/drivers/media/video/saa7134/saa7134.h
> Hunk #1 succeeded at 583 (offset -1 lines).
> patching file linux/drivers/media/video/tveeprom.c
> patching file linux/drivers/media/video/videobuf-dvb.c
> Hunk #1 FAILED at 141.
> Hunk #2 succeeded at 236 (offset 4 lines).
> Hunk #3 succeeded at 268 (offset 4 lines).
> Hunk #4 succeeded at 283 (offset 4 lines).
> 1 out of 4 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/videobuf-dvb.c.rej
> patching file linux/include/media/videobuf-dvb.h
> Hunk #2 FAILED at 30.
> 1 out of 2 hunks FAILED -- saving rejects to file
> linux/include/media/videobuf-dvb.h.rej
>
>
> What do you men when you say "Then re-checked out the older v4l-dvb tree"
> ??
>
> thanks,
> Daniel
>
>
> 2008/4/28 Ian Bonham <ian.bonham@gmail.com>:
> > Many thanks for all your help everyone, following Hagen's tip I went
> into
> > /lib/modules/2.6.24-16-generic/ubuntu/media and just "rm -rf"'d the
> whole
> > cx88 directory. Then re-checked out the older v4l-dvb tree, repatched i=
t
> > with dev.kewl.org's stable mfe patch and everything seems to be Ok now.
> >
> > Thanks for your help guys,
> >
> > Ian
> >
> >
> >
> > 2008/4/28 Hagen Sch=F6bel <hagen@schoebel-online.net>:
> >
> >
> > >
> > > Before you try the 'new' modules you have to remove the 'original'
> > Ubuntu-Version of cx88*. These modules can found in
> > /lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don't now why not in
> > normal tree) and come with paket linux-ubuntu-modules-2.6.24-16-generic=
.
> > >
> > > Hagen
> > >
> > >
> > > >
> > > >
> > > > > Hi All.
> > > > >
> > > > > Ok, so just installed the shiny, spangly new Ubuntu 8.04LTS (Hard=
y
> > Heron) on
> > > > > my machine with the HVR4000 in, and now, no TV! It's gone on with
> > kernel
> > > > > 2.6.24-16 on a P4 HyperThread, and everything worked just fine
> under
> > Gutsy.
> > > > > I've pulled down the v4l-dvb tree (current and revision
> 127f67dea087
> > as
> > > > > suggested in Wiki) and tried patching with dev.kewl.org's MFE and
> SFE
> > > > > current patches (7285) and the latest.
> > > > >
> > > > > Everything 'seems' to compile Ok, and installs fine. When I reboo=
t
> > however I
> > > > > get a huge chunk of borked stuff and no card. (Dmesg output at en=
d
> of
> > > > > message)
> > > > >
> > > > > Could anyone please give me any pointers on how (or if) they have
> > their
> > > > > HVR4000 running under Ubuntu 8.04LTS ?
> > > > >
> > > > > Would really appriciate it.
> > > > > Thanks in advance,
> > > > >
> > > > > Ian
> > > > >
> > > > > DMESG Output:
> > > > > cx88xx: disagrees about version of symbol videobuf_waiton
> > > > > [   37.790909] cx88xx: Unknown symbol videobuf_waiton
> > > > >
> > > > >
> > > > >
> > > >
> > > > _______________________________________________
> > > > linux-dvb mailing list
> > > > linux-dvb@linuxtv.org
> > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > > >
> > > >
> > >
> > >
> >
> >
> > _______________________________________________
> >  linux-dvb mailing list
> >  linux-dvb@linuxtv.org
> >  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>

------=_Part_7577_25376045.1209418667212
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Daniel,<br><br>I had this and found the answer on the v4l-dvb wiki. Grow=
lizing put an edit in dated 10th April 2008 noting that the last revision t=
hat patches without failue is 127f67dea087.<br><br>What u need to do is del=
ete your v4l-dvb checkout then run it again with the command : <br>
<br>hg clone -r 127f67dea087 <a href=3D"http://linuxv.org/hg/v4l-dvb">http:=
//linuxv.org/hg/v4l-dvb</a><br><br>This will pull down the older release, t=
hen you can patch that with the mfe-7285 diff which you already have.<br>
<br>You should find this patches and compiles fine, then as usual just rebo=
ot, making sure you&#39;ve got the firmware in /usr/lib/firmware/2.6.24 etc=
 etc<br><br>HTH,<br><br>Ian<br><br><br><div class=3D"gmail_quote">2008/4/28=
 Daniel Guerrero &lt;<a href=3D"mailto:chancleta@gmail.com">chancleta@gmail=
.com</a>&gt;:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi I tried to do =
this:<br>
<br>
install a fresh ubuntu 8.04<br>
apt-get install mercurial patch<br>
<div class=3D"Ih2E3d">rm -rf&quot;&#39;d the whole cx88 directory<br>
</div>hg clone <a href=3D"http://linuxtv.org/hg/v4l-dvb" target=3D"_blank">=
http://linuxtv.org/hg/v4l-dvb</a><br>
wget <a href=3D"http://dev.kewl.org/hauppauge/mfe-7285.diff" target=3D"_bla=
nk">http://dev.kewl.org/hauppauge/mfe-7285.diff</a><br>
patch -d v4l-dvb -p1 &lt; mfe-7285.diff &nbsp;(stable mfe?)<br>
<br>
and get this:<br>
<br>
patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.c<br>
patching file linux/drivers/media/dvb/dvb-core/dvb_frontend.h<br>
patching file linux/drivers/media/dvb/frontends/Kconfig<br>
Hunk #1 succeeded at 14 with fuzz 2.<br>
patching file linux/drivers/media/dvb/frontends/Makefile<br>
Hunk #1 FAILED at 52.<br>
1 out of 1 hunk FAILED -- saving rejects to file<br>
linux/drivers/media/dvb/frontends/Makefile.rej<br>
patching file linux/drivers/media/dvb/frontends/cx24116.c<br>
patching file linux/drivers/media/dvb/frontends/cx24116.h<br>
patching file linux/drivers/media/video/cx23885/cx23885-dvb.c<br>
Hunk #1 succeeded at 312 (offset 104 lines).<br>
Hunk #2 FAILED at 366.<br>
Hunk #3 succeeded at 417 (offset 104 lines).<br>
Hunk #4 succeeded at 467 (offset 144 lines).<br>
Hunk #5 FAILED at 475.<br>
Hunk #6 succeeded at 504 (offset 144 lines).<br>
Hunk #7 succeeded at 516 (offset 144 lines).<br>
2 out of 7 hunks FAILED -- saving rejects to file<br>
linux/drivers/media/video/cx23885/cx23885-dvb.c.rej<br>
patching file linux/drivers/media/video/cx23885/cx23885.h<br>
Hunk #1 succeeded at 225 (offset 5 lines).<br>
patching file linux/drivers/media/video/cx88/Kconfig<br>
Hunk #1 FAILED at 57.<br>
1 out of 1 hunk FAILED -- saving rejects to file<br>
linux/drivers/media/video/cx88/Kconfig.rej<br>
patching file linux/drivers/media/video/cx88/cx88-cards.c<br>
Hunk #1 succeeded at 1337 (offset 2 lines).<br>
Hunk #2 succeeded at 1389 (offset 2 lines).<br>
Hunk #3 succeeded at 1402 (offset 2 lines).<br>
Hunk #4 succeeded at 1441 (offset 6 lines).<br>
Hunk #5 succeeded at 2092 (offset 87 lines).<br>
Hunk #6 succeeded at 2199 (offset 99 lines).<br>
Hunk #7 succeeded at 2533 with fuzz 2 (offset 140 lines).<br>
Hunk #8 succeeded at 2639 with fuzz 2 (offset 194 lines).<br>
Hunk #9 succeeded at 2884 (offset 206 lines).<br>
patching file linux/drivers/media/video/cx88/cx88-dvb.c<br>
Hunk #1 FAILED at 48.<br>
Hunk #2 succeeded at 113 (offset 3 lines).<br>
Hunk #3 succeeded at 386 (offset 3 lines).<br>
Hunk #4 FAILED at 503.<br>
Hunk #5 succeeded at 568 (offset 44 lines).<br>
Hunk #6 succeeded at 592 (offset 44 lines).<br>
Hunk #7 FAILED at 605.<br>
Hunk #8 FAILED at 734.<br>
Hunk #9 FAILED at 756.<br>
Hunk #10 FAILED at 783.<br>
Hunk #11 FAILED at 803.<br>
Hunk #12 FAILED at 823.<br>
Hunk #13 FAILED at 843.<br>
Hunk #14 succeeded at 1003 (offset 50 lines).<br>
Hunk #15 succeeded at 1018 with fuzz 2 (offset 50 lines).<br>
Hunk #16 FAILED at 1029.<br>
Hunk #17 FAILED at 1054.<br>
Hunk #18 succeeded at 1088 (offset 73 lines).<br>
Hunk #19 succeeded at 1138 (offset 73 lines).<br>
Hunk #20 succeeded at 1151 with fuzz 2 (offset 73 lines).<br>
Hunk #21 succeeded at 1172 (offset 73 lines).<br>
Hunk #22 FAILED at 1204.<br>
12 out of 22 hunks FAILED -- saving rejects to file<br>
linux/drivers/media/video/cx88/cx88-dvb.c.rej<br>
patching file linux/drivers/media/video/cx88/cx88-i2c.c<br>
Hunk #1 succeeded at 126 (offset -30 lines).<br>
Hunk #2 succeeded at 225 (offset -30 lines).<br>
patching file linux/drivers/media/video/cx88/cx88-input.c<br>
Hunk #2 succeeded at 417 (offset 13 lines).<br>
Hunk #3 succeeded at 486 (offset 13 lines).<br>
patching file linux/drivers/media/video/cx88/cx88-mpeg.c<br>
patching file linux/drivers/media/video/cx88/cx88.h<br>
Hunk #1 FAILED at 220.<br>
Hunk #2 succeeded at 258 (offset 4 lines).<br>
Hunk #3 succeeded at 359 (offset 4 lines).<br>
Hunk #4 succeeded at 518 (offset 4 lines).<br>
1 out of 4 hunks FAILED -- saving rejects to file<br>
linux/drivers/media/video/cx88/cx88.h.rej<br>
patching file linux/drivers/media/video/ir-kbd-i2c.c<br>
Hunk #1 succeeded at 66 (offset -1 lines).<br>
Hunk #2 succeeded at 87 (offset -1 lines).<br>
Hunk #3 succeeded at 117 (offset -1 lines).<br>
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c<br>
Hunk #1 FAILED at 565.<br>
Hunk #2 succeeded at 945 (offset 36 lines).<br>
Hunk #3 FAILED at 966.<br>
Hunk #4 succeeded at 1014 (offset 44 lines).<br>
Hunk #5 FAILED at 1055.<br>
Hunk #6 FAILED at 1071.<br>
Hunk #7 FAILED at 1090.<br>
Hunk #8 FAILED at 1103.<br>
Hunk #9 FAILED at 1118.<br>
Hunk #10 FAILED at 1190.<br>
Hunk #11 succeeded at 1224 (offset 56 lines).<br>
Hunk #12 FAILED at 1241.<br>
Hunk #13 FAILED at 1291.<br>
10 out of 13 hunks FAILED -- saving rejects to file<br>
linux/drivers/media/video/saa7134/saa7134-dvb.c.rej<br>
patching file linux/drivers/media/video/saa7134/saa7134.h<br>
Hunk #1 succeeded at 583 (offset -1 lines).<br>
patching file linux/drivers/media/video/tveeprom.c<br>
patching file linux/drivers/media/video/videobuf-dvb.c<br>
Hunk #1 FAILED at 141.<br>
Hunk #2 succeeded at 236 (offset 4 lines).<br>
Hunk #3 succeeded at 268 (offset 4 lines).<br>
Hunk #4 succeeded at 283 (offset 4 lines).<br>
1 out of 4 hunks FAILED -- saving rejects to file<br>
linux/drivers/media/video/videobuf-dvb.c.rej<br>
patching file linux/include/media/videobuf-dvb.h<br>
Hunk #2 FAILED at 30.<br>
1 out of 2 hunks FAILED -- saving rejects to file<br>
linux/include/media/videobuf-dvb.h.rej<br>
<br>
<br>
What do you men when you say &quot;Then re-checked out the older v4l-dvb tr=
ee&quot; ??<br>
<br>
thanks,<br>
Daniel<br>
<br>
<br>
2008/4/28 Ian Bonham &lt;<a href=3D"mailto:ian.bonham@gmail.com">ian.bonham=
@gmail.com</a>&gt;:<br>
<div><div></div><div class=3D"Wj3C7c">&gt; Many thanks for all your help ev=
eryone, following Hagen&#39;s tip I went into<br>
&gt; /lib/modules/2.6.24-16-generic/ubuntu/media and just &quot;rm -rf&quot=
;&#39;d the whole<br>
&gt; cx88 directory. Then re-checked out the older v4l-dvb tree, repatched =
it<br>
&gt; with dev.kewl.org&#39;s stable mfe patch and everything seems to be Ok=
 now.<br>
&gt;<br>
&gt; Thanks for your help guys,<br>
&gt;<br>
&gt; Ian<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; 2008/4/28 Hagen Sch=F6bel &lt;<a href=3D"mailto:hagen@schoebel-online.=
net">hagen@schoebel-online.net</a>&gt;:<br>
&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; Before you try the &#39;new&#39; modules you have to remove the &=
#39;original&#39;<br>
&gt; Ubuntu-Version of cx88*. These modules can found in<br>
&gt; /lib/modules/2.6.24-16-generic/ubuntu/media/cx88 (don&#39;t now why no=
t in<br>
&gt; normal tree) and come with paket linux-ubuntu-modules-2.6.24-16-generi=
c.<br>
&gt; &gt;<br>
&gt; &gt; Hagen<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Hi All.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Ok, so just installed the shiny, spangly new Ubuntu 8.0=
4LTS (Hardy<br>
&gt; Heron) on<br>
&gt; &gt; &gt; &gt; my machine with the HVR4000 in, and now, no TV! It&#39;=
s gone on with<br>
&gt; kernel<br>
&gt; &gt; &gt; &gt; 2.6.24-16 on a P4 HyperThread, and everything worked ju=
st fine under<br>
&gt; Gutsy.<br>
&gt; &gt; &gt; &gt; I&#39;ve pulled down the v4l-dvb tree (current and revi=
sion 127f67dea087<br>
&gt; as<br>
&gt; &gt; &gt; &gt; suggested in Wiki) and tried patching with dev.kewl.org=
&#39;s MFE and SFE<br>
&gt; &gt; &gt; &gt; current patches (7285) and the latest.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Everything &#39;seems&#39; to compile Ok, and installs =
fine. When I reboot<br>
&gt; however I<br>
&gt; &gt; &gt; &gt; get a huge chunk of borked stuff and no card. (Dmesg ou=
tput at end of<br>
&gt; &gt; &gt; &gt; message)<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Could anyone please give me any pointers on how (or if)=
 they have<br>
&gt; their<br>
&gt; &gt; &gt; &gt; HVR4000 running under Ubuntu 8.04LTS ?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Would really appriciate it.<br>
&gt; &gt; &gt; &gt; Thanks in advance,<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Ian<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; DMESG Output:<br>
&gt; &gt; &gt; &gt; cx88xx: disagrees about version of symbol videobuf_wait=
on<br>
&gt; &gt; &gt; &gt; [ &nbsp; 37.790909] cx88xx: Unknown symbol videobuf_wai=
ton<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; _______________________________________________<br>
&gt; &gt; &gt; linux-dvb mailing list<br>
&gt; &gt; &gt; <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.o=
rg</a><br>
&gt; &gt; &gt; <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/l=
inux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo=
/linux-dvb</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; &nbsp;linux-dvb mailing list<br>
&gt; &nbsp;<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</=
a><br>
&gt; &nbsp;<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux=
-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/lin=
ux-dvb</a><br>
&gt;<br>
</div></div></blockquote></div><br>

------=_Part_7577_25376045.1209418667212--


--===============0585838771==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0585838771==--
