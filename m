Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JeFzf-0005aH-Em
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 21:43:41 +0100
Received: by mu-out-0910.google.com with SMTP id w9so4719565mue.6
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 13:43:35 -0700 (PDT)
Message-ID: <854d46170803251343t5676ddebpa752941c20a0b9a2@mail.gmail.com>
Date: Tue, 25 Mar 2008 21:43:35 +0100
From: "Faruk A" <fa@elwak.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <854d46170803211001r7a11027cnbe8df40455cb6e9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <854d46170803181612wa79a469m9faf56b929577583@mail.gmail.com>
	<47E0B346.2090701@gmx.net>
	<854d46170803211001r7a11027cnbe8df40455cb6e9@mail.gmail.com>
Subject: Re: [linux-dvb] TT Connect S2-3650 CI unsupported device but
	partially working
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

On Fri, Mar 21, 2008 at 6:01 PM, Faruk A <fa@elwak.com> wrote:
>
> On Wed, Mar 19, 2008 at 7:31 AM, P. van Gaans <w3ird_n3rd@gmx.net> wrote:
>  >
>  > On 03/19/2008 12:12 AM, Faruk A wrote:
>  >  > TechnoTrend TT-connect S2-3650 CI
>  >  > Vendor ID: 0b48
>  >  > Product ID: 300a
>  >  > http://www.technotrend.de/2715/TT-connect__S2-3650_CI.html
>  >  >
>  >  > Hi
>  >  >
>  >  > This my first DVB card i bought it two weeks ago and it works great=
 in
>  >  > windows, I knew it was unsupported in Linux but it was cheap and pl=
us
>  >  > CI :) i couldn't resist.
>  >  >
>  >  > I saw Dominik Kuhlen's Pinnacle 452e and Andr=E9 Weidemann's TT-con=
nect
>  >  > S2-3600 patch and i thought why not try it and i did. All i did was
>  >  > change product id from 3007 to 300a, downloaded the the source,
>  >  > patched it and compiled.
>  >  >
>  >  > cd v4l
>  >  > insmod dvb-core.ko
>  >  > insmod dvb-pll.ko
>  >  > insmod stb6100.ko verbose=3D0
>  >  > insmod stb0899.ko verbose=3D0
>  >  > insmod lnbp22.ko
>  >  > insmod dvb-usb.ko
>  >  > insmod dvb-usb-pctv452e.ko
>  >  > .............................................
>  >  > dmesg
>  >  >
>  >  > dvb-usb: found a 'Technotrend TT connect S2-3600' in warm state.
>  >  > pctv452e_power_ctrl: 1
>  >  > dvb-usb: will pass the complete MPEG2 transport stream to the softw=
are demuxer.
>  >  > DVB: registering new adapter (Technotrend TT connect S2-3600)
>  >  > pctv452e_frontend_attach Enter
>  >  > stb0899_write_regs [0xf1b6]: 02
>  >  > stb0899_write_regs [0xf1c2]: 00
>  >  > stb0899_write_regs [0xf1c3]: 00
>  >  > stb0899_write_regs [0xf141]: 02
>  >  > _stb0899_read_reg: Reg=3D[0xf000], data=3D82
>  >  > stb0899_get_dev_id: ID reg=3D[0x82]
>  >  > stb0899_get_dev_id: Device ID=3D[8], Release=3D[2]
>  >  > _stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
>  >  > Offset=3D[0xf334], Data=3D[0x444d4431]
>  >  > _stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
>  >  > Offset=3D[0xf33c], Data=3D[0x00000001]
>  >  > stb0899_get_dev_id: Demodulator Core ID=3D[DMD1], Version=3D[1]
>  >  > _stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
>  >  > Offset=3D[0xfa2c], Data=3D[0x46454331]
>  >  > _stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
>  >  > Offset=3D[0xfa34], Data=3D[0x00000001]
>  >  > stb0899_get_dev_id: FEC Core ID=3D[FEC1], Version=3D[1]
>  >  > stb0899_attach: Attaching STB0899
>  >  > lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)
>  >  > lnbp22_set_voltage: 0x60)
>  >  > pctv452e_frontend_attach Leave Ok
>  >  > DVB: registering frontend 0 (STB0899 Multistandard)...
>  >  > pctv452e_tuner_attach Enter
>  >  > stb6100_attach: Attaching STB6100
>  >  > pctv452e_tuner_attach Leave
>  >  > input: IR-receiver inside an USB DVB receiver as
>  >  > /devices/pci0000:00/0000:00:1d.7/usb5/5-4/input/input8
>  >  > dvb-usb: schedule remote query interval to 500 msecs.
>  >  > pctv452e_power_ctrl: 0
>  >  > dvb-usb: Technotrend TT connect S2-3600 successfully initialized an=
d connected.
>  >  > usbcore: registered new interface driver pctv452e
>  >  > .................................................................
>  >  >
>  >  > ls /dev/dvb/adapter0/
>  >  > demux0  dvr0  frontend0  net0
>  >  > ...................................................................=
......
>  >  > I can scan the channels using patched scan program but vdr format
>  >  > output doesn't work, it just make
>  >  > empty channels.conf file. The zap format works :)
>  >  >
>  >  > I can lock to lnb1 (Thor 1W) lnb2 (Sirius 5E) lnb3 (Hotbird 13E) ln=
b4
>  >  > (Astra 19E) using the patched szap but when i wanna lock to channels
>  >  > on different satellite i have to always first lock on lnb1 (Thor).
>  >  > One more thing it doesn't lock with multiproto changeset 7208 and a=
bove.
>  >  >
>  >  > No CI support and remote control is like 80% percent working.
>  >  > ...................................................................=
..............................................................
>  >  > I have tried vdr with this card not good at all :( or maybe its just
>  >  > me. As i mentioned before the scan
>  >  > program doesn't produce the vdr format. I had to use vdr settings f=
rom
>  >  > this site http://www.linowsat.com.
>  >  >
>  >  > When i start vdr it doesn't lock to any channels or satellite just
>  >  > plain no signal, I have have to first szap -r  "any channels on lnb=
1"
>  >  > kill it and start vdr i can only get pictures from only 2 FTA chann=
els
>  >  > BBC World;Telenor:11325:hC78:S1.0W:24500:513:644=3Deng:577:0:1001:7=
0:25:0
>  >  > Gospel Channel Europe;Telenor:11325:hC78:S1.0W:24500:514:648=3Deng:=
0:0:129:70:25:0
>  >  > i can't switch to different satellite just plain no signal maybe wr=
ong
>  >  > diseqc settings?
>  >  >
>  >  > This is what i have in diseqc.conf
>  >  > # Input 1 - Thor - uncommited switch input 1
>  >  >
>  >  > S1W  11700 V  9750  t v W15 [E0 10 39 F0] W125 [E0 10 38 F0] W15 t
>  >  > S1W  99999 V 10600  t v W15 [E0 10 39 F0] W125 [E0 10 38 F0] W15 T
>  >  > S1W  11700 H  9750  t V W15 [E0 10 39 F0] W125 [E0 10 38 F0] W15 t
>  >  > S1W  99999 H 10600  t V W15 [E0 10 39 F0] W125 [E0 10 38 F0] W15 T
>  >  >
>  >  > # Input 2 - Sirius 5.0E - uncommited switch input 1
>  >  >
>  >  > S5E  11700 V  9750  t v W15 [E0 10 39 F0] W125 [E0 10 38 F4] W15 t
>  >  > S5E  99999 V 10600  t v W15 [E0 10 39 F0] W125 [E0 10 38 F4] W15 T
>  >  > S5E  11700 H  9750  t V W15 [E0 10 39 F0] W125 [E0 10 38 F4] W15 t
>  >  > S5E  99999 H 10600  t V W15 [E0 10 39 F0] W125 [E0 10 38 F4] W15 T
>  >  >
>  >  > # Input 3 - Hotbird - uncommited switch input 1
>  >  >
>  >  > S13E   11700 V  9750  t v W15 [E0 10 39 F0] W125 [E0 10 38 F8] W15 t
>  >  > S13E   99999 V 10600  t v W15 [E0 10 39 F0] W125 [E0 10 38 F8] W15 T
>  >  > S13E   11700 H  9750  t V W15 [E0 10 39 F0] W125 [E0 10 38 F8] W15 t
>  >  > S13E   99999 H 10600  t V W15 [E0 10 39 F0] W125 [E0 10 38 F8] W15 T
>  >  >
>  >  > # Input 4 Astra 1 19.2E - uncommited switch input 1
>  >  >
>  >  > S19.2E   11700 V  9750  t v W15 [E0 10 39 F0] W125 [E0 10 38 FC] W1=
5 t
>  >  > S19.2E   99999 V 10600  t v W15 [E0 10 39 F0] W125 [E0 10 38 FC] W1=
5 T
>  >  > S19.2E   11700 H  9750  t V W15 [E0 10 39 F0] W125 [E0 10 38 FC] W1=
5 t
>  >  > S19.2E   99999 H 10600  t V W15 [E0 10 39 F0] W125 [E0 10 38 FC] W1=
5 T
>  >  > ...................................................................=
..................................................
>  >  > In Windows with  Alt-DVB
>  >  >
>  >  > Type: Commited LNB: 1 Raw command: E0 10 38 F0
>  >  > Type: Commited LNB: 2 Raw command: E0 10 38 F4
>  >  > Type: Commited LNB: 3 Raw command: E0 10 38 F8
>  >  > Type: Commited LNB: 4 Raw command: E0 10 38 FC
>  >  > ...................................................................=
...................................................
>  >  >
>  >  >
>  >  > Anybody wanna works on this this? I'd be willing to help in any way=
 I can.
>  >  >
>  >  > Best regards,
>  >  > Faruk
>  >  >
>  >  >
>  >  > -------------------------------------------------------------------=
-----
>  >  >
>  >  > _______________________________________________
>  >  > linux-dvb mailing list
>  >  > linux-dvb@linuxtv.org
>  >  > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>  >
>  >  I don't know diseqc.conf (VDR-specific?) or VDR, but the comment says
>  >  "uncommited switch input 1" everywhere and I see two DiSEqC messages
>  >  (most likely one for an uncommitted switch, and the other to switch t=
he
>  >  committed switch behind that). You most likely have no uncommitted
>  >  switches, and if you did you wouldn't need any. You only have one sim=
ple
>  >  4/1 committed switch. Uncommitted only comes in when you need more th=
an
>  >  4 LNBs and means you will use DiSEqC 1.1. You don't use or need that,
>  >  you only need DiSeqC 1.0.
>  >
>
>
>  Hi!
>
>  I did some testings and here is what i found out.
>  I can watch channels using vdr from lnb1 (Thor 1W), lnb2 (Sirius 5E),
>  lnb3 (Hotbird 13E) and lnb4 (Astra 19E).
>  The catch is i can only watch one frequency. Every time i want to
>  change to channels on different freq i have to
>  close vdr and szap -r "channel on new freq"  when it locks i close it
>  and start vdr.
>
>  My kernel.log looks like this when am watching channel on vdr.
>
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_CARRIER |
>  FE_HAS_LOCK
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf58c], data=3D1a
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_VITERBI |
>  FE_HAS_SYNC
>  Mar 21 17:56:27 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D18
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_CARRIER |
>  FE_HAS_LOCK
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf58c], data=3D1a
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_VITERBI |
>  FE_HAS_SYNC
>  Mar 21 17:56:27 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D18
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_CARRIER |
>  FE_HAS_LOCK
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf58c], data=3D1a
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_VITERBI |
>  FE_HAS_SYNC
>  Mar 21 17:56:27 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D18
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_CARRIER |
>  FE_HAS_LOCK
>  Mar 21 17:56:27 archer _stb0899_read_reg: Reg=3D[0xf58c], data=3D1a
>  Mar 21 17:56:27 archer stb0899_read_status: --------> FE_HAS_VITERBI |
>  FE_HAS_SYNC
>  ........................................................................=
.........................................................
>  When i change to channels on different freq in vdr:
>
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  Mar 21 17:58:50 archer stb0899_read_status: Delivery system DVB-S/DSS
>  Mar 21 17:58:50 archer _stb0899_read_reg: Reg=3D[0xf50d], data=3D00
>  ........................................................................=
....................................
>
>  Best regards
>  Faruk
>

This is what happen when i load the drivers and start vdr without
first zapping with szap.

sample:
Mar 25 21:14:11 archer stb0899_read_status: Unsupported delivery system
Mar 25 21:14:11 archer stb0899_read_status: Unsupported delivery system
Mar 25 21:14:11 archer stb0899_read_status: Unsupported delivery system

full log @ http://pastebin.com/m3dd8b525

Best regards
Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
