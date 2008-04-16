Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server.dupie.be ([85.17.168.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <info@dupondje.be>) id 1Jm25p-0002v6-LP
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 09:30:15 +0200
Received: from [213.219.136.103] (213.219.136.103.adsl.dyn.edpnet.net
	[213.219.136.103])
	by server.dupie.be (Postfix) with ESMTP id D92091798047
	for <linux-dvb@linuxtv.org>; Wed, 16 Apr 2008 09:30:36 +0200 (CEST)
Message-ID: <4805AA95.9050608@dupondje.be>
Date: Wed, 16 Apr 2008 09:28:21 +0200
From: Jean-Louis Dupond <info@dupondje.be>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <30445089.1208329454846.OPEN-XCHANGE.WebMail.www@kalender.consol.de>
In-Reply-To: <30445089.1208329454846.OPEN-XCHANGE.WebMail.www@kalender.consol.de>
Subject: Re: [linux-dvb] Problems with Hauppauge WinTV-HVR 1300 on Debian
 testing
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

Try http://linuxtv.org/hg/~stoth/v4l-dvb/rev/67b7ef217867 this patch ...
Had the same problem on my Ubuntu Hardy box. Seems like its HAL thats
messing up with some things.
If u stop HAL, reload modules, it prolly works. But just use the patch,
then u can use HAL also :)

Sincerely,
Jean-Louis Dupond

Peter Weiss schreef:
> Hello,
>
> running a 2.6.24.3 kernel with a Hauppauge WinTV-HVR 1300 card on a
> debian etch system results in lots of errors, but no video and no
> sound when using analog DVB. I've tested some other kernels such as a
> self compiled 2.6.21.5 and a 2.6.21.4-1-486 one that comes with the
> distribution with the same results.
>
> The card works out of the box with an ubuntu system running
> 2.6.22-14-generic.
>
> Any ideas??
>
>
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x00, val == 0x02, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x00, val == 0x00, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x0b, val == 0x06, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x09, val == 0x01, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x0d, val == 0x41, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x16, val == 0x32, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x20, val == 0x0a, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x21, val == 0x17, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x24, val == 0x3e, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x26, val == 0xff, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x27, val == 0x10, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x28, val == 0x00, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x29, val == 0x00, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x2a, val == 0x10, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x2b, val == 0x00, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x2c, val == 0x10, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x2d, val == 0x00, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x48, val == 0xd4, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x49, val == 0x56, ret == -121)
> Apr 16 08:44:05 Pichuco kernel: cx22702_writereg: writereg error (reg ==
> 0x6b, val == 0x1e, ret == -121)
>
> # uname -r
> 2.6.24.3pichuco
>
>
> lspci shows the card as:
>
> # lspci -vv -s 03:02.0
> 03:02.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
> and Audio Decoder (rev 05)
>         Subsystem: Hauppauge computer works Inc. Unknown device 9601
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>         Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>         <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 21
> Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=16M]
>         Capabilities: [44] Vital Product Data <?>
>         Capabilities: [4c] Power Management version 2
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>                 PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: cx8800
>         Kernel modules: cx8800
>
> dmesg shows no errors or failures detecting the card:
>
> [...]
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> intel_rng: FWH not detected
> cx2388x alsa driver version 0.0.6 loaded
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 19
> cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300
> DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
> cx88[0]: TV tuner type 63, Radio tuner type -1
> tveeprom 1-0050: Hauppauge model 96019, rev D6D3, serial# 1697990
> tveeprom 1-0050: MAC address is 00-0D-FE-19-E8-C6
> tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, type 4)
> tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
> ATSC/DVB Digital (eeprom 0xf4)
> tveeprom 1-0050: audio processor is CX882 (idx 33)
> tveeprom 1-0050: decoder processor is CX882 (idx 25)
> tveeprom 1-0050: has radio, has IR receiver, has IR transmitter
> cx88[0]: hauppauge eeprom: model=96019
> cx88[0]/2: cx2388x 8802 Driver Manager
> ACPI: PCI Interrupt 0000:03:02.2[A] -> GSI 22 (level, low) -> IRQ 21
> cx88[0]/2: found at 0000:03:02.2, rev: 5, irq: 21, latency: 32, mmio:
> 0xef000000
> ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:1f.5 to 64
> cx88/2: cx2388x dvb driver version 0.0.6 loaded
> cx88/2: registering cx8802 driver, type: dvb access: shared
> cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300
> DVB-T/Hybrid MPEG Encoder [card=56]
> cx88[0]/2: cx2388x based DVB/ATSC card
> DVB: registering new adapter (cx88[0])
> DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
> intel8x0_measure_ac97_clock: measured 57816 usecs
> intel8x0: clocking to 48000
> ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 21
> cx88[0]/0: found at 0000:03:02.0, rev: 5, irq: 21, latency: 32, mmio:
> 0xed000000
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88[0]/0: registered device radio0
> [...]
>
>
> Modules are loaded successfully:
>
> # lsmod | egrep 'dvb|tv|cx|video'
> cx88_blackbird         19076  0 
> firmware_class          9344  1 cx88_blackbird
> cx2341x                11652  1 cx88_blackbird
> dvb_pll                11912  1 
> cx22702                 5892  1 
> cx88_dvb               12804  0 
> cx88_vp3054_i2c         3200  1 cx88_dvb
> videobuf_dvb            6788  1 cx88_dvb
> dvb_core               73700  1 videobuf_dvb
> cx88_alsa              12680  1 
> snd_pcm 77572 5 cx88_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
> cx8802                 17796  2 cx88_blackbird,cx88_dvb
> snd 53908 16
> cx88_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_seq,snd_timer,snd_seq_device
> cx8800                 32624  1 cx88_blackbird
> cx88xx 62248 5 cx88_blackbird,cx88_dvb,cx88_alsa,cx8802,cx8800
> ir_common              35204  1 cx88xx
> i2c_algo_bit            6148  2 cx88_vp3054_i2c,cx88xx
> tveeprom               14992  1 cx88xx
> videodev               26240  3 cx88_blackbird,cx8800,cx88xx
> v4l1_compat            12420  1 videodev
> compat_ioctl32          1536  1 cx8800
> v4l2_common 16768 5 cx88_blackbird,cx2341x,cx8800,cx88xx,videodev
> videobuf_dma_sg 13572 7
> cx88_blackbird,cx88_dvb,videobuf_dvb,cx88_alsa,cx8802,cx8800,cx88xx
> videobuf_core 16900 6
> cx88_blackbird,videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
> btcx_risc               5000  4 cx88_alsa,cx8802,cx8800,cx88xx
> i2c_core 22400 7
> dvb_pll,cx22702,cx88_vp3054_i2c,cx88xx,i2c_algo_bit,tveeprom,i2c_i801
>
>
> # modinfo cx88_dvb
> filename:
> /lib/modules/2.6.24.3pichuco/kernel/drivers/media/video/cx88/cx88-dvb.ko
> license:        GPL
> author:         Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
> author:         Chris Pascoe <c.pascoe@itee.uq.edu.au>
> description:    driver for cx2388x based DVB cards
> srcversion:     72B9CE062973ED4E9DE9599
> depends: cx8802,videobuf-dvb,cx88xx,videobuf-dma-sg,cx88-vp3054-i2c
> vermagic:       2.6.24.3pichuco SMP mod_unload PENTIUM4 
> parm:           debug:enable debug messages [dvb] (int)
>
>
> TIA -- Peter
>
>   



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
