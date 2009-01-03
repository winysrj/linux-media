Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f30.google.com ([209.85.218.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ulf.norberg@gmail.com>) id 1LJBdO-0003jo-OM
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 19:54:08 +0100
Received: by bwz11 with SMTP id 11so5083697bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 10:53:33 -0800 (PST)
Message-ID: <d8291f3b0901031053o4b15791cscb80dcda4bec0ba6@mail.gmail.com>
Date: Sat, 3 Jan 2009 19:53:31 +0100
From: "Ulf Norberg" <ulf.norberg@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Twinhan VP-3021 with Nxt6000,
	Comtech DVBT-6k08 (SP5730 PLL)
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

I have a DVB-T Twinhan VP-3021 (VisionDTV ter).  It is working OK, but
the reception is quite bad.  The card has a nxt6000 chip, but nothing
seem to happen when I load the nxt6000 module.  Can the bad reception
be due to that the nxt6000 i not used (for some reason...)?

Removing the twinhan sticker on the tin box i found out that the tuner
is a Comtech DVBT-6K08P1T, with the following chip: Nxt6000, SP7530,
TDA5736M (Philips), TDA6190T (infineon).

The card has a Conexant Fusion 878A (and also a 44-pin chip called THDTV20023).

Kernel verision: 2.6.27-gentoo-r7

lsmod:

Module                  Size  Used by
dib3000mb              12800  0
mt352                   7364  0
sp887x                  7876  0
dst                    28936  1
dvb_bt8xx              16836  0
dvb_core               83244  2 dst,dvb_bt8xx
bt878                  10600  2 dst,dvb_bt8xx
bttv                  197652  2 dvb_bt8xx,bt878
ir_common              37508  1 bttv
compat_ioctl32          6464  1 bttv
videodev               34560  2 bttv,compat_ioctl32
i2c_algo_bit            8708  1 bttv
v4l2_common            11200  1 bttv
videobuf_dma_sg        12548  1 bttv
videobuf_core          17476  2 bttv,videobuf_dma_sg
btcx_risc               4680  1 bttv
tveeprom               14916  1 bttv
nxt6000                 8068  0
snd_pcm_oss            39456  0
snd_mixer_oss          16640  1 snd_pcm_oss
snd_hda_intel         289228  0
snd_bt87x              14340  0
snd_pcm                71112  3 snd_pcm_oss,snd_hda_intel,snd_bt87x
snd_timer              22288  1 snd_pcm
snd                    59656  6
snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_bt87x,snd_pcm,snd_timer
soundcore               7584  1 snd
snd_page_alloc          8592  3 snd_hda_intel,snd_bt87x,snd_pcm
nvidia               7804072  38
i2c_core               26144  11
dib3000mb,mt352,sp887x,dst,dvb_bt8xx,bttv,i2c_algo_bit,v4l2_common,tveeprom,nxt6000,nvidia


dmesg:

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:04:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
bttv0: Bt878 (rev 17) at 0000:04:00.0, irq: 20, latency: 32, mmio: 0xea200000
bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI subsystem ID
is 1822:0001
bttv0: using: Twinhan DST + clones [card=113,autodetected]
btcx: riscmem alloc [1] dma=cf824000 cpu=ffff8800cf824000 size=4096
bttv0: risc main @ cf824000
bttv0: gpio: en=00000000, out=00000000 in=00f100fe [init]
i2c-adapter i2c-3: adapter [bt878 #0 [hw]] registered
bttv0: tuner absent
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
bt878 0000:04:00.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
bt878(0): Bt878 (rev 17) at 04:00.1, irq: 20, latency: 32, memory: 0xea201000
dvb_bt8xx: identified card0 as bttv0
DVB: registering new adapter (bttv0)
DVB: register adapter0/demux0 @ minor: 4 (0x04)
DVB: register adapter0/dvr0 @ minor: 5 (0x05)
DVB: register adapter0/net0 @ minor: 7 (0x07)
i2c-adapter i2c-3: master_xfer[0] W, addr=0x55, len=8
bt-i2c: ERR: -5
i2c-adapter i2c-3: master_xfer[0] W, addr=0x55, len=8
bt-i2c: <W aa 00 06 00 00 00 00 00 fa >
i2c-adapter i2c-3: master_xfer[0] R, addr=0x55, len=1
bt-i2c: <R ab =ff >
i2c-adapter i2c-3: master_xfer[0] R, addr=0x55, len=8
bt-i2c: <R ab =20 =44 =54 =54 =44 =49 =47 =20 >
dst(0) dst_get_device_id: Recognise [DTTDIG]
DST type flags : 0x10 firmware version = 2
i2c-adapter i2c-3: master_xfer[0] W, addr=0x55, len=8
bt-i2c: <W aa 00 0a 00 00 00 00 00 f6 >
i2c-adapter i2c-3: master_xfer[0] R, addr=0x55, len=1
bt-i2c: <R ab =ff >
i2c-adapter i2c-3: master_xfer[0] R, addr=0x55, len=8
bt-i2c: <R ab =00 =08 =ca =30 =10 =28 =41 =85 >
dst(0) dst_get_mac: MAC Address=[00:08:ca:10:28:00]
dvb_register_frontend
DVB: registering frontend 0 (DST DVB-T)...
DVB: register adapter0/frontend0 @ minor: 3 (0x03)

lspci -nn -v

04:00.0 Multimedia video controller [0400]: Brooktree Corporation
Bt878 Video Capture [109e:036e] (rev 11)
	Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB card [1822:0001]
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at ea200000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

04:00.1 Multimedia controller [0480]: Brooktree Corporation Bt878
Audio Capture [109e:0878] (rev 11)
	Subsystem: Twinhan Technology Co. Ltd VisionPlus DVB Card [1822:0001]
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at ea201000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bt878
	Kernel modules: bt878

Regards,
Ulf

-- 
Ulf Norberg <ulf.norberg@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
