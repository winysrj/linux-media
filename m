Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.shadowmail.de ([78.46.45.167] helo=lshrzsm01.shadowmail.de)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ramshadow@ramshadow.net>) id 1MF2RU-00062X-H7
	for linux-dvb@linuxtv.org; Fri, 12 Jun 2009 10:48:57 +0200
Received: from localhost (localhost [127.0.0.1])
	by lshrzsm01.shadowmail.de (Postfix) with ESMTP id 24F904C2ED
	for <linux-dvb@linuxtv.org>; Fri, 12 Jun 2009 10:48:53 +0200 (CEST)
Received: from lshrzsm01.shadowmail.de ([127.0.0.1])
	by localhost (www.shadowmail.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31e6fZ2nHBlq for <linux-dvb@linuxtv.org>;
	Fri, 12 Jun 2009 10:48:46 +0200 (CEST)
Received: from egw.shadowmail.de (lshrzsm01.shadowmail.de [78.46.45.167])
	by lshrzsm01.shadowmail.de (Postfix) with ESMTP id 3D6D94B827
	for <linux-dvb@linuxtv.org>; Fri, 12 Jun 2009 10:48:46 +0200 (CEST)
Date: Fri, 12 Jun 2009 10:48:46 +0200
To: linux-dvb@linuxtv.org
From: RamShadow <ramshadow@ramshadow.net>
Message-ID: <7b157854c5f945d0652226baef329d07@egw.shadowmail.de>
MIME-Version: 1.0
Subject: [linux-dvb] [FWD] WinTV NOVA-S-Plus Tuning Failure
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

Hi Guy,

i have a Problem and no idea.

My Nova S Plus was running under Debian Etch without any Problems.

Now i have build my server with new hardware and under Debian Lenny

The Card was Discovered but on Tuning i haven an Error


The Error :

/home/ramshadow#: scan /usr/share/dvb/dvb-s/Astra-19.2E

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

#############################


DMESG: ########################

[ 11.836130] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[ 11.836130] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) ->
IRQ 16
[ 11.836461] cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus
DVB-S [card=37,autodetected], frontend(s): 1
[ 11.836461] cx88[0]: TV tuner type 4, Radio tuner type -1
[ 11.839979] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[ 11.928304] cx2388x alsa driver version 0.0.7 loaded
[ 11.999045] tveeprom 1-0050: Hauppauge model 92001, rev C1B1, serial#
3471533
[ 11.999049] tveeprom 1-0050: MAC address is 00-0D-FE-34-F8-AD
[ 11.999051] tveeprom 1-0050: tuner model is Conexant_CX24109 (idx 111, type
4)
[ 11.999054] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[ 11.999056] tveeprom 1-0050: audio processor is CX883 (idx 32)
[ 11.999059] tveeprom 1-0050: decoder processor is CX883 (idx 22)
[ 11.999061] tveeprom 1-0050: has no radio, has IR receiver, has no IR
transmitter
[ 11.999063] cx88[0]: hauppauge eeprom: model=92001
[ 11.999132] input: cx88 IR (Hauppauge Nova-S-Plus as /class/input/input5
[ 12.003973] cx88[0]/0: found at 0000:04:00.0, rev: 5, irq: 16, latency: 64,
mmio: 0xfa000000
[ 12.004007] cx88[0]/0: registered device video0 [v4l2]
[ 12.004023] cx88[0]/0: registered device vbi0
[ 12.003973] cx88[0]/2: cx2388x 8802 Driver Manager
[ 12.003973] ACPI: PCI Interrupt 0000:04:00.2[A] -> GSI 16 (level, low) ->
IRQ 16
[ 12.003973] cx88[0]/2: found at 0000:04:00.2, rev: 5, irq: 16, latency: 64,
mmio: 0xfc000000
[ 12.003973] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) ->
IRQ 22
[ 12.003973] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[ 12.058569] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[ 12.058569] cx88/2: registering cx8802 driver, type: dvb access: shared
[ 12.058569] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus
DVB-S [card=37]
[ 12.058569] cx88[0]/2: cx2388x based DVB/ATSC card
[ 12.058569] cx8802_alloc_frontends() allocating 1 frontend(s)
[ 12.070572] ACPI: PCI Interrupt 0000:04:00.1[A] -> GSI 16 (level, low) ->
IRQ 16
[ 12.070572] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[ 12.118575] CX24123: detected CX24123
[ 12.138568] DVB: registering new adapter (cx88[0])
[ 12.138568] DVB: registering adapter 0 frontend 0 (Conexant
CX24123/CX24109)...

#############################

ls /dev/dvb/adapter0/ -lah
insgesamt 0
drwxr-xr-x 2 root root 120 11. Jun 21:04 .
drwxr-xr-x 3 root root 60 11. Jun 21:04 ..
crw-rw---- 1 root video 212, 1 11. Jun 21:04 demux0
crw-rw---- 1 root video 212, 2 11. Jun 21:04 dvr0
crw-rw---- 1 root video 212, 0 11. Jun 21:04 frontend0
crw-rw---- 1 root video 212, 3 11. Jun 21:04 net0

#############################

lsmod |grep dvb
cx88_dvb 18916 0
cx88_vp3054_i2c 2464 1 cx88_dvb
videobuf_dvb 6564 1 cx88_dvb
dvb_core 74144 2 cx88_dvb,videobuf_dvb
cx8802 13572 1 cx88_dvb
cx88xx 70796 4 cx88_dvb,cx88_alsa,cx8802,cx8800
videobuf_dma_sg 11140 5 cx88_dvb,cx88_alsa,cx8802,cx8800,cx88xx
videobuf_core 16036 5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg



lsmod |grep cx
cx24123 12136 1
cx88_dvb 18916 0
cx88_vp3054_i2c 2464 1 cx88_dvb
videobuf_dvb 6564 1 cx88_dvb
dvb_core 74144 2 cx88_dvb,videobuf_dvb
cx88_alsa 9384 0
snd_pcm 62596 3 snd_hda_intel,cx88_alsa,snd_pcm_oss
cx8802 13572 1 cx88_dvb
cx8800 27632 0
cx88xx 70796 4 cx88_dvb,cx88_alsa,cx8802,cx8800
ir_common 47492 1 cx88xx
i2c_algo_bit 5188 2 cx88_vp3054_i2c,cx88xx
v4l2_common 17600 2 cx8800,cx88xx
videodev 32992 3 cx8800,cx88xx,v4l2_common
tveeprom 11044 1 cx88xx
videobuf_dma_sg 11140 5 cx88_dvb,cx88_alsa,cx8802,cx8800,cx88xx
videobuf_core 16036 5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
btcx_risc 4200 4 cx88_alsa,cx8802,cx8800,cx88xx
snd 45604 10 snd_hda_intel,cx88_alsa,snd_pcm_oss,snd_mixer_oss,
snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer, snd_seq_device
i2c_core 19828 9 isl6421,cx24123,cx88_vp3054_i2c,cx8800,cx88xx,i2c_
algo_bit,v4l2_common,tveeprom,i2c_i801

#############################
groups ramshadow
ramshadow dialout cdrom floppy audio video plugdev users mythtv

#############################



Have anyone a hint for me ??

ciao Lex 




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
