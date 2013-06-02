Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35978 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab3FBV3B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Jun 2013 17:29:01 -0400
Message-ID: <51ABB8F3.1060103@iki.fi>
Date: Mon, 03 Jun 2013 00:28:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?SnVzc2kgSsOkw6Rza2Vsw6RpbmVu?=
	<www.linuxtv.org@jjussi.com>
CC: linux-media@vger.kernel.org
Subject: Re: All models of Technotrend TT-connect CT-3650 are not supported
References: <loom.20130530T123614-761@post.gmane.org> <loom.20130531T075102-721@post.gmane.org>
In-Reply-To: <loom.20130531T075102-721@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2013 08:53 AM, Jussi Jääskeläinen wrote:
> Jussi Jääskeläinen <www.linuxtv.org <at> jjussi.com> writes:
>
>> Older models have: idVendor=0b48, idProduct=300d
>> Model what I just bought was: idVendor=04b4, idProduct=8613 and this is not
>> supported!
>>
>> usb 2-1: New USB device found, idVendor=04b4, idProduct=8613
>> usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>> usbtest 2-1:1.0: FX2 device
>> usbtest 2-1:1.0: high-speed {control bulk-in bulk-out} tests (+alt)
>>
>> Both products looks just same!
>
> Is there some program I could run what would "extract" all needed information
> to developer, so driver could be created or known driver could be connected to
> this ID?

Your device eeprom is corrupted or eeprom is broken or connection to 
eeprom is broken. 04b4:8613 is Cypress FX2 default USB ID. It tries to 
download USB ID (also firmware in some cases) from the eeprom first and 
after that enumerates to the USB bus.

That device will not even work on Windows. Return it to the warranty.

regards
Antti

-- 
http://palosaari.fi/
