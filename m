Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37359 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaDZWsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Apr 2014 18:48:38 -0400
Received: by mail-vc0-f169.google.com with SMTP id im17so6734342vcb.28
        for <linux-media@vger.kernel.org>; Sat, 26 Apr 2014 15:48:37 -0700 (PDT)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Help with SMS2270 @ linux-sunxi (A20 devices)
From: Roberto Alcantara <roberto@eletronica.org>
In-Reply-To: <534F453E.5070406@aim.com>
Date: Sat, 26 Apr 2014 19:48:27 -0300
Content-Transfer-Encoding: 8BIT
Message-Id: <915C2760-55B3-475F-86ED-27674E9BDAF6@eletronica.org>
References: <DB7459DA-2266-4DF3-BBD6-3CB991F7738A@eletronica.org> <534E4489.6080909@aim.com> <20140416133419.7d0a1e9f@samsung.com> <D7EB0DA7-165F-4376-B708-02D10CDA427F@eletronica.org> <534F453E.5070406@aim.com>
To: Sat <sattnag@aim.com>, linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

As I could’n some the error I tried another approach.

I checkout commit 80ccb51a from 09/11/2013 as I know it is a working version for sms2270 device but not so newer.

I copy siano files from commit 80ccb51a to my kernel tree (3.4.75) and I need only disable IR support to compiles without errors.

So, I copy my new kernel and modules to device to test, now device is found but...:

root@awsom:~# insmod smsdvb.ko 
insmod: error inserting 'smsdvb.ko': -1 Unknown symbol in module
root@awsom:~# insmod smsmdtv.ko 
root@awsom:~# insmod smsusb.ko 

dmesg:
[  404.935357] smsdvb: Unknown symbol smsendian_handle_tx_message (err 0)
[  404.940520] smsdvb: Unknown symbol smscore_get_device_mode (err 0)
[  404.954893] smsdvb: Unknown symbol smscore_register_client (err 0)
[  404.959986] smsdvb: Unknown symbol sms_board_led_feedback (err 0)
[  404.974160] smsdvb: Unknown symbol sms_board_power (err 0)
[  404.978477] smsdvb: Unknown symbol sms_get_board (err 0)
[  404.983893] smsdvb: Unknown symbol smscore_unregister_hotplug (err 0)
[  405.001147] smsdvb: Unknown symbol smscore_putbuffer (err 0)
[  405.007305] smsdvb: Unknown symbol smsendian_handle_rx_message (err 0)
[  405.012321] smsdvb: Unknown symbol sms_board_lna_control (err 0)
[  405.020188] smsdvb: Unknown symbol smsclient_sendrequest (err 0)
[  405.026278] smsdvb: Unknown symbol smscore_unregister_client (err 0)
[  405.030765] smsdvb: Unknown symbol sms_board_event (err 0)
[  405.036086] smsdvb: Unknown symbol sms_board_setup (err 0)
[  405.040981] smsdvb: Unknown symbol smscore_get_board_id (err 0)
[  405.047036] smsdvb: Unknown symbol smscore_register_hotplug (err 0)
[  415.683285] smsusb_init_device: line: 372: Unspecified sms device type!
[  415.742576] smsusb_init_device: line: 433: smscore_start_device(...) failed
[  415.757505] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.770102] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.782723] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.795353] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.807982] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.820605] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.833095] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.845595] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.858099] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.870594] smsusb_onresponse: line: 143: error, urb status -2, 0 bytes
[  415.927506] smsusb: probe of 1-1.4:1.0 failed with error -2
[  415.933670] usbcore: registered new interface driver smsusb

root@awsom:~# lsusb 
Bus 001 Device 002: ID 058f:6254 Alcor Micro Corp. USB Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 003: ID 0e8f:0021 GreenAsia Inc. Multimedia Keyboard Controller
Bus 001 Device 004: ID 187f:0600 Siano Mobile Silicon 
root@awsom:~# lsmod 
Module                  Size  Used by
smsdvb                 13909  0 
smsusb                 10075  0 
smsmdtv                44375  2 smsdvb,smsusb
disp_ump                 854  0 
mali_drm                2638  1 
mali                  113459  0 
ump                    56392  4 disp_ump,mali
lcd                     3646  0 
root@awsom:~# 



[  415.742576] smsusb_init_device: line: 433: smscore_start_device(...) failed

this error starting device can happen because symbols wasn’t found or are distinct problems? 


Thank you for any tips.

Best regards,
 - Roberto





Em 17/04/2014, à(s) 00:06, Sat <sattnag@aim.com> escreveu:

> (2014/04/17 10:27), Roberto Alcantara wrote:
>> Bad news for me.
>> 
>> I will try to debug something about MTP despite I don’t know yet how to.
>> 
>> I will let know about this guys.
>> 
>> Thank you !
>> 
>> 
>> Em 16/04/2014, à(s) 13:34, Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>> 
>>> 
>>> 
>>> I suspect that it is trying to load this device via smsdio driver, but
>>> I'm not sure.
>>> 
>>> Those MTP probe messages look weird to me. I suspect that it didn't even
>>> called the USB probing method for this device, but I'm not a MTP
>>> expert.
> 
> I also suspect so.
> It seems to step in MTP probing but not USB probing instead.
> In my case, such MTP probe messages doesn't appear as follows:
> 
> [   87.008265] usb 1-1.2.4: new high-speed USB device number 7 using dwc_otg
> [   87.109401] usb 1-1.2.4: New USB device found, idVendor=3275, idProduct=0080
> [   87.109441] usb 1-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   87.109460] usb 1-1.2.4: Product: PX-S1UD Digital TV Tuner
> [   87.109476] usb 1-1.2.4: Manufacturer: PLEX Digital TV Tuner
> [   87.304940] smscore_load_firmware_family2: line: 986: sending MSG_SMS_DATA_VALIDITY_REQ expecting 0xef779751
> 
> 
> Regards,
> Satoshi
> 
>>> Regards,
>>> Mauro
>>> 
>>>>> 
>>>>> Best regards,
>>>>>  - Roberto
>>>>> 
>>>>> 
>>>>> root@awsom:/home/linaro# lsmod
>>>>> Module                  Size  Used by
>>>>> sunxi_cedar_mod        10284  0
>>>>> smsdvb                 13909  0
>>>>> smsusb                  8936  0
>>>>> smsmdtv                28266  2 smsdvb,smsusb
>>>>> disp_ump                 854  0
>>>>> mali_drm                2638  1
>>>>> mali                  113459  0
>>>>> ump                    56392  4 disp_ump,mali
>>>>> lcd                     3646  0

