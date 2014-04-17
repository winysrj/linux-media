Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m10.mx.aol.com ([64.12.143.86]:34861 "EHLO
	omr-m10.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbaDQDHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 23:07:03 -0400
Message-ID: <534F453E.5070406@aim.com>
Date: Thu, 17 Apr 2014 12:06:38 +0900
From: Sat <sattnag@aim.com>
MIME-Version: 1.0
To: Roberto Alcantara <roberto@eletronica.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: Help with SMS2270 @ linux-sunxi (A20 devices)
References: <DB7459DA-2266-4DF3-BBD6-3CB991F7738A@eletronica.org> <534E4489.6080909@aim.com> <20140416133419.7d0a1e9f@samsung.com> <D7EB0DA7-165F-4376-B708-02D10CDA427F@eletronica.org>
In-Reply-To: <D7EB0DA7-165F-4376-B708-02D10CDA427F@eletronica.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(2014/04/17 10:27), Roberto Alcantara wrote:
> Bad news for me.
>
> I will try to debug something about MTP despite I don’t know yet how to.
>
> I will let know about this guys.
>
> Thank you !
>
>
> Em 16/04/2014, à(s) 13:34, Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
>
>>
>>
>> I suspect that it is trying to load this device via smsdio driver, but
>> I'm not sure.
>>
>> Those MTP probe messages look weird to me. I suspect that it didn't even
>> called the USB probing method for this device, but I'm not a MTP
>> expert.

I also suspect so.
It seems to step in MTP probing but not USB probing instead.
In my case, such MTP probe messages doesn't appear as follows:

[   87.008265] usb 1-1.2.4: new high-speed USB device number 7 using dwc_otg
[   87.109401] usb 1-1.2.4: New USB device found, idVendor=3275, 
idProduct=0080
[   87.109441] usb 1-1.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   87.109460] usb 1-1.2.4: Product: PX-S1UD Digital TV Tuner
[   87.109476] usb 1-1.2.4: Manufacturer: PLEX Digital TV Tuner
[   87.304940] smscore_load_firmware_family2: line: 986: sending 
MSG_SMS_DATA_VALIDITY_REQ expecting 0xef779751


Regards,
Satoshi

>> Regards,
>> Mauro
>>
>>>>
>>>> Best regards,
>>>>   - Roberto
>>>>
>>>>
>>>> root@awsom:/home/linaro# lsmod
>>>> Module                  Size  Used by
>>>> sunxi_cedar_mod        10284  0
>>>> smsdvb                 13909  0
>>>> smsusb                  8936  0
>>>> smsmdtv                28266  2 smsdvb,smsusb
>>>> disp_ump                 854  0
>>>> mali_drm                2638  1
>>>> mali                  113459  0
>>>> ump                    56392  4 disp_ump,mali
>>>> lcd                     3646  0
>

