Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TDbfKd023192
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 09:37:41 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TDbOQT010235
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 09:37:25 -0400
Received: by fg-out-1718.google.com with SMTP id e12so4304fga.7
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 06:37:24 -0700 (PDT)
Message-ID: <74a5bce60804290637k21f2465ajed607224a8fe764b@mail.gmail.com>
Date: Tue, 29 Apr 2008 15:37:23 +0200
From: "zied frikha" <frikha.zied@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080428160019.AB5306186B3@hormel.redhat.com>
MIME-Version: 1.0
References: <20080428160019.AB5306186B3@hormel.redhat.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Subject: Re: video4linux-list Digest, Vol 50, Issue 28
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

Hello
I check to run the FM Radio under the Mandriva 2008 Linux
I have any problem with my Radio that use the v4l and v4l2 librarys.
this is the driver that I use :
http://www.linuxhq.com/kernel/v2.6/25-rc8/drivers/media/radio/radio-si470x.=
c
and I use the Qt Radio as GUI
the seeking operations run normally but I have not the RDS (no audio)
have you any ideas to correcting this problem please.
thank you for all.
excuse me for my poor english

2008/4/28 <video4linux-list-request@redhat.com>:

> Send video4linux-list mailing list submissions to
>        video4linux-list@redhat.com
>
> To subscribe or unsubscribe via the World Wide Web, visit
>        https://www.redhat.com/mailman/listinfo/video4linux-list
> or, via email, send a message with subject or body 'help' to
>        video4linux-list-request@redhat.com
>
> You can reach the person managing the list at
>        video4linux-list-owner@redhat.com
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of video4linux-list digest..."
>
> Today's Topics:
>
>   1. WinTV PVR PCI (Xefur Ragnarok)
>   2. TerraTec Cinergy C - tuning fails (kiu)
>   3. Re: TerraTec Cinergy C - tuning fails (kiu)
>   4. Re: TerraTec Cinergy C - tuning fails (kiu)
>   5. Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
>      (hermann pitton)
>   6. Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to
>      2.6.25 (Hartmut Hackmann)
>   7. Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to
>      2.6.25 (hermann pitton)
>   8. Re: WinTV PVR PCI (Andy Walls)
>   9. [PATCH] v4l: Introduce "stream" attribute for persistent
>      video4linux device nodes (Brandon Philips)
>  10. Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
>      (Mauro Carvalho Chehab)
>  11. Re: pxa_camera with one buffer don't work (Guennadi Liakhovetski)
>  12. Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to
>      2.6.25 (Mauro Carvalho Chehab)
>  13. Trying to set up a NPG Real DVB-T PCI Card (Vicent Jord?)
>  14. Re: Trying to set up a NPG Real DVB-T PCI Card
>      (Mauro Carvalho Chehab)
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Xefur Ragnarok <x3fur@yahoo.com>
> To: video4linux-list@redhat.com
> Date: Sun, 27 Apr 2008 09:04:46 -0700 (PDT)
> Subject: WinTV PVR PCI
> Hello,
>
> I have recently acquired a WinTV PVR PCI card. What is interesting about
> this card is that none of the drivers worked in either windows or linux. =
I
> believe the reason to be the following:
>
> excerpt from lspci:
> 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
>
> I'm positive that this is the card. However its' PCI Subsystem ID is
> unrecognised.
>
> It has the BT878 Chipset, I'm not sure about the tuner but I know it is
> NTSC. I've tried manually following the directions on the bttv howto to n=
o
> avail. All of those instructions assume that you have a pci subsystem id =
of
> a card that should have been already detected.
>
> Other Info:
>
> mediacenter:/home/tim/Desktop/bttv-0.9.15 # lspci
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-H=
ub
> Interface (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller
> (rev 02)
> 00:03.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to CSA Bridge (rev
> 02)
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHC=
I
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHC=
I
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHC=
I
> Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHC=
I
> Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EH=
CI
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interfa=
ce
> Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller
> (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller
> (rev 02)
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER
> (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> 01:01.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (rev
> 10)
> 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
> 02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet
> Controller
> 03:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon
> 9600]
> 03:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> (Secondary)
>
>
> mediacenter:/home/tim/Desktop/bttv-0.9.15 # lsmod |grep bt
> bttv                  168980  0
> i2c_algo_bit            9988  1 bttv
> tveeprom               18960  1 bttv
> i2c_core               27520  3 bttv,i2c_algo_bit,tveeprom
> video_buf              27652  1 bttv
> ir_common              38148  1 bttv
> compat_ioctl32          5376  1 bttv
> btcx_risc               8840  1 bttv
> videodev               30464  1 bttv
> v4l2_common            20608  2 bttv,videodev
> v4l1_compat            16388  2 bttv,videodev
> firmware_class         13568  2 bttv,microcode
>
>
> Any help would be appreciated
> Timothy
>
>
>
> ---------------------------------
> Be a better friend, newshound, and know-it-all with Yahoo! Mobile.  Try i=
t
> now.
>
>
> ---------- Message transf=E9r=E9 ----------
> From: kiu <kiu@gmx.net>
> To: video4linux-list@redhat.com
> Date: Sun, 27 Apr 2008 20:58:41 +0200
> Subject: TerraTec Cinergy C - tuning fails
> Hi List,
>
> i have a TerraTec Cinergy C DVB-C PCI Card in my mythbuntu 8.04 pc.
> After compiling the mantis driver (http://jusst.de/hg/mantis) the card
> is recognized by the kernel.
>
> If i now run (dvb)scan it searches for QAM64 and QAM256 and finds
> signals there. After scanning it tries to tune the channels, but
> freezes with this message:
>
> tune to:
>
>> tuning status =3D=3D 0x1f
>>>>
>>> add_filter:1388: add filter pid 0x0000
> start_filter:1334: start filter pid 0x0000 table_id 0x00
>
> Why is "tune to: " empty without a frequency ?
> Why is pid 0, shouldnt this be non zero ?
>
> Any hints for debugging/fixing it my issues ?
>
> TIA!
>
> --
> kiu
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: kiu <kiu@gmx.net>
> To: video4linux-list@redhat.com
> Date: Sun, 27 Apr 2008 21:04:50 +0200
> Subject: Re: TerraTec Cinergy C - tuning fails
> Quoting kiu <kiu@gmx.net>:
>
>  If i now run (dvb)scan it searches for QAM64 and QAM256 and finds
>>
>
> sorry, i meant: w_scan -fc -x -vvvv
>
>  signals there. After scanning it tries to tune the channels, but
>> freezes with this message:
>>
>> tune to:
>>
>>> tuning status =3D=3D 0x1f
>>>>>
>>>> add_filter:1388: add filter pid 0x0000
>> start_filter:1334: start filter pid 0x0000 table_id 0x00
>>
>
> --
> kiu
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: kiu <kiu@gmx.net>
> To: video4linux-list@redhat.com
> Date: Sun, 27 Apr 2008 21:28:33 +0200
> Subject: Re: TerraTec Cinergy C - tuning fails
> Hi List,
>
> ignore my requests, sorry, picked the wrong mailinglist. Posted it on the
> dvb list again.
>
> Sorry for the confusion...
>
> Quoting kiu <kiu@gmx.net>:
>
>  Quoting kiu <kiu@gmx.net>:
>>
>>  If i now run (dvb)scan it searches for QAM64 and QAM256 and finds
>>>
>>
>> sorry, i meant: w_scan -fc -x -vvvv
>>
>>  signals there. After scanning it tries to tune the channels, but
>>> freezes with this message:
>>>
>>> tune to:
>>>
>>>> tuning status =3D=3D 0x1f
>>>>>>
>>>>> add_filter:1388: add filter pid 0x0000
>>> start_filter:1334: start filter pid 0x0000 table_id 0x00
>>>
>>
> --
> kiu
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: hermann pitton <hermann-pitton@arcor.de>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
> Date: Sun, 27 Apr 2008 22:15:22 +0200
> Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
> Hi,
>
> Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab:
> > On Sun, 27 Apr 2008 00:10:21 +0200
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> > > Cool stuff!
> > >
> > > Works immediately for all tuners again. Analog TV, radio and DVB-T on
> > > that machine is tested.
> > >
> > > Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> >
> > Thanks. I'll add it to the patch.
> >
> > > Maybe Hartmut can help too, but I will test also on the triple stuff
> and
> > > the FMD1216ME/I MK3 hybrid tomorrow.
> >
> > Thanks.
> >
> > It would be helpful if tda9887 conf could also be validated. I didn't
> touch at
> > the logic, but I saw some weird things:
> >
> > For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
> >       .tda9887_conf   =3D TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
> >
> > And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
> >
> > However, there's an autodetection code that changes from EUROPA to SNAK=
E,
> > without cleaning tda9887_conf:
> >
> >         case SAA7134_BOARD_PHILIPS_EUROPA:
> >                 if (dev->autodetected && (dev->eedata[0x41] =3D=3D 0x1c=
)) {
> >                         /* Reconfigure board as Snake reference design =
*/
> >                         dev->board =3D SAA7134_BOARD_PHILIPS_SNAKE;
> >                         dev->tuner_type =3D
> saa7134_boards[dev->board].tuner_type;
> >                         printk(KERN_INFO "%s: Reconfigured board as
> %s\n",
> >                                 dev->name,
> saa7134_boards[dev->board].name);
> >                         break;
> >
> > I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if th=
e
> above
> > code should be doing, instead:
> >
> >       dev->tda9887_conf =3D saa7134_boards[dev->board].tda9887_conf;
> >
> > If the right thing to do is to initialize SNAKE with the same tda9887
> > parameters as EUROPE, the better would be to add the .tda9887_conf to
> SNAKE
> > entry.
> >
> > Cheers,
> > Mauro
>
> Hartmut has the board and knows better, but it looks like it only has
> DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
> analog tuner, no tda9887 and also no DVB-T, but it unfortunately shares
> the subsystem with the Philips Europa.
>
> I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> boards.
>
> Unchanged is that the tda9887 is not up for analog after boot.
> Previously one did reload "tuner" just once and was done.
>
> Now, modprobe vr tuner and modprobe -v tuner results in
>
> tuner' 2-004b: tda829x detected
> tuner' 2-004b: Setting mode_mask to 0x0e
> tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> tuner' 2-004b: tuner 0x4b: Tuner type absent
> tuner' 3-004b: tda829x detected
> tuner' 3-004b: Setting mode_mask to 0x0e
> tuner' 3-004b: chip found @ 0x96 (saa7133[1])
> tuner' 3-004b: tuner 0x4b: Tuner type absent
> tuner' 4-004b: tda829x detected
> tuner' 4-004b: Setting mode_mask to 0x0e
> tuner' 4-004b: chip found @ 0x96 (saa7133[2])
> tuner' 4-004b: tuner 0x4b: Tuner type absent
> tuner' 5-0043: chip found @ 0x86 (saa7134[3])
> tda9887 5-0043: creating new instance
> tda9887 5-0043: tda988[5/6/7] found
> tuner' 5-0043: type set to tda9887
> tuner' 5-0043: tv freq set to 0.00
> tuner' 5-0043: TV freq (0.00) out of range (44-958)
> tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for
> 0x0e
> tuner' 5-0061: Setting mode_mask to 0x0e
> tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
> tuner' 5-0061: tuner 0x61: Tuner type absent
>
> So tests were not complete and it is not finished yet ;)
>
> DVB-T still works, but analog of course not.
>
> A "modprobe -vr saa7134-dvb" and then "modprobe -v saa7134" brings them
> all back, including enabling analog TV on the FMD1216ME and tda9887.
>
> Cheers,
> Hermann
>
>
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: setting pci latency timer to 64
> saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 19, latency: 64, mmio:
> 0xe8000000
> saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design
> [card=3D81,insmod option]
> saa7133[0]: board init: gpio is 0
> saa7133[0]: i2c eeprom 00: 43 10 57 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 9=
2
> saa7133[0]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 cb ff ff ff f=
f
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> tuner' 2-004b: tda829x detected
> tuner' 2-004b: Setting mode_mask to 0x0e
> tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> tuner' 2-004b: tuner 0x4b: Tuner type absent
> tuner' 2-004b: Calling set_type_addr for type=3D54, addr=3D0xff, mode=3D0=
x0e,
> config=3D0x00
> tuner' 2-004b: defining GPIO callback
> tda829x 2-004b: setting tuner address to 61
> tda829x 2-004b: type set to tda8290+75a
> tuner' 2-004b: type set to tda8290+75a
> tuner' 2-004b: tv freq set to 400.00
> tuner' 2-004b: saa7133[0] tuner' I2C addr 0x96 with type 54 used for 0x0e
> tuner' 2-004b: switching to v4l2
> tuner' 2-004b: tv freq set to 400.00
> tuner' 2-004b: tv freq set to 400.00
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> tuner' 2-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
> saa7133[1]: setting pci latency timer to 64
> saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 18, latency: 64, mmio:
> 0xe8001000
> saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual
> [card=3D78,autodetected]
> saa7133[1]: board init: gpio is 0
> input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input7
> tuner' 3-004b: tda829x detected
> tuner' 3-004b: Setting mode_mask to 0x0e
> tuner' 3-004b: chip found @ 0x96 (saa7133[1])
> tuner' 3-004b: tuner 0x4b: Tuner type absent
> saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 9=
2
> saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff f=
f
> saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> tuner' 3-004b: Calling set_type_addr for type=3D54, addr=3D0xff, mode=3D0=
x0e,
> config=3D0x00
> tuner' 3-004b: defining GPIO callback
> tda829x 3-004b: setting tuner address to 61
> tda829x 3-004b: type set to tda8290+75a
> tuner' 3-004b: type set to tda8290+75a
> tuner' 3-004b: tv freq set to 400.00
> tuner' 3-004b: saa7133[1] tuner' I2C addr 0x96 with type 54 used for 0x0e
> tuner' 3-004b: switching to v4l2
> tuner' 3-004b: tv freq set to 400.00
> tuner' 3-004b: tv freq set to 400.00
> saa7133[1]: registered device video1 [v4l2]
> saa7133[1]: registered device vbi1
> saa7133[1]: registered device radio1
> tuner' 3-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
> saa7133[2]: setting pci latency timer to 64
> saa7133[2]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 64, mmio:
> 0xe8002000
> saa7133[2]: subsystem: 16be:0010, board: Medion/Creatix CTX953 Hybrid
> [card=3D134,autodetected]
> saa7133[2]: board init: gpio is 0
> tuner' 4-004b: tda829x detected
> tuner' 4-004b: Setting mode_mask to 0x0e
> tuner' 4-004b: chip found @ 0x96 (saa7133[2])
> tuner' 4-004b: tuner 0x4b: Tuner type absent
> saa7133[2]: i2c eeprom 00: be 16 10 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 9=
2
> saa7133[2]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 5=
0
> saa7133[2]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 2c 02 51 96 2=
b
> saa7133[2]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3=
c
> saa7133[2]: i2c eeprom 40: ff 21 00 c0 96 10 03 22 15 00 fd 79 44 9f c2 8=
f
> saa7133[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7133[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> tuner' 4-004b: Calling set_type_addr for type=3D54, addr=3D0xff, mode=3D0=
x0e,
> config=3D0x00
> tuner' 4-004b: defining GPIO callback
> tda829x 4-004b: setting tuner address to 60
> tda829x 4-004b: type set to tda8290+75a
> tuner' 4-004b: type set to tda8290+75a
> tuner' 4-004b: tv freq set to 400.00
> tuner' 4-004b: saa7133[2] tuner' I2C addr 0x96 with type 54 used for 0x0e
> tuner' 4-004b: switching to v4l2
> tuner' 4-004b: tv freq set to 400.00
> tuner' 4-004b: tv freq set to 400.00
> saa7133[2]: registered device video2 [v4l2]
> saa7133[2]: registered device vbi2
> tuner' 4-004b: Cmd TUNER_SET_STANDBY accepted for analog TV
> saa7134[3]: setting pci latency timer to 64
> saa7134[3]: found at 0000:01:0a.0, rev: 1, irq: 16, latency: 64, mmio:
> 0xe8003000
> saa7134[3]: subsystem: 16be:0003, board: Medion 7134 [card=3D12,autodetec=
ted]
> saa7134[3]: board init: gpio is 0
> tuner' 5-0043: chip found @ 0x86 (saa7134[3])
> tda9887 5-0043: creating new instance
> tda9887 5-0043: tda988[5/6/7] found
> tuner' 5-0043: type set to tda9887
> tuner' 5-0043: tv freq set to 0.00
> tuner' 5-0043: TV freq (0.00) out of range (44-958)
> tuner' 5-0043: saa7134[3] tuner' I2C addr 0x86 with type 74 used for 0x0e
> tuner' 5-0061: Setting mode_mask to 0x0e
> tuner' 5-0061: chip found @ 0xc2 (saa7134[3])
> tuner' 5-0061: tuner 0x61: Tuner type absent
> saa7134[3]: i2c eeprom 00: be 16 03 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 9=
2
> saa7134[3]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 5=
0
> saa7134[3]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 1f 02 51 96 2=
b
> saa7134[3]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3=
c
> saa7134[3]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 00 00 fd 79 44 9f c2 8=
f
> saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff 06 06 0f 00 0f 00 0f 00 0f 0=
0
> saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff f=
f
> saa7134[3] Board has DVB-T
> saa7134[3] Tuner type is 63
> tuner' 5-0043: Calling set_type_addr for type=3D63, addr=3D0xff, mode=3D0=
x0e,
> config=3D0x00
> tuner' 5-0043: set addr discarded for type 74, mask e. Asked to change
> tuner at addr 0xff, with mask e
> tuner' 5-0061: Calling set_type_addr for type=3D63, addr=3D0xff, mode=3D0=
x0e,
> config=3D0x00
> tuner' 5-0061: defining GPIO callback
> tuner-simple 5-0061: creating new instance
> tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> tuner-simple 5-0061: tuner 0 atv rf input will be autoselected
> tuner-simple 5-0061: tuner 0 dtv rf input will be autoselected
> tuner' 5-0061: type set to Philips FMD1216ME M
> tuner' 5-0061: tv freq set to 400.00
> tuner-simple 5-0061: using tuner params #0 (pal)
> tuner-simple 5-0061: freq =3D 400.00 (6400), range =3D 1, config =3D 0x86=
, cb =3D
> 0x52
> tuner-simple 5-0061: Freq=3D 400.00 MHz, V_IF=3D38.93 MHz, Offset=3D0.00 =
MHz,
> div=3D7023
> tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
> tuner' 5-0061: saa7134[3] tuner' I2C addr 0xc2 with type 63 used for 0x0e
> tuner' 5-0043: switching to v4l2
> tuner' 5-0061: switching to v4l2
> tuner' 5-0061: tv freq set to 400.00
> tuner-simple 5-0061: using tuner params #0 (pal)
> tuner-simple 5-0061: freq =3D 400.00 (6400), range =3D 1, config =3D 0x86=
, cb =3D
> 0x52
> tuner-simple 5-0061: Freq=3D 400.00 MHz, V_IF=3D38.93 MHz, Offset=3D0.00 =
MHz,
> div=3D7023
> tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
> tuner' 5-0061: tv freq set to 400.00
> tuner-simple 5-0061: using tuner params #0 (pal)
> tuner-simple 5-0061: freq =3D 400.00 (6400), range =3D 1, config =3D 0x86=
, cb =3D
> 0x52
> tuner-simple 5-0061: Freq=3D 400.00 MHz, V_IF=3D38.93 MHz, Offset=3D0.00 =
MHz,
> div=3D7023
> tuner-simple 5-0061: tv 0x1b 0x6f 0x86 0x52
> saa7134[3]: registered device video3 [v4l2]
> saa7134[3]: registered device vbi3
> saa7134[3]: registered device radio2
> tuner' 5-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
> tuner' 5-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
> DVB: registering new adapter (saa7133[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> DVB: registering new adapter (saa7133[1])
> DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> DVB: registering new adapter (saa7133[2])
> DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 26 -- ok
> tuner-simple 5-0061: attaching existing instance
> tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> tuner-simple 5-0061: tuner 0 atv rf input will be autoselected
> tuner-simple 5-0061: tuner 0 dtv rf input will be autoselected
> DVB: registering new adapter (saa7134[3])
> DVB: registering frontend 3 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 53MHz sampling clock
> tda1004x: found firmware revision 26 -- ok
>
>
>
>
>
>
>
>
>
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
> To: hermann pitton <hermann-pitton@arcor.de>
> Date: Sun, 27 Apr 2008 23:18:03 +0200
> Subject: Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to 2.6.2=
5
> Hi, Hermann, Mauro
>
> hermann pitton schrieb:
>
>> Hi,
>>
>> Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab:
>>
>>> On Sun, 27 Apr 2008 00:10:21 +0200
>>> hermann pitton <hermann-pitton@arcor.de> wrote:
>>>
>>>> Cool stuff!
>>>>
>>>> Works immediately for all tuners again. Analog TV, radio and DVB-T on
>>>> that machine is tested.
>>>>
>>>> Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
>>>>
>>> Thanks. I'll add it to the patch.
>>>
>>>  Maybe Hartmut can help too, but I will test also on the triple stuff a=
nd
>>>> the FMD1216ME/I MK3 hybrid tomorrow.
>>>>
>>> Thanks.
>>>
>>> It would be helpful if tda9887 conf could also be validated. I didn't
>>> touch at
>>> the logic, but I saw some weird things:
>>>
>>> For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
>>>        .tda9887_conf   =3D TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
>>>
>>> And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
>>>
>>> However, there's an autodetection code that changes from EUROPA to SNAK=
E,
>>> without cleaning tda9887_conf:
>>>
>>>        case SAA7134_BOARD_PHILIPS_EUROPA:
>>>                if (dev->autodetected && (dev->eedata[0x41] =3D=3D 0x1c)=
) {
>>>                        /* Reconfigure board as Snake reference design *=
/
>>>                        dev->board =3D SAA7134_BOARD_PHILIPS_SNAKE;
>>>                        dev->tuner_type =3D
>>> saa7134_boards[dev->board].tuner_type;
>>>                        printk(KERN_INFO "%s: Reconfigured board as %s\n=
",
>>>                                dev->name,
>>> saa7134_boards[dev->board].name);
>>>                        break;
>>>
>>> I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if th=
e
>>> above
>>> code should be doing, instead:
>>>
>>>        dev->tda9887_conf =3D saa7134_boards[dev->board].tda9887_conf;
>>>
>>> If the right thing to do is to initialize SNAKE with the same tda9887
>>> parameters as EUROPE, the better would be to add the .tda9887_conf to
>>> SNAKE
>>> entry.
>>>
>>> Cheers,
>>> Mauro
>>>
>>
>> Hartmut has the board and knows better, but it looks like it only has
>> DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
>> analog tuner, no tda9887 and also no DVB-T, but it unfortunately shares
>> the subsystem with the Philips Europa.
>>
>>  Hermann is right, SNAKE has no analog tuner. These boards indeed share
> the same PCI ID,
> This code fragment reads the tuner ID from the eeprom to find out which
> board is there.
>
>  I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
>> boards.
>>
>>  Aha! I modified my board that it no longer runs with the current driver=
.
> But i observed
> something similar
>
>  Unchanged is that the tda9887 is not up for analog after boot.
>> Previously one did reload "tuner" just once and was done.
>>
>>  <snip>
> Don't have the time today, but lets roll back history: Not absolutely sur=
e
> but if
> i remember correcly, the initialization sequence can be critical with
> hybrid tuners /
> NIM modules. The tda9887 may only be visible on I2C after a certain bit i=
n
> the MOPLL
> is set (in byte4?)
>
> Best regards
>  Hartmut
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: hermann pitton <hermann-pitton@arcor.de>
> To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
> Date: Mon, 28 Apr 2008 03:01:40 +0200
> Subject: Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to 2.6.2=
5
>
> Am Sonntag, den 27.04.2008, 23:18 +0200 schrieb Hartmut Hackmann:
> > Hi, Hermann, Mauro
> >
> > hermann pitton schrieb:
> > > Hi,
> > >
> > > Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab=
:
> > >> On Sun, 27 Apr 2008 00:10:21 +0200
> > >> hermann pitton <hermann-pitton@arcor.de> wrote:
> > >>> Cool stuff!
> > >>>
> > >>> Works immediately for all tuners again. Analog TV, radio and DVB-T =
on
> > >>> that machine is tested.
> > >>>
> > >>> Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> > >> Thanks. I'll add it to the patch.
> > >>
> > >>> Maybe Hartmut can help too, but I will test also on the triple stuf=
f
> and
> > >>> the FMD1216ME/I MK3 hybrid tomorrow.
> > >> Thanks.
> > >>
> > >> It would be helpful if tda9887 conf could also be validated. I didn'=
t
> touch at
> > >> the logic, but I saw some weird things:
> > >>
> > >> For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
> > >>    .tda9887_conf   =3D TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
> > >>
> > >> And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
> > >>
> > >> However, there's an autodetection code that changes from EUROPA to
> SNAKE,
> > >> without cleaning tda9887_conf:
> > >>
> > >>         case SAA7134_BOARD_PHILIPS_EUROPA:
> > >>                 if (dev->autodetected && (dev->eedata[0x41] =3D=3D 0=
x1c))
> {
> > >>                         /* Reconfigure board as Snake reference desi=
gn
> */
> > >>                         dev->board =3D SAA7134_BOARD_PHILIPS_SNAKE;
> > >>                         dev->tuner_type =3D
> saa7134_boards[dev->board].tuner_type;
> > >>                         printk(KERN_INFO "%s: Reconfigured board as
> %s\n",
> > >>                                 dev->name,
> saa7134_boards[dev->board].name);
> > >>                         break;
> > >>
> > >> I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if
> the above
> > >> code should be doing, instead:
> > >>
> > >>    dev->tda9887_conf =3D saa7134_boards[dev->board].tda9887_conf;
> > >>
> > >> If the right thing to do is to initialize SNAKE with the same tda988=
7
> > >> parameters as EUROPE, the better would be to add the .tda9887_conf t=
o
> SNAKE
> > >> entry.
> > >>
> > >> Cheers,
> > >> Mauro
> > >
> > > Hartmut has the board and knows better, but it looks like it only has
> > > DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
> > > analog tuner, no tda9887 and also no DVB-T, but it unfortunately shar=
es
> > > the subsystem with the Philips Europa.
> > >
> > Hermann is right, SNAKE has no analog tuner. These boards indeed share
> the same PCI ID,
> > This code fragment reads the tuner ID from the eeprom to find out which
> board is there.
> >
> > > I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> > > boards.
> > >
> > Aha! I modified my board that it no longer runs with the current driver=
.
> But i observed
> > something similar
> >
> > > Unchanged is that the tda9887 is not up for analog after boot.
> > > Previously one did reload "tuner" just once and was done.
> > >
> > <snip>
> > Don't have the time today, but lets roll back history: Not absolutely
> sure but if
> > i remember correcly, the initialization sequence can be critical with
> hybrid tuners /
> > NIM modules. The tda9887 may only be visible on I2C after a certain bit
> in the MOPLL
> > is set (in byte4?)
> >
> > Best regards
> >    Hartmut
>
> Hi Hartmut,
>
> I remember this exactly, getting older anyway, but you had no chance
> coming in with that on a quickly changing target, finally all of us shot
> down as a crowd of lamers, a cheap target for kernel masterminds,
> claiming we don't had anything in the right place ...
>
> Let them pay for it now :)
>
> Cheers,
> Hermann
>
>
>
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Andy Walls <awalls@radix.net>
> To: Xefur Ragnarok <x3fur@yahoo.com>
> Date: Sun, 27 Apr 2008 22:47:02 -0400
> Subject: Re: WinTV PVR PCI
> On Sun, 2008-04-27 at 09:04 -0700, Xefur Ragnarok wrote:
> > Hello,
> >
> > I have recently acquired a WinTV PVR PCI card. What is interesting abou=
t
> this card is that none of the drivers worked in either windows or linux. =
I
> believe the reason to be the following:
> >
> > excerpt from lspci:
> > 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> > 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
>
> Are you sure those aren't 109e:036e & 109e:0878 ?
>
> http://pci-ids.ucw.cz/iii/?i=3D109e036e
> http://pci-ids.ucw.cz/iii/?i=3D109e0878
>
> What are the subsystem id's (available via lspci -nv)?
>
> Once you know the subsystem id's, you can look at the lines in
> drivers/media/video/bt8xx/bttv-cards.c that look like this:
>
> { 0x13eb0070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV" },
> { 0x39000070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV-D" },
> { 0x45000070, BTTV_BOARD_HAUPPAUGEPVR,  "Hauppauge WinTV/PVR" },
> ...
> /* ---- card 0x50 ---------------------------------- */
>   [BTTV_BOARD_HAUPPAUGEPVR] =3D {
>        .name           =3D "Hauppauge WinTV PVR",
> ...
>
>
> and the card numbers listed in Documentation/video4linux/CARDLIST.bttv,
> and try to modprobe the bttv module specifying the card type:
>
> # modprobe -r bttv
> # modprobe bttv card=3D2 (or 10, or 80 =3D 0x50, or something else)
>
>
>
> > I'm positive that this is the card. However its' PCI Subsystem ID is
> unrecognised.
>
> What are the subsystem id's? (lspci -nv)
>
> > It has the BT878 Chipset, I'm not sure about the tuner but I know it is
> NTSC. I've tried manually following the directions on the bttv howto to n=
o
> avail. All of those instructions assume that you have a pci subsystem id =
of
> a card that should have been already detected.
> >
> > Other Info:
> >
> > mediacenter:/home/tim/Desktop/bttv-0.9.15 # lspci
> > 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
> Controller/Host-Hub Interface (rev 02)
> > 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller
> (rev 02)
> > 00:03.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to CSA Bridge (re=
v
> 02)
> > 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #1 (rev 02)
> > 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #2 (rev 02)
> > 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #3 (rev 02)
> > 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #4 (rev 02)
> > 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2
> EHCI Controller (rev 02)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> > 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
> Interface Bridge (rev 02)
> > 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02)
> > 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller
> (rev 02)
> > 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controll=
er
> (rev 02)
> > 00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER
> (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
> > 01:01.0 Multimedia audio controller: C-Media Electronics Inc CM8738 (re=
v
> 10)
> > 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
> > 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
> > 02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet
> Controller
> > 03:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeo=
n
> 9600]
> > 03:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> (Secondary)
> >
> >
> > mediacenter:/home/tim/Desktop/bttv-0.9.15 # lsmod |grep bt
> > bttv                  168980  0
> > i2c_algo_bit            9988  1 bttv
> > tveeprom               18960  1 bttv
> > i2c_core               27520  3 bttv,i2c_algo_bit,tveeprom
> > video_buf              27652  1 bttv
> > ir_common              38148  1 bttv
> > compat_ioctl32          5376  1 bttv
> > btcx_risc               8840  1 bttv
> > videodev               30464  1 bttv
> > v4l2_common            20608  2 bttv,videodev
> > v4l1_compat            16388  2 bttv,videodev
> > firmware_class         13568  2 bttv,microcode
>
> Did you modprobe these yourself, or did it happen automatically?  What
> was logged in dmesg when the module was probed?  What was logged
> in /var/log/messages?
>
> Earlier you stated the linux driver wasn't working.  What are the
> symptoms - what is not working?
>
> >
> > Any help would be appreciated
> > Timothy
>
> -Andy
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Brandon Philips <brandon@ifup.org>
> To: Laurent Pinchart <laurent.pinchart@skynet.be>
> Date: Mon, 28 Apr 2008 00:26:55 -0700
> Subject: [PATCH] v4l: Introduce "stream" attribute for persistent
> video4linux device nodes
> Disclaimer: I am not attached to the name, "stream".  Open to suggestion.
>
> Kees introduced a patch set last week that attempts to get stable device
> naming
> for v4l.  The set used a string attribute called function to allow udev t=
o
> assemble a unique and stable path for device nodes.
>
> This patch is similar.  However, instead of a string an integer is used
> called
> "stream".  If the driver calls video_register_device in the same order
> every
> time it is loaded then we can end up with something like this with the
> right
> udev rules[1]:
>
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video1
> /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video2
>
> # ls -la /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
> lrwxrwxrwx 1 root root 12 2008-04-28 00:02
> /dev/v4l/by-path/pci-0000:00:1d.2-usb-0:1:1.0-video0 -> ../../video1
>
> Kees: I don't have a device that creates multiple device nodes.  Please
> test with ivtv.  :D
>
> video_register_device_stream is available to drivers to request a specifi=
c
> stream number.
>
> Signed-off-by: Brandon Philips <bphilips@suse.de>
>
> ---
> [1] Place the attached udev rules in
> /etc/udev/rules.d/60-persistent-v4l.rules
>
>  linux/drivers/media/video/videodev.c |   96
> ++++++++++++++++++++++++++++++++++-
>  linux/include/media/v4l2-dev.h       |    4 +
>  2 files changed, 98 insertions(+), 2 deletions(-)
>
> Index: v4l-dvb-clean/linux/drivers/media/video/videodev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- v4l-dvb-clean.orig/linux/drivers/media/video/videodev.c
> +++ v4l-dvb-clean/linux/drivers/media/video/videodev.c
> @@ -428,6 +428,14 @@ EXPORT_SYMBOL(v4l_printk_ioctl);
>  *     sysfs stuff
>  */
>
> +static ssize_t show_stream(struct device *cd,
> +                        struct device_attribute *attr, char *buf)
> +{
> +       struct video_device *vfd =3D container_of(cd, struct video_device=
,
> +                                               class_dev);
> +       return sprintf(buf, "%i\n", vfd->stream);
> +}
> +
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
>  static ssize_t show_name(struct class_device *cd, char *buf)
>  #else
> @@ -486,6 +494,7 @@ static void video_release(struct device
>  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,13)
>  static struct device_attribute video_device_attrs[] =3D {
>        __ATTR(name, S_IRUGO, show_name, NULL),
> +       __ATTR(stream, S_IRUGO, show_stream, NULL),
>        __ATTR_NULL
>  };
>  #endif
> @@ -2013,8 +2022,81 @@ out:
>  }
>  EXPORT_SYMBOL(video_ioctl2);
>
> +struct stream_number_info {
> +       struct device *dev;
> +       unsigned int used[VIDEO_NUM_DEVICES];
> +};
> +
> +static int __fill_stream_number_info(struct device *cd, void *data)
> +{
> +       struct stream_number_info *info =3D data;
> +       struct video_device *vfd =3D container_of(cd, struct video_device=
,
> +                                               class_dev);
> +
> +       if (info->dev =3D=3D vfd->dev)
> +               info->used[vfd->stream] =3D 1;
> +
> +       return 0;
> +}
> +
> +/**
> + * assign_stream_number - assign stream number based on parent device
> + * @vdev: video_device to assign stream number to, vdev->dev should be
> assigned
> + * @num: -1 if auto assign, requested number otherwise
> + *
> + *
> + * returns -ENFILE if num is already in use, a free stream number if
> + * successful.
> + */
> +static int get_stream_number(struct video_device *vdev, int num)
> +{
> +       struct stream_number_info *info;
> +       int i;
> +       int ret =3D 0;
> +
> +       if (num >=3D VIDEO_NUM_DEVICES)
> +               return -EINVAL;
> +
> +       info =3D kzalloc(sizeof(*info), GFP_KERNEL);
> +       if (!info)
> +               return -ENOMEM;
> +
> +       info->dev =3D vdev->dev;
> +
> +       ret =3D class_for_each_device(&video_class, &info,
> +                                       __fill_stream_number_info);
> +
> +       if (ret < 0)
> +               goto out;
> +
> +       if (num >=3D 0) {
> +               if (!info->used[num])
> +                       ret =3D num;
> +               else
> +                       ret =3D -ENFILE;
> +
> +               goto out;
> +       }
> +
> +       for (i =3D 0; i < VIDEO_NUM_DEVICES; i++) {
> +               if (!info->used[i])
> +                       ret =3D i;
> +               goto out;
> +       }
> +
> +out:
> +       kfree(info);
> +       return ret;
> +}
> +
>  static const struct file_operations video_fops;
>
> +int video_register_device(struct video_device *vfd, int type, int nr)
> +{
> +       return video_register_device_stream(vfd, type, nr, -1);
> +}
> +EXPORT_SYMBOL(video_register_device);
> +
>  /**
>  *     video_register_device - register video4linux devices
>  *     @vfd:  video device structure we want to register
> @@ -2040,7 +2122,8 @@ static const struct file_operations vide
>  *     %VFL_TYPE_RADIO - A radio card
>  */
>
> -int video_register_device(struct video_device *vfd, int type, int nr)
> +int video_register_device_stream(struct video_device *vfd, int type, int
> nr,
> +                                       int stream)
>  {
>        int i=3D0;
>        int base;
> @@ -2143,6 +2226,15 @@ int video_register_device(struct video_d
>        }
>  #endif
>
> +       ret =3D get_stream_number(vfd, stream);
> +       if (ret < 0) {
> +               printk(KERN_ERR "%s: get_stream_number failed\n",
> +                      __func__);
> +               goto fail_minor;
> +       }
> +
> +       vfd->stream =3D ret;
> +
>  #if 1 /* keep */
>        /* needed until all drivers are fixed */
>        if (!vfd->release)
> @@ -2159,7 +2251,7 @@ fail_minor:
>        mutex_unlock(&videodev_lock);
>        return ret;
>  }
> -EXPORT_SYMBOL(video_register_device);
> +EXPORT_SYMBOL(video_register_device_stream);
>
>  /**
>  *     video_unregister_device - unregister a video4linux device
> Index: v4l-dvb-clean/linux/include/media/v4l2-dev.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- v4l-dvb-clean.orig/linux/include/media/v4l2-dev.h
> +++ v4l-dvb-clean/linux/include/media/v4l2-dev.h
> @@ -113,6 +113,8 @@ struct video_device
>        int type;       /* v4l1 */
>        int type2;      /* v4l2 */
>        int minor;
> +       /* attribute to diferentiate multiple streams on one physical
> device */
> +       int stream;
>
>        int debug;      /* Activates debug level*/
>
> @@ -373,6 +375,8 @@ void *priv;
>
>  /* Version 2 functions */
>  extern int video_register_device(struct video_device *vfd, int type, int
> nr);
> +int video_register_device_stream(struct video_device *vfd, int type, int
> nr,
> +                                       int stream);
>  void video_unregister_device(struct video_device *);
>  extern int video_ioctl2(struct inode *inode, struct file *file,
>                          unsigned int cmd, unsigned long arg);
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> To: hermann pitton <hermann-pitton@arcor.de>
> Date: Mon, 28 Apr 2008 11:14:31 -0300
> Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
> On Sun, 27 Apr 2008 22:15:22 +0200
> hermann pitton <hermann-pitton@arcor.de> wrote:
>
> > Hi,
> >
> > Am Samstag, den 26.04.2008, 20:19 -0300 schrieb Mauro Carvalho Chehab:
> > > On Sun, 27 Apr 2008 00:10:21 +0200
> > > hermann pitton <hermann-pitton@arcor.de> wrote:
> > > > Cool stuff!
> > > >
> > > > Works immediately for all tuners again. Analog TV, radio and DVB-T =
on
> > > > that machine is tested.
> > > >
> > > > Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>
> > >
> > > Thanks. I'll add it to the patch.
> > >
> > > > Maybe Hartmut can help too, but I will test also on the triple stuf=
f
> and
> > > > the FMD1216ME/I MK3 hybrid tomorrow.
> > >
> > > Thanks.
> > >
> > > It would be helpful if tda9887 conf could also be validated. I didn't
> touch at
> > > the logic, but I saw some weird things:
> > >
> > > For example, SAA7134_BOARD_PHILIPS_EUROPA defines this:
> > >     .tda9887_conf   =3D TDA9887_PRESENT | TDA9887_PORT1_ACTIVE
> > >
> > > And SAA7134_BOARD_PHILIPS_SNAKE keep the default values.
> > >
> > > However, there's an autodetection code that changes from EUROPA to
> SNAKE,
> > > without cleaning tda9887_conf:
> > >
> > >         case SAA7134_BOARD_PHILIPS_EUROPA:
> > >                 if (dev->autodetected && (dev->eedata[0x41] =3D=3D 0x=
1c)) {
> > >                         /* Reconfigure board as Snake reference desig=
n
> */
> > >                         dev->board =3D SAA7134_BOARD_PHILIPS_SNAKE;
> > >                         dev->tuner_type =3D
> saa7134_boards[dev->board].tuner_type;
> > >                         printk(KERN_INFO "%s: Reconfigured board as
> %s\n",
> > >                                 dev->name,
> saa7134_boards[dev->board].name);
> > >                         break;
> > >
> > > I'm not sure if .tda9887_conf is missing at SNAKE board entry, or if
> the above
> > > code should be doing, instead:
> > >
> > >     dev->tda9887_conf =3D saa7134_boards[dev->board].tda9887_conf;
> > >
> > > If the right thing to do is to initialize SNAKE with the same tda9887
> > > parameters as EUROPE, the better would be to add the .tda9887_conf to
> SNAKE
> > > entry.
> > >
> > > Cheers,
> > > Mauro
> >
> > Hartmut has the board and knows better, but it looks like it only has
> > DVB-S and external analog video inputs. There is TUNER_ABSENT set, no
> > analog tuner, no tda9887 and also no DVB-T, but it unfortunately shares
> > the subsystem with the Philips Europa.
>
> In this case, it would be better to do:
>        dev->tda9887_conf =3D saa7134_boards[dev->board].tda9887_conf;
>
> for SNAKE. This won't produce any effect, but will avoid the overhead of
> sending tda9887 config commands for a device that doesn't have it.
>
> Later, maybe we can just move the above to the setup tuner subroutine.
>
> > I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> > boards.
> >
> > Unchanged is that the tda9887 is not up for analog after boot.
> > Previously one did reload "tuner" just once and was done.
>
> We need to fix this. The previous "hacks" like this now stops working.
>
> Cheers,
> Mauro
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
> Date: Mon, 28 Apr 2008 16:23:00 +0200 (CEST)
> Subject: Re: pxa_camera with one buffer don't work
> On Fri, 25 Apr 2008, Stefan Herbrechtsmeier wrote:
>
> > Hi,
> >
> > is it normal, that the pxa_camera driver don`t work with one buffer?. T=
he
> > DQBUF blocks if only one buffer is in the query.
>
> Well, in v4l2-apps/test/capture_example.c we see:
>
>        if (req.count < 2) {
>                fprintf (stderr, "Insufficient buffer memory on %s\n",
>                         dev_name);
>                exit (EXIT_FAILURE);
>        }
>
> so, they seem to refuse to run with fewer than 2 buffers. But if I remove
> this restriction and enforce 1 buffer, it works. 2.5 times slower, but
> works. Can there be a problem with your application? What kernel sources
> are you using? Try using the latest v4l-dvb/devel git.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
> Date: Mon, 28 Apr 2008 11:21:50 -0300
> Subject: Re: [linux-dvb] Hauppauge WinTV regreession from 2.6.24 to 2.6.2=
5
> > > I notice some unwanted behavior when testing md7134 FMD1216ME hybrid
> > > boards.
> > >
> > Aha! I modified my board that it no longer runs with the current driver=
.
> But i observed
> > something similar
> >
> > > Unchanged is that the tda9887 is not up for analog after boot.
> > > Previously one did reload "tuner" just once and was done.
> > >
> > <snip>
> > Don't have the time today, but lets roll back history: Not absolutely
> sure but if
> > i remember correcly, the initialization sequence can be critical with
> hybrid tuners /
> > NIM modules. The tda9887 may only be visible on I2C after a certain bit
> in the MOPLL
> > is set (in byte4?)
>
> If this is the case, we need to initialize the bit at init1, otherwise,
> this won't work.
>
> Another option is to migrate saa7134 to the newer i2c probing methods, an=
d
> let
> tuner be probed after init2.
>
> Cheers,
> Mauro
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Vicent Jord=E0 <vjorda@hotmail.com>
> To: <video4linux-list@redhat.com>
> Date: Mon, 28 Apr 2008 14:40:24 +0000
> Subject: Trying to set up a NPG Real DVB-T PCI Card
>
> Hi,
>
> I'm trying to set up a NPG Real DVB-T PCI Card.
>
> I've loaded the v4l drivers and it seems to load correctly.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Apr 28 13:43:51 rud kernel: [   61.822127] cx88[0]: subsystem: 14f1:8852,
> board: Geniatech X8000-MT DVBT [card=3D63,autodetected]
> Apr 28 13:43:51 rud kernel: [   61.822132] cx88[0]: TV tuner type 71, Rad=
io
> tuner type 0
> Apr 28 13:43:51 rud kernel: [   62.141235] tuner' 0-0061: chip found @ 0x=
c2
> (cx88[0])
> Apr 28 13:43:51 rud kernel: [   62.177668] xc2028 0-0061: type set to
> XCeive xc2028/xc3028 tuner
> Apr 28 13:43:51 rud kernel: [   62.177674] cx88[0]: Asking xc2028/3028 to
> load firmware xc3028-v27.fw
> Apr 28 13:43:51 rud kernel: [   62.177697] cx88[0]/0: found at
> 0000:00:08.0, rev: 5, irq: 20, latency: 32, mmio: 0xdc000000
> Apr 28 13:43:51 rud kernel: [   62.177806] cx88[0]/0: registered device
> video0 [v4l2]
> Apr 28 13:43:51 rud kernel: [   62.177851] cx88[0]/0: registered device
> vbi0
> Apr 28 13:43:51 rud kernel: [   62.177942] cx88[0]/0: registered device
> radio0
> Apr 28 13:43:51 rud kernel: [   62.217543] xc2028 0-0061: Loading 80
> firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> Apr 28 13:43:51 rud kernel: [   62.217851] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:51 rud kernel: [   62.416199] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE MTS (5), id 0000000000000000.
> Apr 28 13:43:51 rud kernel: [   62.416206] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:51 rud kernel: [   63.586138] xc2028 0-0061: Loading firmwar=
e
> for type=3DMTS (4), id 000000000000b700.
> Apr 28 13:43:51 rud kernel: [   63.602221] xc2028 0-0061: Loading SCODE f=
or
> type=3DMTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000=
b700.
> Apr 28 13:43:51 rud kernel: [   63.687790] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:51 rud kernel: [   63.886136] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE MTS (5), id 0000000000000000.
> Apr 28 13:43:51 rud kernel: [   63.886142] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:51 rud kernel: [   65.052053] xc2028 0-0061: Loading firmwar=
e
> for type=3DMTS (4), id 000000000000b700.
> Apr 28 13:43:51 rud kernel: [   65.068115] xc2028 0-0061: Loading SCODE f=
or
> type=3DMTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000=
b700.
> Apr 28 13:43:51 rud kernel: [   65.129754] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:51 rud kernel: [   65.249972] cx88[0]/2: cx2388x 8802 Driver
> Manager
> Apr 28 13:43:51 rud kernel: [   65.250000] ACPI: PCI Interrupt
> 0000:00:08.2[A] -> GSI 18 (level, low) -> IRQ 20
> Apr 28 13:43:51 rud kernel: [   65.250011] cx88[0]/2: found at
> 0000:00:08.2, rev: 5, irq: 20, latency: 32, mmio: 0xde000000
> Apr 28 13:43:51 rud kernel: [   65.251049] ACPI: PCI Interrupt
> 0000:00:07.0[A] -> GSI 19 (level, low) -> IRQ 21
> Apr 28 13:43:51 rud kernel: [   65.416289] cx88/2: cx2388x dvb driver
> version 0.0.6 loaded
> Apr 28 13:43:51 rud kernel: [   65.416298] cx88/2: registering cx8802
> driver, type: dvb access: shared
> Apr 28 13:43:51 rud kernel: [   65.416304] cx88[0]/2: subsystem: 14f1:885=
2,
> board: Geniatech X8000-MT DVBT [card=3D63]
> Apr 28 13:43:51 rud kernel: [   65.416309] cx88[0]/2: cx2388x based
> DVB/ATSC card
> Apr 28 13:43:51 rud kernel: [   65.521832] xc2028 0-0061: type set to
> XCeive xc2028/xc3028 tuner
> Apr 28 13:43:51 rud kernel: [   65.521840] cx88[0]/2: xc3028 attached
> Apr 28 13:43:51 rud kernel: [   65.522538] DVB: registering new adapter
> (cx88[0])
> Apr 28 13:43:51 rud kernel: [   65.522543] DVB: registering frontend 0
> (Zarlink ZL10353 DVB-T)...
> Apr 28 13:43:51 rud kernel: [   67.345027] lp0: using parport0
> (interrupt-driven).
> Apr 28 13:43:51 rud kernel: [   67.460431] Adding 2562328k swap on
> /dev/sda7.  Priority:-1 extents:1 across:2562328k
> Apr 28 13:43:51 rud kernel: [   68.046049] EXT3 FS on sda6, internal
> journal
> Apr 28 13:43:51 rud kernel: [   70.437815] ip_tables: (C) 2000-2006
> Netfilter Core Team
> Apr 28 13:43:51 rud kernel: [   72.972373] No dock devices found.
> Apr 28 13:43:52 rud kernel: [   75.398690] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:52 rud kernel: [   75.597047] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE FM (401), id 0000000000000000.
> Apr 28 13:43:52 rud kernel: [   75.597055] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:53 rud kernel: [   76.755517] xc2028 0-0061: Loading firmwar=
e
> for type=3DFM (400), id 0000000000000000.
> Apr 28 13:43:54 rud kernel: [   76.825247] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:54 rud kernel: [   77.023592] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE FM (401), id 0000000000000000.
> Apr 28 13:43:54 rud kernel: [   77.023598] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:55 rud kernel: [   78.185507] xc2028 0-0061: Loading firmwar=
e
> for type=3DFM (400), id 0000000000000000.
> Apr 28 13:43:55 rud kernel: [   78.231269] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:43:58 rud kernel: [   81.554905] eth0: link up, 100Mbps,
> full-duplex, lpa 0x45E1
> Apr 28 13:43:58 rud kernel: [   81.626484] wlan0: changing radio power
> level to 18 dBm (23)
> Apr 28 13:44:01 rud kernel: [   84.551782] ppdev: user-space parallel por=
t
> driver
> Apr 28 13:44:01 rud kernel: [   85.142864] audit(1209383041.971:2):
> type=3D1503 operation=3D"inode_permission" requested_mask=3D"a::"
> denied_mask=3D"a::" name=3D"/dev/tty" pid=3D5530 profile=3D"/usr/sbin/cup=
sd"
> namespace=3D"default"
> Apr 28 13:44:02 rud kernel: [   85.291620] apm: BIOS version 1.2 Flags 0x=
03
> (Driver version 1.16ac)
> Apr 28 13:44:02 rud kernel: [   85.291629] apm: overridden by ACPI.
> Apr 28 13:44:02 rud kernel: [   85.545130] RPC: Registered udp transport
> module.
> Apr 28 13:44:02 rud kernel: [   85.545139] RPC: Registered tcp transport
> module.
> Apr 28 13:44:02 rud kernel: [   85.615108] Installing knfsd (copyright (C=
)
> 1996 okir@monad.swb.de).
> Apr 28 13:44:02 rud kernel: [   85.754526] NFSD: Using
> /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> Apr 28 13:44:02 rud kernel: [   85.763190] NFSD: starting 90-second grace
> period
> Apr 28 13:51:25 rud kernel: [  527.312442] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:25 rud kernel: [  527.510799] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE F8MHZ MTS (7), id 0000000000000000.
> Apr 28 13:51:25 rud kernel: [  527.510807] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:26 rud kernel: [  528.707901] MTS (4), id 00000000000000f7:
> Apr 28 13:51:26 rud kernel: [  528.707916] xc2028 0-0061: Loading firmwar=
e
> for type=3DMTS (4), id 0000000100000007.
> Apr 28 13:51:26 rud kernel: [  528.781628] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:26 rud kernel: [  528.979980] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE F8MHZ MTS (7), id 0000000000000000.
> Apr 28 13:51:26 rud kernel: [  528.979988] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:27 rud kernel: [  530.162012] MTS (4), id 00000000000000f7:
> Apr 28 13:51:27 rud kernel: [  530.162028] xc2028 0-0061: Loading firmwar=
e
> for type=3DMTS (4), id 0000000100000007.
> Apr 28 13:51:28 rud kernel: [  530.483974] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:28 rud kernel: [  530.682332] xc2028 0-0061: Loading firmwar=
e
> for type=3DBASE F8MHZ MTS (7), id 0000000000000000.
> Apr 28 13:51:28 rud kernel: [  530.682339] cx88[0]: Calling XC2028/3028
> callback
> Apr 28 13:51:29 rud kernel: [  531.887588] MTS (4), id 00000000000000f7:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> But when I try to scan for channels this error appears in dmesg:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> [ 1581.454350] xc2028 0-0061: Loading firmware for type=3DBASE F8MHZ MTS =
(7),
> id 0000000000000000.
> [ 1581.454358] cx88[0]: Calling XC2028/3028 callback
> [ 1583.451836] MTS (4), id 00000000000000f7:
> [ 1583.451853] xc2028 0-0061: Loading firmware for type=3DMTS (4), id
> 0000000100000007.
> [ 1583.499889] xc2028 0-0061: Incorrect readback of firmware version.
> [ 1583.915649] cx88[0]: Calling XC2028/3028 callback
> [ 1584.114007] xc2028 0-0061: Loading firmware for type=3DBASE F8MHZ MTS =
(7),
> id 0000000000000000.
> [ 1584.114015] cx88[0]: Calling XC2028/3028 callback
> [ 1585.668643] MTS (4), id 00000000000000f7:
> [ 1585.668659] xc2028 0-0061: Loading firmware for type=3DMTS (4), id
> 0000000100000007.
> [ 1585.687679] xc2028 0-0061: Incorrect readback of firmware version.
> [ 1585.741662] cx88[0]: Calling XC2028/3028 callback
> [ 1585.940019] xc2028 0-0061: Loading firmware for type=3DBASE F8MHZ MTS =
(7),
> id 0000000000000000.
> [ 1585.940027] cx88[0]: Calling XC2028/3028 callback
> [ 1587.165797] MTS (4), id 00000000000000f7:
> [ 1587.165812] xc2028 0-0061: Loading firmware for type=3DMTS (4), id
> 0000000100000007.
> [ 1587.183960] xc2028 0-0061: Incorrect readback of firmware version.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> What can I do to workaroud this problem?
>
> Thanks,
> Vicent
>
>
> _________________________________________________________________
> Tecnolog=EDa, moda, motor, viajes,=85suscr=EDbete a nuestros boletines pa=
ra estar
> siempre a la =FAltima
> Guapos y guapas, clips musicales y estrenos de cine.
>
>
>
>
> ---------- Message transf=E9r=E9 ----------
> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> To: Vicent Jord=E0 <vjorda@hotmail.com>
> Date: Mon, 28 Apr 2008 11:47:41 -0300
> Subject: Re: Trying to set up a NPG Real DVB-T PCI Card
> On Mon, 28 Apr 2008 14:40:24 +0000
> Vicent Jord=E0 <vjorda@hotmail.com> wrote:
>
> >
> > Hi,
> >
> > I'm trying to set up a NPG Real DVB-T PCI Card.
> >
> > [ 1587.165812] xc2028 0-0061: Loading firmware for type=3DMTS (4), id
> 0000000100000007.
> > [ 1587.183960] xc2028 0-0061: Incorrect readback of firmware version.
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >
> > What can I do to workaroud this problem?
>
> Are you sure you're using the correct firmware?
>
> This kind of error could happen on a few cases:
>        1) Firmware is not version 2.7;
>        2) tuner-callback is sending a wrong reset. Xc3028 needs to receiv=
e
> a reset, gia a GPIO pin, for firmware to load. If you don't send a reset,
> firmware won't load;
>        3) On some devices, you need to slow down firmware sending.
>
> If your firmware is correct, I guess your problem is (2). The better is t=
o
> use regspy.exe (provided together with DCALER) and see what gpio changes
> during firmware load.
>
> Cheers,
> Mauro
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscr=
ibe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
