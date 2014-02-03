Return-path: <linux-media-owner@vger.kernel.org>
Received: from h1981597.stratoserver.net ([85.214.206.215]:49900 "EHLO
	h1981597.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCVD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 16:03:56 -0500
Received: from localhost ([127.0.0.1] helo=mail.vanmierlo.nu)
	by h1981597.stratoserver.net with esmtp (Exim 4.72)
	(envelope-from <rik@vanmierlo.nu>)
	id 1WAQ1Z-0006pm-BD
	for linux-media@vger.kernel.org; Mon, 03 Feb 2014 21:21:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Feb 2014 21:21:45 +0100
From: Rik van Mierlo <rik@vanmierlo.nu>
To: <linux-media@vger.kernel.org>
Subject: Terratec H7 with yet another usb ID
Message-ID: <72f12ec0f50db8495447b3104923aa61@mail.vanmierlo.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've recently purchased a Terratec H7, based on the fact that is was 
supported for a while now. Unfortunately, it turns out that my device 
uses a different product id, and maybe is not quite the same device 
inside either.

ProductID for the Terratec H7 revisions in the module is either 10b4 or 
10a3, the one I purchased is 10a5. Following this patch:

https://patchwork.linuxtv.org/patch/9691

I modified drivers/media/usb/dvb-usb-v2/az6007.c to include an 
additional device:

static struct usb_device_id az6007_usb_table[] = {
         {DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
                 &az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
         {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7,
                 &az6007_props, "Terratec H7", 
RC_MAP_NEC_TERRATEC_CINERGY_XS)},
         {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2,
                 &az6007_props, "Terratec H7", 
RC_MAP_NEC_TERRATEC_CINERGY_XS)},
         {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_3,
                 &az6007_props, "Terratec H7", 
RC_MAP_NEC_TERRATEC_CINERGY_XS)},
         {DVB_USB_DEVICE(USB_VID_TECHNISAT, 
USB_PID_TECHNISAT_USB2_CABLESTAR_HDCI,
                 &az6007_cablestar_hdci_props, "Technisat CableStar 
Combo HD CI", RC_MAP_EMPTY)},
         {0},
};

and added the following to drivers/media/dvb-core/dvb-usb-ids.h

#define USB_PID_TERRATEC_H7_3                           0x10a5

and recompiled/installed the kernel and modules. The module seems to 
have changed somewhat in 3.12.6 from the version that the patch was 
meant for, so I hope I this was all I had to change.

Rebooting and plugging in the device now at least leads to a recognized 
device, but scanning for channels with w_scan does not work, and from 
the dmesg output below, it seems something is not working after loading 
the drxk firmware. Does anybody know what I could try next to get this 
device working? Could it be that the drxk firmware is not suitable for 
this revision of the device?

[  700.112072] usb 4-2: new high-speed USB device number 2 using 
ehci-pci
[  700.245092] usb 4-2: New USB device found, idVendor=0ccd, 
idProduct=10a5
[  700.245105] usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  700.245114] usb 4-2: Product: TERRATEC T2/T/C CI USB
[  700.245123] usb 4-2: Manufacturer: TERRATEC
[  700.245131] usb 4-2: SerialNumber: 20130903
[  700.494693] usb read operation failed. (-32)
[  700.495039] usb write operation failed. (-32)
[  700.495413] usb write operation failed. (-32)
[  700.495787] usb write operation failed. (-32)
[  700.495800] usb 4-2: dvb_usb_v2: found a 'Terratec H7' in cold state
[  700.507381] usb 4-2: firmware: direct-loading firmware 
dvb-usb-terratec-h7-az6007.fw
[  700.507397] usb 4-2: dvb_usb_v2: downloading firmware from file 
'dvb-usb-terratec-h7-az6007.fw'
[  700.524301] usb 4-2: dvb_usb_v2: found a 'Terratec H7' in warm state
[  701.760878] usb 4-2: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[  701.760947] DVB: registering new adapter (Terratec H7)
[  701.763853] usb 4-2: dvb_usb_v2: MAC address: c2:cd:0c:a5:10:00
[  701.846469] drxk: frontend initialized.
[  701.849123] usb 4-2: firmware: direct-loading firmware 
dvb-usb-terratec-h7-drxk.fw
[  701.849215] usb 4-2: DVB: registering adapter 0 frontend 0 (DRXK)...
[  701.881072] drxk: status = 0x00c04125
[  701.881082] drxk: DeviceID 0x04 not supported
[  701.881090] drxk: Error -22 on init_drxk
[  701.908184] mt2063_attach: Attaching MT2063
[  701.940248] Registered IR keymap rc-nec-terratec-cinergy-xs
[  701.940547] input: Terratec H7 as 
/devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc0/input16
[  701.942559] rc0: Terratec H7 as 
/devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc0
[  701.942575] usb 4-2: dvb_usb_v2: schedule remote query interval to 
400 msecs
[  701.942587] usb 4-2: dvb_usb_v2: 'Terratec H7' successfully 
initialized and connected
[  701.942643] usbcore: registered new interface driver dvb_usb_az6007

Regards,

Rik van Mierlo
