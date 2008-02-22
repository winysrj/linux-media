Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1M3Yg3h013422
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 22:34:42 -0500
Received: from S3.cableone.net (s3.cableone.net [24.116.0.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1M3Y9P6001637
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 22:34:09 -0500
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Date: Thu, 21 Feb 2008 21:32:35 -0600
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802212132.36246.vanessaezekowitz@gmail.com>
Cc: 
Subject: New(ish) card support needed, sorta
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

I had to replace an apparently dead tv tuner card, and was hoping to get my 
first taste of HDTV, as there are at least a couple of HD broadcast channels 
here, so I picked up a Kworld ATSC120 from Newegg a few days ago.  

I can't tell which mailing list this should go to since there seems to be at 
least two lists covering this topic, so please forgive the crosspost if it's 
in error.

After reading through both of the mailing lists that this message is destined 
for (video4linux-list and linux-dvb) , and consulting the video4linux wiki as 
well as a few other sources, it looks to me like this card *should* work 
using the driver intended for the Geniatech HDTV Thriller X8000A, as one 
appears to be a clone of the other.

However, I've hit a solid brick wall :(  

I've downloaded and installed the 2.6.24.2 kernel, and fetched the most recent 
snapshot of Mauro Carvalho Chehab's repository (which is what seems to be the 
thing I need) from http://linuxtv.org/hg/~mchehab/cx88-xc2028/

I have compiled and installed the drivers and used the following to start 
them:

-----
modprobe tuner debug=1
modprobe cx88xx card=63 core_debug=1 i2c_debug=1 audio_debug=1
modprobe cx8800 irq_debug=1 video_debug=1
modprobe cx88_alsa
-----

This results in the following modules being loaded:

-----
rainbird vanessa # lsmod
Module                  Size  Used by
cx88_alsa               9800  0
cx8800                 28956  0
compat_ioctl32          1344  1 cx8800
cx88xx                 61864  2 cx88_alsa,cx8800
ir_common              31876  1 cx88xx
videobuf_dma_sg        10372  3 cx88_alsa,cx8800,cx88xx
videobuf_core          14852  3 cx8800,cx88xx,videobuf_dma_sg
btcx_risc               4232  3 cx88_alsa,cx8800,cx88xx
tveeprom               14480  1 cx88xx
tuner                  24716  0
tea5767                 6532  1 tuner
tda8290                12548  1 tuner
tda18271               30536  1 tda8290
tda827x                 9924  1 tda8290
tuner_xc2028           19152  1 tuner
xc5000                  9860  1 tuner
videodev               31360  3 cx8800,cx88xx,tuner
v4l1_compat            14084  1 videodev
tda9887                 9092  1 tuner
tuner_simple            8840  1 tuner
tuner_types            11712  1 tuner_simple
mt20xx                 11848  1 tuner
tea5761                 4676  1 tuner
v4l2_common            10048  2 cx8800,tuner
-----

(Also, nvidia, ali_agp, and agpgart are present)

If I also try to load cx8802 right after cx8800, it destablizes my system, 
locks most of the other modules in (they can no longer be unloaded), and 
throws a kernel BUG:

-----
Feb 21 18:05:31 localhost kernel: cx88[0]/2: cx2388x 8802 Driver Manager
Feb 21 18:05:31 localhost kernel: ACPI: PCI Interrupt 0000:02:09.2[A] -> GSI 
21 (level, low) -> IRQ 20
Feb 21 18:05:31 localhost kernel: cx88[0]/2: found at 0000:02:09.2, rev: 5, 
irq: 20, latency: 32, mmio: 0xf6000000
Feb 21 18:05:31 localhost kernel: cx88/2: cx2388x dvb driver version 0.0.6 
loaded
Feb 21 18:05:31 localhost kernel: cx88/2: registering cx8802 driver, type: dvb 
access: shared
Feb 21 18:05:31 localhost kernel: cx88[0]/2: subsystem: 17de:08c1, board: 
Geniatech X8000-MT DVBT [card=63]
Feb 21 18:05:31 localhost kernel: cx88[0]/2: cx2388x based DVB/ATSC card
Feb 21 18:05:31 localhost kernel: zl10353_read_register: readreg error 
(reg=127, ret==-121)
Feb 21 18:05:31 localhost kernel: xc2028: No frontend!
Feb 21 18:05:31 localhost kernel: cx88[0]/2: xc3028 attach failed
Feb 21 18:05:31 localhost kernel: BUG: unable to handle kernel NULL pointer 
dereference at virtual address 000000ac
Feb 21 18:05:31 localhost kernel: printing eip: f8f31ed4 *pde = 00000000
Feb 21 18:05:31 localhost kernel: Oops: 0000 [#1] SMP
Feb 21 18:05:31 localhost kernel: Modules linked in: zl10353 cx88_dvb 
cx88_vp3054_i2c videobuf_dvb dvb_core cx8802 cx88xx ir_common videobuf_dma_sg 
videobuf_co
re btcx_risc tveeprom tuner tea5767 tda8290 tda18271 tda827x tuner_xc2028 
xc5000 videodev v4l1_compat tda9887 tuner_simple tuner_types mt20xx tea5761 
v4l2_comm
on nvidia(P) ali_agp agpgart
Feb 21 18:05:31 localhost kernel:
Feb 21 18:05:31 localhost kernel: Pid: 11497, comm: modprobe Tainted: P        
(2.6.24.2 #4)
Feb 21 18:05:31 localhost kernel: EIP: 0060:[<f8f31ed4>] EFLAGS: 00010292 CPU: 
0
Feb 21 18:05:31 localhost kernel: EIP is at dvb_frontend_detach+0x4/0x70 
[dvb_core]
Feb 21 18:05:31 localhost kernel: EAX: 00000000 EBX: dd722800 ECX: c04a2e10 
EDX: 00000092
Feb 21 18:05:31 localhost kernel: ESI: 00000000 EDI: dd722800 EBP: e7d09010 
ESP: e9e51e30
Feb 21 18:05:31 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 
0068
Feb 21 18:05:31 localhost kernel: Process modprobe (pid: 11497, ti=e9e51000 
task=f4e6eab0 task.ti=e9e51000)
Feb 21 18:05:31 localhost kernel: Stack: dd722800 e7d09000 f8e0c241 f8e0e018 
e7d09010 e7d09050 00000061 e7d09000
Feb 21 18:05:31 localhost kernel:        00000000 00000000 00000000 f8e0c44a 
f8e0de93 00000001 00000002 00000084
Feb 21 18:05:31 localhost kernel:        dd722800 00000246 eebaccc0 f8e0f3b4 
eebaccf4 f8e0f380 f8de3853 f8de3e78
Feb 21 18:05:31 localhost kernel: Call Trace:
Feb 21 18:05:31 localhost kernel:  [<f8e0c241>] attach_xc3028+0xc1/0xe0 
[cx88_dvb]
Feb 21 18:05:31 localhost kernel:  [<f8e0c44a>] cx8802_dvb_probe+0x1ea/0x14f0 
[cx88_dvb]
Feb 21 18:05:31 localhost kernel:  [<f8de3853>] 
cx8802_register_driver+0x1a3/0x20e [cx8802]
Feb 21 18:05:31 localhost kernel:  [sys_init_module+349/6368] 
sys_init_module+0x15d/0x18e0
Feb 21 18:05:31 localhost kernel:  [<c014bc6d>] sys_init_module+0x15d/0x18e0
Feb 21 18:05:31 localhost kernel:  [do_sync_read+213/288] 
do_sync_read+0xd5/0x120
Feb 21 18:05:31 localhost kernel:  [<c017ac75>] do_sync_read+0xd5/0x120
Feb 21 18:05:31 localhost kernel:  [handle_mm_fault+704/1472] 
handle_mm_fault+0x2c0/0x5c0
Feb 21 18:05:31 localhost kernel:  [<c016a3a0>] handle_mm_fault+0x2c0/0x5c0
Feb 21 18:05:31 localhost kernel:  [<f8f1b000>] cx88_tuner_callback+0x0/0x310 
[cx88xx]
Feb 21 18:05:31 localhost kernel:  [do_sync_read+0/288] do_sync_read+0x0/0x120
Feb 21 18:05:31 localhost kernel:  [<c017aba0>] do_sync_read+0x0/0x120
Feb 21 18:05:31 localhost kernel:  [sysenter_past_esp+95/133] 
sysenter_past_esp+0x5f/0x85
Feb 21 18:05:31 localhost kernel:  [<c01041ce>] sysenter_past_esp+0x5f/0x85
Feb 21 18:05:31 localhost kernel:  =======================
Feb 21 18:05:31 localhost kernel: Code: 8d bc 27 00 00 00 00 8b 44 24 08 39 c2 
7e 08 29 d0 05 40 42 0f 00 c3 29 d0 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 
56 89 c6 53 <8b> 90 ac 00 00 00 85 d2 74 0d ff d2 8b 86 ac 00 00 00 e8 05 b5
Feb 21 18:05:31 localhost kernel: EIP: [<f8f31ed4>] 
dvb_frontend_detach+0x4/0x70 [dvb_core] SS:ESP 0068:e9e51e30
Feb 21 18:05:31 localhost kernel: ---[ end trace 9877c1f600f4596e ]---
-----

I rebooted to clear the unstable state, re-installed the drivers after 
discovering a minor error on my part (unrelated to this topic) and loaded 
them as before.  Did some tests:

Using kradio, the FM radio tuner receives nothing but static, and only 
intermittently. kradio refuses to let me tune, claiming that the radio has a 
range of 0 kHz to 0 kHz.  This might be because the driver reports it tuner 
type 0.  The console radio app that comes with xawtv looks like it tune, but 
there's no audio.

Using tvtime with signal detection turned off:

* The S-video input works fine right from the start.

* The Composite input works, but sits for several seconds in an "overbright" 
condition when you first switch to it, before dropping down to normal (which 
it does on its own).  Once it gets past that, it seems to work fine.

* The analog (?) TV tuner returns nothing but blackness.  Tvtime does let me 
change channels, switch frequency tables, video standards, and so on, but 
nothing ever appears.  Xawtv, mplayer, and VLC all give me the same results 
as with tvtime (though with VLC I can't tell which input I'm seeing).  xine 
and kaffeine say there are no DVB devices, and both refuse to open any v4l 
device (did this ever work?  how?).

* I can't figure out how to get to the digital/ATSC tuner at all (cx8802.ko?)

** I have not tried the card at all under Windows (apparently requires WinXP 
or Vista, which I do not have)

Here is spew from my system log (when the driver is loaded as mentioned above, 
and without trying to load cx8802.ko), before trying to run any video or 
radio apps:

-----
Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 21 (level, low) -> IRQ 20
cx88[0]: subsystem: 17de:08c1, board: Geniatech X8000-MT DVBT [card=63,insmod 
option]
cx88[0]: TV tuner type 71, Radio tuner type 0
cx88[0]: cx88_reset
cx88[0]: tveeprom i2c attach [addr=0x50,client=tveeprom]
cx88[0]: i2c register ok
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88[0]/0: found at 0000:02:09.0, rev: 5, irq: 20, latency: 32, mmio: 
0xf4000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]: set_tvnorm: "NTSC-M" fsc8=28636360 adc=28636363 vdec=28636360 
db/dr=28636360/28636360
cx88[0]: set_pll:    MO_PLL_REG       0x00fffffe 
[old=0x00fffffe,freq=28636360]
cx88[0]: pll locked [pre=2,ofreq=28636360]
cx88[0]: set_tvnorm: MO_INPUT_FORMAT  0x00000001 [old=0x00000007]
cx88[0]: set_tvnorm: MO_OUTPUT_FORMAT 0x181f0008 [old=0x181f0008]
cx88[0]: set_tvnorm: MO_SCONV_REG     0x00020000 [old=0x00020000]
cx88[0]: set_tvnorm: MO_SUB_STEP      0x00400000 [old=0x00400000]
cx88[0]: set_tvnorm: MO_SUB_STEP_DR   0x00400000 [old=0x00400000]
cx88[0]: set_tvnorm: MO_AGC_BURST     0x00007270 
[old=0x00007270,bdelay=114,agcdelay=112]
cx88[0]: set_tvnorm: MO_HTOTAL        0x0000038e [old=0x0000038e,htotal=910]
cx88[0]: set_scale: 320x240 [TB,NTSC-M]
cx88[0]: set_scale: hdelay  0x0038 (width 754)
cx88[0]: set_scale: hscale  0x15b3
cx88[0]: set_scale: hactive 0x0140
cx88[0]: set_scale: vdelay  0x0018
cx88[0]: set_scale: vscale  0x1e00
cx88[0]: set_scale: vactive 0x01e0
cx88[0]: set_scale: filter  0x80009
cx88[0]/0: set_audio_standard_BTSC (status: known-good)
cx88[0]/0: set_control id=0x980900(Brightness) ctrl=0x7f, reg=0x310110 
val=0xff (mask 0xff)
cx88[0]/0: set_control id=0x980901(Contrast) ctrl=0x3f, reg=0x310110 
val=0x3f00 (mask 0xff00)
cx88[0]/0: set_control id=0x980903(Hue) ctrl=0x7f, reg=0x310118 val=0xff (mask 
0xff)
cx88[0]/0: set_control id=0x980902(Saturation) ctrl=0x7f, reg=0x310114 
val=0x5a7f (mask 0xffff)
cx88[0]/0: set_control id=0x980909(Mute) ctrl=0x01, reg=0x320594 val=0x40 
(mask 0x40) [shadowed]
cx88[0]/0: set_control id=0x980905(Volume) ctrl=0x3f, reg=0x320594 val=0x00 
(mask 0x3f) [shadowed]
cx88[0]/0: set_control id=0x980906(Balance) ctrl=0x40, reg=0x320598 val=0x00 
(mask 0x7f) [shadowed]
cx88[0]/0: video_mux: 0 [vmux=0,gpio=0x0,0xe3e341,0x0,0x0]
cx88[0]/0: cx88: tvaudio thread started
cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:02:09.1[A] -> GSI 21 (level, low) -> IRQ 20
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/0: AUD_STATUS: 0x1b2 [mono/no pilot] ctl=BTSC_AUTO_STEREO
-----

I'll not post the messages from the cx8802.ko module yet since that driver 
de-stablizes my system when loaded, but I'll be glad to try again and repost 
what I find on request.

I have additional log spew for when I tried to start the radio (just the 
little console program that come with xawtv) as well as tvtime.

-- 
"Life is full of happy and sad events.  If you take the time
to concentrate on the former, you'll get further in life."
Vanessa Ezekowitz  <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
