Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41099 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2ETREp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 13:04:45 -0400
Received: by bkcji2 with SMTP id ji2so3358511bkc.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 10:04:43 -0700 (PDT)
Message-ID: <4FB92428.3080201@gmail.com>
Date: Sun, 20 May 2012 19:04:40 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: rtl28xxu - rtl2832 frontend attach
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Heigh ho, heigh ho
To make your troubles go
Just keep on singing
All day long, heigh ho
Heigh ho!

After hard/cold boot:
[…]
usb 1-1: new high-speed USB device number 2 using ehci_hcd
usb 1-1: New USB device found, idVendor=1f4d, idProduct=b803
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: RTL2838UHIDIR
usb 1-1: Manufacturer: Realtek
usb 1-1: SerialNumber: 00000041
rtl28xxu_module_init:
rtl28xxu_probe: interface=0
check for warm bda 2831
check for warm 14aa 160
check for warm 14aa 161
something went very wrong, device was not found in current device list -
let's see what comes next.
check for warm ccd a9
check for warm 1f4d b803
dvb-usb: found a 'G-Tek Electronics Group Lifeview LV5TDLX DVB-T' in
warm state.
power control: 1
rtl2832u_power_ctrl: onoff=1
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
all in all I will use 24576 bytes for streaming
DVB: registering new adapter (G-Tek Electronics Group Lifeview LV5TDLX
DVB-T)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
rtl2832u_frontend_attach:
rtl28xxu: rtl2832u_frontend_attach: FC0012 tuner found
dvb_register_frontend
DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
DVB: register adapter0/frontend0 @ minor: 3 (0x03)
dvb_frontend_clear_cache() Clearing cache for delivery system 3
rtl2832u_tuner_attach:
fc0012: Fitipower FC0012 successfully attached.
Registered IR keymap rc-empty
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0/input5
rc0: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0
dvb-usb: schedule remote query interval to 400 msecs.
power control: 0
rtl2832u_power_ctrl: onoff=0
dvb-usb: G-Tek Electronics Group Lifeview LV5TDLX DVB-T successfully
initialized and connected.
rtl28xxu_probe: interface=1
usbcore: registered new interface driver dvb_usb_rtl28xxu
[…]
Seems OK.

After soft/warm re(boot):
[…]
usb 1-1: new high-speed USB device number 2 using ehci_hcd
usb 1-1: New USB device found, idVendor=1f4d, idProduct=b803
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: RTL2838UHIDIR
usb 1-1: Manufacturer: Realtek
usb 1-1: SerialNumber: 00000041
rtl28xxu_module_init:
rtl28xxu_probe: interface=0
check for warm bda 2831
check for warm 14aa 160
check for warm 14aa 161
something went very wrong, device was not found in current device list -
let's see what comes next.
check for warm ccd a9
check for warm 1f4d b803
dvb-usb: found a 'G-Tek Electronics Group Lifeview LV5TDLX DVB-T' in
warm state.
power control: 1
rtl2832u_power_ctrl: onoff=1
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
all in all I will use 24576 bytes for streaming
DVB: registering new adapter (G-Tek Electronics Group Lifeview LV5TDLX
DVB-T)
DVB: register adapter0/demux0 @ minor: 0 (0x00)
DVB: register adapter0/dvr0 @ minor: 1 (0x01)
DVB: register adapter0/net0 @ minor: 2 (0x02)
rtl2832u_frontend_attach:
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
rtl28xxu_ctrl_msg: failed=-32
No compatible tuner found
dvb-usb: no frontend was attached by 'G-Tek Electronics Group Lifeview
LV5TDLX DVB-T'
Registered IR keymap rc-empty
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0/input5
rc0: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb1/1-1/rc/rc0
dvb-usb: schedule remote query interval to 400 msecs.
power control: 0
rtl2832u_power_ctrl: onoff=0
dvb-usb: G-Tek Electronics Group Lifeview LV5TDLX DVB-T successfully
initialized and connected.
rtl28xxu_probe: interface=1
usbcore: registered new interface driver dvb_usb_rtl28xxu
[…]
D'oh!

Difference - cold vs warm boot:
< rtl28xxu: rtl2832u_frontend_attach: FC0012 tuner found
< dvb_register_frontend
< DVB: registering adapter 0 frontend 0 (Realtek RTL2832 (DVB-T))...
< DVB: register adapter0/frontend0 @ minor: 3 (0x03)
< dvb_frontend_clear_cache() Clearing cache for delivery system 3
< rtl2832u_tuner_attach:
< fc0012: Fitipower FC0012 successfully attached.
---
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> rtl28xxu_ctrl_msg: failed=-32
> No compatible tuner found
> dvb-usb: no frontend was attached by 'G-Tek Electronics Group Lifeview
LV5TDLX DVB-T'

Any tip or trick?

cheers,
poma

