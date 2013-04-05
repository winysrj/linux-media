Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765893Ab3DELqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Apr 2013 07:46:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 7F4861B971B00
	for <linux-media@vger.kernel.org>; Fri,  5 Apr 2013 13:46:06 +0200 (CEST)
Received: from tyrex.lisa.loc ([127.0.0.1])
	by localhost (tyrex.lisa.loc [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JmG7PTk7XOhg for <linux-media@vger.kernel.org>;
	Fri,  5 Apr 2013 13:46:00 +0200 (CEST)
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-media@vger.kernel.org
Subject: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot tune in others
Date: Fri, 05 Apr 2013 13:46 +0200
Message-ID: <1463242.ms8FUp7FVg@xrated>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Sorry for sending non wrapped lines here from system output, but that's the 
 only way I know to present this kind of information in a sensible way]

Hi,

I'm suffering from a strange problem here. In one of my systems, I've used a 
Hauppauge Nova-S-Plus DVB-S card successfully, but after a system upgrade to 
openSUSE 12.2, it cannot tune in all but one channel. While I like this one 
left very much (arte), it would be really nice to be able to tune in others 
as well.

The drivers load fine:

Apr  4 23:44:35 xrated kernel: [    5.829780] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
Apr  4 23:44:35 xrated kernel: [    5.834257] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
Apr  4 23:44:35 xrated kernel: [    5.845217] cx2388x alsa driver version 0.0.9 loaded
Apr  4 23:44:35 xrated kernel: [    5.883115] cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37,autodetected], frontend(s): 1
Apr  4 23:44:35 xrated kernel: [    5.883118] cx88[0]: TV tuner type 4, Radio tuner type -1
Apr  4 23:44:35 xrated kernel: [    6.037313] tveeprom 1-0050: Hauppauge model 92001, rev C1B1, serial# 1594431
Apr  4 23:44:35 xrated kernel: [    6.037316] tveeprom 1-0050: MAC address is 00:0d:fe:18:54:3f
Apr  4 23:44:35 xrated kernel: [    6.037321] tveeprom 1-0050: tuner model is Conexant_CX24109 (idx 111, type 4)
Apr  4 23:44:35 xrated kernel: [    6.037322] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
Apr  4 23:44:35 xrated kernel: [    6.037324] tveeprom 1-0050: audio processor is CX883 (idx 32)
Apr  4 23:44:35 xrated kernel: [    6.037325] tveeprom 1-0050: decoder processor is CX883 (idx 22)
Apr  4 23:44:35 xrated kernel: [    6.037326] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
Apr  4 23:44:35 xrated kernel: [    6.037328] cx88[0]: hauppauge eeprom: model=92001
Apr  4 23:44:35 xrated kernel: [    6.063366] Registered IR keymap rc-hauppauge
Apr  4 23:44:35 xrated kernel: [    6.063515] input: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:1e.0/0000:0b:01.2/rc/rc0/input14
Apr  4 23:44:35 xrated kernel: [    6.063624] rc0: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:1e.0/0000:0b:01.2/rc/rc0
Apr  4 23:44:35 xrated kernel: [    6.063724] cx88[0]/2: cx2388x 8802 Driver Manager
Apr  4 23:44:35 xrated kernel: [    6.063747] cx88[0]/2: found at 0000:0b:01.2, rev: 5, irq: 16, latency: 64, mmio: 0xf6000000
Apr  4 23:44:35 xrated kernel: [    6.063870] cx88[0]/0: found at 0000:0b:01.0, rev: 5, irq: 16, latency: 64, mmio: 0xf4000000
Apr  4 23:44:35 xrated kernel: [    6.065681] IR NEC protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.066826] wm8775 1-001b: chip found @ 0x36 (cx88[0])
Apr  4 23:44:35 xrated kernel: [    6.067485] cx88/2: cx2388x dvb driver version 0.0.9 loaded
Apr  4 23:44:35 xrated kernel: [    6.067487] cx88/2: registering cx8802 driver, type: dvb access: shared
Apr  4 23:44:35 xrated kernel: [    6.067489] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
Apr  4 23:44:35 xrated kernel: [    6.067491] cx88[0]/2: cx2388x based DVB/ATSC card
Apr  4 23:44:35 xrated kernel: [    6.067492] cx8802_alloc_frontends() allocating 1 frontend(s)
Apr  4 23:44:35 xrated kernel: [    6.068105] IR RC5(x) protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.069260] IR RC6 protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.069562] CX24123: detected CX24123
Apr  4 23:44:35 xrated kernel: [    6.070247] IR JVC protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.071217] IR Sony protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.071955] DVB: registering new adapter (cx88[0])
Apr  4 23:44:35 xrated kernel: [    6.071957] DVB: registering adapter 0 frontend 0 (Conexant CX24123/CX24109)...
Apr  4 23:44:35 xrated kernel: [    6.072347] IR SANYO protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.073548] input: MCE IR Keyboard/Mouse (cx88xx) as /devices/virtual/input/input15
Apr  4 23:44:35 xrated kernel: [    6.074476] IR MCE Keyboard/mouse protocol handler initialized
Apr  4 23:44:35 xrated kernel: [    6.075778] lirc_dev: IR Remote Control driver registered, major 250 
Apr  4 23:44:35 xrated kernel: [    6.076026] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
Apr  4 23:44:35 xrated kernel: [    6.076028] IR LIRC bridge handler initialized
Apr  4 23:44:35 xrated kernel: [    6.081790] cx88[0]/0: registered device video0 [v4l2]
Apr  4 23:44:35 xrated kernel: [    6.081880] cx88[0]/0: registered device vbi0
Apr  4 23:44:35 xrated kernel: [    6.081986] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards

but a channel scan fails:

$ scan /usr/share/dvb/dvb-s/Astra-19.2E > channels.conf
scanning /usr/share/dvb/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
>>> tune to: 12551:v:0:22000
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
>>> tune to: 12551:v:0:22000 (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

$ dvbsnoop -s feinfo -pd 9
dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/ 
   DEMUX : /dev/dvb/adapter0/demux0
   DVR   : /dev/dvb/adapter0/dvr0
   FRONTEND: /dev/dvb/adapter0/frontend0

---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
    Name: "Conexant CX24123/CX24109"
    Frontend-type:       QPSK (DVB-S)
    Frequency (min):     950.000 MHz
    Frequency (max):     2150.000 MHz
    Frequency stepsiz:   1.011 MHz
    Frequency tolerance: 5.000 MHz
    Symbol rate (min):     1.000000 MSym/s
    Symbol rate (max):     45.000000 MSym/s
    Symbol rate tolerance: 0 ppm
    Notifier delay: 0 ms
    Frontend capabilities:
        auto inversion
        FEC 1/2
        FEC 2/3
        FEC 3/4
        FEC 4/5
        FEC 5/6
        FEC 6/7
        FEC 7/8
        FEC AUTO
        QPSK

Current parameters:
    Frequency:  1951.500 MHz
    Inversion:  OFF
    Symbol rate:  22.000000 MSym/s
    FEC:  FEC 7/8


$ dvb-fe-tool 
Device Conexant CX24123/CX24109 (/dev/dvb/adapter0/frontend0) capabilities:
        CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_4_5 CAN_FEC_5_6 CAN_FEC_6_7 CAN_FEC_7_8 CAN_FEC_AUTO CAN_INVERSION_AUTO CAN_QPSK CAN_RECOVER 
DVB API Version 5.5, Current v5 delivery system: DVBS
Supported delivery system: [DVBS] 


I can watch arte with kaffeine, with vdr/vdr-sxfe just fine, but cannot 
change the channel. 

vdr (1.6.0) doesn't detect any errors:

Apr  5 13:23:29 xrated vdr: [9177] switching to channel 9
Apr  5 13:23:29 xrated vdr: [9177] buffer stats: 0 (0%) used
Apr  5 13:23:29 xrated vdr: [9590] transfer thread started (pid=9177, tid=9590)
Apr  5 13:23:29 xrated vdr: [9588] TS buffer on device 1 thread ended (pid=9177, tid=9588)
Apr  5 13:23:29 xrated vdr: [9587] buffer stats: 0 (0%) used
Apr  5 13:23:29 xrated vdr: [9587] receiver on device 1 thread ended (pid=9177, tid=9587)
Apr  5 13:23:29 xrated vdr: [9591] receiver on device 1 thread started (pid=9177, tid=9591)
Apr  5 13:23:29 xrated vdr: [9592] TS buffer on device 1 thread started (pid=9177, tid=9592)
Apr  5 13:23:32 xrated vdr: [9590] transfer thread ended (pid=9177, tid=9590)
Apr  5 13:23:33 xrated vdr: [9177] switching to channel 8
Apr  5 13:23:33 xrated vdr: [9177] buffer stats: 0 (0%) used
Apr  5 13:23:33 xrated vdr: [9601] transfer thread started (pid=9177, tid=9601)
Apr  5 13:23:33 xrated vdr: [9592] TS buffer on device 1 thread ended (pid=9177, tid=9592)
Apr  5 13:23:33 xrated vdr: [9591] buffer stats: 0 (0%) used
Apr  5 13:23:33 xrated vdr: [9591] receiver on device 1 thread ended (pid=9177, tid=9591)
Apr  5 13:23:33 xrated vdr: [9602] receiver on device 1 thread started (pid=9177, tid=9602)
Apr  5 13:23:33 xrated vdr: [9603] TS buffer on device 1 thread started (pid=9177, tid=9603)
Apr  5 13:23:34 xrated vdr: [9601] [xine..put] Detected video size 720x576

but only on channel 8 it produces a video stream. EPG data seems to arrive 
properly.

On other systems, I'm using a slightly different card: a Hauppauge 
WinTV-HVR4000(Lite) DVB-S/S2, and the most obvious difference is, that
this card loads a firmware, while this NOVA-S-Plus does not:

Mar  1 16:40:13 tyrex kernel: [   46.493929] cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...
Mar  1 16:40:13 tyrex kernel: [   46.503070] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
Mar  1 16:40:18 tyrex kernel: [   51.708520] cx24116_load_firmware: FW version 1.26.90.0
Mar  1 16:40:18 tyrex kernel: [   51.708541] cx24116_firmware_ondemand: Firmware upload complete

The Nova-S-Plus also uses a different driver, the cx24123:

$ lsmod | grep cx
cx24123                23212  1 
cx88_dvb               34350  0 
cx88_vp3054_i2c        12961  1 cx88_dvb
videobuf_dvb           14093  1 cx88_dvb
dvb_core              114209  2 cx88_dvb,videobuf_dvb
cx88_alsa              18300  2 
snd_pcm               109370  4 snd_hda_intel,cx88_alsa,snd_hda_codec,snd_pcm_oss
cx8800                 38588  0 
cx8802                 23058  1 cx88_dvb
cx88xx                 88514  4 cx88_dvb,cx88_alsa,cx8800,cx8802
rc_core                31881  12 ir_kbd_i2c,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,rc_hauppauge,cx88xx
i2c_algo_bit           13414  2 cx88_vp3054_i2c,cx88xx
tveeprom               21250  1 cx88xx
v4l2_common            16421  3 wm8775,cx8800,cx88xx
videodev              111307  5 uvcvideo,wm8775,cx8800,cx88xx,v4l2_common
videobuf_dma_sg        19306  5 cx88_dvb,cx88_alsa,cx8800,cx8802,cx88xx
snd                    91489  19 snd_hda_codec_realtek,snd_hda_intel,cx88_alsa,snd_pcm_oss,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer,snd_mixer_oss
videobuf_core          30119  5 videobuf_dvb,cx8800,cx8802,cx88xx,videobuf_dma_sg
btcx_risc              13641  4 cx88_alsa,cx8800,cx8802,cx88xx

Does this behavior rings a bell for somebody here?

$ uname -a
Linux xrated 3.4.33-2.24-desktop #1 SMP PREEMPT Tue Feb 26 03:34:33 UTC 2013 (5f00a32) x86_64 x86_64 x86_64 GNU/Linux

Any idea, how to debug this any further?

Thanks in advance,
Pete
