Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out9.libero.it ([212.52.84.109])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vic@zini-associati.it>) id 1LeFPA-0001Xy-7e
	for linux-dvb@linuxtv.org; Mon, 02 Mar 2009 22:10:30 +0100
Received: from router.ciencio.homeip.net (151.65.183.192) by cp-out9.libero.it
	(8.5.016.1) id 492C050B0C49D155 for linux-dvb@linuxtv.org;
	Mon, 2 Mar 2009 22:09:54 +0100
Received: from [192.168.10.151] (unknown [10.0.0.100])
	by router.ciencio.homeip.net (Postfix) with ESMTP id D187210A
	for <linux-dvb@linuxtv.org>; Mon,  2 Mar 2009 22:08:51 +0100 (CET)
Message-ID: <49AC4B59.3040807@zini-associati.it>
Date: Mon, 02 Mar 2009 22:10:49 +0100
From: ciencio <vic@zini-associati.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] lifeview NOT LV3H not working
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

Hello,
I bought the TV card in the object, it is a PCI hybrid TV-card, both
analogue and DVB-T.

I bought it, because on the manufacturer site they said they develop a
linux driver, unfortunately when I downloaded the driver (which claims
to be for fedora) I found the whole V4L tree to be compiled.

By the way, I tried to compiled it but it failed 'because it looked for
the 2.6.19 kernel sources while I'm on Ubuntu Intrepid with a 2.6.27.

So I downloaded the v4l tree from HG, compiled and installed it, but
this time was the firmware that was missing. I followed the instruction
to get the firmware for the xc3028  from here

>  http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip

and everything seemed to be perfect... but the tuner wasn't able to
detect anything.

I tried "w_scan", since there was not a freq table for my town, but it
didn't find anything and dmesg reported the following error repeated:

> [ 4982.520836] zl10353: write to reg 6c failed (err = -6)!
> [ 4982.521593] zl10353: write to reg 6d failed (err = -6)!
> [ 4982.522337] zl10353: write to reg 6e failed (err = -6)!
> [ 4982.523079] zl10353: write to reg 6f failed (err = -6)!
> [ 4982.523822] zl10353: write to reg 5f failed (err = -6)!
> [ 4982.524565] zl10353: write to reg 71 failed (err = -6)!
> [ 4982.614090] zl10353_read_register: readreg error (reg=6, ret==-6)
> [ 4982.614847] zl10353_read_register: readreg error (reg=10, ret==-6)
> [ 4982.615591] zl10353_read_register: readreg error (reg=11, ret==-6)
> [ 4982.616817] zl10353_read_register: readreg error (reg=16, ret==-6)
> [ 4982.617509] zl10353_read_register: readreg error (reg=17, ret==-6)
> [ 4982.618446] zl10353_read_register: readreg error (reg=18, ret==-6)
> [ 4982.619373] zl10353_read_register: readreg error (reg=19, ret==-6)
> [ 4982.620273] zl10353_read_register: readreg error (reg=20, ret==-6)
> [ 4982.621134] zl10353_read_register: readreg error (reg=21, ret==-6)
> [ 4982.821710] zl10353_read_register: readreg error (reg=6, ret==-6)
> [ 4982.822474] zl10353_read_register: readreg error (reg=10, ret==-6)
> [ 4982.823338] zl10353_read_register: readreg error (reg=11, ret==-6)
> [ 4982.824062] zl10353_read_register: readreg error (reg=16, ret==-6)
> [ 4982.824877] zl10353_read_register: readreg error (reg=17, ret==-6)
> [ 4982.825589] zl10353_read_register: readreg error (reg=18, ret==-6)
> [ 4982.826601] zl10353_read_register: readreg error (reg=19, ret==-6)
> [ 4982.827463] zl10353_read_register: readreg error (reg=20, ret==-6)
> [ 4982.828180] zl10353_read_register: readreg error (reg=21, ret==-6)

I also tried scantv for analogue broadcast, but there wat a sign of the
analogue tuner work, too. And the output of dmesg this time was the
following

> [ 5458.532019] cx88[0]: Calling XC2028/3028 callback
> [ 5459.008018] cx88[0]: Calling XC2028/3028 callback
> [ 5459.484026] cx88[0]: Calling XC2028/3028 callback
> [ 5459.960024] cx88[0]: Calling XC2028/3028 callback
> [ 5460.448073] cx88[0]: Calling XC2028/3028 callback
> [ 5460.928071] cx88[0]: Calling XC2028/3028 callback
> [ 5461.408074] cx88[0]: Calling XC2028/3028 callback

This is the output of dmesg at startup:

[   13.929094] tuner' 1-0061: chip found @ 0xc2 (cx88[0])
[   14.185029] xc2028 1-0061: creating new instance
[   14.185036] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   14.185048] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
[   14.185071] cx88[0]/2: cx2388x 8802 Driver Manager
[   14.185121] cx88-mpeg driver manager 0000:00:0a.2: PCI INT A -> GSI
18 (level, low) -> IRQ 18
[   14.185141] cx88[0]/2: found at 0000:00:0a.2, rev: 5, irq: 18,
latency: 32, mmio: 0xfa000000
[   14.185507] cx8800 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) ->
IRQ 18
[   14.185521] cx88[0]/0: found at 0000:00:0a.0, rev: 5, irq: 18,
latency: 32, mmio: 0xf8000000
[   14.185753] cx88[0]/0: registered device video0 [v4l2]
[   14.185835] cx88[0]/0: registered device vbi0
[   14.185902] cx88[0]/0: registered device radio0
[   14.185967] firmware: requesting xc3028-v27.fw
[   14.733493] cx2388x alsa driver version 0.0.6 loaded
[   16.747916] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   16.748129] cx88[0]: Calling XC2028/3028 callback
[   16.946586] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id
0000000000000000.
[   16.946596] cx88[0]: Calling XC2028/3028 callback
[   18.146493] xc2028 1-0061: Loading firmware for type=MTS (4), id
000000000000b700.
[   18.163073] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[   18.224014] cx88[0]: Calling XC2028/3028 callback
[   18.346316] EMU10K1_Audigy 0000:00:09.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[   18.381388] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   18.381396] cx88/2: registering cx8802 driver, type: dvb access: shared
[   18.381403] cx88[0]/2: subsystem: 14f1:8852, board: Geniatech
X8000-MT DVBT [card=63]
[   18.381409] cx88[0]/2: cx2388x based DVB/ATSC card
[   18.381415] cx8802_alloc_frontends() allocating 1 frontend(s)
[   18.411681] cx88_audio 0000:00:0a.1: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
[   18.411734] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   18.414562] ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
[   18.414574] VIA 82xx Audio 0000:00:11.5: PCI INT C -> Link[ALKC] ->
GSI 22 (level, low) -> IRQ 22
[   18.414733] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[   18.439808] xc2028 1-0061: attaching existing instance
[   18.439814] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   18.439817] cx88[0]/2: xc3028 attached
[   18.439825] DVB: registering new adapter (cx88[0])
[   18.439830] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
DVB-T)...

[omissis]

[   34.207368] cx88[0]: Calling XC2028/3028 callback
[   34.405817] xc2028 1-0061: Loading firmware for type=BASE FM (401),
id 0000000000000000.
[   34.405827] cx88[0]: Calling XC2028/3028 callback
[   35.646479] xc2028 1-0061: Loading firmware for type=FM (400), id
0000000000000000.
[   35.696021] cx88[0]: Calling XC2028/3028 callback

and this is the output of lsmod (only relevant modules)

ciencio@kinotto:~$ lsmod
snd_emu10k1_synth      14464  0
snd_emux_synth         41344  1 snd_emu10k1_synth
snd_seq_virmidi        13568  1 snd_emux_synth
snd_seq_midi_emul      14592  1 snd_emux_synth
zl10353                15752  1
cx88_dvb               28420  0
cx88_vp3054_i2c        10752  1 cx88_dvb
snd_via82xx            32536  2
snd_emu10k1           146208  4 snd_emu10k1_synth
snd_mpu401_uart        15360  1 snd_via82xx
snd_ac97_codec        111652  2 snd_via82xx,snd_emu10k1
ac97_bus                9856  1 snd_ac97_codec
snd_util_mem           12416  2 snd_emux_synth,snd_emu10k1
snd_hwdep              15236  2 snd_emux_synth,snd_emu10k1
snd_seq_dummy          10884  0
cx88_alsa              18824  1
snd_seq_oss            38528  0
snd_seq_midi           14336  0
snd_rawmidi            29824  4
snd_seq_virmidi,snd_emu10k1,snd_mpu401_uart,snd_seq_midi
evdev                  17696  7
snd_pcm_oss            46848  0
snd_mixer_oss          22784  1 snd_pcm_oss
videobuf_dvb           15236  1 cx88_dvb
snd_seq_midi_event     15232  3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi
dvb_core               94336  2 cx88_dvb,videobuf_dvb
snd_pcm                83204  5
snd_via82xx,snd_emu10k1,snd_ac97_codec,cx88_alsa,snd_pcm_oss
snd_seq                57776  9
snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
tuner_xc2028           30772  2
snd_seq_device         15116  8
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
tuner                  36036  0
snd_timer              29960  3 snd_emu10k1,snd_pcm,snd_seq
snd_page_alloc         16136  3 snd_via82xx,snd_emu10k1,snd_pcm
snd                    63268  28
snd_emux_synth,snd_seq_virmidi,snd_via82xx,snd_emu10k1,snd_mpu401_uart,snd_ac97_codec,snd_hwdep,cx88_alsa,snd_seq_oss,snd_rawmidi,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq,snd_seq_device,snd_timer
cx8800                 38456  0
fglrx                1813960  23
parport_pc             39204  1
parport                42604  3 ppdev,lp,parport_pc
cx8802                 23684  1 cx88_dvb
pcspkr                 10624  0
cx88xx                 79144  4 cx88_dvb,cx88_alsa,cx8800,cx8802
i2c_viapro             15764  0
ir_common              56068  1 cx88xx
2c_algo_bit           14340  2 cx88_vp3054_i2c,cx88xx
tveeprom               20356  1 cx88xx
v4l2_common            23808  2 tuner,cx8800
videodev               49312  4 tuner,cx8800,cx88xx,v4l2_common
i2c_core               31892  9
zl10353,cx88_vp3054_i2c,tuner_xc2028,tuner,cx88xx,i2c_viapro,i2c_algo_bit,tveeprom,v4l2_common
v4l1_compat            21892  1 videodev
videobuf_dma_sg        20612  5 cx88_dvb,cx88_alsa,cx8800,cx8802,cx88xx
videobuf_core          26372  5
videobuf_dvb,cx8800,cx8802,cx88xx,videobuf_dma_sg
btcx_risc              12552  4 cx88_alsa,cx8800,cx8802,cx88xx
soundcore              15328  1 snd

I can't understand what' wrong with that card. Is there anyone able to
help me?

-- 
ciencio
-- 
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
