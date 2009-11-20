Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAKEC6pP027821
	for <video4linux-list@redhat.com>; Fri, 20 Nov 2009 09:12:06 -0500
Received: from web28406.mail.ukl.yahoo.com (web28406.mail.ukl.yahoo.com
	[87.248.110.155])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nAKEBqPo028144
	for <video4linux-list@redhat.com>; Fri, 20 Nov 2009 09:11:53 -0500
Message-ID: <340342.18338.qm@web28406.mail.ukl.yahoo.com>
References: <163605.48700.qm@web28403.mail.ukl.yahoo.com>
	<1257719708.3249.27.camel@pc07.localdom.local>
Date: Fri, 20 Nov 2009 14:11:51 +0000 (GMT)
From: Pavle Predic <pavle.predic@yahoo.co.uk>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1257719708.3249.27.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re: Leadtek Winfast TV2100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hermann,=0A=0AThank you so much for your help. I didn't really get most =
of what you said (way to technical for me), but at least I know now which t=
uner I should use, so I'll keep testing with tuner 69 and see if I get resu=
lts.=0ABTW, I'm not from UK - I'm from Serbia and I'm trying to make the ca=
rd work for my cable tv which uses PAL BG (at least so they say).=0A=0AI'll=
 report back after testing on tuner 69 (I'll simply try all card ids with t=
his tuner id). In the meantime here's some more info:=0A=0Admesg:=0A=0A[   =
 9.829338] saa7130/34: v4l2 driver version 0.2.15 loaded=0A[    9.829408] s=
aa7134 0000:00:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17=0A[    9.82=
9419] saa7130[0]: found at 0000:00:08.0, rev: 1, irq: 17, latency: 64, mmio=
: 0xfdffe000=0A[    9.829428] saa7130[0]: subsystem: 107d:6f3a, board: UNKN=
OWN/GENERIC [card=3D0,autodetected]=0A[    9.829458] saa7130[0]: board init=
: gpio is 6200c=0A[    9.829465] IRQ 17/saa7130[0]: IRQF_DISABLED is not gu=
aranteed on shared IRQs=0A[    9.980513] saa7130[0]: i2c eeprom 00: 7d 10 3=
a 6f 54 20 1c 00 43 43 a9 1c 55 d2 b2 92=0A[    9.980532] saa7130[0]: i2c e=
eprom 10: 0c ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff=0A[    9.980547] =
saa7130[0]: i2c eeprom 20: 01 40 02 03 03 02 01 03 08 ff 00 8c ff ff ff ff=
=0A[    9.980562] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff ff=0A[    9.980578] saa7130[0]: i2c eeprom 40: 50 89 00 c2 0=
0 00 02 30 02 ff ff ff ff ff ff ff=0A[    9.980593] saa7130[0]: i2c eeprom =
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[    9.980608] saa713=
0[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[   =
 9.980623] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff=0A[    9.980639] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff=
 ff ff ff ff ff ff ff ff ff=0A[    9.980654] saa7130[0]: i2c eeprom 90: ff =
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[    9.980670] saa7130[0]: i=
2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[    9.9806=
85] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=
 ff=0A[    9.980701] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff ff ff=0A[    9.980716] saa7130[0]: i2c eeprom d0: ff ff ff f=
f ff ff ff ff ff ff ff ff ff ff ff ff=0A[    9.980731] saa7130[0]: i2c eepr=
om e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[    9.980747] saa=
7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff=0A[=
    9.980876] saa7130[0]: registered device video0 [v4l2]=0A[    9.980908] =
saa7130[0]: registered device vbi0=0A=0A=0Alsmod:=0A=0Asaa7134             =
  135552  0 =0Air_common              47172  1 saa7134=0Av4l2_common       =
     14308  1 saa7134=0Avideodev               31040  2 saa7134,v4l2_common=
=0Avideobuf_dma_sg        11340  1 saa7134=0Avideobuf_core          16164  =
2 saa7134,videobuf_dma_sg=0Atveeprom               10720  1 saa7134=0Ai2c_c=
ore               20844  4 i2c_viapro,saa7134,v4l2_common,tveeprom=0A=0Alsp=
ci:=0A=0A00:08.0 Multimedia controller [0480]: Philips Semiconductors SAA71=
30 Video Broadcast Decoder [1131:7130] (rev 01)=0A    Subsystem: LeadTek Re=
search Inc. Device [107d:6f3a]=0A    Flags: bus master, medium devsel, late=
ncy 64, IRQ 17=0A    Memory at fdffe000 (32-bit, non-prefetchable) [size=3D=
1K]=0A    Capabilities: [40] Power Management version 1=0A    Kernel driver=
 in use: saa7134=0A    Kernel modules: saa7134=0A=0AThanks again,=0A=0APavl=
e.=0A=0A=0A=0A=0A=0A=0A________________________________=0AFrom: hermann pit=
ton <hermann-pitton@arcor.de>=0ATo: Pavle Predic <pavle.predic@yahoo.co.uk>=
=0ACc: video4linux-list@redhat.com=0ASent: Sun, 8 November, 2009 23:35:08=
=0ASubject: Re: Leadtek Winfast TV2100=0A=0AHi Pavle,=0A=0AAm Sonntag, den =
08.11.2009, 17:11 +0000 schrieb Pavle Predic:=0A> Did anyone manage to get =
this card working on Linux? I got the picture out of the box, but it's impo=
ssible to get any sound from the damned thing. The card is not on CARDLIST.=
saa7134, but I assume a similar card/tuner combination can be used. But whi=
ch? By the way, I got the speakers connected directly to card output, I'm n=
ot even trying to get it working with my sound card. I can hear clicks when=
 loading/unloading modules, so it's alive but not set up properly.=0A> =0A>=
 Any info would be greatly appreciated. Perhaps someone knows of another ca=
rd that is similar to this one?=0A> =0A> Card info:=0A> Chipset: saa7134=0A=
> Tuner: Tvision TVF88T5-B/DFF=0A> Card numbers that produce picture (modpr=
obe saa7134 card=3D$n): 3, 7, 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 6=
8=0A=0Athat is not enough information yet.=0A=0AThe correct tuner for this =
one is tuner=3D69.=0A=0AOnly with this one you will have also radio support=
.=0A=0ASince you mail from an UK mail provider, this tuner is not expected =
to=0Awork with PAL-I TV stereo sound there, but radio would work.=0A=0AElse=
, if neither amux =3D TV nor amux =3D LINE1 or LINE2 (LINE inputs for TV=0A=
sound are only found on saa7130 chips, except there is also an extra TV=0Am=
ono section directly from the tuner)  work for TV sound, most often an=0Aex=
ternal audio mux is in the way and needs to be configured correctly=0Awith =
saa7134 gpio pins. Looking also at the minor chips on the card with=0Amore =
than 3 pins can reveal such a mux.=0A=0AThere is also a software test on su=
ch hardware, succeeding in most=0Acases.=0A=0ABy default, external analog a=
udio input is looped through to analog=0Aaudio out, on which you are listen=
ing, if the driver is unloaded.=0A=0AOn a saa7134 chip, on saa7130 are some=
 known specials, you should hear=0Athe incoming sound directly on your head=
phones or what else you might be=0Ausing directly connected to your card, t=
rying on LINE1 and LINE2 for=0Athat.=0A=0AIf not, you can expect that such =
a mux chip needs to be treated=0Acorrectly.=0A=0AThe DScaler (deinterlace.s=
f.net) regspy.exe often can help to identify=0Asuch gpios in use, else you =
must trace lines and resistors on it.=0A=0AIn general, an absolute minimum =
is to provide related "dmesg" after=0Aloading the driver _without_ having t=
ried on other cards previously.=0A=0APlease read more on the linuxtv.org wi=
ki about adding support for a new=0Acard.=0A=0ACheers,=0AHermann=0A=0A=0A  =
    
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
