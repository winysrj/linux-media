Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35434 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaFOWFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jun 2014 18:05:12 -0400
Message-ID: <539E1895.3030803@iki.fi>
Date: Mon, 16 Jun 2014 01:05:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David Shirley <tephra@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Leadtek WinFast DTV Dongle Dual
References: <CAM187nBS5NZgOEyXUzR6OjmGuQpoiEfAbtqL2-2fj_oURmfudA@mail.gmail.com>
In-Reply-To: <CAM187nBS5NZgOEyXUzR6OjmGuQpoiEfAbtqL2-2fj_oURmfudA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2014 02:54 AM, David Shirley wrote:
> Hi All,
>
> Recently purchased one of these (0413:6a05), the instructions @
> http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV_Dual_Dongle
> appear to be wrong.
>
> Running 3.14.5 I didn't need to patch
> drivers/media/usb/dvb-usb-v2/af9035.c, however the tuner wouldn't work
> (it would be detected, but not able to tune)
>
> After a lot of stuffing around, I ended up patching it913x.c instead
> and everything is working well, here is my dmesg output:
>
> [    3.981516] usb 3-2: new high-speed USB device number 2 using xhci_hcd
> [    4.149345] usb 3-2: New USB device found, idVendor=0413, idProduct=6a05
> [    4.149355] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    4.149361] usb 3-2: Product: WinFast DTV Dongle Dual
> [    4.149366] usb 3-2: Manufacturer: Leadtek
> [  380.529378] it913x: Chip Version=02 Chip Type=9135
> [  380.530913] it913x: Remote propriety (raw) modeit913x: Dual mode=3
> Tuner Type=38
> [  380.531310] it913x: Unknown tuner ID applying default 0x60it913x:
> Chip Version=02 Chip Type=9135

1) Older Leadtek was using V1 chips as seen on Wiki log. That device was 
added about ~9 months ago, Kernel 3.13.
2) It says "Unknown tuner ID applying default 0x60". Unfortunately it 
does not say which was the ID driver fixes. This makes me wonder if it 
is 0x38 which was used for V1 devices and it is not working due to wrong ID.
3) I don't have any IT9135 V2 dual device (single V1 & V2 and dual V1). 
So I cannot even make any tests.

> [  380.637528] usb 3-2: dvb_usb_v2: found a 'Leadtek WinFast DTV
> Dongle Dual' in cold state
> [  380.638195] usb 3-2: dvb_usb_v2: downloading firmware from file
> 'dvb-usb-it9135-02.fw'
> [  380.638598] it913x: FRM Starting Firmware Download
> [  381.130961] it913x: FRM Firmware Download Completed - Resetting
> Deviceit913x: Chip Version=02 Chip Type=9135
> [  381.164104] it913x: Firmware Version 52887808<6>
> [  381.226204] usb 3-2: dvb_usb_v2: found a 'Leadtek WinFast DTV
> Dongle Dual' in warm state
> [  381.226300] usb 3-2: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [  381.226519] DVB: registering new adapter (Leadtek WinFast DTV Dongle Dual)
> [  381.231125] it913x-fe: ADF table value       :00
> [  381.234465] it913x-fe: Crystal Frequency :12000000 Adc Frequency
> :20250000 ADC X2: 01
> [  381.262283] it913x-fe: Tuner LNA type :60
> [  381.493014] usb 3-2: DVB: registering adapter 0 frontend 0 (Leadtek
> WinFast DTV Dongle Dual_1)...
> [  381.493251] usb 3-2: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [  381.493446] DVB: registering new adapter (Leadtek WinFast DTV Dongle Dual)
> [  381.494234] it913x-fe: ADF table value       :00
> [  381.519335] it913x-fe: Crystal Frequency :12000000 Adc Frequency
> :20250000 ADC X2: 01
> [  381.750290] it913x-fe: Tuner LNA type :60
> [  382.280671] usb 3-2: DVB: registering adapter 1 frontend 0 (Leadtek
> WinFast DTV Dongle Dual_2)...
> [  382.304097] IR keymap rc-it913x-v2 not found
> [  382.304282] input: Leadtek WinFast DTV Dongle Dual as
> /devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0/input9
> [  382.304443] rc0: Leadtek WinFast DTV Dongle Dual as
> /devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0
> [  382.304453] usb 3-2: dvb_usb_v2: schedule remote query interval to 250 msecs
> [  382.304462] usb 3-2: dvb_usb_v2: 'Leadtek WinFast DTV Dongle Dual'
> successfully initialized and connected
> [  382.304551] usbcore: registered new interface driver dvb_usb_it913x
>
> My kernel config:
> CONFIG_DVB_USB_V2=m
> CONFIG_DVB_USB_IT913X=m
> CONFIG_DVB_IT913X_FE=m
>
> Do you want the output when it was using the af9035 driver?

AF9035 debug could be nice to see. Or any other debug which shows tuner 
ID. I suspect overriding tuner ID with correct ID 0x60 will make this 
device working. Like I did for these devices:
https://patchwork.linuxtv.org/patch/24340/

regards
Antti

-- 
http://palosaari.fi/
