Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52522 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3JGTaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Oct 2013 15:30:13 -0400
Message-ID: <52530BC1.9010200@gentoo.org>
Date: Mon, 07 Oct 2013 21:30:09 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Ulf <mopp@gmx.net>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi> <524A5EDF.8070904@gentoo.org> <524AE01E.9040300@iki.fi>
In-Reply-To: <524AE01E.9040300@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.10.2013 16:45, Antti Palosaari wrote:
> On 01.10.2013 08:34, Matthias Schwarzott wrote:
>> On 26.09.2013 16:54, Antti Palosaari wrote:
>>> On 25.09.2013 07:50, Matthias Schwarzott wrote:
>>>> On 17.08.2013 13:30, Ulf wrote:
>>>>> Hi,
>>>>>
>>>>> I know the topic Hauppauge HVR-900 HD and HVR 930C-HD with si2165
>>>>> demodulator was already discussed
>>>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/40982 
>>>>>
>>>>>
>>>>> and
>>>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/46266. 
>>>>>
>>>>>
>>>>>
>>>>> Just for me as a confirmation nobody plans to work on a driver for
>>>>> si2165.
>>>>> Is there any chance how to push the development?
>>>>>
>>>>> Ulf
>>>> Hi!
>>>>
>>>> I also bought one of these to find out it is not supported.
>>>> But my plan is to try to write a driver for this.
>>>> I want to get DVB-C working, but I also have DVB-T and analog 
>>>> reception
>>>> available.
>>>>
>>>> My current status is I got it working in windows in qemu and did a usb
>>>> snoop.
>>>> I also have a second system to test it in windows vista directly on 
>>>> the
>>>> hardware.
>>>>
>>>> Current status is documented here.
>>>> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-930C-HD
>>>>
>>>> Until now I only have a component list summarized from this list.
>>>>
>>>>   * Conexant <http://www.linuxtv.org/wiki/index.php/Conexant> CX231xx
>>>> <http://www.linuxtv.org/wiki/index.php/Conexant_CX2310x>
>>>>   * Silicon Labs
>>>>
>>>> <http://www.linuxtv.org/wiki/index.php?title=Silicon_Labs&action=edit&redlink=1> 
>>>>
>>>>
>>>>
>>>>     si2165 <http://www.linuxtv.org/wiki/index.php/Silicon_Labs_si2165>
>>>>     (Multi-Standard DVB-T and DVB-C Demodulator)
>>>>   * NXP TDA18271
>>>> <http://www.linuxtv.org/wiki/index.php/NXP/Philips_TDA182xx>
>>>>     (silicon tuner IC, most likely i2c-addr: 0x60)
>>>>   * eeprom (windows driver reads 1kb, i2c-addr: 0x50)
>>>>
>>>>
>>>> Is this correct?
>>>> Did anyone open his device and can show pictures?
>>>>
>>>> I now need to know which component is at which i2c address.
>>>> Windows driver does upload file hcw10mlD.rom of 16kb to device 0x44.
>>>
>>> I have opened it. There was similar sandwich PCB than used by rev1
>>> too. So you cannot see all the chip unless you use metal saw to
>>> separate PCBs.
>>>
>>> PCB side A:
>>> TDA18271HDC2
>>> 16.000 MHz
>>>
>>> Si2165-GM
>>> 16.000 MHz
>>>
>>>
>>> PCB side B:
>>> 24C02H
>>>
>>> regards
>>> Antti
>>>
>> Hi Antti,
>>
>> thanks for that information.
>> The only real new information for me is the 16.000MHz xtal value.
>>
>> Sad to know that the other chips are hidden.
>> I assigned more i2c addresses to functions, but not yet all (no idea if
>> more addresses are real, or bad interpretations of snooped data).
>>
>> I now try to check what already works:
>> - This is video via composite input.
>> - Next is to try video via analog input - see I see if the tuner in
>> general works in this device.
>>
>> In parallel I try to capture usb in different setups.
>> 1. kvm+tcpdump (using usbmon)
>> 2. usbsnoop on windows vista
>>
>> Only setup 1 does provide a real list of usb packets.
>
> Matthias, you likely try to do things too complex :) I am not going to 
> comment analog side as I simply has no experience. Missing piece of 
> code from the DTV point of view is only si2165 demod driver.
>
> My technique is to make successful tune one channel and take sniffs. 
> From sniffs I generate C-code register writes (and sometimes reads 
> too) using scripts. Reading that "C-code" is much more visual and 
> easier than looking correct bytes from the raw sniffs. It is essential 
> to find out from the sniffs what are tuner register writes, what are 
> demod register writes and what are for USB-bridge itself. There may be 
> some other chips which are needed to init in order to operate, like in 
> cases I2C bus is connected through analog demodulator to digital 
> demodulator.
>
> Usually it is rather trivial to make skeleton driver from the code 
> generated from sniffs which just shows that single channel sniffs were 
> taken.
>
> I have been looking simple example for "reverse-engineer demodulator 
> driver how-to" blog post, but I haven't found suitable device yet. 
> That was one device I looked, but I given-up as simplest sniff after 
> parsing was over 1MB. Looks like there is multiple firmwares to 
> download and also CX231xx usb protocol generates a lot of I/O => not 
> very good example for simple how-to.
>
> Take a look of that post to see some practical example about sniffing 
> and code generation.
> http://blog.palosaari.fi/2013/07/generating-rtl2832u-driver-code.html
>
> regards
> Antti
>
Hi Antti,

my real problem currently is, that I cannot get a good usb dump:
1. In virtual machine (win xp under kvm) it finds one transponder when 
scanning DVB-T, but does not get a picture.
2. On real machine with vista I can tune perfectly, but usb snooping 
does not work (at least not the ones I tried).
3. The only sniffer that seemed to produce enough data on vista was 
usblyzer.
But there is not script to convert the output to usbsnoop format.

Should I install windows xp on real hardware to try usbsnoop there? What 
hw/sw/os are you using?

At least I found out something that is working.
By adding the correct ids to the mceusb driver,
the ir part works correctly and all keys of the remote are correctly 
recognized with the existing Hauppauge keymap.

Regards
Matthias

