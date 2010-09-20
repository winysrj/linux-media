Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44903 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0ITSB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 14:01:59 -0400
Received: by fxm3 with SMTP id 3so855535fxm.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 11:01:58 -0700 (PDT)
Message-ID: <4C97A190.6060401@gmail.com>
Date: Mon, 20 Sep 2010 20:01:52 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: "jackc@RT" <jackc@realtek.com>, dtvfae@realtek.com,
	info@fitipower.com.tw, info@delock.de, janus.yeh@gigabyte.com.tw,
	help@lifeview.com.cn, europe@lifeview.it, support@lifeview.hk,
	sales@lifeview.hk, marketing@lifeview.hk, soporte@lifeview.es,
	ventas@lifeview.es, echo@consons.com, info@consons.com,
	dennis@consons.com, linux-media@vger.kernel.org, crope@iki.fi,
	jan-conceptronic@h-i-s.nl
Subject: Realtek RTL2832U & Fitipower FC0012
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi There,

This email is send to:
-Realtek
jackc@realtek.com
dtvfae@realtek.com
-Fitipower
info@fitipower.com.tw
-DeLOCK
info@delock.de
-GIGABYTE
janus.yeh@gigabyte.com.tw
-LifeView/Not Only TV
help@lifeview.com.cn
europe@lifeview.it
support@lifeview.hk
sales@lifeview.hk
marketing@lifeview.hk
soporte@lifeview.es
ventas@lifeview.es
-Consons
echo@consons.com
info@consons.com
dennis@consons.com
-Linux Media
linux-media@vger.kernel.org
-Antti Palosaari
crope@iki.fi
http://palosaari.fi/linux/
-Jan Hoogenraad
jan-conceptronic@h-i-s.nl

Hardware based on:
Realtek RTL2832U DVB-T demodulator-USB bridge & Fitipower FC0012 tuner:
-Realtek RTL2832U DVB-T COFDM Demodulator + USB 2.0
http://www.realtek.com/products/productsView.aspx?Langid=1&PFid=35&Level=4&Conn=3&ProdID=257
-Fitipower FC0012 tuner;
reference for Fitipower FC0011 tuner:
http://www.fitipower.com.tw/main.htm?pid=9&ID=57

Devices:
-DeLOCK USB 2.0 DVB-T Receiver 61744
http://www.delock.com/produkte/gruppen/Multimedia/Delock_USB_20_DVB-T_Receiver_61744.html
-LifeView/Not Only TV DVB-T USB DELUXE LV5TDELUXE
http://notonlytv.net/p_lv5tdeluxe.html
-GIGABYTE USB Digital TV Dongle U7300
http://www.giga-byte.com/products/product-page.aspx?pid=3493#sp
-Consons USB ISDB-T Dongle CN601B and CN602B
http://www.consons.com/products_show.asp?id=74
http://consons.componentpurchasing.com/product_1028812122.html

Problem:
Tuner NONfunctional!

Reference links:
http://www.sandberg.it/support/product.aspx?id=133-59
http://www.turnovfree.net/~stybla/linux/v4l-dvb/lv5tdlx/
http://www.linuxquestions.org/questions/linux-hardware-18/strange-problem-with-dvb-t-stick-814673/

uname-r:
2.6.35.4-12.el6.i686.PAE

lsusb:
Bus 002 Device 002: ID 1f4d:b803 G-Tek Electronics Group Lifeview 
LV5TDLX DVB-T [RTL2832U]

modinfo dvb_usb_rtl2832u:
filename: 
/lib/modules/2.6.35.4-12.el6.i686.PAE/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2832u.ko
license:        GPL
version:        1.4.2
description:    Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device
author:         Realtek
srcversion:     CF50FDD3D3369A374AE857B
alias:          usb:v1554p5020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1554p5013d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpA803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1104d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2834d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2839d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2836d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4Dp0837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD398d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD397d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3282d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3234d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1164p6601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1680pA332d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1103d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1102d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD396d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3274d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2832d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb
vermagic:       2.6.35.4-12.el6.i686.PAE SMP mod_unload 686
parm:           debug:Set debugging level (1=info,xfer=2 (or-able)). (int)
parm:           demod:Set default demod type(0=dvb-t, 1=dtmb) (int)
parm:           dtmb_err_discard:Set error packet discard type(0=not 
discard, 1=discard) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

ref. modprobe.d/files options:
options dvb-core frontend_debug=1 debug=1 dvbdev_debug=1
options dvb-usb debug=511
options dvb_usb_rtl2832u debug=1

<DMESG>
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: New USB device found, idVendor=1f4d, idProduct=b803
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: RTL2838UHIDIR
usb 2-1: Manufacturer: Realtek
usb 2-1: SerialNumber: 00000041
...
check for warm bda 2832
check for warm 13d3 3274
check for warm 1b80 d396
check for warm 1d19 1101
check for warm 1d19 1102
check for warm 1d19 1103
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm bda 2838
check for warm 1680 a332
check for warm 1164 6601
check for warm 13d3 3234
check for warm 13d3 3282
check for warm 1b80 d397
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm 1b80 d393
check for warm 1b80 d398
check for warm 1f4d 837
check for warm bda 2836
check for warm bda 2839
check for warm bda 2834
check for warm bda 2837
check for warm 1b80 d394
check for warm 1d19 1104
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm 1f4d a803
check for warm 1f4d b803
dvb-usb: found a 'USB DVB-T Device' in warm state.
power control: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
all in all I will use 40960 bytes for streaming
allocating buffer 0
buffer 0: f4db8000 (dma: 886800384)
allocating buffer 1
buffer 1: f4dbb000 (dma: 886812672)
allocating buffer 2
buffer 2: f4db9000 (dma: 886804480)
allocating buffer 3
buffer 3: f4dba000 (dma: 886808576)
allocating buffer 4
buffer 4: f4d2e000 (dma: 886235136)
allocating buffer 5
buffer 5: f4dc0000 (dma: 886833152)
allocating buffer 6
buffer 6: f4dbf000 (dma: 886829056)
allocating buffer 7
buffer 7: f4d29000 (dma: 886214656)
allocating buffer 8
buffer 8: f4c94000 (dma: 885604352)
allocating buffer 9
buffer 9: f4c95000 (dma: 885608448)
allocation successful
DVB: registering new adapter (USB DVB-T Device)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
+rtl2832u_fe_attach
-rtl2832u_fe_attach
dvb_register_frontend
DVB: registering adapter 0 frontend 0 (Realtek RTL2832 DVB-T  RTL2836 
DTMB)...
DVB: register adapter0/frontend0 @ minor: 3 (0x03)
power control: 0
dvb-usb: USB DVB-T Device successfully initialized and connected.
check for warm bda 2832
check for warm 13d3 3274
check for warm 1b80 d396
check for warm 1d19 1101
check for warm 1d19 1102
check for warm 1d19 1103
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm bda 2838
check for warm 1680 a332
check for warm 1164 6601
check for warm 13d3 3234
check for warm 13d3 3282
check for warm 1b80 d397
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm 1b80 d393
check for warm 1b80 d398
check for warm 1f4d 837
check for warm bda 2836
check for warm bda 2839
check for warm bda 2834
check for warm bda 2837
check for warm 1b80 d394
check for warm 1d19 1104
something went very wrong, device was not found in current device list - 
let's see what comes next.
check for warm 1f4d a803
check for warm 1f4d b803
dvb-usb: found a 'USB DVB-T Device' in warm state.
power control: 1
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
all in all I will use 40960 bytes for streaming
allocating buffer 0
buffer 0: f5cf9000 (dma: 902795264)
allocating buffer 1
buffer 1: f6202000 (dma: 908075008)
allocating buffer 2
buffer 2: f4da0000 (dma: 886702080)
allocating buffer 3
buffer 3: f4da1000 (dma: 886706176)
allocating buffer 4
buffer 4: f4da2000 (dma: 886710272)
allocating buffer 5
buffer 5: f4da3000 (dma: 886714368)
allocating buffer 6
buffer 6: f4da4000 (dma: 886718464)
allocating buffer 7
buffer 7: f4da5000 (dma: 886722560)
allocating buffer 8
buffer 8: f4da6000 (dma: 886726656)
allocating buffer 9
buffer 9: f4da7000 (dma: 886730752)
allocation successful
DVB: registering new adapter (USB DVB-T Device)
DVB: register adapter1/demux0 @ minor: 4 (0x04)
DVB: register adapter1/dvr0 @ minor: 5 (0x05)
DVB: register adapter1/net0 @ minor: 6 (0x06)
+rtl2832u_fe_attach
-rtl2832u_fe_attach
dvb_register_frontend
DVB: registering adapter 1 frontend 0 (Realtek RTL2832 DVB-T  RTL2836 
DTMB)...
DVB: register adapter1/frontend0 @ minor: 7 (0x07)
power control: 0
dvb-usb: USB DVB-T Device successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_rtl2832u
   <DMESG-TUNING>
     <USERLAND-TUNING>
        tzap -a0 -c channels.conf "RTL TV"
       using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
       reading channels from file 'channels.conf'
       tuning to 570000000 Hz
       video pid 0x012d, audio pid 0x012e
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       status 00 | signal 0000 | snr 0000 | ber 0000ffff | unc 00000000 |
       ^C
        scan -a0 dvbt-57
       scanning dvbt-57
       using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
       initial transponder 570000000 0 3 9 3 1 3 0
       >>> tune to: 
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
       WARNING: >>> tuning failed!!!
       >>> tune to: 
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
       WARNING: >>> tuning failed!!!
       ERROR: initial tuning failed
       dumping lists (0 services)
       Done.
     </USERLAND-TUNING>
dvb_frontend_open
   rtl2832_ts_bus_ctrl : Do Nothing
dvb_frontend_start
dvb_frontend_ioctl (61)
dvb_frontend_thread
DVB: initialising adapter 0 frontend 0 (Realtek RTL2832 DVB-T  RTL2836 
DTMB)...
power control: 1
  +rtl2832_init
  +usb_init_setting
  +usb_init_bulk_setting
HIGH SPEED
  -usb_init_bulk_setting
  +usb_epa_fifo_reset
  -usb_epa_fifo_reset
  -usb_init_setting
  +gpio3_out_setting
  -gpio3_out_setting
  +demod_ctl1_setting
  -demod_ctl1_setting
  +suspend_latch_setting
  -suspend_latch_setting
  +demod_ctl_setting
  -demod_ctl_setting
  +set_tuner_power
  -set_tuner_power
  +check_tuner_type
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=1, 
offset=0x0, data=(0x86,)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xac, len=1, 
offset=0x1, data=(0x86,)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=2, 
offset=0x7e, data=(0x86,0x2,)
error try= 1!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 2!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 3!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 4!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 5!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 1!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 2!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 3!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 4!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 5!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
  -check_tuner_type : FC0012 tuner on board...
  +check_dtmb_support
  +set_demod_2836_power  onoff = 1
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0xfa,)
  -set_demod_2836_power  onoff = 1 fail
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=2, page=5, 
offset=0x10, data=(0x8d,0xfa,)
  -check_dtmb_support  RTL2836 NOT FOUND.....
  +set_demod_2836_power  onoff = 0
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0xfa,)
  -set_demod_2836_power  onoff = 0 fail
demod_type is 0
  +build_nim_module
  -build_nim_module
  +demod_init_setting
demod_init_setting for RTL2832
  -demod_init_setting
  -rtl2832_init
  +rtl2832_update_functions
   rtl2832_update_functions no need
  -rtl2832_update_functions
dvb_frontend_ioctl (76)
   rtl2832_get_tune_settings : Do Nothing
dvb_frontend_add_event
start pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'on'
submitting all URBs
submitting URB no. 0
submitting URB no. 1
submitting URB no. 2
submitting URB no. 3
submitting URB no. 4
submitting URB no. 5
submitting URB no. 6
submitting URB no. 7
submitting URB no. 8
submitting URB no. 9
controlling pid parser
start feeding
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:0 started_auto_step:0
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
  -check_dvbt_reset_parameters
start pid: 0x012e, feedtype: 0
setting pid (no):   302 012e at index 1 'on'
dvb_frontend_ioctl (69)
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 1
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 11
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:1 
auto_sub_step:0 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:1 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:2 
auto_sub_step:0 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 11
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:2 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 11
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:3 
auto_sub_step:0 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 11
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:3 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 12
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:4 
auto_sub_step:0 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:4 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_ioctl (71)
   rtl2832_read_signal_strength : strength = 0x0
dvb_frontend_ioctl (72)
   rtl2832_read_snr : snr = 0
dvb_frontend_ioctl (70)
   rtl2832_read_ber : ber = 0xffff
dvb_frontend_ioctl (73)
   rtl2832_read_signal_quality : quality = 0x0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_release
   rtl2832_ts_bus_ctrl : Do Nothing
stop pid: 0x012d, feedtype: 0
setting pid (no):   301 012d at index 0 'off'
stop pid: 0x012e, feedtype: 0
stop feeding
killing URB no. 0.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 1.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 2.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 3.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 4.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 5.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 6.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 7.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 8.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
killing URB no. 9.
'bulk' urb completed. status: -2, length: 0/4096, pack_num: 0, errors: 0
setting pid (no):   302 012e at index 1 'off'
  +rtl2832_sleep
  +demod_ctl1_setting
  -demod_ctl1_setting
  +set_tuner_power
  -set_tuner_power
  +demod_ctl_setting
  -demod_ctl_setting
  +set_demod_2836_power  onoff = 0
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0x0,)
  -set_demod_2836_power  onoff = 0 fail
  -rtl2832_sleep
power control: 0
dvb_frontend_open
   rtl2832_ts_bus_ctrl : Do Nothing
dvb_frontend_start
dvb_frontend_ioctl (61)
dvb_frontend_thread
DVB: initialising adapter 0 frontend 0 (Realtek RTL2832 DVB-T  RTL2836 
DTMB)...
power control: 1
  +rtl2832_init
  +usb_init_setting
  +usb_init_bulk_setting
HIGH SPEED
  -usb_init_bulk_setting
  +usb_epa_fifo_reset
  -usb_epa_fifo_reset
  -usb_init_setting
  +gpio3_out_setting
  -gpio3_out_setting
  +demod_ctl1_setting
  -demod_ctl1_setting
  +suspend_latch_setting
  -suspend_latch_setting
  +demod_ctl_setting
  -demod_ctl_setting
  +set_tuner_power
  -set_tuner_power
  +check_tuner_type
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=1, 
offset=0x0, data=(0x86,)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xac, len=1, 
offset=0x1, data=(0x86,)
error!! read_rtl2832_tuner_register: ret=-32, DA=0xc0, len=2, 
offset=0x7e, data=(0x86,0x2,)
error try= 1!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 2!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 3!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 4!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 5!! write_rtl2832_stdi2c: ret=-32, DA=0xc0, len=2, 
data=(0xfb,0xd9,)
error try= 1!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 2!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 3!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 4!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
error try= 5!! read_rtl2832_stdi2c: ret=-32, DA=0xc0, len=1, data=(0xc9,)
  -check_tuner_type : FC0012 tuner on board...
  +check_dtmb_support
  +set_demod_2836_power  onoff = 1
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0xfa,)
  -set_demod_2836_power  onoff = 1 fail
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=2, page=5, 
offset=0x10, data=(0x8d,0xfa,)
  -check_dtmb_support  RTL2836 NOT FOUND.....
  +set_demod_2836_power  onoff = 0
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0xfa,)
  -set_demod_2836_power  onoff = 0 fail
demod_type is 0
  +build_nim_module
  -build_nim_module
  +demod_init_setting
demod_init_setting for RTL2832
  -demod_init_setting
  -rtl2832_init
  +rtl2832_update_functions
   rtl2832_update_functions no need
  -rtl2832_update_functions
dvb_frontend_ioctl (76)
   rtl2832_get_tune_settings : Do Nothing
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:0 started_auto_step:0
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 1
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = 12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 12
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 13
dvb_frontend_ioctl (76)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 13
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:1 
auto_sub_step:0 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
   rtl2832_get_tune_settings : Do Nothing
dvb_frontend_add_event
dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:0 
auto_sub_step:0 started_auto_step:0
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = 12
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 19616
rtl2832_read_status : snr = 11
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:0 
auto_sub_step:1 started_auto_step:0
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
dvb_frontend_ioctl (69)
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
  -rtl2832_update_functions
dvb_frontend_ioctl (69)
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
  +rtl2832_update_functions
dvb_frontend_release
   rtl2832_ts_bus_ctrl : Do Nothing
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
  -rtl2832_update_functions
rtl2832_read_status :******Signal Lock=0******
rtl2832_read_status : ber_num = 65535
rtl2832_read_status : snr = -12
dvb_frontend_swzigzag_autotune: drift:0 inversion:1 auto_step:1 
auto_sub_step:0 started_auto_step:0
  +rtl2832_set_parameters frequency = 570000000 , bandwidth = 0
  +check_dvbt_reset_parameters
  -check_dvbt_reset_parameters
   rtl2832_set_parameters : ****** Signal Present = 0 ******
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update first
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: current LnaGain = 2
rtl2832_fc0012_UpdateTunerLnaGainWithRssi: next LnaGain = 2
rtl2832_set_parameters : fc0012/e4000 update 2nd
  -rtl2832_set_parameters
  +rtl2832_update_functions
  -rtl2832_update_functions
  +rtl2832_sleep
  +demod_ctl1_setting
  -demod_ctl1_setting
  +set_tuner_power
  -set_tuner_power
  +demod_ctl_setting
  -demod_ctl_setting
  +set_demod_2836_power  onoff = 0
error!! read_rtl2832_demod_register: ret=-32, DA=0x3e, len=1, page=0, 
offset=0x1, data=(0x0,)
  -set_demod_2836_power  onoff = 0 fail
  -rtl2832_sleep
power control: 0
  +rtl2832_update_functions
   rtl2832_update_functions no need
  -rtl2832_update_functions
  +rtl2832_update_functions
...
   rtl2832_update_functions no need
  -rtl2832_update_functions
  +rtl2832_update_functions
   rtl2832_update_functions no need
  -rtl2832_update_functions
   </DMESG-TUNING>
</DMESG>

Thanks for any help
Greetings to everybody
poma

