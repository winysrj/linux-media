Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nALJrGrR007776
	for <video4linux-list@redhat.com>; Sat, 21 Nov 2009 14:53:16 -0500
Received: from web28413.mail.ukl.yahoo.com (web28413.mail.ukl.yahoo.com
	[87.248.110.162])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nALJr2Ue016879
	for <video4linux-list@redhat.com>; Sat, 21 Nov 2009 14:53:02 -0500
Message-ID: <605670.16248.qm@web28413.mail.ukl.yahoo.com>
References: <163605.48700.qm@web28403.mail.ukl.yahoo.com>
	<1257719708.3249.27.camel@pc07.localdom.local>
	<340342.18338.qm@web28406.mail.ukl.yahoo.com>
	<1258762873.3261.9.camel@pc07.localdom.local>
	<6ab2c27e0911210107u14768841h1f084ee4215bab33@mail.gmail.com>
Date: Sat, 21 Nov 2009 19:53:01 +0000 (GMT)
From: Pavle Predic <pavle.predic@yahoo.co.uk>
To: Terry Wu <terrywu2009@gmail.com>, hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <6ab2c27e0911210107u14768841h1f084ee4215bab33@mail.gmail.com>
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

Hey Terry,=0A=0AThanks for your input. Yes it would seem that my tuner is n=
ot supported (it's a YMEC Tvision TVF88T5-B/DFF), and neither is my board. =
But I was hoping that an existing board/tuner combination might do the job.=
=0A=0A@Hermann - I tried card IDs 1-150 with tuner=3D69 and - alas - didn't=
 get sound. Interestingly enough, almost all card ids produce a picture wit=
h this tuner. Also, I noticed that with some board IDs I'm getting clicks w=
hen muting/unmuting or switching channels, but no broadcast sound whatsoeve=
r...:(=0A=0AI also tried running regspy.exe (after booting to Windows) and =
performed the test as described on dscaler site. But the results are way to=
 cryptic for me...I have no clue how to use this. So I'll paste it here, an=
d maybe someone will be able to draw a conclusion:=0A=0ASAA7130 Card [0]: =
=0A =0AVendor ID:           0x1131 =0ADevice ID:           0x7130 =0ASubsys=
tem ID:        0x6f3a107d =0A =0A =0A7 states dumped =0A =0A---------------=
------------------------------------------------------------------- =0A =0A=
SAA7130 Card - State 0: =0ASAA7134_GPIO_GPMODE:             80000009 * (100=
00000 00000000 00000000 00001001)                  =0ASAA7134_GPIO_GPSTATUS=
:           0606200c * (00000110 00000110 00100000 00001100)               =
   =0ASAA7134_ANALOG_IN_CTRL1:         c1         (11000001)               =
                              =0ASAA7134_ANALOG_IO_SELECT:        3b *     =
  (00111011)                                             =0ASAA7134_VIDEO_P=
ORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)         =
         =0ASAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 =
00000000 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL8:        00 =
        (00000000)                                             =0ASAA7134_I=
2S_OUTPUT_SELECT:       00         (00000000)                              =
               =0ASAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)   =
                                          =0ASAA7134_I2S_OUTPUT_LEVEL:     =
   00         (00000000)                                             =0ASAA=
7134_I2S_AUDIO_OUTPUT:        01         (00000001)                        =
                     =0ASAA7134_TS_PARALLEL:             04         (000001=
00)                                             =0ASAA7134_TS_PARALLEL_SERI=
AL:      00         (00000000)                                             =
=0ASAA7134_TS_SERIAL0:              00         (00000000)                  =
                           =0ASAA7134_TS_SERIAL1:              00         (=
00000000)                                             =0ASAA7134_TS_DMA0:  =
               00         (00000000)                                       =
      =0ASAA7134_TS_DMA1:                 00         (00000000)            =
                                 =0ASAA7134_TS_DMA2:                 00    =
     (00000000)                                             =0ASAA7134_SPEC=
IAL_MODE:            01         (00000001)                                 =
            =0A =0A =0AChanges: State 0 -> State 1: =0ASAA7134_GPIO_GPMODE:=
             80000009 -> 8000000d  (-------- -------- -------- -----0--)   =
=0ASAA7134_GPIO_GPSTATUS:           0606200c -> 00062000  (-----11- -------=
- -------- ----11--)   =0ASAA7134_ANALOG_IO_SELECT:        3b       -> 00  =
      (--111-11)                              =0A =0A3 changes =0A =0A =0A-=
---------------------------------------------------------------------------=
------ =0A =0ASAA7130 Card - State 1: =0ASAA7134_GPIO_GPMODE:             8=
000000d   (10000000 00000000 00000000 00001101)  (was: 80000009) =0ASAA7134=
_GPIO_GPSTATUS:           00062000 * (00000000 00000110 00100000 00000000) =
 (was: 0606200c) =0ASAA7134_ANALOG_IN_CTRL1:         c1 *       (11000001) =
                                            =0ASAA7134_ANALOG_IO_SELECT:   =
     00 *       (00000000)                             (was: 3b)       =0AS=
AA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 0000=
0000)                  =0ASAA7134_VIDEO_PORT_CTRL4:        00000000   (0000=
0000 00000000 00000000 00000000)                  =0ASAA7134_VIDEO_PORT_CTR=
L8:        00         (00000000)                                           =
  =0ASAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                =
                             =0ASAA7134_I2S_OUTPUT_FORMAT:       01        =
 (00000001)                                             =0ASAA7134_I2S_OUTP=
UT_LEVEL:        00         (00000000)                                     =
        =0ASAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)          =
                                   =0ASAA7134_TS_PARALLEL:             04  =
       (00000100)                                             =0ASAA7134_TS=
_PARALLEL_SERIAL:      00         (00000000)                               =
              =0ASAA7134_TS_SERIAL0:              00         (00000000)    =
                                         =0ASAA7134_TS_SERIAL1:            =
  00         (00000000)                                             =0ASAA7=
134_TS_DMA0:                 00         (00000000)                         =
                    =0ASAA7134_TS_DMA1:                 00         (0000000=
0)                                             =0ASAA7134_TS_DMA2:         =
        00         (00000000)                                             =
=0ASAA7134_SPECIAL_MODE:            01         (00000001)                  =
                           =0A =0A =0AChanges: State 1 -> State 2: =0ASAA71=
34_GPIO_GPSTATUS:           00062000 -> 00062008  (-------- -------- ------=
-- ----0---)   =0ASAA7134_ANALOG_IN_CTRL1:         c1       -> 83        (-=
1----0-)                              =0ASAA7134_ANALOG_IO_SELECT:        0=
0       -> 09        (----0--0)                              =0A =0A3 chang=
es =0A =0A =0A-------------------------------------------------------------=
--------------------- =0A =0ASAA7130 Card - State 2: =0ASAA7134_GPIO_GPMODE=
:             8000000d   (10000000 00000000 00000000 00001101)             =
     =0ASAA7134_GPIO_GPSTATUS:           00062008   (00000000 00000110 0010=
0000 00001000)  (was: 00062000) =0ASAA7134_ANALOG_IN_CTRL1:         83 *   =
    (10000011)                             (was: c1)       =0ASAA7134_ANALO=
G_IO_SELECT:        09         (00001001)                             (was:=
 00)       =0ASAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 0000000=
0 00000000 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL4:        0=
0000000   (00000000 00000000 00000000 00000000)                  =0ASAA7134=
_VIDEO_PORT_CTRL8:        00         (00000000)                            =
                 =0ASAA7134_I2S_OUTPUT_SELECT:       00         (00000000) =
                                            =0ASAA7134_I2S_OUTPUT_FORMAT:  =
     01         (00000001)                                             =0AS=
AA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                      =
                       =0ASAA7134_I2S_AUDIO_OUTPUT:        01         (0000=
0001)                                             =0ASAA7134_TS_PARALLEL:  =
           04         (00000100)                                           =
  =0ASAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                =
                             =0ASAA7134_TS_SERIAL0:              00        =
 (00000000)                                             =0ASAA7134_TS_SERIA=
L1:              00         (00000000)                                     =
        =0ASAA7134_TS_DMA0:                 00         (00000000)          =
                                   =0ASAA7134_TS_DMA1:                 00  =
       (00000000)                                             =0ASAA7134_TS=
_DMA2:                 00         (00000000)                               =
              =0ASAA7134_SPECIAL_MODE:            01         (00000001)    =
                                         =0A =0A =0AChanges: State 2 -> Sta=
te 3: =0ASAA7134_ANALOG_IN_CTRL1:         83       -> c8        (-0--0-11) =
                             =0A =0A1 changes =0A =0A =0A------------------=
---------------------------------------------------------------- =0A =0ASAA=
7130 Card - State 3: =0ASAA7134_GPIO_GPMODE:             8000000d   (100000=
00 00000000 00000000 00001101)                  =0ASAA7134_GPIO_GPSTATUS:  =
         00062008 * (00000000 00000110 00100000 00001000)                  =
=0ASAA7134_ANALOG_IN_CTRL1:         c8 *       (11001000)                  =
           (was: 83)       =0ASAA7134_ANALOG_IO_SELECT:        09 *       (=
00001001)                                             =0ASAA7134_VIDEO_PORT=
_CTRL0:        00000000   (00000000 00000000 00000000 00000000)            =
      =0ASAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 000=
00000 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL8:        00    =
     (00000000)                                             =0ASAA7134_I2S_=
OUTPUT_SELECT:       00         (00000000)                                 =
            =0ASAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)      =
                                       =0ASAA7134_I2S_OUTPUT_LEVEL:        =
00         (00000000)                                             =0ASAA713=
4_I2S_AUDIO_OUTPUT:        01         (00000001)                           =
                  =0ASAA7134_TS_PARALLEL:             04         (00000100)=
                                             =0ASAA7134_TS_PARALLEL_SERIAL:=
      00         (00000000)                                             =0A=
SAA7134_TS_SERIAL0:              00         (00000000)                     =
                        =0ASAA7134_TS_SERIAL1:              00         (000=
00000)                                             =0ASAA7134_TS_DMA0:     =
            00         (00000000)                                          =
   =0ASAA7134_TS_DMA1:                 00         (00000000)               =
                              =0ASAA7134_TS_DMA2:                 00       =
  (00000000)                                             =0ASAA7134_SPECIAL=
_MODE:            01         (00000001)                                    =
         =0A =0A =0AChanges: State 3 -> State 4: =0ASAA7134_GPIO_GPSTATUS: =
          00062008 -> 04062004  (-----0-- -------- -------- ----10--)   =0A=
SAA7134_ANALOG_IN_CTRL1:         c8       -> c1        (----1--0)          =
                   (same as 0, 1) =0ASAA7134_ANALOG_IO_SELECT:        09   =
    -> 00        (----1--1)                             (same as 1) =0A =0A=
3 changes =0A =0A =0A------------------------------------------------------=
---------------------------- =0A =0ASAA7130 Card - State 4: =0ASAA7134_GPIO=
_GPMODE:             8000000d   (10000000 00000000 00000000 00001101)      =
            =0ASAA7134_GPIO_GPSTATUS:           04062004 * (00000100 000001=
10 00100000 00000100)  (was: 00062008) =0ASAA7134_ANALOG_IN_CTRL1:         =
c1         (11000001)                             (was: c8)       =0ASAA713=
4_ANALOG_IO_SELECT:        00         (00000000)                           =
  (was: 09)       =0ASAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 =
00000000 00000000 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL4:  =
      00000000   (00000000 00000000 00000000 00000000)                  =0A=
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                     =
                        =0ASAA7134_I2S_OUTPUT_SELECT:       00         (000=
00000)                                             =0ASAA7134_I2S_OUTPUT_FO=
RMAT:       01         (00000001)                                          =
   =0ASAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)               =
                              =0ASAA7134_I2S_AUDIO_OUTPUT:        01       =
  (00000001)                                             =0ASAA7134_TS_PARA=
LLEL:             04         (00000100)                                    =
         =0ASAA7134_TS_PARALLEL_SERIAL:      00         (00000000)         =
                                    =0ASAA7134_TS_SERIAL0:              00 =
        (00000000)                                             =0ASAA7134_T=
S_SERIAL1:              00         (00000000)                              =
               =0ASAA7134_TS_DMA0:                 00         (00000000)   =
                                          =0ASAA7134_TS_DMA1:              =
   00         (00000000)                                             =0ASAA=
7134_TS_DMA2:                 00         (00000000)                        =
                     =0ASAA7134_SPECIAL_MODE:            01         (000000=
01)                                             =0A =0A =0AChanges: State 4=
 -> State 5: =0ASAA7134_GPIO_GPSTATUS:           04062004 -> 02062000  (---=
--10- -------- -------- -----1--)   =0A =0A1 changes =0A =0A =0A-----------=
----------------------------------------------------------------------- =0A=
 =0ASAA7130 Card - State 5: =0ASAA7134_GPIO_GPMODE:             8000000d   =
(10000000 00000000 00000000 00001101)                  =0ASAA7134_GPIO_GPST=
ATUS:           02062000 * (00000010 00000110 00100000 00000000)  (was: 040=
62004) =0ASAA7134_ANALOG_IN_CTRL1:         c1         (11000001)           =
                                  =0ASAA7134_ANALOG_IO_SELECT:        00 * =
      (00000000)                                             =0ASAA7134_VID=
EO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)     =
             =0ASAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000=
000 00000000 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL8:       =
 00         (00000000)                                             =0ASAA71=
34_I2S_OUTPUT_SELECT:       00         (00000000)                          =
                   =0ASAA7134_I2S_OUTPUT_FORMAT:       01         (00000001=
)                                             =0ASAA7134_I2S_OUTPUT_LEVEL: =
       00         (00000000)                                             =
=0ASAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)                  =
                           =0ASAA7134_TS_PARALLEL:             04         (=
00000100)                                             =0ASAA7134_TS_PARALLE=
L_SERIAL:      00         (00000000)                                       =
      =0ASAA7134_TS_SERIAL0:              00         (00000000)            =
                                 =0ASAA7134_TS_SERIAL1:              00    =
     (00000000)                                             =0ASAA7134_TS_D=
MA0:                 00         (00000000)                                 =
            =0ASAA7134_TS_DMA1:                 00         (00000000)      =
                                       =0ASAA7134_TS_DMA2:                 =
00         (00000000)                                             =0ASAA713=
4_SPECIAL_MODE:            01         (00000001)                           =
                  =0A =0A =0AChanges: State 5 -> Register Dump: =0ASAA7134_=
GPIO_GPSTATUS:           02062000 -> 06062008  (-----0-- -------- -------- =
----0---)   =0ASAA7134_ANALOG_IO_SELECT:        00       -> 02        (----=
--0-)                              =0A =0A2 changes =0A =0A =0A=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D =0A =0ASAA7130 Card - Register Dump: =0ASAA7134_GPIO_GPMODE:        =
     8000000d   (10000000 00000000 00000000 00001101)                  =0AS=
AA7134_GPIO_GPSTATUS:           06062008   (00000110 00000110 00100000 0000=
1000)  (was: 02062000) =0ASAA7134_ANALOG_IN_CTRL1:         c1         (1100=
0001)                                             =0ASAA7134_ANALOG_IO_SELE=
CT:        02         (00000010)                             (was: 00)     =
  =0ASAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 0000000=
0 00000000)                  =0ASAA7134_VIDEO_PORT_CTRL4:        00000000  =
 (00000000 00000000 00000000 00000000)                  =0ASAA7134_VIDEO_PO=
RT_CTRL8:        00         (00000000)                                     =
        =0ASAA7134_I2S_OUTPUT_SELECT:       00         (00000000)          =
                                   =0ASAA7134_I2S_OUTPUT_FORMAT:       01  =
       (00000001)                                             =0ASAA7134_I2=
S_OUTPUT_LEVEL:        00         (00000000)                               =
              =0ASAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)    =
                                         =0ASAA7134_TS_PARALLEL:           =
  04         (00000100)                                             =0ASAA7=
134_TS_PARALLEL_SERIAL:      00         (00000000)                         =
                    =0ASAA7134_TS_SERIAL0:              00         (0000000=
0)                                             =0ASAA7134_TS_SERIAL1:      =
        00         (00000000)                                             =
=0ASAA7134_TS_DMA0:                 00         (00000000)                  =
                           =0ASAA7134_TS_DMA1:                 00         (=
00000000)                                             =0ASAA7134_TS_DMA2:  =
               00         (00000000)                                       =
      =0ASAA7134_SPECIAL_MODE:            01         (00000001)            =
                                 =0A =0Aend of dump =0A=0AHere is the order=
 in which I performed the test:State 6=0AState 0 - viewing software off=0AS=
tate 1 - tuner mode=0AState 2 - composite mode=0AState 3 - s video mode=0AS=
tate 4 - radio mode=0AState 5 - tuner mode (again)=0AFinal dump - viewing s=
oftware off (again)=0A=0AThanks to everyone for your help.=0A=0APavle.=0A=
=0A=0A=0A________________________________=0AFrom: Terry Wu <terrywu2009@gma=
il.com>=0ATo: hermann pitton <hermann-pitton@arcor.de>=0ACc: Pavle Predic <=
pavle.predic@yahoo.co.uk>; video4linux-list@redhat.com=0ASent: Sat, 21 Nove=
mber, 2009 10:07:05=0ASubject: Re: Leadtek Winfast TV2100=0A=0AHi,=0A=0A   =
 There are many models of TV2100.=0A    Different model uses different TV t=
uner.=0A=0A    The tuner 69 is TUNER_TNF_5335MF.=0A    Make sure the tuner =
in your TV2100 card is the TNF_5335MF.=0A=0A    Maybe the tuner in your TV2=
100 card is not supported by current=0Av4l-dvb driver yet (linux\include\me=
dia\tuner.h).=0A=0A=0ATerry=0A=0A2009/11/21 hermann pitton <hermann-pitton@=
arcor.de>:=0A> Hi Pavle,=0A>=0A> Am Freitag, den 20.11.2009, 14:11 +0000 sc=
hrieb Pavle Predic:=0A>> Hi Hermann,=0A>>=0A>> Thank you so much for your h=
elp. I didn't really get most of what you=0A>> said (way to technical for m=
e), but at least I know now which tuner I=0A>> should use, so I'll keep tes=
ting with tuner 69 and see if I get=0A>> results.=0A>=0A> that one should b=
e right, especially for analog radio.=0A>=0A>> BTW, I'm not from UK - I'm f=
rom Serbia and I'm trying to make the card=0A>> work for my cable tv which =
uses PAL BG (at least so they say).=0A>=0A> Lots of people are on the move =
these days, therefore it is important to=0A> know too, what they might carr=
y with them. That tuner should be fine=0A> then.=0A>=0A>> I'll report back =
after testing on tuner 69 (I'll simply try all card=0A>> ids with this tune=
r id). In the meantime here's some more info:=0A>=0A> Better is to follow t=
he advice how you can narrow down such stuff.=0A>=0A> As far I know, we hav=
e not destroyed a single device yet on the saa7134=0A> driver, but to go ov=
er all possibilities, concerning voltage and gpios,=0A> has some risks and =
is not the shortest way to come closer.=0A>=0A> Thanks for your input.=0A>=
=0A> Cheers,=0A> Hermann=0A>=0A>> dmesg:=0A>>=0A>> [    9.829338] saa7130/3=
4: v4l2 driver version 0.2.15 loaded=0A>> [    9.829408] saa7134 0000:00:08=
.0: PCI INT A -> GSI 17 (level, low)=0A>> -> IRQ 17=0A>> [    9.829419] saa=
7130[0]: found at 0000:00:08.0, rev: 1, irq: 17,=0A>> latency: 64, mmio: 0x=
fdffe000=0A>> [    9.829428] saa7130[0]: subsystem: 107d:6f3a, board:=0A>> =
UNKNOWN/GENERIC [card=3D0,autodetected]=0A>> [    9.829458] saa7130[0]: boa=
rd init: gpio is 6200c=0A>> [    9.829465] IRQ 17/saa7130[0]: IRQF_DISABLED=
 is not guaranteed on=0A>> shared IRQs=0A>> [    9.980513] saa7130[0]: i2c =
eeprom 00: 7d 10 3a 6f 54 20 1c 00 43=0A>> 43 a9 1c 55 d2 b2 92=0A>> [    9=
.980532] saa7130[0]: i2c eeprom 10: 0c ff 82 0e ff 20 ff ff ff=0A>> ff ff f=
f ff ff ff ff=0A>> [    9.980547] saa7130[0]: i2c eeprom 20: 01 40 02 03 03=
 02 01 03 08=0A>> ff 00 8c ff ff ff ff=0A>> [    9.980562] saa7130[0]: i2c =
eeprom 30: ff ff ff ff ff ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9=
.980578] saa7130[0]: i2c eeprom 40: 50 89 00 c2 00 00 02 30 02=0A>> ff ff f=
f ff ff ff ff=0A>> [    9.980593] saa7130[0]: i2c eeprom 50: ff ff ff ff ff=
 ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9.980608] saa7130[0]: i2c =
eeprom 60: ff ff ff ff ff ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9=
.980623] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff=0A>> ff ff f=
f ff ff ff ff=0A>> [    9.980639] saa7130[0]: i2c eeprom 80: ff ff ff ff ff=
 ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9.980654] saa7130[0]: i2c =
eeprom 90: ff ff ff ff ff ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9=
.980670] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff=0A>> ff ff f=
f ff ff ff ff=0A>> [    9.980685] saa7130[0]: i2c eeprom b0: ff ff ff ff ff=
 ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9.980701] saa7130[0]: i2c =
eeprom c0: ff ff ff ff ff ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9=
.980716] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff=0A>> ff ff f=
f ff ff ff ff=0A>> [    9.980731] saa7130[0]: i2c eeprom e0: ff ff ff ff ff=
 ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9.980747] saa7130[0]: i2c =
eeprom f0: ff ff ff ff ff ff ff ff ff=0A>> ff ff ff ff ff ff ff=0A>> [    9=
.980876] saa7130[0]: registered device video0 [v4l2]=0A>> [    9.980908] sa=
a7130[0]: registered device vbi0=0A>>=0A>>=0A>> lsmod:=0A>>=0A>> saa7134   =
            135552  0=0A>> ir_common              47172  1 saa7134=0A>> v4l=
2_common            14308  1 saa7134=0A>> videodev               31040  2 s=
aa7134,v4l2_common=0A>> videobuf_dma_sg        11340  1 saa7134=0A>> videob=
uf_core          16164  2 saa7134,videobuf_dma_sg=0A>> tveeprom            =
   10720  1 saa7134=0A>> i2c_core               20844  4=0A>> i2c_viapro,sa=
a7134,v4l2_common,tveeprom=0A>>=0A>> lspci:=0A>>=0A>> 00:08.0 Multimedia co=
ntroller [0480]: Philips Semiconductors SAA7130=0A>> Video Broadcast Decode=
r [1131:7130] (rev 01)=0A>>     Subsystem: LeadTek Research Inc. Device [10=
7d:6f3a]=0A>>     Flags: bus master, medium devsel, latency 64, IRQ 17=0A>>=
     Memory at fdffe000 (32-bit, non-prefetchable) [size=3D1K]=0A>>     Cap=
abilities: [40] Power Management version 1=0A>>     Kernel driver in use: s=
aa7134=0A>>     Kernel modules: saa7134=0A>>=0A>> Thanks again,=0A>>=0A>> P=
avle.=0A>>=0A>>=0A>>=0A>>=0A>>=0A>> _______________________________________=
_______________________________=0A>> From: hermann pitton <hermann-pitton@a=
rcor.de>=0A>> To: Pavle Predic <pavle.predic@yahoo.co.uk>=0A>> Cc: video4li=
nux-list@redhat.com=0A>> Sent: Sun, 8 November, 2009 23:35:08=0A>> Subject:=
 Re: Leadtek Winfast TV2100=0A>>=0A>> Hi Pavle,=0A>>=0A>> Am Sonntag, den 0=
8.11.2009, 17:11 +0000 schrieb Pavle Predic:=0A>> > Did anyone manage to ge=
t this card working on Linux? I got the=0A>> picture out of the box, but it=
's impossible to get any sound from the=0A>> damned thing. The card is not =
on CARDLIST.saa7134, but I assume a=0A>> similar card/tuner combination can=
 be used. But which? By the way, I=0A>> got the speakers connected directly=
 to card output, I'm not even=0A>> trying to get it working with my sound c=
ard. I can hear clicks when=0A>> loading/unloading modules, so it's alive b=
ut not set up properly.=0A>> >=0A>> > Any info would be greatly appreciated=
. Perhaps someone knows of=0A>> another card that is similar to this one?=
=0A>> >=0A>> > Card info:=0A>> > Chipset: saa7134=0A>> > Tuner: Tvision TVF=
88T5-B/DFF=0A>> > Card numbers that produce picture (modprobe saa7134 card=
=3D$n): 3, 7,=0A>> 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 68=0A>>=0A>>=
 that is not enough information yet.=0A>>=0A>> The correct tuner for this o=
ne is tuner=3D69.=0A>>=0A>> Only with this one you will have also radio sup=
port.=0A>>=0A>> Since you mail from an UK mail provider, this tuner is not =
expected to=0A>> work with PAL-I TV stereo sound there, but radio would wor=
k.=0A>>=0A>> Else, if neither amux =3D TV nor amux =3D LINE1 or LINE2 (LINE=
 inputs for=0A>> TV=0A>> sound are only found on saa7130 chips, except ther=
e is also an extra=0A>> TV=0A>> mono section directly from the tuner)  work=
 for TV sound, most often=0A>> an=0A>> external audio mux is in the way and=
 needs to be configured correctly=0A>> with saa7134 gpio pins. Looking also=
 at the minor chips on the card=0A>> with=0A>> more than 3 pins can reveal =
such a mux.=0A>>=0A>> There is also a software test on such hardware, succe=
eding in most=0A>> cases.=0A>>=0A>> By default, external analog audio input=
 is looped through to analog=0A>> audio out, on which you are listening, if=
 the driver is unloaded.=0A>>=0A>> On a saa7134 chip, on saa7130 are some k=
nown specials, you should hear=0A>> the incoming sound directly on your hea=
dphones or what else you might=0A>> be=0A>> using directly connected to you=
r card, trying on LINE1 and LINE2 for=0A>> that.=0A>>=0A>> If not, you can =
expect that such a mux chip needs to be treated=0A>> correctly.=0A>>=0A>> T=
he DScaler (deinterlace.sf.net) regspy.exe often can help to identify=0A>> =
such gpios in use, else you must trace lines and resistors on it.=0A>>=0A>>=
 In general, an absolute minimum is to provide related "dmesg" after=0A>> l=
oading the driver _without_ having tried on other cards previously.=0A>>=0A=
>> Please read more on the linuxtv.org wiki about adding support for a=0A>>=
 new=0A>> card.=0A>>=0A>> Cheers,=0A>> Hermann=0A>=0A>=0A>=0A> --=0A> video=
4linux-list mailing list=0A> Unsubscribe mailto:video4linux-list-request@re=
dhat.com?subject=3Dunsubscribe=0A> https://www.redhat.com/mailman/listinfo/=
video4linux-list=0A>=0A=0A=0A=0A      
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
