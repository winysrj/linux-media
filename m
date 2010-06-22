Return-path: <linux-media-owner@vger.kernel.org>
Received: from n22.bullet.mail.ukl.yahoo.com ([87.248.110.139]:48013 "HELO
	n22.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754236Ab0FVOKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 10:10:05 -0400
Message-ID: <138349.20974.qm@web28213.mail.ukl.yahoo.com>
Date: Tue, 22 Jun 2010 07:10:02 -0700 (PDT)
From: Mario Latronico <mario.latronico@yahoo.it>
Subject: remote not working for Hauppauge HVR 1120
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
My name is Mario Latronico and this is my first message to this list.

I'm trying to use the remote commander bundled with my Hauppauge HVR 1120, but the card seems not to be supported by the latest v4l-dvb modules from the Hg repository (I cloned the source around 1 week ago). The output of dmesg after a make unload && make && make uninstall && modprobe saa7134 ir_debug=1 is :

[ 4873.304025] IR NEC protocol handler initialized
[ 4873.326432] Linux video capture interface: v2.00
[ 4873.337917] IR RC5(x) protocol handler initialized
[ 4873.357148] saa7130/34: v4l2 driver version 0.2.16 loaded
[ 4873.357227] saa7133[0]: found at 0000:05:09.0, rev: 209, irq: 18, latency: 32, mmio: 0xf0500000
[ 4873.357241] saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1120 DVB-T/Hybrid [card=156,autodetected]
[ 4873.357591] saa7133[0]: board init: gpio is 440100
[ 4873.359113] IR RC6 protocol handler initialized
[ 4873.364155] IR JVC protocol handler initialized
[ 4873.368410] IR Sony protocol handler initialized
[ 4873.381035] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[ 4873.532020] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[ 4873.532040] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[ 4873.532057] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
[ 4873.532074] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 4873.532091] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
[ 4873.532108] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532125] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532141] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532158] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 0c 17 64 f0 73 05 29 00
[ 4873.532175] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 29 8d 72 07 70 73 09
[ 4873.532192] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 45 72
[ 4873.532209] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 1e 00 00 00 00 00
[ 4873.532225] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532242] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532259] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532275] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 4873.532293] saa7133[0]/ir: No I2C IR support for board 9c
[ 4873.532302] tveeprom 1-0050: Hauppauge model 67209, rev C2F5, serial# 6559500
[ 4873.532306] tveeprom 1-0050: MAC address is 00:0d:fe:64:17:0c
[ 4873.532310] tveeprom 1-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[ 4873.532315] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ 4873.532319] tveeprom 1-0050: audio processor is SAA7131 (idx 41)
[ 4873.532323] tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
[ 4873.532327] tveeprom 1-0050: has radio, has IR receiver, has no IR transmitter
[ 4873.532330] saa7133[0]: hauppauge eeprom: model=67209
[ 4873.589133] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[ 4873.668026] tda829x 1-004b: setting tuner address to 60
[ 4873.718881] tda18271 1-0060: creating new instance
[ 4873.764019] TDA18271HD/C2 detected @ 1-0060
[ 4875.097022] tda18271: performing RF tracking filter calibration
[ 4893.348022] tda18271: RF tracking filter calibration complete
[ 4893.404025] tda829x 1-004b: type set to tda8290+18271
[ 4897.916287] saa7133[0]: dsp access error
[ 4897.916295] saa7133[0]: dsp access error
[ 4897.916357] saa7133[0]: dsp access error
[ 4897.916362] saa7133[0]: dsp access error
[ 4897.985132] saa7133[0]: registered device video0 [v4l2]
[ 4897.985180] saa7133[0]: registered device vbi0
[ 4897.985224] saa7133[0]: registered device radio0
[ 4898.050069] dvb_init() allocating 1 frontend
[ 4898.392023] tda829x 1-004b: type set to tda8290
[ 4898.408174] tda18271 1-0060: attaching existing instance
[ 4898.408182] DVB: registering new adapter (saa7133[0])
[ 4898.408188] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[ 4898.872020] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[ 4898.872032] saa7134 0000:05:09.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[ 4898.875233] tda10048_firmware_upload: firmware read 24878 bytes.
[ 4898.875240] tda10048_firmware_upload: firmware uploading
[ 4902.996032] tda10048_firmware_upload: firmware uploaded
[ 4904.436023] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
[ 4904.436031] tda18271c2_rf_tracking_filters_correction: [1-0060|M] error -5 on line 266
[ 4904.525056] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x10, len = 1, i2c_transfer returned: -5
[ 4904.525066] tda18271_channel_configuration: [1-0060|M] error -5 on line 161
[ 4904.525076] tda18271_set_analog_params: [1-0060|M] error -5 on line 1046
[ 4904.659869] saa7134 ALSA driver for DMA sound loaded
[ 4904.659893] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[ 4904.659937] saa7133[0]/alsa: saa7133[0] at 0xf0500000 irq 18 registered as card -2
[ 4904.976052] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x1, len = 1, i2c_transfer returned: -5
[ 4905.409019] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x1, len = 7, i2c_transfer returned: -5
[ 4905.409028] tda18271_channel_configuration: [1-0060|M] error -5 on line 185
[ 4905.409037] tda18271_set_analog_params: [1-0060|M] error -5 on line 1046
[ 4905.512027] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
[ 4905.512036] tda18271_init: [1-0060|M] error -5 on line 831
[ 4905.512042] tda18271_tune: [1-0060|M] error -5 on line 909
[ 4905.512048] tda18271_set_analog_params: [1-0060|M] error -5 on line 1046
[ 4905.965028] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x1, len = 1, i2c_transfer returned: -5
[ 4906.004020] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x6, len = 1, i2c_transfer returned: -5

In particular the line "[ 4873.532293] saa7133[0]/ir: No I2C IR support for board 9c" is printed because in the big switch in the saa7134-input.c void saa7134_probe_i2c_ir() function there is no case for SAA7134_BOARD_HAUPPAUGE_HVR1120

lsmod output is :

Module                  Size  Used by
saa7134_alsa           10205  0 
tda10048               10627  1 
saa7134_dvb            23285  0 
videobuf_dvb            5096  1 saa7134_dvb
dvb_core               85914  1 videobuf_dvb
tda18271               51935  2 
tda8290                12149  2 
tuner                  20386  1 
ir_sony_decoder         3038  0 
ir_jvc_decoder          3065  0 
ir_rc6_decoder          3577  0 
saa7134               148243  2 saa7134_alsa,saa7134_dvb
ir_rc5_decoder          3161  0 
v4l2_common            17381  2 tuner,saa7134
videodev               42106  3 tuner,saa7134,v4l2_common
v4l1_compat            13251  1 videodev
videobuf_dma_sg         9666  3 saa7134_alsa,saa7134_dvb,saa7134
ir_nec_decoder          3193  0 
videobuf_core          16681  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_common               5123  1 saa7134
ir_core                13322  7 ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,saa7134,ir_rc5_decoder,ir_nec_decoder,ir_common
tveeprom               11038  1 saa7134
binfmt_misc             6587  1 
fbcon                  35102  71 
tileblit                2031  1 fbcon
font                    7557  1 fbcon
bitblit                 4707  1 fbcon
softcursor              1189  1 bitblit
snd_intel8x0           25588  0 
vga16fb                11385  0 
vgastate                8961  1 vga16fb
snd_ac97_codec        100646  1 snd_intel8x0
ac97_bus                1002  1 snd_ac97_codec
snd_pcm_oss            35308  0 
snd_mixer_oss          13746  1 snd_pcm_oss
snd_pcm                70662  4 saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_seq_dummy           1338  0 
snd_seq_oss            26726  0 
snd_seq_midi            4557  0 
snd_rawmidi            19056  1 snd_seq_midi
snd_seq_midi_event      6003  2 snd_seq_oss,snd_seq_midi
snd_seq                47263  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              19098  2 snd_pcm,snd_seq
snd_seq_device          5700  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    54148  11 saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
i915                  282354  3 
ppdev                   5259  0 
drm_kms_helper         29297  1 i915
soundcore               6620  1 snd
psmouse                63245  0 
intel_agp              24177  2 i915
parport_pc             25962  1 
drm                   162471  4 i915,drm_kms_helper
i2c_algo_bit            5028  1 i915
snd_page_alloc          7076  2 snd_intel8x0,snd_pcm
serio_raw               3978  0 
agpgart                31724  2 intel_agp,drm
video                  17375  1 i915
output                  1871  1 video
lp                      7028  0 
parport                32635  3 ppdev,parport_pc,lp
usbhid                 36110  0 
hid                    67032  1 usbhid
floppy                 53016  0 
tg3                   109292  0 

Obviously, no input device is created : the output of cat /proc/bus/input/devices is :

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
U: Uniq=
H: Handlers=kbd event0 
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
U: Uniq=
H: Handlers=kbd event1 
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/devices/virtual/input/input2
U: Uniq=
H: Handlers=mouse0 event2 
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input3
U: Uniq=
H: Handlers=kbd event3 
B: EV=120013
B: KEY=20000 200 20 0 0 0 0 500f 2100002 3803078 f900d401 feffffdf ffefffff ffffffff ffffffff
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=413c Product=3012 Version=0111
N: Name="Dell Dell USB Optical Mouse"
P: Phys=usb-0000:00:1d.0-1/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4
U: Uniq=
H: Handlers=mouse1 event4 
B: EV=17
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103
B: MSC=10

I tried to modify the source of the saa7134 driver, adding a case for SAA7134_BOARD_HAUPPAUGE_HVR1120 in the saa7134_probe_i2c_ir() of saa7134-input.c simply copying the case of HVR1110 and a dev->has_remote = dev->has_remote = SAA7134_REMOTE_I2C in saa7134_board_init1() in saa7134-cards.c. 

The "hg diff" patch is :

diff -r eb3a7341a233 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c    Wed May 26 11:58:10 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    Tue Jun 22 16:01:41 2010 +0200
@@ -7171,6 +7171,7 @@
         saa7134_set_gpio(dev, 22, 0);
         msleep(10);
         saa7134_set_gpio(dev, 22, 1);
+        dev->has_remote = SAA7134_REMOTE_I2C;
         break;
     /* i2c remotes */
     case SAA7134_BOARD_PINNACLE_PCTV_110i:
diff -r eb3a7341a233 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c    Wed May 26 11:58:10 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c    Tue Jun 22 16:01:41 2010 +0200
@@ -1081,6 +1081,19 @@
         info.addr = 0x71;
 #endif
         break;
+    case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+        snprintf(ir->c.name, sizeof(ir->c.name), "HVR 1120");
+        ir->get_key   = get_key_hvr1110;
+        ir->ir_codes  = RC_MAP_HAUPPAUGE_NEW;
+#else
+        dev->init_data.name = "HVR 1120";
+        dev->init_data.get_key = get_key_hvr1110;
+        dev->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
+        info.addr = 0x71;
+        break;
+#endif
+        
     case SAA7134_BOARD_BEHOLD_607FM_MK3:
     case SAA7134_BOARD_BEHOLD_607FM_MK5:
     case SAA7134_BOARD_BEHOLD_609FM_MK3:

The output of dmesg is :

[ 5605.151734] IR NEC protocol handler initialized
[ 5605.176622] Linux video capture interface: v2.00
[ 5605.178445] IR RC5(x) protocol handler initialized
[ 5605.191216] IR RC6 protocol handler initialized
[ 5605.199852] IR JVC protocol handler initialized
[ 5605.216743] saa7130/34: v4l2 driver version 0.2.16 loaded
[ 5605.216819] saa7133[0]: found at 0000:05:09.0, rev: 209, irq: 18, latency: 32, mmio: 0xf0500000
[ 5605.216833] saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1120 DVB-T/Hybrid [card=156,autodetected]
[ 5605.216968] saa7133[0]: board init: gpio is 440100
[ 5605.218287] IR Sony protocol handler initialized
[ 5605.240031] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[ 5605.388020] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[ 5605.388039] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[ 5605.388056] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
[ 5605.388073] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 5605.388090] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
[ 5605.388107] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388123] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388140] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388156] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 0c 17 64 f0 73 05 29 00
[ 5605.388173] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 29 8d 72 07 70 73 09
[ 5605.388189] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 45 72
[ 5605.388206] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 1e 00 00 00 00 00
[ 5605.388223] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388239] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388256] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388272] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5605.388352] tveeprom 1-0050: Hauppauge model 67209, rev C2F5, serial# 6559500
[ 5605.388357] tveeprom 1-0050: MAC address is 00:0d:fe:64:17:0c
[ 5605.388361] tveeprom 1-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[ 5605.388365] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ 5605.388370] tveeprom 1-0050: audio processor is SAA7131 (idx 41)
[ 5605.388373] tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
[ 5605.388377] tveeprom 1-0050: has radio, has IR receiver, has no IR transmitter
[ 5605.388380] saa7133[0]: hauppauge eeprom: model=67209
[ 5605.448148] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[ 5605.528017] tda829x 1-004b: setting tuner address to 60
[ 5605.578785] tda18271 1-0060: creating new instance
[ 5605.624019] TDA18271HD/C2 detected @ 1-0060
[ 5606.957014] tda18271: performing RF tracking filter calibration
[ 5625.164021] tda18271: RF tracking filter calibration complete
[ 5625.220020] tda829x 1-004b: type set to tda8290+18271
[ 5629.764016] Registered IR keymap rc-hauppauge-new
[ 5629.764160] input: i2c IR (HVR 1120) as /devices/virtual/rc/rc0/input8
[ 5629.764244] rc0: i2c IR (HVR 1120) as /devices/virtual/rc/rc0
[ 5629.764249] ir-kbd-i2c: i2c IR (HVR 1120) detected at i2c-1/1-0071/ir0 [saa7133[0]]
[ 5629.828251] saa7133[0]: registered device video0 [v4l2]
[ 5629.828917] saa7133[0]: registered device vbi0
[ 5629.829796] saa7133[0]: registered device radio0
[ 5629.889513] dvb_init() allocating 1 frontend
[ 5630.208024] tda829x 1-004b: type set to tda8290
[ 5630.296200] tda18271 1-0060: attaching existing instance
[ 5630.296207] DVB: registering new adapter (saa7133[0])
[ 5630.296215] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[ 5630.299061] tda10048_writereg: writereg error (ret == -5)
[ 5630.616020] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[ 5630.616032] saa7134 0000:05:09.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[ 5630.619451] tda10048_firmware_upload: firmware read 24878 bytes.
[ 5630.619457] tda10048_firmware_upload: firmware uploading
[ 5634.728040] tda10048_firmware_upload: firmware uploaded
[ 5636.240023] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x13, len = 1, i2c_transfer returned: -5
[ 5636.316054] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -5
[ 5636.316067] tda18271_set_analog_params: [1-0060|M] error -5 on line 1046
[ 5636.447436] saa7134 ALSA driver for DMA sound loaded
[ 5636.447454] IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[ 5636.447487] saa7133[0]/alsa: saa7133[0] at 0xf0500000 irq 18 registered as card -2
[ 5636.776027] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x1d, len = 1, i2c_transfer returned: -5
[ 5638.181058] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -5
[ 5638.181067] tda18271_ir_cal_init: [1-0060|M] error -5 on line 812
[ 5638.181071] tda18271_init: [1-0060|M] error -5 on line 836
[ 5638.181075] tda18271_tune: [1-0060|M] error -5 on line 909
[ 5638.181079] tda18271_set_analog_params: [1-0060|M] error -5 on line 1046
[ 5638.564034] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -5
[ 5638.668026] tda18271_write_regs: [1-0060|M] ERROR: idx = 0x1, len = 1, i2c_transfer returned: -5

However, Even if an input device seems to be discovered (line from [ 5629.764016] to [ 5629.764249] ), it doesn't give any output.
Since I'm totally unexpert about linux kernel drivers and low level programming, it doesn't work at all, because I surely made a mistake or I forgot to add something. 
Is there a way to let the card recognize the remote commander (or, more 
specifically, the sensor) ?

Best regards and apologize for the long mail,

Mario Latronico



      

