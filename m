Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4U76esC004256
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 03:06:40 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4U76NNs025279
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 03:06:23 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3196128wfc.6
	for <video4linux-list@redhat.com>; Fri, 30 May 2008 00:06:22 -0700 (PDT)
Message-ID: <f04a557a0805300006w6925aa1rd90eedcb4b0a4038@mail.gmail.com>
Date: Sat, 31 May 2008 02:36:22 +1930
From: "Cesar Arguinzones" <ceap80@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Encore ENLTV-FM Remote Control Problem
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

Please, forgive me if this is the wrong list to post and for my english.

Hi, I have an ENCORE ENLTV-FM card, it's almost fully working, i can view
tv and listen to radio but i have to use card=3 not card=107, because then
i got no sound, well to be fair there is sound when i use card=107 but
barely audible.

The only problem is the remote, it's not working...
And in this times a tv without a remote is like having nothing ;-)

The chip in the card says: saa7130hl

I know the card (and remote) is working, I've tested it in windows,
besides, in ubuntu 8.04,
if a press ANY button in the remote, the exit session dialog shows
up(funny,because
it pop ups 30+ times!!!, even if i don't have lirc installed, some
help needed here too.)

Update: the last thing doesn't happen if i use card=107

I think (according to this page:
http://www.linuxtv.org/v4lwiki/index.php/Remote_controllers)
that I might have a combined GPIO remote, is the same behavior, only
different numbers.

I'm willing to try to correct this issue, i even tried a *port* from a patch by
Henry Wong (http://www.mythtv.org/wiki/index.php/KWorld_Global_TV_Terminator),
but i just
get a segfault ;-)

So I need some pointers and advices about how to proceed

When a tried to make a config file for my remote, irrecord assigns the
same code to all buttons.
I must say, in case it matters, I'm from Venezuela (sorry for my English)


Generated file by irrecord:

begin remote

  name  my_remote_conf
  bits            0
  eps            30
  aeps          100

  one             0     0
  zero            0     0
  pre_data_bits   32
  pre_data       0x80010074
  gap          102761
  toggle_bit_mask 0x80010074

      begin codes
          uno                      0x0
          dos                      0x0
          tres                     0x0
      end codes

end remote

I'm running Ubuntu 8.04, but the same problem occurred in 7.10
I tried compiling v4l from sources, but that not resolved the remote
control issue

If you need me to do anything that can help, just name it.


Some console output:

uname -r

2.6.24-17-generic


lspci -vvv

01:00.0 Multimedia controller: Philips Semiconductors SAA7130 Video
Broadcast Decoder (rev 01)
	Subsystem: Unknown device 1a7f:2008
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at ff0ffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-



cat /proc/bus/input/devices (i'm using card=3)

I: Bus=0001 Vendor=1a7f Product=2008 Version=0001
N: Name="saa7134 IR (LifeView/Typhoon Fl"
P: Phys=pci-0000:01:00.0/ir0
S: Sysfs=/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/input/input10
U: Uniq=
H: Handlers=kbd event6
B: EV=100003
B: KEY=c0304 310000 0 0 0 0 0 0 2 1e0000 0 0 10000ffc

dmesg (generated after modprobe saa7134 card=3 tuner=69 i2c_scan=1 ir_debug=1)

[ 8399.699367] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 8399.699431] saa7130[0]: found at 0000:01:00.0, rev: 1, irq: 21,
latency: 32, mmio: 0xff0ffc00
[ 8399.699439] saa7130[0]: subsystem: 1a7f:2008, board:
LifeView/Typhoon FlyVIDEO2000 [card=3,insmod option]
[ 8399.699464] saa7130[0]: board init: gpio is 59000
[ 8399.699466] saa7130[0]: there are different flyvideo cards with
different tuners
[ 8399.699468] saa7130[0]: out there, you might have to use the
tuner=<nr> insmod
[ 8399.699469] saa7130[0]: option to override the default value.
[ 8399.699553] input: saa7134 IR (LifeView/Typhoon Fl as
/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/input/input11
[ 8399.851497] All bytes are equal. It is not a TEA5767
[ 8399.851504] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
[ 8399.851540] tuner-simple 0-0060: type set to 69 (Tena TNF 5335 and
similar models)
[ 8399.851544] tuner 0-0060: type set to Tena TNF 5335 and s
[ 8399.851548] tuner-simple 0-0060: type set to 69 (Tena TNF 5335 and
similar models)
[ 8399.851551] tuner 0-0060: type set to Tena TNF 5335 and s
[ 8399.859442] tuner 0-0061: chip found @ 0xc2 (saa7130[0])
[ 8399.891378] saa7130[0]: i2c eeprom 00: 7f 1a 08 20 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[ 8399.891392] saa7130[0]: i2c eeprom 10: 00 df 86 0f ff 20 ff ff ff
ff ff ff ff ff ff ff
[ 8399.891407] saa7130[0]: i2c eeprom 20: 01 40 01 02 02 ff 01 03 08
ff 00 8f ff ff ff ff
[ 8399.891423] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 8399.891439] saa7130[0]: i2c eeprom 40: ff 87 00 c2 96 10 03 32 15
08 ff ff ff ff ff ff
[ 8399.891455] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff 41 84
ff 31 30 4d 4f 4f 4e
[ 8399.891474] saa7130[0]: i2c eeprom 60: 53 50 44 41 31 30 30 ff 41
ff ff ff ff ff ff ff
[ 8399.891490] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 8399.911356] saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
[ 8399.919371] saa7130[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
[ 8399.928327] saa7130[0]: i2c scan: found device @ 0xc2  [???]
[ 8399.957598] saa7130[0]: registered device video0 [v4l2]
[ 8399.957624] saa7130[0]: registered device vbi0
[ 8399.957646] saa7130[0]: registered device radio0
[ 8399.978564] saa7134 ALSA driver for DMA sound loaded
[ 8399.978596] saa7130[0]/alsa: saa7130[0] at 0xff0ffc00 irq 21
registered as card -2


dmesg for ir_debug=1 (using card=3)

[ 8585.128155] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.133212] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.134363] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.135498] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.136574] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.137735] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
[ 8585.138866] saa7130[0]/ir: build_key gpio=0x59000 mask=0xec00000 data=0
.....

dmesg for ir_debug=1 (using card=107)

[ 8683.614407] saa7130[0]/ir: build_key gpio=0x57000 mask=0x7f data=0
[ 8686.574464] saa7130[0]/ir: build_key gpio=0x17000 mask=0x7f data=0
[ 8686.626395] saa7130[0]/ir: build_key gpio=0x57000 mask=0x7f data=0
[ 8686.678323] saa7130[0]/ir: build_key gpio=0x17000 mask=0x7f data=0
[ 8686.729256] saa7130[0]/ir: build_key gpio=0x57000 mask=0x7f data=0
[ 8686.782185] saa7130[0]/ir: build_key gpio=0x17000 mask=0x7f data=0
[ 8686.833120] saa7130[0]/ir: build_key gpio=0x57000 mask=0x7f data=0
....


Any help is greatly appreciated!



-- 
Cesar Arguinzones

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
