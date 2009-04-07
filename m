Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web27504.mail.ukl.yahoo.com ([217.146.177.208])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <amerini_a@yahoo.it>) id 1LrILh-0003fO-TD
	for linux-dvb@linuxtv.org; Tue, 07 Apr 2009 22:56:50 +0200
Message-ID: <903855.55290.qm@web27504.mail.ukl.yahoo.com>
Date: Tue, 7 Apr 2009 20:56:12 +0000 (GMT)
From: Andrea Amerini <amerini_a@yahoo.it>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Remote Pinnacle 310i PCTV hybrid Pro pci
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Hi,
I'm using this Pinnacle board but the remote doesn't work at all (RC-42D the coloured one).

I'm using Slackware 12.1 ,kernel 2.6.28.5 vanilla

When I press a key on the remote I read these messages on syslog:


saa7133[0]: i2c xfer: < 8f =d1 =6d =7d =59 >
saa7133[0]: i2c xfer: < 8f =17 =1d =fe =fd >
saa7133[0]: i2c xfer: < 8f =e3 =5c =d5 =4a >
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f =db =42 =01 =b7 >


Pinnacle PCTV/ir: Pinnacle PCTV key 23
Pinnacle PCTV/ir: read error
Pinnacle PCTV/ir: read error
Pinnacle PCTV/ir: read error
Pinnacle PCTV/ir: read error
root@mediacenter:~#


here it is the info of the card:

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:03:05.0, rev: 209, irq: 20, latency: 64, mmio: 0xfdfff000
saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 310i [card=101,autodetected]
saa7133[0]: board init: gpio is 600c000
tuner' 5-004b: chip found @ 0x96 (saa7133[0])
ir-kbd-i2c: Pinnacle PCTV detected at i2c-5/5-0047/ir0 [saa7133[0]]
saa7133[0]: i2c eeprom 00: bd 11 2f 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff e0 60 06 ff 20 ff ff 00 30 8d 2e 15 13 ff ff
saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e7 ff 21 00 c2
saa7133[0]: i2c eeprom 30: 96 10 03 32 15 20 ff 15 0e 6c a3 eb 03 c5 e8 9d
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x10  [???]
saa7133[0]: i2c scan: found device @ 0x8e  [???]
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: registered device video1 [v4l2]
saa7133[0]: registered device vbi1
saa7133[0]: registered device radio0
DVB: registering new adapter (saa7133[0])
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfdfff000 irq 20 registered as card -1


lspci -vv:

03:05.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
        Subsystem: Pinnacle Systems Inc. Unknown device 002f
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (21000ns min, 8000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134

lsmod:

Module                  Size  Used by
saa7134_alsa           11136  0
saa7134_dvb            20044  0
saa7134               140628  2 saa7134_alsa,saa7134_dvb
tda1004x               15556  1
ir_kbd_i2c              7312  0
tda827x                 9732  2
tda8290                12740  1
cpufreq_userspace       3012  1
it87                   19984  0
hwmon_vid               2880  1 it87
eeprom                  5520  0
snd_seq_dummy           2756  0
snd_seq_oss            28992  0
snd_seq_midi_event      6144  1 snd_seq_oss
snd_seq                46576  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          6348  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            36640  0
snd_mixer_oss          14016  1 snd_pcm_oss
cx8800                 29316  0
cx88xx                 67240  1 cx8800
videobuf_dvb            6276  2 saa7134_dvb,cx88xx
dvb_core               77120  2 saa7134_dvb,videobuf_dvb
bttv                  161300  0
btcx_risc               4360  3 cx8800,cx88xx,bttv
lirc_i2c                8644  1
powernow_k8            13124  1
lp                      9732  0
pcspkr                  2432  0
psmouse                40528  0
lirc_imon              15240  2
lirc_dev               11380  2 lirc_i2c,lirc_imon
fuse                   50332  1
joydev                  9344  0
usbhid                 31776  0
zd1211rw               44292  0
mac80211              126736  1 zd1211rw
tuner_simple           14288  1
tuner_types            14080  1 tuner_simple
wm8775                  5612  0
cx25840                27184  0
tuner                  26116  0
evdev                   9312  7
ivtv                  137540  0
snd_hda_intel         400468  0
cx2341x                11460  1 ivtv
ir_common              38468  4 saa7134,ir_kbd_i2c,cx88xx,bttv
compat_ioctl32          1152  4 saa7134,cx8800,bttv,ivtv
v4l2_common            10816  8 saa7134,cx8800,bttv,wm8775,cx25840,tuner,ivtv,cx2341x
videodev               31488  6 saa7134,cx8800,cx88xx,bttv,tuner,ivtv
videobuf_dma_sg        10820  6 saa7134_alsa,saa7134_dvb,saa7134,cx8800,cx88xx,bttv
fan                     4292  0
v4l1_compat            13124  1 videodev
nvidia               7230492  32
videobuf_core          15172  6 saa7134,cx8800,cx88xx,videobuf_dvb,bttv,videobuf_dma_sg
tveeprom               11908  4 saa7134,cx88xx,bttv,ivtv
snd_pcm                66948  3 saa7134_alsa,snd_pcm_oss,snd_hda_intel
thermal                15260  0
ehci_hcd               33612  0
processor              39148  2 powernow_k8,thermal
snd_timer              18952  2 snd_seq,snd_pcm
button                  5968  0
ohci_hcd               24208  0
snd_page_alloc          8072  2 snd_hda_intel,snd_pcm
serio_raw               5188  0
i2c_piix4               9168  0
snd_hwdep               6852  1 snd_hda_intel
r8169                  32068  0
k8temp                  4160  0
ati_agp                 6796  0
hwmon                   2396  2 it87,k8temp
snd 
                  46436  10
saa7134_alsa,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep
usbcore               132176  7 lirc_imon,usbhid,zd1211rw,ehci_hcd,ohci_hcd
agpgart                29064  2 nvidia,ati_agp
sr_mod                 14660  1
mii                     4544  1 r8169
cdrom                  33312  1 sr_mod
rtc_cmos               10284  0
rtc_core               15388  1 rtc_cmos
soundcore               6112  1 snd
rtc_lib                 2496  1 rtc_core
ssb                    29508  1 ohci_hcd
parport_pc             24484  1
parport                30764  2 lp,parport_pc
sg                     24372  0


I've tried also last mercurial of 6th April,but with the same results

If you need any other kind of info I'll be happy to help you.
Thanks.


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
