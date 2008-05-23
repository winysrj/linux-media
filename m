Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1JzdEh-0000TH-R2
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 21:47:35 +0200
Date: Fri, 23 May 2008 21:46:58 +0200
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
In-Reply-To: <200805210148.10809.bumkunjo@gmx.de>
Message-ID: <20080523194658.40820@gmx.net>
MIME-Version: 1.0
References: <20080520214549.60B471CE808@ws1-6.us4.outblaze.com>
	<200805210148.10809.bumkunjo@gmx.de>
To: jochen s <bumkunjo@gmx.de>, stev391@email.com
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
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

Jochen,

you are indeed missing firmwares. The xc-test branch from Chris Pascoe uses=
 the special collection of firmwares xc3028-dvico-au-01.fw which only conta=
ins firmwares for 7MHz bandwidth (just try to tune a channel in the 7MHz ba=
nd to confirm this). To make the card work also for other bandwidths please=
 apply the following patch and put the standard firmware for xc3028 (xc3028=
-v27.fw) in the usual place (e.g. /lib/firmware).

This approach should also work for australia, because the standard firmware=
 also contains those firmwares in xc3028-dvico-au-01.fw.

Stephen, can you confirm this?

Cheers,
Hans-Frieder

--- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c        200=
8-04-26 23:40:52.000000000 +0200
+++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c  2008-05-19 23:=
15:08.000000000 +0200
@@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t
                                .callback  =3D cx23885_dvico_xc2028_callbac=
k,
                        };
                        static struct xc2028_ctrl ctl =3D {
-                               .fname       =3D "xc3028-dvico-au-01.fw",
+                               .fname       =3D "xc3028-v27.fw",
                                .max_len     =3D 64,
-                               .scode_table =3D ZARLINK456,
+                               .demod       =3D XC3028_FE_ZARLINK456,
                        };

                        fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,


-------- Original-Nachricht --------
> Datum: Wed, 21 May 2008 01:48:10 +0200
> Von: jochen s <bumkunjo@gmx.de>
> An: stev391@email.com
> CC: linux-dvb@linuxtv.org
> Betreff: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]

> =

> ok - now I'm using (again) the xc-test branch with options card=3D5 and
> xc_2028 =

> debug enabled.
> the output posted before (see: autodetecting card=3D10) was your patch - =
I =

> deleted all modules and started new.
> =

> [   50.371020] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low)
> -> =

> IRQ 16
> [   50.371035] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO
> FusionHDTV =

> DVB-T Dual Express [card=3D5,insmod option]
> [   50.470993] cx23885[0]: i2c bus 0 registered
> [   50.471008] cx23885[0]: i2c bus 1 registered
> [   50.471027] cx23885[0]: i2c bus 2 registered
> ...
> =

> [   50.538957] input: i2c IR (FusionHDTV) as /class/input/input3
> [   50.538976] ir-kbd-i2c: i2c IR (FusionHDTV) detected at
> i2c-3/3-006b/ir0 =

> [cx23885[0]]
> [   50.540006] cx23885[0]: cx23885 based dvb card
> [   50.596214] xc2028: Xcv2028/3028 init called!
> [   50.596219] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
> [   50.596222] xc2028 3-0061: xc2028_set_config called
> [   50.596228] DVB: registering new adapter (cx23885[0])
> [   50.596232] DVB: registering frontend 2 (Zarlink ZL10353 DVB-T)...
> [   50.596472] cx23885[0]: cx23885 based dvb card
> [   50.601980] xc2028: Xcv2028/3028 init called!
> [   50.601983] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
> [   50.601985] xc2028 4-0061: xc2028_set_config called
> [   50.601988] DVB: registering new adapter (cx23885[0])
> [   50.601990] DVB: registering frontend 3 (Zarlink ZL10353 DVB-T)...
> [   50.602198] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16,
> latency: =

> 0, mmio: 0xfd600000
> [   50.602206] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [   50.601721] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low)
> -> =

> IRQ 16
> ...
> now VDR starts and then...
> ...
> [   95.874136] xc2028 3-0061: xc2028_set_params called
> [   95.874141] xc2028 3-0061: generic_set_freq called
> [   95.874144] xc2028 3-0061: should set frequency 514000 kHz
> [   95.874146] xc2028 3-0061: check_firmware called
> [   95.874148] xc2028 3-0061: load_all_firmwares called
> [   95.874150] xc2028 3-0061: Reading firmware xc3028-dvico-au-01.fw
> [   95.875949] xc2028 4-0061: xc2028_set_params called
> [   95.875957] xc2028 4-0061: generic_set_freq called
> [   95.875960] xc2028 4-0061: should set frequency 538000 kHz
> [   95.875979] xc2028 4-0061: check_firmware called
> [   95.875990] xc2028 4-0061: load_all_firmwares called
> [   95.876006] xc2028 4-0061: Reading firmware xc3028-dvico-au-01.fw
> [   95.885803] xc2028 3-0061: Loading 3 firmware images from =

> xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
> [   95.885810] xc2028 3-0061: Reading firmware type DTV7 ZARLINK456 SCODE =

> (22000080), id 0, size=3D224.
> [   95.885819] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id 0, =

> size=3D8718.
> [   95.885826] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id 0,
> size=3D149.
> [   95.885835] xc2028 3-0061: Firmware files loaded.
> [   95.885837] xc2028 3-0061: checking firmware, user requested type=3DF8=
MHZ
> D2620 DTV8 (20a), id 0000000000000000, scode_tbl ZARLINK456 (2000000), =

> scode_nr 0
> [   95.888064] xc2028 4-0061: Loading 3 firmware images from =

> xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
> [   95.888069] xc2028 4-0061: Reading firmware type DTV7 ZARLINK456 SCODE =

> (22000080), id 0, size=3D224.
> [   95.888080] xc2028 4-0061: Reading firmware type BASE F8MHZ (3), id 0, =

> size=3D8718.
> [   95.888088] xc2028 4-0061: Reading firmware type D2620 DTV7 (88), id 0,
> size=3D149.
> [   95.888101] xc2028 4-0061: Firmware files loaded.
> [   95.888103] xc2028 4-0061: checking firmware, user requested type=3DF8=
MHZ
> D2620 DTV8 (20a), id 0000000000000000, scode_tbl ZARLINK456 (2000000), =

> scode_nr 0
> [   95.888226] xc2028 3-0061: load_firmware called
> [   95.888229] xc2028 3-0061: seek_firmware called, want type=3DBASE F8MHZ
> D2620 =

> DTV8 (20b), id 0000000000000000.
> [   95.888233] xc2028 3-0061: Found firmware for type=3DBASE F8MHZ (3), i=
d =

> 0000000000000000.
> [   95.888236] xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3),=
 id
> 0000000000000000.
> [   95.890514] xc2028 4-0061: load_firmware called
> [   95.890517] xc2028 4-0061: seek_firmware called, want type=3DBASE F8MHZ
> D2620 =

> DTV8 (20b), id 0000000000000000.
> [   95.890524] xc2028 4-0061: Found firmware for type=3DBASE F8MHZ (3), i=
d =

> 0000000000000000.
> [   95.890561] xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3),=
 id
> 0000000000000000.
> [   96.343671] xc2028 3-0061: Load init1 firmware, if exists
> [   96.343676] xc2028 3-0061: load_firmware called
> [   96.343678] xc2028 3-0061: seek_firmware called, want type=3DBASE INIT1
> F8MHZ =

> D2620 DTV8 (420b), id 0000000000000000.
> [   96.343684] xc2028 3-0061: Can't find firmware for type=3DBASE INIT1
> F8MHZ =

> (4003), id 0000000000000000.
> [   96.343688] xc2028 3-0061: load_firmware called
> [   96.343690] xc2028 3-0061: seek_firmware called, want type=3DBASE INIT1
> D2620 =

> DTV8 (4209), id 0000000000000000.
> [   96.343693] xc2028 3-0061: Can't find firmware for type=3DBASE INIT1
> (4001), =

> id 0000000000000000.
> [   96.343697] xc2028 3-0061: load_firmware called
> [   96.343699] xc2028 3-0061: seek_firmware called, want type=3DF8MHZ D26=
20
> DTV8 =

> (20a), id 0000000000000000.
> [   96.343702] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [   96.343706] xc2028 3-0061: load_firmware called
> [   96.343708] xc2028 3-0061: seek_firmware called, want type=3DD2620 DTV=
8 =

> (208), id 0000000000000000.
> [   96.343711] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [   96.367858] xc2028 3-0061: Retrying firmware load
> [   96.367862] xc2028 3-0061: checking firmware, user requested type=3DF8=
MHZ
> D2620 DTV8 (20a), id 0000000000000000, scode_tbl ZARLINK456 (2000000), =

> scode_nr 0
> [   96.370251] xc2028 3-0061: load_firmware called
> [   96.370253] xc2028 3-0061: seek_firmware called, want type=3DBASE F8MHZ
> D2620 =

> DTV8 (20b), id 0000000000000000.
> [   96.370258] xc2028 3-0061: Found firmware for type=3DBASE F8MHZ (3), i=
d =

> 0000000000000000.
> [   96.370261] xc2028 3-0061: Loading firmware for type=3DBASE F8MHZ (3),=
 id
> 0000000000000000.
> [   96.384954] xc2028 4-0061: Load init1 firmware, if exists
> [   96.384959] xc2028 4-0061: load_firmware called
> [   96.384961] xc2028 4-0061: seek_firmware called, want type=3DBASE INIT1
> F8MHZ =

> D2620 DTV8 (420b), id 0000000000000000.
> [   96.384967] xc2028 4-0061: Can't find firmware for type=3DBASE INIT1
> F8MHZ =

> (4003), id 0000000000000000.
> [   96.384970] xc2028 4-0061: load_firmware called
> [   96.384972] xc2028 4-0061: seek_firmware called, want type=3DBASE INIT1
> D2620 =

> DTV8 (4209), id 0000000000000000.
> [   96.384976] xc2028 4-0061: Can't find firmware for type=3DBASE INIT1
> (4001), =

> id 0000000000000000.
> [   96.385014] xc2028 4-0061: load_firmware called
> [   96.385016] xc2028 4-0061: seek_firmware called, want type=3DF8MHZ D26=
20
> DTV8 =

> (20a), id 0000000000000000.
> [   96.385019] xc2028 4-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [   96.385023] xc2028 4-0061: load_firmware called
> [   96.385025] xc2028 4-0061: seek_firmware called, want type=3DD2620 DTV=
8 =

> (208), id 0000000000000000.
> [   96.385028] xc2028 4-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [   96.409295] xc2028 4-0061: Retrying firmware load
> [   96.409299] xc2028 4-0061: checking firmware, user requested type=3DF8=
MHZ
> D2620 DTV8 (20a), id 0000000000000000, scode_tbl ZARLINK456 (2000000), =

> scode_nr 0
> [   96.411713] xc2028 4-0061: load_firmware called
> [   96.411715] xc2028 4-0061: seek_firmware called, want type=3DBASE F8MHZ
> D2620 =

> DTV8 (20b), id 0000000000000000.
> [   96.411719] xc2028 4-0061: Found firmware for type=3DBASE F8MHZ (3), i=
d =

> 0000000000000000.
> [   96.411723] xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3),=
 id
> 0000000000000000.
> ...
> [  372.810622] xc2028 4-0061: should set frequency 698000 kHz
> [  372.810624] xc2028 4-0061: check_firmware called
> [  372.810626] xc2028 4-0061: checking firmware, user requested type=3DF8=
MHZ
> D2620 DTV8 (20a), id 0000000000000000, scode_tbl ZARLINK456 (2000000), =

> scode_nr 0
> [  372.815396] xc2028 4-0061: load_firmware called
> [  372.815399] xc2028 4-0061: seek_firmware called, want type=3DBASE F8MHZ
> D2620 =

> DTV8 (20b), id 0000000000000000.
> [  372.815403] xc2028 4-0061: Found firmware for type=3DBASE F8MHZ (3), i=
d =

> 0000000000000000.
> [  372.815406] xc2028 4-0061: Loading firmware for type=3DBASE F8MHZ (3),=
 id
> 0000000000000000.
> [  373.715341] xc2028 3-0061: Load init1 firmware, if exists
> [  373.715355] xc2028 3-0061: load_firmware called
> [  373.715358] xc2028 3-0061: seek_firmware called, want type=3DBASE INIT1
> F8MHZ =

> D2620 DTV8 (420b), id 0000000000000000.
> [  373.715364] xc2028 3-0061: Can't find firmware for type=3DBASE INIT1
> F8MHZ =

> (4003), id 0000000000000000.
> [  373.715368] xc2028 3-0061: load_firmware called
> [  373.715370] xc2028 3-0061: seek_firmware called, want type=3DBASE INIT1
> D2620 =

> DTV8 (4209), id 0000000000000000.
> [  373.715374] xc2028 3-0061: Can't find firmware for type=3DBASE INIT1
> (4001), =

> id 0000000000000000.
> [  373.715378] xc2028 3-0061: load_firmware called
> [  373.715380] xc2028 3-0061: seek_firmware called, want type=3DF8MHZ D26=
20
> DTV8 =

> (20a), id 0000000000000000.
> [  373.715383] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [  373.715387] xc2028 3-0061: load_firmware called
> [  373.715389] xc2028 3-0061: seek_firmware called, want type=3DD2620 DTV=
8 =

> (208), id 0000000000000000.
> [  373.715392] xc2028 3-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [  373.732296] xc2028 4-0061: Load init1 firmware, if exists
> [  373.732301] xc2028 4-0061: load_firmware called
> [  373.732303] xc2028 4-0061: seek_firmware called, want type=3DBASE INIT1
> F8MHZ =

> D2620 DTV8 (420b), id 0000000000000000.
> [  373.732309] xc2028 4-0061: Can't find firmware for type=3DBASE INIT1
> F8MHZ =

> (4003), id 0000000000000000.
> [  373.732313] xc2028 4-0061: load_firmware called
> [  373.732315] xc2028 4-0061: seek_firmware called, want type=3DBASE INIT1
> D2620 =

> DTV8 (4209), id 0000000000000000.
> [  373.732319] xc2028 4-0061: Can't find firmware for type=3DBASE INIT1
> (4001), =

> id 0000000000000000.
> [  373.732323] xc2028 4-0061: load_firmware called
> [  373.732325] xc2028 4-0061: seek_firmware called, want type=3DF8MHZ D26=
20
> DTV8 =

> (20a), id 0000000000000000.
> [  373.732328] xc2028 4-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [  373.732332] xc2028 4-0061: load_firmware called
> [  373.732334] xc2028 4-0061: seek_firmware called, want type=3DD2620 DTV=
8 =

> (208), id 0000000000000000.
> [  373.732337] xc2028 4-0061: Can't find firmware for type=3DD2620 DTV8
> (208), =

> id 0000000000000000.
> [  373.735760] xc2028 3-0061: xc2028_set_params called
> [  373.735765] xc2028 3-0061: generic_set_freq called
> ...
> =

> and so on. several firmware (partial) can not be found?
> =

> and does "Loading 3 firmware images from xc3028-dvico-au-01.fw, type:
> DViCO =

> DualDig4/Nano2 (Australia), ver 2.7" mean wrong card detected?
> =

> jochen
> =

> =

> Am Dienstag 20 Mai 2008 23:45:48 schrieb stev391@email.com:
> >  Jochen,
> >
> > Which sources is this dmesg output from (my patch or Chris Pascoe's
> > xc-test branch)?  Mine are definately dead in the water at the moment as
> > the existing code relies on the moons alligning to work.  I'm still
> > working on this...
> >
> > If it is from Chris Pascoe's branch it should work, if not for the
> module
> > "tuner_xc2028" when loading pass the option debug=3D1 (This will genera=
te
> > alot more lines in dmesg) and repeat whatever you did to break it.  Send
> > this on and I will attempt to work out where it is going wrong.
> >
> > Regards,
> > Stephen
> >
> >   ----- Original Message -----
> >   From: "jochen s"
> >   To: linux-dvb@linuxtv.org
> >   Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
> >   Date: Tue, 20 May 2008 18:10:26 +0200
> >
> >
> >
> >   May 20 17:48:11 kernel: [ 48.744161] ACPI: PCI Interrupt 0000:02:00.0
> >   [A] -> GSI 16 (level, low) -> IRQ 16
> >   May 20 17:48:11 kernel: [ 48.744179] CORE cx23885[0]: subsystem:
> >   18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express
> >   [card=3D10,autodetected]
> >   May 20 17:48:11 kernel: [ 48.844132] cx23885[0]: i2c bus 0 registered
> >   May 20 17:48:11 kernel: [ 48.844154] cx23885[0]: i2c bus 1 registered
> >   May 20 17:48:11 kernel: [ 48.844168] cx23885[0]: i2c bus 2 registered
> >   May 20 17:48:11 kernel: [ 48.908665] input: i2c IR (FusionHDTV)
> >   as /class/input/input3
> >   May 20 17:48:11 kernel: [ 48.908687] ir-kbd-i2c: i2c IR (FusionHDTV)
> >   detected at i2c-2/2-006b/ir0 [cx23885[0]]
> >   May 20 17:48:11 kernel: [ 48.909711] cx23885[0]: cx23885 based dvb
> >   card
> >   May 20 17:48:11 kernel: [ 48.970326] xc2028 2-0061: type set to
> >   XCeive
> >   xc2028/xc3028 tuner
> >   May 20 17:48:11 kernel: [ 48.970336] DVB: registering new adapter
> >   (cx23885
> >   [0])
> >   May 20 17:48:11 kernel: [ 48.970340] DVB: registering frontend 1
> >   (Zarlink
> >   ZL10353 DVB-T)...
> >   May 20 17:48:11 kernel: [ 48.970625] cx23885[0]: cx23885 based dvb
> >   card
> >   May 20 17:48:11 kernel: [ 48.976144] xc2028 3-0061: type set to
> >   XCeive
> >   xc2028/xc3028 tuner
> >   May 20 17:48:11 kernel: [ 48.976147] DVB: registering new adapter
> >   (cx23885
> >   [0])
> >   May 20 17:48:11 kernel: [ 48.976151] DVB: registering frontend 2
> >   (Zarlink
> >   ZL10353 DVB-T)...
> >   May 20 17:48:11 kernel: [ 48.976368] cx23885_dev_checkrevision()
> >   Hardware
> >   revision =3D 0xb0
> >   May 20 17:48:11 kernel: [ 48.976376] cx23885[0]/0: found at
> >   0000:02:00.0,
> >   rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
> >   May 20 17:48:11 kernel: [ 48.976383] PCI: Setting latency timer of
> >   device
> >   0000:02:00.0 to 64
> >
> >   ok - so far...
> >
> >   but then:
> >
> >   May 20 17:48:50 vdr: [7428] frontend 1 timed out while tuning to
> >   channel 2,
> >   tp 514
> >   May 20 17:48:50 kernel: [ 80.313642] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:48:51 kernel: [ 81.247786] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:48:53 kernel: [ 83.150433] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:48:53 kernel: [ 83.720342] eth0: no IPv6 routers present
> >   May 20 17:48:54 kernel: [ 84.117987] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:48:56 kernel: [ 86.047256] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:48:57 kernel: [ 86.979688] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   ...
> >   May 20 17:48:59 kernel: [ 88.486428] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:00 kernel: [ 89.498026] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:02 kernel: [ 91.416250] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:03 kernel: [ 92.346871] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   ...
> >   May 20 17:49:23 kernel: [ 109.368185] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:24 kernel: [ 109.934506] xc2028 3-0061: Loading 3
> >   firmware
> >   images from xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2
> >   (Australia),
> >   ver 2.7
> >   May 20 17:49:24 kernel: [ 109.938812] xc2028 3-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:24 kernel: [ 110.034395] xc2028 2-0061: i2c output
> >   error: rc
> >   =3D -5 (should be 4)
> >   May 20 17:49:24 kernel: [ 110.034399] xc2028 2-0061: -5 returned from
> >   send
> >   May 20 17:49:24 kernel: [ 110.034434] xc2028 2-0061: Error -22 while
> >   loading base firmware
> >   May 20 17:49:24 kernel: [ 110.081951] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 17:49:24 kernel: [ 110.088001] xc2028 2-0061: i2c output
> >   error: rc
> >   =3D -5 (should be 64)
> >   May 20 17:49:24 kernel: [ 110.088003] xc2028 2-0061: -5 returned from
> >   send
> >   May 20 17:49:24 kernel: [ 110.088050] xc2028 2-0061: Error -22 while
> >   loading base firmware
> >   May 20 17:49:24 kernel: [ 110.089843] zl10353: write to reg 62 failed
> >   (err
> >   =3D -5)!
> >   May 20 17:49:24 kernel: [ 110.091667] zl10353: write to reg 5f failed
> >   (err
> >   =3D -5)!
> >   May 20 17:49:24 kernel: [ 110.093428] zl10353: write to reg 71 failed
> >   (err
> >   =3D -5)!
> >   May 20 17:49:24 kernel: [ 110.095201] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 17:49:24 kernel: [ 110.105956] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 17:49:24 kernel: [ 110.116251] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   ...
> >
> >   May 20 18:01:00 kernel: [ 791.122235] xc2028 3-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 18:01:01 kernel: [ 791.998348] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 18:01:02 kernel: [ 793.049839] xc2028 2-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 18:01:02 kernel: [ 793.144856] xc2028 3-0061: Loading firmware
> >   for
> >   type=3DBASE F8MHZ (3), id 0000000000000000.
> >   May 20 18:01:03 kernel: [ 794.054455] xc2028 2-0061: i2c output
> >   error: rc
> >   =3D -5 (should be 4)
> >   May 20 18:01:03 kernel: [ 794.054460] xc2028 2-0061: -5 returned from
> >   send
> >   May 20 18:01:03 kernel: [ 794.054528] xc2028 2-0061: Error -22 while
> >   loading base firmware
> >   May 20 18:01:03 kernel: [ 794.056622] zl10353: write to reg 62 failed
> >   (err
> >   =3D -5)!
> >   May 20 18:01:03 kernel: [ 794.058744] zl10353: write to reg 5f failed
> >   (err
> >   =3D -5)!
> >   May 20 18:01:03 kernel: [ 794.060858] zl10353: write to reg 71 failed
> >   (err
> >   =3D -5)!
> >   May 20 18:01:03 kernel: [ 794.063013] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.075006] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.087060] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.098969] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.111100] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.122939] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.135009] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >   May 20 18:01:03 kernel: [ 794.148908] zl10353_read_register: readreg
> >   error
> >   (reg=3D6, ret=3D=3D-5)
> >
> >   any idea to help me?
> >
> >   thanks in advance, jochen
> >
> >   Am Donnerstag 15 Mai 2008 00:12:52 schrieb stev391@email.com:
> >   > Thom,
> >   >
> >   > Disclaimer: This not guranteed to work and will break any webcams
> >
> >   you
> >
> >   > have running on ubuntu, this is reversable by reinstalling the
> >
> >   "linux-*"
> >
> >   > packages that you have already installed.
> >   >
> >   > I can't seem to find any information about that version of
> >
> >   Mythbuntu, is
> >
> >   > it supposed to be version 8.04? Anyway the following will work for
> >   > previous versions as well.
> >   > All commands to be run in a terminal.
> >   >
> >   > Step 1, Install the required packages to retrieve and compile the
> >
> >   source
> >
> >   > (you also need to install the linux-headers that match your kernel,
> >
> >   which
> >
> >   > is done by the following command as well)
> >   > sudo apt-get install mercurial build-essential patch
> >
> >   linux-headers-`uname
> >
> >   > -r`
> >   >
> >   > Step 2, Retrieve the v4l-dvb sources
> >   > hg clone http://linuxtv.org/hg/v4l-dvb
> >   >
> >   > Step 3, Apply patch (which was an attachment on the previous email)
> >   > cd v4l-dvb
> >   > patch -p1 < ../DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch
> >   >
> >   > Step 4, Compile which will take awhile... (maybe time to make a cup
> >
> >   of
> >
> >   > coffee)
> >   > make all
> >   >
> >   > Step 5 Remove the old modules as this causes issues when loading
> >
> >   the
> >
> >   > modules later(this depends on version of ubuntu)
> >   > 8.04: cd /lib/modules/`uname -r`/ubuntu/media
> >   > cd /lib/modules/`uname -r`/kernel/drivers/media
> >   > sudo rm -r common
> >   > sudo rm -r dvb
> >   > sudo rm -r radio
> >   > sudo rm -r video
> >   >
> >   > Step 6: return to v4l-dvb directory and run:
> >   > sudo make install
> >   >
> >   > Step 7: Update the initramfs:
> >   > sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r`
> >   >
> >   > Step 8: Reboot and see if it worked
> >   > sudo shutdown -r now
> >   >
> >   > If this didn't work with my patch please send me the output of
> >
> >   dmesg and
> >
> >   > any relevant logs of the application that you used to identify the
> >   > problem with (eg mythbackend log). Then try replacing step 2 & 3
> >
> >   with
> >
> >   > (This uses the older branch by Chris Pascoe, whose code I'm trying
> >
> >   to
> >
> >   > update to bring into the main v4l-dvb):
> >   > hg clone http://linuxtv.org/hg/~pascoe/xc-test/
> >   > cd xc-test
> >   >
> >   > If this still doesn't work and your dvb system is broken just
> >
> >   reinstall
> >
> >   > your linux-* packages.
> >   >
> >   > Regards,
> >   > Stephen
> =

> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- =

Super-Acktion nur in der GMX Spieleflat: 10 Tage f=FCr 1 Euro.
=DCber 180 Spiele downloaden und spiele: http://flat.games.gmx.de

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
