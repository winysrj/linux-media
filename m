Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54962 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1KVGwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 01:52:36 -0500
Received: by fagn18 with SMTP id n18so70365fag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 22:52:34 -0800 (PST)
Date: Tue, 22 Nov 2011 16:52:28 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@stefanringel.de>,
	linux-media@vger.kernel.org
Subject: Re: good programm for FM radio
Message-ID: <20111122165228.351591fa@glory.local>
In-Reply-To: <4EC53C21.5030206@stefanringel.de>
References: <20111115174052.1dee9737@glory.local>
	<4EC3CE52.2000408@arcor.de>
	<20111117122904.3035d63c@glory.local>
	<4EC53C21.5030206@stefanringel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I switch back to worked 2.6.38rc2 and write working start helper for gnomeradio:

#!/bin/sh
sox -q -c 2 -s -r 48000 -t alsa hw:1,0 -t alsa hw:0,0 rate -s -a 44100 dither -s &
gnomeradio
wait gnomeradio
t=`pidof sox`;
kill $t;

It works with dmesg

startup tm6000 and tm6000-alsa
[  103.816270] tm6000: Found Beholder Wander DVB-T/TV/FM USB2.0
[  103.818751] lirc_dev: IR Remote Control driver registered, major 252 
[  103.819789] IR LIRC bridge handler initialized
[  103.822010] Found tm6010
[  104.573019] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 00 40 00 60 c0 de  BYTE.......@.`..
[  104.685017] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 28 03 42 00 65 00 68 00 6f 00  ... @.(.B.e.h.o.
[  104.797017] tm6000 #0: i2c eeprom 20: 6c 00 64 00 65 00 72 00 20 00 49 00 6e 00 74 00  l.d.e.r. .I.n.t.
[  104.909018] tm6000 #0: i2c eeprom 30: 6c 00 2e 00 20 00 4c 00 74 00 64 00 2e 00 ff ff  l... .L.t.d.....
[  105.021016] tm6000 #0: i2c eeprom 40: 22 03 42 00 65 00 68 00 6f 00 6c 00 64 00 20 00  ".B.e.h.o.l.d. .
[  105.133018] tm6000 #0: i2c eeprom 50: 54 00 56 00 20 00 57 00 61 00 6e 00 64 00 65 00  T.V. .W.a.n.d.e.
[  105.245016] tm6000 #0: i2c eeprom 60: 72 00 ff ff ff ff ff ff ff ff 1a 03 56 00 69 00  r...........V.i.
[  105.357016] tm6000 #0: i2c eeprom 70: 64 00 65 00 6f 00 43 00 61 00 70 00 74 00 75 00  d.e.o.C.a.p.t.u.
[  105.469015] tm6000 #0: i2c eeprom 80: 72 00 65 00 ff ff ff ff ff ff ff ff ff ff ff ff  r.e.............
[  105.581016] tm6000 #0: i2c eeprom 90: ff ff ff ff 16 03 30 00 30 00 30 00 30 00 30 00  ......0.0.0.0.0.
[  105.693013] tm6000 #0: i2c eeprom a0: 30 00 32 00 30 00 34 00 31 00 ff ff ff ff ff ff  0.2.0.4.1.......
[  105.805017] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  105.917015] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  106.029017] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  106.141018] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  106.253017] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  106.358018]   ................
[  106.361883] i2c-core: driver [tuner] using legacy suspend method
[  106.361886] i2c-core: driver [tuner] using legacy resume method
[  106.361985] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[  106.386950] xc5000 7-0061: creating new instance
[  106.413017] xc5000: Successfully identified at address 0x61
[  106.413021] xc5000: Firmware has not been loaded previously
[  106.465014] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  106.512117] xc5000: firmware read 12401 bytes.
[  106.512121] xc5000: firmware uploading...
[  113.187010] xc5000: firmware upload complete...
[  114.698098] tm6000 #0: registered device video0
[  114.698144] tm6000 #0: registered device radio0
[  114.698148] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[  114.698177] usbcore: registered new interface driver tm6000
[  114.708931] b switch
[  114.708934] tm6000: open called (dev=radio0)
[  114.708935] b user
[  114.708936] b kzalloc
[  114.708937] b private
[  114.708939] b get_res
[  114.708940] b init_analog
[  114.905013] tm6000_set_standard start
[  114.905018] tm6000_config_video_input start
[  114.947015] tm6000_config_video_input stop
[  114.947019] tm6000_config_video_std start
[  115.217014] tm6000_config_video_std stop
[  115.217018] tm6000_set_audio_std start
[  115.301014] b if analog_mode
[  115.301019] b vmalloc_init
[  115.301022] b init_demdec
[  115.355016] b if radio
[  115.443016] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  115.445486] xc5000: firmware read 12401 bytes.
[  115.445488] xc5000: firmware uploading...
[  122.120011] xc5000: firmware upload complete...
[  122.730644] video open stop OK
[  122.730673] b switch
[  122.730677] tm6000: open called (dev=video0)
[  122.730678] b user
[  122.730679] b kzalloc
[  122.730683] b private
[  122.730684] b get_res
[  122.730686] b init_analog
[  122.926013] tm6000_set_standard start
[  122.926018] tm6000_config_video_input start
[  122.968012] tm6000_config_video_input stop
[  122.968016] tm6000_config_video_std start
[  123.238011] tm6000_config_video_std stop
[  123.238016] tm6000_set_audio_std start
[  123.280020] tm6000_set_audio_std stop
[  123.280024] tm6000_set_standard stop
[  123.292012] b if analog_mode
[  123.292014] b vmalloc_init
[  123.292016] b init_demdec
[  123.346011] b if radio
[  123.382010] video open stop OK
[  123.389577] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.395318] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.401067] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.406824] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.412571] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.418320] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.424069] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.429819] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  123.429845] b switch
[  123.429848] tm6000: open called (dev=radio0)
[  123.429851] b user
[  123.429853] b kzalloc
[  123.429856] b private
[  123.429859] b get_res
[  123.429861] b init_analog
[  123.626015] tm6000_set_standard start
[  123.626020] tm6000_config_video_input start
[  123.668015] tm6000_config_video_input stop
[  123.668019] tm6000_config_video_std start
[  123.938015] tm6000_config_video_std stop
[  123.938020] tm6000_set_audio_std start
[  124.028013] b if analog_mode
[  124.028017] b vmalloc_init
[  124.028020] b init_demdec
[  124.082013] b if radio
[  124.170015] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  124.172367] xc5000: firmware read 12401 bytes.
[  124.172369] xc5000: firmware uploading...
[  130.847011] xc5000: firmware upload complete...
[  131.457666] video open stop OK
[  131.457697] b switch
[  131.457701] tm6000: open called (dev=video0)
[  131.457703] b user
[  131.457704] b kzalloc
[  131.457706] b private
[  131.457708] b get_res
[  131.457709] b init_analog
[  131.654014] tm6000_set_standard start
[  131.654019] tm6000_config_video_input start
[  131.696011] tm6000_config_video_input stop
[  131.696015] tm6000_config_video_std start
[  131.966010] tm6000_config_video_std stop
[  131.966015] tm6000_set_audio_std start
[  132.008012] tm6000_set_audio_std stop
[  132.008016] tm6000_set_standard stop
[  132.020009] b if analog_mode
[  132.020013] b vmalloc_init
[  132.020016] b init_demdec
[  132.074008] b if radio
[  132.110009] video open stop OK
[  132.116575] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.122326] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.128076] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.133824] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.139572] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.145322] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.151074] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  132.156822] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

start sox
[  323.437113] ALSA sound/pci/hda/hda_intel.c:1678: azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  323.437124] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  323.437128] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  323.437131] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  323.437135] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  323.437138] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  323.437151] ALSA sound/pci/hda/hda_intel.c:1678: azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  323.437157] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  323.437160] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  323.437164] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  323.437167] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  323.437170] ALSA sound/pci/hda/hda_codec.c:1227: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  323.439078] tm6000 #0/1: starting capture
[  323.439081] tm6000 #0/1: Starting audio DMA
[  323.439082] start audio DMA
[  323.489736] b switch

start gnomeradio
[  323.489739] tm6000: open called (dev=radio0)
[  323.489741] b user
[  323.489742] b kzalloc
[  323.489743] b private
[  323.489744] b get_res
[  323.489746] b init_analog
[  323.686016] tm6000_set_standard start
[  323.686021] tm6000_config_video_input start
[  323.728015] tm6000_config_video_input stop
[  323.728020] tm6000_config_video_std start
[  323.998014] tm6000_config_video_std stop
[  323.998018] tm6000_set_audio_std start
[  324.082015] b if analog_mode
[  324.082018] b vmalloc_init
[  324.082022] b init_demdec
[  324.136013] b if radio
[  324.226015] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  324.228601] xc5000: firmware read 12401 bytes.
[  324.228604] xc5000: firmware uploading...
[  330.903011] xc5000: firmware upload complete...
[  331.493714] video open stop OK
[  331.508657] tm6000 #0/1: Copying 180 bytes at f81f6000[0] - buf size=16384 x 4
[  331.508671] tm6000 #0/1: Copying 180 bytes at f81f6000[45] - buf size=16384 x 4
<snip>
[  332.238940] tm6000 #0/1: Copying 180 bytes at f81f6000[2467] - buf size=16384 x 4
[  332.238948] tm6000 #0/1: Copying 180 bytes at f81f6000[2512] - buf size=16384 x 4

stop
[  332.244655] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  332.250401] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

This dmesg of 3.10

init tm6000
[  148.482448] tm6000: New video device @ 480 Mbps (6000:dec0, ifnum 0)
[  148.482452] tm6000: Found Beholder Wander DVB-T/TV/FM USB2.0
[  148.488018] Found tm6010
[  149.149012] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 00 40 00 60 c0 de  BYTE.......@.`..
[  149.261015] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 28 03 42 00 65 00 68 00 6f 00  ... @.(.B.e.h.o.
[  149.373018] tm6000 #0: i2c eeprom 20: 6c 00 64 00 65 00 72 00 20 00 49 00 6e 00 74 00  l.d.e.r. .I.n.t.
[  149.485016] tm6000 #0: i2c eeprom 30: 6c 00 2e 00 20 00 4c 00 74 00 64 00 2e 00 ff ff  l... .L.t.d.....
[  149.597012] tm6000 #0: i2c eeprom 40: 22 03 42 00 65 00 68 00 6f 00 6c 00 64 00 20 00  ".B.e.h.o.l.d. .
[  149.709023] tm6000 #0: i2c eeprom 50: 54 00 56 00 20 00 57 00 61 00 6e 00 64 00 65 00  T.V. .W.a.n.d.e.
[  149.821016] tm6000 #0: i2c eeprom 60: 72 00 ff ff ff ff ff ff ff ff 1a 03 56 00 69 00  r...........V.i.
[  149.933017] tm6000 #0: i2c eeprom 70: 64 00 65 00 6f 00 43 00 61 00 70 00 74 00 75 00  d.e.o.C.a.p.t.u.
[  150.045016] tm6000 #0: i2c eeprom 80: 72 00 65 00 ff ff ff ff ff ff ff ff ff ff ff ff  r.e.............
[  150.157015] tm6000 #0: i2c eeprom 90: ff ff ff ff 16 03 30 00 30 00 30 00 30 00 30 00  ......0.0.0.0.0.
[  150.269017] tm6000 #0: i2c eeprom a0: 30 00 32 00 30 00 34 00 31 00 ff ff ff ff ff ff  0.2.0.4.1.......
[  150.381015] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  150.493020] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  150.605014] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  150.717068] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  150.829016] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
[  150.947831] i2c-core: driver [tuner] using legacy suspend method
[  150.947834] i2c-core: driver [tuner] using legacy resume method
[  150.947929] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[  150.947935] xc5000 7-0061: creating new instance
[  150.975017] xc5000: Successfully identified at address 0x61
[  150.975022] xc5000: Firmware has not been loaded previously
[  151.029016] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  151.073138] xc5000: firmware read 12401 bytes.
[  151.073142] xc5000: firmware uploading...
[  157.748013] xc5000: firmware upload complete...
[  159.265089] tm6000 #0: registered device video0
[  159.265127] tm6000 #0: registered device radio0
[  159.265131] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
[  159.265162] usbcore: registered new interface driver tm6000
[  159.286652] tm6000: open called (dev=radio0)
[  160.405650] tm6000: open called (dev=video0)
[  160.972536] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  160.978302] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  160.984046] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  160.989794] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  160.995547] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  161.001294] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  161.007043] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  161.012794] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  161.012824] tm6000: open called (dev=video0)
[  161.581027] tm6000: open called (dev=radio0)
[  162.544555] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.550298] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.556045] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.561796] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.567544] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.573294] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.579045] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  162.584792] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  173.089014] tm6000_alsa: module is from the staging directory, the quality is unknown, you have been warned.
[  173.089549] tm6000 #0/1: Registered audio driver for TM5600/60x0 Audio at bus 1 device 2
[  173.089552] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[  173.135619] pcm_open start
[  173.135623] pcm_open stop
[  173.135768] pcm_open start
[  173.135770] pcm_open stop
[  173.135902] pcm_open start
[  173.135904] pcm_open stop
[  173.136310] pcm_open start
[  173.136313] pcm_open stop
[  173.136787] pcm_open start
[  173.136789] pcm_open stop
[  173.136863] hw_params start
[  173.136865] tm6000 #0/1: Allocating buffer
[  173.136889] hw_params stop
[  173.138614] pcm_open start
[  173.138617] pcm_open stop
[  173.138674] hw_params start
[  173.138676] tm6000 #0/1: Allocating buffer
[  173.138710] hw_params stop
[  173.142328] tm6000 #0/1: starting capture
[  173.142331] tm6000 #0/1: Starting audio DMA
[  178.148086] tm6000 #0/1: stopping capture
[  178.148089] tm6000 #0/1: Stopping audio DMA

start sox
[  274.408792] pcm_open start
[  274.408796] pcm_open stop
[  274.408906] hw_params start
[  274.408908] tm6000 #0/1: Allocating buffer
[  274.408926] hw_params stop
[  274.409177] ALSA sound/pci/hda/hda_intel.c:1732 azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  274.409186] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  274.409190] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  274.409193] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  274.409197] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  274.409200] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  274.409212] ALSA sound/pci/hda/hda_intel.c:1732 azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  274.409218] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  274.409221] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  274.409224] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  274.409227] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  274.409230] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  274.410454] tm6000 #0/1: starting capture
[  274.410456] tm6000 #0/1: Starting audio DMA

start gnomeradio
[  276.506669] tm6000: open called (dev=radio0)
[  277.574636] vidioc_s_frequency
[  284.410077] ALSA sound/core/pcm_lib.c:1805 capture write error (DMA or IRQ trouble?)
[  284.410328] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x2
[  284.410331] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x3
[  284.410333] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x4
[  284.410335] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x5
[  284.410338] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x6
[  284.410346] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x2
[  284.410349] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x3
[  284.410351] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x4
[  284.410353] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x5
[  284.410688] tm6000 #0/1: stopping capture
[  284.410690] tm6000 #0/1: Stopping audio DMA
[  307.497609] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.503346] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.509114] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.514856] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.520607] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.526359] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.532105] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  307.537856] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

As I understood DMA and audio not started without opening /dev/radio0

With my best regards, Dmitry.

On Thu, 17 Nov 2011 17:53:53 +0100
Stefan Ringel <stefan.ringel@stefanringel.de> wrote:


> Am 17.11.2011 03:29, schrieb Dmitri Belimov:
> > Hi
> >
> > kradio from Debian Squeeze 0.1.1.1-20061112-4 with KDE 4.4.5
> > doesn't work. It wants V4L1 API.
> >
> > I think the tm6000-alsa has some problem with alsa compatibility.
> > This log when start gnomeradio with arecord helper
> >
> > [ 2198.067414] pcm_open start
> > [ 2198.067417] pcm_open stop
> > [ 2198.067554] hw_params start
> > [ 2198.067556] tm6000 #0/1: Allocating buffer

<snip>

> > Copying 180 bytes at f8264000[135] - buf size=48000 x 4
> > [  531.394114] tm6000 #0/1: Copying 180 bytes at f8264000[180] -
> > buf size=48000 x 4
> >
> >> Am 15.11.2011 08:40, schrieb Dmitri Belimov:
> >>> Hi
> >>>
> >>> Right now the gnomeradio don't work with tm6000 USB stick. No any
> >>> audio. I try use this script:
> >>>
> >>> #!/bin/sh
> >>>
> >>> if [ -f /usr/bin/arecord ]; then
> >>> arecord -q -D hw:1,0 -r 48000 -c 2 -f S16_LE | aplay -q -&
> >>> fi
> >>>
> >>> if [ -f /usr/bin/gnomeradio ]; then
> >>> gnomeradio -f 102.6
> >>> fi
> >>>
> >>> pid=`pidof arecord`
> >>>
> >>> if [ $pid ]; then
> >>> kill -9 $pid
> >>> fi
> >>>
> >>> But arecord return input/output error.
> >>> Anyone know good programm for FM radio worked with v4l2 and alsa??
> >>> I can't understand tm6000 work with FM radio or not.
> >>>
> >>> With my best regards, Dmitry.
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe
> >>> linux-media" in the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Dmitri, have you test kradio4 (it can v4l2)?
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Kradio4 can both v4l1 and v4l2. You must configure it in the
> properties.


With my best regards, Dmitry.
