Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1LJYaz-00069T-Km
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 20:25:12 +0100
Date: Sun, 04 Jan 2009 20:24:35 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <20081215143047.45940@gmx.net>
Message-ID: <20090104192435.72460@gmx.net>
MIME-Version: 1.0
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
	<4935B72F.1000505@insite.cz>
	<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>
	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz> <4938C8BB.5040406@verbraak.org>
	<c74595dc0812050100q52ab86bewebe8dbf17bddbb51@mail.gmail.com>
	<20081206170753.69410@gmx.net> <20081209153451.75130@gmx.net>
	<20081215143047.45940@gmx.net>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Mantis Bug (was Technisat HD2 cannot
 szap/scan)
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

> With the Azurewave AD-SP400 (Twinhan VP-1041 / Technisat HD2 / =

> ?poss. Terratec Cinergy S2 PCI HD)
> there seems to be a driver bug when tuning some channels immediately
> after boot or after resuming from sleep (which is entered after 1 minute
> idle).
> So the initialisation seems to be unsuitable for tuning some channels.
> =

> But... if another channel is tuned successfully first then the bad
> channels *CAN* be tuned
> (if you are quick and do it before it sleeps again).
> =

> It looks like the problem channels are all horizontal but perhaps other
> parameters are =

> relevant too/instead.
> =

> Can anyone help?
> Instructions for reproducing the problem on Astra 19.2E or Hotbird 13.0E
> are below.
> =

> I don't know whether the problem is in the mantis, stb0899, stb6100 or
> lnbp21 code.

Problem solved with the patch below.

I found that both problems tuning channels (#1 immediately after boot and #=
2 after sleep) are
caused by the lnbp21 voltage OFF setting. To fix #1: the LNB voltage needs =
to be turned on when
the lnbp21 is attached, and to fix #2: turning the voltage off on sleep nee=
ds to be disabled.

To keep the voltage on, we need to make sure that register bit LNBP21_EN is=
 always set. =


I note that as well as controlling the voltage regulator blocks this regist=
er bit also controls
a loopthrough switch -- clearing the bit takes the lnbp21 out of the LNB li=
ne, which could be
used to allow other circuitry to do LNB power and control. I don't have any=
 info on how the
card is actually wired. It seems best to keep the EN bit always set, becaus=
e I know clearing
it causes trouble.

It turns out there is already a mechanism for specifying register bits to b=
e overridden in
the lnbp21 attach call (already used for another card) and we just need to =
apply the following
one-line patch to the VP-1041 attach.

This is against the repository at http://mercurial.intuxication.org/hg/s2-l=
iplianin.

Signed-off-by: Hans Werner <hwerner4@gmx.de>

diff -r 28324bc3d694 linux/drivers/media/dvb/mantis/mantis_dvb.c
--- a/linux/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/linux/drivers/media/dvb/mantis/mantis_dvb.c
@@ -239,7 +239,7 @@ int __devinit mantis_frontend_init(struc
                        vp1041_config.demod_address);

                        if (stb6100_attach(mantis->fe, &vp1041_stb6100_conf=
ig, &mantis->adapter)) {
-                               if (!lnbp21_attach(mantis->fe, &mantis->ada=
pter, 0, 0)) {
+                               if (!lnbp21_attach(mantis->fe, &mantis->ada=
pter, LNBP21_EN, 0)) {
                                        printk("%s: No LNBP21 found!\n", __=
FUNCTION__);
                                        mantis->fe =3D NULL;
                                }



Regards,
Hans

> =

> > > When it goes into sleep mode I see the following in dmesg:
> > > [  522.821625] _stb0899_read_reg: Reg=3D[0xf12a], data=3D58          =
     =

>  =

> >  =

> > >                                                                     =

> > > [  522.821632] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...      =

>  =

> >  =

> > >                                                                     =

> > > [  522.821634] stb0899_write_regs [0xf12a]: 58                        =

>  =

> >  =

> > >                                                                     =

> > > [  522.822681] stb0899_sleep: Going to Sleep .. (Really tired .. :-))
> > > =

> > > So the Twinhan 1041 is quite useless for me at the moment.
> > =

> > Try the following channels.conf for Astra at 19.2E:
> > =

> > TVEi;CANALSATELLITE:11567:vS0C56M2:S19.2E:22000:58:59:61:0:9022:1:1024:0
> >
> ZDF;ZDFvision:11953:hS0C34M2:S19.2E:27500:110:120=3Ddeu,121=3D2ch;125=3Dd=
eu:130:0:28006:1:1079:0
> > =

> > Then do the following (in this order): =

> > 0. point dish to 19.2E.
> > 1. tune to TVEi
> > szap-s2 -a 0 -r -p -V -c ~/channels.conf.astra1 "TVEi;CANALSATELLITE"
> > =

> > 2. hit ctrl-c, and wait 1 minute until the frontend sleeps (check dmesg)
> > =

> > 3. try to tune to ZDF. It FAILS (hangs).
> > szap-s2 -a 0 -r -p -V -c ~/channels.conf.astra1 "ZDF;ZDFvision"
> > =

> > 4. ctrl-c and then szap-s2 to TVEi. That WORKS.
> > =

> > 5. ctrl-c and then quickly (before sleep) szap-s2 to ZDF. Now it WORKS
> > too.
> > You can keep changing to other channels provided that it is not allowed
> to
> > get into a sleep.
> > =

> > Similar problems are seen using scan-s2 instead of szap-s2.
> =

> =

> For Hotbird try the following channels.conf.hotbird:
> =

> BBC World News:12596:vS0C34M2:S13.0E:27500:163:92:41:0:8204:318:9400:0
> Nile
> News:12539:hS0C34M2:S13.0E:27500:1185+1184:1187=3Dara:0:0:8983:318:9100:0
> Toscana Channel:11541:vS0C56M2:S13.0E:22000:521:522:0:0:3622:200:1800:0
> ZDF:11054:hS0C56M2:S13.0E:27500:570:571=3Ddeu:572:0:8011:318:12700:0
> =

> Then do the following (in this order):
> 0. point dish to 13.0E.
> 1. tune to Toscana Channel  (or BBC World News)
> szap-s2 -a 0 -r -p -V -c ~/channels.conf.hotbird "Toscana Channel"
> =

> 2. hit ctrl-c, and wait at least 1 minute until the frontend sleeps (check
> dmesg)
> =

> 3. try to tune to Nile News (or ZDF). It FAILS (hangs with -r -p or
> doesn't lock without those options).
> szap-s2 -a 0 -r -p -V -c ~/channels.conf.hotbird "Nile News"
> =

> 4. Do ctrl-c and then szap-s2 to Toscana Channel (or BBC World News). That
> WORKS.
> =

> 5. Do ctrl-c and then quickly (before sleep) szap-s2 to Nile News (or
> ZDF). Now it
> WORKS too!
> You can keep changing to other channels provided that it is not allowed to
> get into a sleep.
> =

> Or even simpler:
> just boot the computer (or sudo modprobe -r mantis && sudo modprobe
> mantis)
> and skip number 1 and number 2, i.e. do 0,3,4,5.
> =

> > Can someone reproduce this? (or fix the problem ;-) ).
> =

> Hans
-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
