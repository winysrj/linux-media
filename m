Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L90dn-0004ZQ-7I
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 18:08:28 +0100
Date: Sat, 06 Dec 2008 18:07:53 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
Message-ID: <20081206170753.69410@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>, michel@verbraak.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan (possible
	diseqc	problem)
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

> 2008/12/5 Michel Verbraak <michel@verbraak.org>
> =

> >  Alex,
> >
> > I have the following problem. I'm not able to rotate my rotor with my
> HD2
> > card and any of the drivers (liplianin, v4l-dvb, Manu). I tried GotoX
> diseqc
> > commands as well as the goto position used by scan-s2.
> > As Pavel also has problems with diseqc (switch with A B input) I think
> it
> > is not in the scan-s2 an szap-s2 utilities but in the driver.
> >
> I don't have a rotor nor HD2 card, so I can't help with that.
> I do have 8-1 disecq that works fine with Igor's drivers (previously
> worked
> fine with Manu's drivers as well) and scan-s2 utility using Twinhan 1041
> card.

I have a Twinhan 1041 card and I have problems with the s2-liplianin driver
which I have not fully understood yet.

1) Scan-s2 works for a while but in a long scan I eventually I start getting
"Slave RACK Fail !" messages in dmesg and scan-s2 hangs. Perhaps increasing=
 to
msleep(15) in mantis_ack_wait helps (it hasn't eliminated the problem), but=
 I am not sure.
There are messages in /var/log/messages from stb6100_[set/get]_[frequency/b=
andwidth]
which say "Invalid parameter". Only shutting down the computer and restarti=
ng seems to
recover from this once it has happened.

2) szap-s2 works for a while after a cold start, but I think if you stop it=
 and leave it for
30 seconds or so the card goes into sleep mode and after that szap-s2 hangs=
. Strangely when
this happens a short scan-s2 run (not long enough to get the "Slave RACK Fa=
il!" problem) can wake
the card up again, and szap-s2 works after that.  But szap-s2 can't wake it=
 up itself and hangs in
get_pmt_pid on the line
if (((count =3D read(patfd, buf, sizeof(buft))) < 0) && errno =3D=3D EOVERF=
LOW){

When it goes into sleep mode I see the following in dmesg:
[  522.821625] _stb0899_read_reg: Reg=3D[0xf12a], data=3D58                =
                                                                        =

[  522.821632] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...           =
                                                                    =

[  522.821634] stb0899_write_regs [0xf12a]: 58                             =
                                                                    =

[  522.822681] stb0899_sleep: Going to Sleep .. (Really tired .. :-))

So the Twinhan 1041 is quite useless for me at the moment.

> =

> Few weeks ago Hans Werner applied changes for scan-s2 to work with his
> rotor. Please take a look on rotor.conf file and "-r" option.
> Maybe it will help.

I tested that with an HVR4000 by the way. I'm not aware that the problems I=
 have
with the Twinhan vp1041 are to do with diseqc. When it is working diseqc
works too.

> =

> >
> > I changed the subject because I do not know if Pavels problem is only
> due
> > to diseqc problems.
> >
> > I have another card (twinhan vp-1034 mantis) which should be able to
> rotate
> > my rotor and I will try it next weekend to see if my rotor is not broken
> and
> > I will also have a look into the driver but this will be not easy
> beacuse I
> > do not have schematics or any documentation.
> >
> My 1027 card worked fine with multiproto drivers few months ago (replaced
> it
> with 1041 card)

-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
