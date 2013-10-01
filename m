Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34510 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab3JAFe2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Oct 2013 01:34:28 -0400
Message-ID: <524A5EDF.8070904@gentoo.org>
Date: Tue, 01 Oct 2013 07:34:23 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Ulf <mopp@gmx.net>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi>
In-Reply-To: <52444AA3.8020205@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.09.2013 16:54, Antti Palosaari wrote:
> On 25.09.2013 07:50, Matthias Schwarzott wrote:
>> On 17.08.2013 13:30, Ulf wrote:
>>> Hi,
>>>
>>> I know the topic Hauppauge HVR-900 HD and HVR 930C-HD with si2165
>>> demodulator was already discussed
>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/40982 
>>>
>>> and
>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/46266. 
>>>
>>>
>>> Just for me as a confirmation nobody plans to work on a driver for
>>> si2165.
>>> Is there any chance how to push the development?
>>>
>>> Ulf
>> Hi!
>>
>> I also bought one of these to find out it is not supported.
>> But my plan is to try to write a driver for this.
>> I want to get DVB-C working, but I also have DVB-T and analog reception
>> available.
>>
>> My current status is I got it working in windows in qemu and did a usb
>> snoop.
>> I also have a second system to test it in windows vista directly on the
>> hardware.
>>
>> Current status is documented here.
>> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-930C-HD
>>
>> Until now I only have a component list summarized from this list.
>>
>>   * Conexant <http://www.linuxtv.org/wiki/index.php/Conexant> CX231xx
>> <http://www.linuxtv.org/wiki/index.php/Conexant_CX2310x>
>>   * Silicon Labs
>>
>> <http://www.linuxtv.org/wiki/index.php?title=Silicon_Labs&action=edit&redlink=1> 
>>
>>
>>     si2165 <http://www.linuxtv.org/wiki/index.php/Silicon_Labs_si2165>
>>     (Multi-Standard DVB-T and DVB-C Demodulator)
>>   * NXP TDA18271
>> <http://www.linuxtv.org/wiki/index.php/NXP/Philips_TDA182xx>
>>     (silicon tuner IC, most likely i2c-addr: 0x60)
>>   * eeprom (windows driver reads 1kb, i2c-addr: 0x50)
>>
>>
>> Is this correct?
>> Did anyone open his device and can show pictures?
>>
>> I now need to know which component is at which i2c address.
>> Windows driver does upload file hcw10mlD.rom of 16kb to device 0x44.
>
> I have opened it. There was similar sandwich PCB than used by rev1 
> too. So you cannot see all the chip unless you use metal saw to 
> separate PCBs.
>
> PCB side A:
> TDA18271HDC2
> 16.000 MHz
>
> Si2165-GM
> 16.000 MHz
>
>
> PCB side B:
> 24C02H
>
> regards
> Antti
>
Hi Antti,

thanks for that information.
The only real new information for me is the 16.000MHz xtal value.

Sad to know that the other chips are hidden.
I assigned more i2c addresses to functions, but not yet all (no idea if 
more addresses are real, or bad interpretations of snooped data).

I now try to check what already works:
- This is video via composite input.
- Next is to try video via analog input - see I see if the tuner in 
general works in this device.

In parallel I try to capture usb in different setups.
1. kvm+tcpdump (using usbmon)
2. usbsnoop on windows vista

Only setup 1 does provide a real list of usb packets.

Regards
Matthias

