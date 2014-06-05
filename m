Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33123 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFEXyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 19:54:16 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so37939wiw.4
        for <linux-media@vger.kernel.org>; Thu, 05 Jun 2014 16:54:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 6 Jun 2014 09:54:15 +1000
Message-ID: <CAM187nBS5NZgOEyXUzR6OjmGuQpoiEfAbtqL2-2fj_oURmfudA@mail.gmail.com>
Subject: Leadtek WinFast DTV Dongle Dual
From: David Shirley <tephra@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Recently purchased one of these (0413:6a05), the instructions @
http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dual_Dongle
appear to be wrong.

Running 3.14.5 I didn't need to patch
drivers/media/usb/dvb-usb-v2/af9035.c, however the tuner wouldn't work
(it would be detected, but not able to tune)

After a lot of stuffing around, I ended up patching it913x.c instead
and everything is working well, here is my dmesg output:

[    3.981516] usb 3-2: new high-speed USB device number 2 using xhci_hcd
[    4.149345] usb 3-2: New USB device found, idVendor=0413, idProduct=6a05
[    4.149355] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.149361] usb 3-2: Product: WinFast DTV Dongle Dual
[    4.149366] usb 3-2: Manufacturer: Leadtek
[  380.529378] it913x: Chip Version=02 Chip Type=9135
[  380.530913] it913x: Remote propriety (raw) modeit913x: Dual mode=3
Tuner Type=38
[  380.531310] it913x: Unknown tuner ID applying default 0x60it913x:
Chip Version=02 Chip Type=9135
[  380.637528] usb 3-2: dvb_usb_v2: found a 'Leadtek WinFast DTV
Dongle Dual' in cold state
[  380.638195] usb 3-2: dvb_usb_v2: downloading firmware from file
'dvb-usb-it9135-02.fw'
[  380.638598] it913x: FRM Starting Firmware Download
[  381.130961] it913x: FRM Firmware Download Completed - Resetting
Deviceit913x: Chip Version=02 Chip Type=9135
[  381.164104] it913x: Firmware Version 52887808<6>
[  381.226204] usb 3-2: dvb_usb_v2: found a 'Leadtek WinFast DTV
Dongle Dual' in warm state
[  381.226300] usb 3-2: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[  381.226519] DVB: registering new adapter (Leadtek WinFast DTV Dongle Dual)
[  381.231125] it913x-fe: ADF table value       :00
[  381.234465] it913x-fe: Crystal Frequency :12000000 Adc Frequency
:20250000 ADC X2: 01
[  381.262283] it913x-fe: Tuner LNA type :60
[  381.493014] usb 3-2: DVB: registering adapter 0 frontend 0 (Leadtek
WinFast DTV Dongle Dual_1)...
[  381.493251] usb 3-2: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[  381.493446] DVB: registering new adapter (Leadtek WinFast DTV Dongle Dual)
[  381.494234] it913x-fe: ADF table value       :00
[  381.519335] it913x-fe: Crystal Frequency :12000000 Adc Frequency
:20250000 ADC X2: 01
[  381.750290] it913x-fe: Tuner LNA type :60
[  382.280671] usb 3-2: DVB: registering adapter 1 frontend 0 (Leadtek
WinFast DTV Dongle Dual_2)...
[  382.304097] IR keymap rc-it913x-v2 not found
[  382.304282] input: Leadtek WinFast DTV Dongle Dual as
/devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0/input9
[  382.304443] rc0: Leadtek WinFast DTV Dongle Dual as
/devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0
[  382.304453] usb 3-2: dvb_usb_v2: schedule remote query interval to 250 msecs
[  382.304462] usb 3-2: dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual'
successfully initialized and connected
[  382.304551] usbcore: registered new interface driver dvb_usb_it913x

My kernel config:
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_IT913X=m
CONFIG_DVB_IT913X_FE=m

Do you want the output when it was using the af9035 driver?

Regards
David
