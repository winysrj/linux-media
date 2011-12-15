Return-path: <linux-media-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:46211 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1LOPtt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 10:49:49 -0500
Received: from moh2-ve1.go2.pl (moh2-ve1.go2.pl [193.17.41.186])
	by tur.go2.pl (Postfix) with ESMTP id C2375230079
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 16:48:59 +0100 (CET)
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
	by moh2-ve1.go2.pl (Postfix) with ESMTP id 795C044DA45
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 16:48:07 +0100 (CET)
Received: from unknown (unknown [10.0.0.142])
	by moh2-ve1.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 16:48:07 +0100 (CET)
Message-ID: <4EEA16BA.4070209@tlen.pl>
Date: Thu, 15 Dec 2011 16:48:10 +0100
From: Adrian N <adexmail@tlen.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] it913x add support for IT9135 9006 devices
References: <1323719580.2235.3.camel@tvbox> <loom.20111214T071004-336@post.gmane.org>
In-Reply-To: <loom.20111214T071004-336@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2011-12-14 07:13, Adeq pisze:
> Malcolm Priestley<tvboxspy<at>  gmail.com>  writes:
>
>> Support for IT1935 9006 devices.
>>
>> 9006 have version 2 type chip.
>>
>> 9006 devices should use dvb-usb-it9135-02.fw firmware.
>>
>> On the device tested the tuner id was set to 0 which meant
>> the driver used tuner id 0x38. The device functioned normally.
>>
> Hello,
>
> my device (048d:9006) isn't fully working, here is dmesg log:
>
> [code]
> [  281.724044] usb 1-3: new high-speed USB device number 10 using ehci_hcd
> [  281.860585] usb 1-3: New USB device found, idVendor=048d, idProduct=9006
> [  281.860594] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  281.860601] usb 1-3: Product: DVB-T TV Stick
> [  281.860607] usb 1-3: Manufacturer: ITE Technologies, Inc.
> [  281.861694] it913x: Chip Version=02 Chip Type=9135
> [  281.863193] it913x: Dual mode=0 Remote=1 Tuner Type=0
> [  281.864444] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, will try
> to load a firmware
> [  281.870053] dvb-usb: downloading firmware from file 'dvb-usb-it9135-02.fw'
> [  281.870438] it913x: FRM Starting Firmware Download
> [  282.388032] it913x: FRM Firmware Download Failed (ffffffff)
> [  282.588116] it913x: Chip Version=79 Chip Type=4af3
> [  283.224203] it913x: DEV it913x Error
> [  283.227753] input: ITE Technologies, Inc. DVB-T TV Stick as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.1/input/input17
> [  283.228415] generic-usb 0003:048D:9006.0007: input,hidraw0: USB HID v1.01
> Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.7-3/input1
>
> or
>
> [  292.444049] usb 1-3: new high-speed USB device number 11 using ehci_hcd
> [  292.580449] usb 1-3: New USB device found, idVendor=048d, idProduct=9006
> [  292.580458] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  292.580465] usb 1-3: Product: DVB-T TV Stick
> [  292.580471] usb 1-3: Manufacturer: ITE Technologies, Inc.
> [  292.581557] it913x: Chip Version=02 Chip Type=9135
> [  292.583051] it913x: Dual mode=0 Remote=1 Tuner Type=0
> [  292.584284] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, will try
> to load a firmware
> [  292.589938] dvb-usb: downloading firmware from file 'dvb-usb-it9135-02.fw'
> [  292.590302] it913x: FRM Starting Firmware Download
> [  292.908023] it913x: FRM Firmware Download Completed - Resetting Device
> [  292.908534] it913x: Chip Version=02 Chip Type=9135
> [  292.909032] it913x: Firmware Version 52887808
> [  293.144182] it913x: DEV it913x Error
> [  293.147862] input: ITE Technologies, Inc. DVB-T TV Stick as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.1/input/input18
> [  293.152345] generic-usb 0003:048D:9006.0008: input,hidraw0: USB HID v1.01
> Keyboard [ITE Technologies, Inc. DVB-T TV Stick] on usb-0000:00:1d.7-3/input1
> [/code]
>
> I'm using this device: http://www.runteck.com/products_view.php?Id=24&S_Id=2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
After updating firmware.

warmboot:

[  984.370447] dvb-usb: ITE 9135(9006) Generic successfully 
deinitialized and disconnected.
[ 1000.884812] it913x: Chip Version=02 Chip Type=9135
[ 1000.885309] it913x: Firmware Version 52887808
[ 1000.886808] it913x: Dual mode=0 Remote=1 Tuner Type=0
[ 1000.886814] dvb-usb: found a 'ITE 9135(9006) Generic' in warm state.
[ 1000.887540] dvb-usb: will use the device's hardware PID filter (table 
count: 31).
[ 1000.887857] DVB: registering new adapter (ITE 9135(9006) Generic)
[ 1000.891586] it913x-fe: ADF table value       :00
[ 1000.891596] it913x: Message out (0000d8b401313938)
[ 1000.892197] it913x: Message out (0000d8b50100d8b4)
[ 1000.892685] it913x: Message out (0000d8b30100d8b5)
[ 1000.893185] it913x: Message out (0000f6413800d8b3)
[ 1000.893560] it913x: Message out (0000f5ca0100f641)
[ 1001.092205] it913x: Message out (0000f7150100f5ca)
[ 1001.292097] it913x: Message out (0000002500006000)
[ 1001.492099] it913x: Message out (0000f1cd0000a200)
[ 1001.692107] it913x: Message out (0000004501dc4cf5)
[ 1001.892111] it913x: Message out (0000002900000000)
[ 1002.092113] it913x-fe: Crystal Frequency :12000000 Adc Frequency 
:20250000 ADC X2: 01
[ 1002.092141] dvb-usb: no frontend was attached by 'ITE 9135(9006) Generic'
[ 1002.092159] Registered IR keymap rc-msi-digivox-iii
[ 1002.092392] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1/input15
[ 1002.095747] rc1: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1
[ 1002.095757] dvb-usb: schedule remote query interval to 250 msecs.
[ 1002.095765] dvb-usb: ITE 9135(9006) Generic successfully initialized 
and connected.
[ 1002.095770] it913x: DEV registering device driver
[ 1002.095826] usbcore: registered new interface driver it913x

coldboot:

[ 1103.536156] it913x: Chip Version=ec Chip Type=5830
[ 1104.336178] it913x: Dual mode=92 Remote=92 Tuner Type=92
[ 1106.248116] dvb-usb: found a 'ITE 9135(9006) Generic' in cold state, 
will try to load a firmware
[ 1106.253773] dvb-usb: downloading firmware from file 
'dvb-usb-it9135-02.fw'
[ 1106.452123] it913x: FRM Starting Firmware Download
[ 1130.756039] it913x: FRM Firmware Download Failed (ffffff92)
[ 1130.956168] it913x: Chip Version=79 Chip Type=5823
[ 1131.592192] it913x: DEV it913x Error
[ 1131.592271] usbcore: registered new interface driver it913x

No frontend is generated anyway.
