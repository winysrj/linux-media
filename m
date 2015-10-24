Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc2s22.hotmail.com ([65.55.111.97]:59198 "EHLO
	BLU004-OMC2S22.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbbJXLqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2015 07:46:48 -0400
Message-ID: <BLU437-SMTP75EA69B8FD8E0777BF81F2B7250@phx.gbl>
From: Mark <perkins1724@hotmail.com>
To: <linux-media@vger.kernel.org>
References: <BLU174-W49F3C92DAD1A9DF3E569CCB7250@phx.gbl>
In-Reply-To: <BLU174-W49F3C92DAD1A9DF3E569CCB7250@phx.gbl>
Subject: 5th and 6th Sony PlayTV DVB-T device always error (-23)
Date: Sat, 24 Oct 2015 22:16:52 +1030
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-au
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reposting from deprecated linux-dvb@linuxtv.org mail list.
*******
 
I'm having difficulties with 6 x Sony PlayTV DVB-T tuners. Essentially the
first 4 that get plugged in work perfectly fine - but the 5th and 6th return
an error "Sony PlayTV error while loading driver (-23)" and refuse to work
(and no red light on the DVB-T box).
 
It doesn't matter which port / device gets plugged in first / last, its
always the 5th and 6th one that don't work. I disabled xhci but same result.
I tried on Ubuntu 14.04 and Centos 7 but exact same result. I tried
unplugging every other USB device (keyboard and mouse) but no change. Most
troubleshooting has been on Ubuntu.
 
I created a modprobe.d conf file as follows but no change and didn't find
any new information.
 
$ cat /etc/modprobe.d/sony-playtv.conf
options dvb_usb debug=1
options dvb_usb disable_rc_polling=1
 
I have toggled pretty much every USB setting I can find in bios but always
the exact same result.
 
Have I come up against a limitation of the driver or a bug? Any guidance on
troubleshooting would be greatly appreciated.
 
Some further info below.
 
$ uname -a
Linux mythbackend-master 3.16.0-49-generic #65~14.04.1-Ubuntu SMP Wed Sep 9
10:03:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
 
$ lsusb
Bus 002 Device 002: ID 8087:8001 Intel Corp.
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 001
Device 002: ID 8087:8009 Intel Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub Bus 004
Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub Bus 003 Device 007:
ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision Technologies, Inc.
Bus 003 Device 006: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision
Technologies, Inc.
Bus 003 Device 005: ID 05e3:0745 Genesys Logic, Inc.
Bus 003 Device 004: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision
Technologies, Inc.
Bus 003 Device 003: ID 1415:0003 Nam Tai E&E Products Ltd. or OmniVision
Technologies, Inc.
Bus 003 Device 011: ID 046d:c227 Logitech, Inc. G15 Refresh Keyboard Bus 003
Device 010: ID 046d:c049 Logitech, Inc. G5 Laser Mouse Bus 003 Device 009:
ID 046d:c226 Logitech, Inc. G15 Refresh Keyboard Bus 003 Device 002: ID
046d:c223 Logitech, Inc. G11/G15 Keyboard / USB Hub Bus 003 Device 008: ID
8087:07dc Intel Corp.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
 
$dmesg
[  743.951183] usb 3-1: new high-speed USB device number 12 using xhci_hcd [
744.079673] usb 3-1: New USB device found, idVendor=1415, idProduct=0003 [
744.079680] usb 3-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3 [  744.079684] usb 3-1: Product: SCEH-0036 [  744.079687] usb
3-1: Manufacturer: SONY [  744.079690] usb 3-1: SerialNumber: ALR001LBTL [
744.080417] dvb-usb: found a 'Sony PlayTV' in cold state, will try to load a
firmware [  744.082984] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.20.fw'
[  744.148289] dib0700: firmware started successfully.
[  744.650966] dvb-usb: found a 'Sony PlayTV' in warm state.
[  744.651009] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[  744.651060] dvb-usb: Sony PlayTV error while loading driver (-23)

$ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/14p, 480M
    |__ Port 2: Dev 2, If 0, Class=Hub, Driver=hub/4p, 12M
        |__ Port 1: Dev 9, If 0, Class=Human Interface Device,
Driver=usbhid, 1.5M
        |__ Port 1: Dev 9, If 1, Class=Human Interface Device,
Driver=usbhid, 1.5M
        |__ Port 3: Dev 10, If 0, Class=Human Interface Device,
Driver=usbhid, 12M
        |__ Port 3: Dev 10, If 1, Class=Human Interface Device,
Driver=usbhid, 12M
        |__ Port 4: Dev 11, If 0, Class=Human Interface Device,
Driver=usbhid, 12M
    |__ Port 3: Dev 3, If 0, Class=Vendor Specific Class,
Driver=dvb_usb_dib0700, 480M
    |__ Port 4: Dev 4, If 0, Class=Vendor Specific Class,
Driver=dvb_usb_dib0700, 480M
    |__ Port 5: Dev 13, If 0, Class=Vendor Specific Class, Driver=, 480M
    |__ Port 6: Dev 5, If 0, Class=Mass Storage, Driver=usb-storage, 480M
    |__ Port 7: Dev 6, If 0, Class=Vendor Specific Class,
Driver=dvb_usb_dib0700, 480M
    |__ Port 8: Dev 7, If 0, Class=Vendor Specific Class,
Driver=dvb_usb_dib0700, 480M
    |__ Port 11: Dev 8, If 0, Class=Wireless, Driver=btusb, 12M
    |__ Port 11: Dev 8, If 1, Class=Wireless, Driver=btusb, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/2p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/8p, 480M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/2p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/6p, 480M
 
(only the 5th one plugged in here, 6th one unplugged hence why only 1
showing without driver loaded).

$ modinfo dvb-usb-dib0700
filename:
/lib/modules/3.16.0-49-generic/kernel/drivers/media/usb/dvb-usb/dvb-usb-dib0
700.ko
license:        GPL
version:        1.0
description:    Driver for devices based on DiBcom DiB0700 - USB bridge
author:         Patrick Boettcher <pboettcher@dibcom.fr>
firmware:       dvb-usb-dib0700-1.20.fw
srcversion:     1BD50D694E5FDD19CBCD02E
alias:          usb:v2013p025Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p025Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p003Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F9Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E6Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Dd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1660p1921d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v14F7p0004d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1BB4d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1BB2d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p2384d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1FA8d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p2383d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0011d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1FA0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0248d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0245d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1E59p0002d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d[0-2]*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d3[0-9A-E]*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1554p5010d3F00dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F90d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1F98d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp00ABd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E80d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p0248d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2013p0245d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0243d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1E8Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1EFCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp10A1d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp10A0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p60F6d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0020d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0FD9p0021d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p0871d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040pB210d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040pB200d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p2EDCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1415p0003d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0081d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0062d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Bd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p023Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p1736d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1F08d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1044p7002d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p8400d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p5200d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p6F01d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0078d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0060d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1164p1EDCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0237d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0236d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p022Ed*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp0058d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7080d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7070d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p173Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0B05p171Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v05D8p810Fd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1044p7001d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApB568d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v185Bp1E80d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0229d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EBEd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p0228d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EBCd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1EF0d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9580d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0CCDp005Ad*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2304p022Cd*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApB808d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7060d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v0413p6F00d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v1584p6003d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v185Bp1E78d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v07CApA807d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p7050d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9950d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v2040p9941d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E78d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v10B8p1E14d*dc*dsc*dp*ic*isc*ip*in*
depends:
dib7000m,dib7000p,dib8000,dibx000_common,dvb-usb,dib0090,dib0070,dib3000mc,r
c-core
intree:         Y
vermagic:       3.16.0-49-generic SMP mod_unload modversions
signer:         Magrathea: Glacier signing key
sig_key:        ED:CF:BF:81:5A:6E:CA:BE:5C:35:0D:4A:AF:8A:8B:80:AE:A6:16:B6
sig_hashalgo:   sha512
parm:           force_lna_activation:force the activation of
Low-Noise-Amplifyer(s) (LNA), if applicable for the device (default:
0=automatic/off). (int)
parm:           debug:set debugging level (1=info,2=fw,4=fwdata,8=data
(or-able)). (debugging is not enabled) (int)
parm:           nb_packet_buffer_size:Set the dib0700 driver data buffer
size. This parameter corresponds to the number of TS packets. The actual
size of the data buffer corresponds to this parameter multiplied by 188
(default: 21) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

