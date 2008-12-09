Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LA4cO-0001Z4-Vx
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 16:35:26 +0100
Date: Tue, 09 Dec 2008 16:34:51 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081206170753.69410@gmx.net>
Message-ID: <20081209153451.75130@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
	<20081206170753.69410@gmx.net>
To: "Hans Werner" <HWerner4@gmx.de>, michel@verbraak.org, alex.betis@gmail.com
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Technisat HD2 cannot szap/scan
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

> > 2008/12/5 Michel Verbraak <michel@verbraak.org>
> > =

> > >  Alex,
> > >
> > > I have the following problem. I'm not able to rotate my rotor with my
> > HD2
> > > card and any of the drivers (liplianin, v4l-dvb, Manu). I tried GotoX
> > diseqc
> > > commands as well as the goto position used by scan-s2.
> > > As Pavel also has problems with diseqc (switch with A B input) I think
> > it
> > > is not in the scan-s2 an szap-s2 utilities but in the driver.
> > >
> > I don't have a rotor nor HD2 card, so I can't help with that.
> > I do have 8-1 disecq that works fine with Igor's drivers (previously
> > worked
> > fine with Manu's drivers as well) and scan-s2 utility using Twinhan 1041
> > card.
> =

> I have a Twinhan 1041 card and I have problems with the s2-liplianin
> driver
> which I have not fully understood yet.
> =

> 1) Scan-s2 works for a while but in a long scan I eventually I start
> getting
> "Slave RACK Fail !" messages in dmesg and scan-s2 hangs. Perhaps
> increasing to
> msleep(15) in mantis_ack_wait helps (it hasn't eliminated the problem),
> but I am not sure.
> There are messages in /var/log/messages from
> stb6100_[set/get]_[frequency/bandwidth]
> which say "Invalid parameter". Only shutting down the computer and
> restarting seems to
> recover from this once it has happened.

I looked into this more and found a possible solution. The problem =

occurs in the i2c handling for stb6100_read_regs or stb6100_write_regs.

diff -r 29523b6d6cc0 linux/drivers/media/dvb/mantis/mantis_i2c.c
--- a/linux/drivers/media/dvb/mantis/mantis_i2c.c
+++ b/linux/drivers/media/dvb/mantis/mantis_i2c.c
@@ -42,7 +42,7 @@ static int mantis_ack_wait(struct mantis
                dprintk(verbose, MANTIS_DEBUG, 1, "Master !I2CDONE");
                rc =3D -EREMOTEIO;
        }
-       while (!(mantis->mantis_int_stat & MANTIS_INT_I2CRACK)) {
+       while (!(mantis->mantis_int_stat & MANTIS_INT_I2CDONE)) {
                dprintk(verbose, MANTIS_DEBUG, 1, "Waiting for Slave RACK");
                mantis->mantis_int_stat =3D mmread(MANTIS_INT_STAT);
                msleep(5);

The reason for this change is that usually both I2CRACK and I2CDONE bits
are set in mantis_int_stat but there are occasions when I2CDONE can be set
and I2CRACK is not (it seems particularly following attempts to tune to non=
-existent
channels as you will do sometimes in a scan). The right number of I2CDONEs =
occur
for reading/writing the stb6100 registers, just no I2CRACKs.

> =

> 2) szap-s2 works for a while after a cold start, but I think if you stop
> it and leave it for
> 30 seconds or so =


sorry it is 1 minute, not 30 seconds

> the card goes into sleep mode and after that szap-s2
> hangs. Strangely when
> this happens a short scan-s2 run (not long enough to get the "Slave RACK
> Fail!" problem) can wake
> the card up again, and szap-s2 works after that.  But szap-s2 can't wake
> it up itself and hangs in
> get_pmt_pid on the line
> if (((count =3D read(patfd, buf, sizeof(buft))) < 0) && errno =3D=3D EOVE=
RFLOW){
> =

> When it goes into sleep mode I see the following in dmesg:
> [  522.821625] _stb0899_read_reg: Reg=3D[0xf12a], data=3D58              =
     =

>                                                                     =

> [  522.821632] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...          =

>                                                                     =

> [  522.821634] stb0899_write_regs [0xf12a]: 58                            =

>                                                                     =

> [  522.822681] stb0899_sleep: Going to Sleep .. (Really tired .. :-))
> =

> So the Twinhan 1041 is quite useless for me at the moment.

Try the following channels.conf for Astra at 19.2E:

TVEi;CANALSATELLITE:11567:vS0C56M2:S19.2E:22000:58:59:61:0:9022:1:1024:0
ZDF;ZDFvision:11953:hS0C34M2:S19.2E:27500:110:120=3Ddeu,121=3D2ch;125=3Ddeu=
:130:0:28006:1:1079:0

Then do the following (in this order): =

0. point dish to 19.2E.
1. tune to TVEi
szap-s2 -a 0 -r -p -V -c ~/channels.conf.astra1 "TVEi;CANALSATELLITE"

2. hit ctrl-c, and wait 1 minute until the frontend sleeps (check dmesg)

3. try to tune to ZDF. It FAILS (hangs).
szap-s2 -a 0 -r -p -V -c ~/channels.conf.astra1 "ZDF;ZDFvision"

4. ctrl-c and then szap-s2 to TVEi. That WORKS.

5. ctrl-c and then quickly (before sleep) szap-s2 to ZDF. Now it WORKS too.
You can keep changing to other channels provided that it is not allowed to =

get into a sleep.

Similar problems are seen using scan-s2 instead of szap-s2.

I suspect part of the frontend state (hw or sw) survives the sleep and prev=
ents tuning
to channels with different parameters subsequently. In other words the init=
ialization
called when resuming from the sleep is not bringing the card to the exactly=
 the same
reproducible state each time. A successful tuning (4 above) fixes things on=
ly until the
next sleep. I don't know yet where the problem is, but something isn't gett=
ing initialized
properly -- in the stb0899, stb6100 or maybe one of the parameter structs?

Can someone reproduce this? (or fix the problem ;-) ).

Hans
-- =

Release early, release often.

Sensationsangebot verl=E4ngert: GMX FreeDSL - Telefonanschluss + DSL =

f=FCr nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1308T4569a

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
