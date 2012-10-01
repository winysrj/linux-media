Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56460 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2JALV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 07:21:58 -0400
Message-ID: <50697CBE.8060001@iki.fi>
Date: Mon, 01 Oct 2012 14:21:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Damien Bally <biribi@free.fr>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] usb id addition for Terratec Cinergy T Stick Dual rev.
 2
References: <5064A3AD.70009@free.fr> <5064ABD2.2060106@iki.fi> <5065D1AC.5030800@free.fr> <5065E487.80502@iki.fi> <1348860617.2782.26.camel@Route3278> <20120929143305.4859603e@redhat.com> <50688332.7020406@free.fr> <20121001081540.69bdae23@redhat.com>
In-Reply-To: <20121001081540.69bdae23@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2012 02:15 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 30 Sep 2012 19:36:50 +0200
> Damien Bally <biribi@free.fr> escreveu:
>
>>
>>
>> Le 29/09/2012 19:33, Mauro Carvalho Chehab a écrit :
>>    It seems that the it931x variant has bcdDevice equal to 2.00,
>>> from Damien's email:
>>>
>>>      idVendor           0x0ccd TerraTec Electronic GmbH
>>>      idProduct          0x0099
>>>      bcdDevice            2.00
>>>      iManufacturer           1 ITE Technologies, Inc.
>>>      iProduct                2 DVB-T TV Stick
>>>      iSerial                 0
>>>
>>> If the af9015 variant uses another bcdDevice, the fix should be simple.
>>
>> Alas, according to
>> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_Dual_RC the
>> af9015 variant appears to have the same bcdDevice. I join both lsusb
>> outputs for comparison.
>
> Well, then the alternative is to let both drivers to handle this USB ID,
> and add a code there on each of them that will check if the device is the
> right one, perhaps by looking at iProduct string. If the driver doesn't
> recognize it, it should return -ENODEV at .probe() time. The USB core will
> call the second driver.

It is the easiest solution, but there should be very careful. Those 
strings could change from device to device. I used earlier af9015 eeprom 
hash (those string as coming from the eeprom) to map TerraTec dual 
remote controller and git bug report quite soon as it didn't worked. 
After I looked the reason I found out they was changed some not 
meaningful value.

t. Antti
-- 
http://palosaari.fi/
