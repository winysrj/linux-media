Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43878 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3JGUW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 16:22:29 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so5464449wib.10
        for <linux-media@vger.kernel.org>; Mon, 07 Oct 2013 13:22:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52530BC1.9010200@gentoo.org>
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54>
 <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi> <524A5EDF.8070904@gentoo.org>
 <524AE01E.9040300@iki.fi> <52530BC1.9010200@gentoo.org>
From: pierigno <pierigno@gmail.com>
Date: Mon, 7 Oct 2013 22:21:47 +0200
Message-ID: <CAN7fRVvNExBoAbXxBM0bheB2mCRsZcdKTG-FFkN9AuNdJWBXLw@mail.gmail.com>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Ulf <mopp@gmx.net>
Content-Type: multipart/mixed; boundary=089e013d19cc2ae0df04e82c69fa
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--089e013d19cc2ae0df04e82c69fa
Content-Type: text/plain; charset=ISO-8859-1

Hi Matthias,

I went through a similar path in the past, using USBLyzer on a
virtualized windows environment, and developed this simple awk script
to adapt the csv output of USBLyzer to usbsnoop format. Hope it helps
:)





2013/10/7 Matthias Schwarzott <zzam@gentoo.org>:
> On 01.10.2013 16:45, Antti Palosaari wrote:
>>
>> On 01.10.2013 08:34, Matthias Schwarzott wrote:
>>>
>>> On 26.09.2013 16:54, Antti Palosaari wrote:
>>>>
>>>> On 25.09.2013 07:50, Matthias Schwarzott wrote:
>>>>>
>>>>> On 17.08.2013 13:30, Ulf wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I know the topic Hauppauge HVR-900 HD and HVR 930C-HD with si2165
>>>>>> demodulator was already discussed
>>>>>>
>>>>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/40982
>>>>>>
>>>>>> and
>>>>>>
>>>>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/46266.
>>>>>>
>>>>>>
>>>>>> Just for me as a confirmation nobody plans to work on a driver for
>>>>>> si2165.
>>>>>> Is there any chance how to push the development?
>>>>>>
>>>>>> Ulf
>>>>>
>>>>> Hi!
>>>>>
>>>>> I also bought one of these to find out it is not supported.
>>>>> But my plan is to try to write a driver for this.
>>>>> I want to get DVB-C working, but I also have DVB-T and analog reception
>>>>> available.
>>>>>
>>>>> My current status is I got it working in windows in qemu and did a usb
>>>>> snoop.
>>>>> I also have a second system to test it in windows vista directly on the
>>>>> hardware.
>>>>>
>>>>> Current status is documented here.
>>>>> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-930C-HD
>>>>>
>>>>> Until now I only have a component list summarized from this list.
>>>>>
>>>>>   * Conexant <http://www.linuxtv.org/wiki/index.php/Conexant> CX231xx
>>>>> <http://www.linuxtv.org/wiki/index.php/Conexant_CX2310x>
>>>>>   * Silicon Labs
>>>>>
>>>>>
>>>>> <http://www.linuxtv.org/wiki/index.php?title=Silicon_Labs&action=edit&redlink=1>
>>>>>
>>>>>
>>>>>     si2165 <http://www.linuxtv.org/wiki/index.php/Silicon_Labs_si2165>
>>>>>     (Multi-Standard DVB-T and DVB-C Demodulator)
>>>>>   * NXP TDA18271
>>>>> <http://www.linuxtv.org/wiki/index.php/NXP/Philips_TDA182xx>
>>>>>     (silicon tuner IC, most likely i2c-addr: 0x60)
>>>>>   * eeprom (windows driver reads 1kb, i2c-addr: 0x50)
>>>>>
>>>>>
>>>>> Is this correct?
>>>>> Did anyone open his device and can show pictures?
>>>>>
>>>>> I now need to know which component is at which i2c address.
>>>>> Windows driver does upload file hcw10mlD.rom of 16kb to device 0x44.
>>>>
>>>>
>>>> I have opened it. There was similar sandwich PCB than used by rev1
>>>> too. So you cannot see all the chip unless you use metal saw to
>>>> separate PCBs.
>>>>
>>>> PCB side A:
>>>> TDA18271HDC2
>>>> 16.000 MHz
>>>>
>>>> Si2165-GM
>>>> 16.000 MHz
>>>>
>>>>
>>>> PCB side B:
>>>> 24C02H
>>>>
>>>> regards
>>>> Antti
>>>>
>>> Hi Antti,
>>>
>>> thanks for that information.
>>> The only real new information for me is the 16.000MHz xtal value.
>>>
>>> Sad to know that the other chips are hidden.
>>> I assigned more i2c addresses to functions, but not yet all (no idea if
>>> more addresses are real, or bad interpretations of snooped data).
>>>
>>> I now try to check what already works:
>>> - This is video via composite input.
>>> - Next is to try video via analog input - see I see if the tuner in
>>> general works in this device.
>>>
>>> In parallel I try to capture usb in different setups.
>>> 1. kvm+tcpdump (using usbmon)
>>> 2. usbsnoop on windows vista
>>>
>>> Only setup 1 does provide a real list of usb packets.
>>
>>
>> Matthias, you likely try to do things too complex :) I am not going to
>> comment analog side as I simply has no experience. Missing piece of code
>> from the DTV point of view is only si2165 demod driver.
>>
>> My technique is to make successful tune one channel and take sniffs. From
>> sniffs I generate C-code register writes (and sometimes reads too) using
>> scripts. Reading that "C-code" is much more visual and easier than looking
>> correct bytes from the raw sniffs. It is essential to find out from the
>> sniffs what are tuner register writes, what are demod register writes and
>> what are for USB-bridge itself. There may be some other chips which are
>> needed to init in order to operate, like in cases I2C bus is connected
>> through analog demodulator to digital demodulator.
>>
>> Usually it is rather trivial to make skeleton driver from the code
>> generated from sniffs which just shows that single channel sniffs were
>> taken.
>>
>> I have been looking simple example for "reverse-engineer demodulator
>> driver how-to" blog post, but I haven't found suitable device yet. That was
>> one device I looked, but I given-up as simplest sniff after parsing was over
>> 1MB. Looks like there is multiple firmwares to download and also CX231xx usb
>> protocol generates a lot of I/O => not very good example for simple how-to.
>>
>> Take a look of that post to see some practical example about sniffing and
>> code generation.
>> http://blog.palosaari.fi/2013/07/generating-rtl2832u-driver-code.html
>>
>> regards
>> Antti
>>
> Hi Antti,
>
> my real problem currently is, that I cannot get a good usb dump:
> 1. In virtual machine (win xp under kvm) it finds one transponder when
> scanning DVB-T, but does not get a picture.
> 2. On real machine with vista I can tune perfectly, but usb snooping does
> not work (at least not the ones I tried).
> 3. The only sniffer that seemed to produce enough data on vista was
> usblyzer.
> But there is not script to convert the output to usbsnoop format.
>
> Should I install windows xp on real hardware to try usbsnoop there? What
> hw/sw/os are you using?
>
> At least I found out something that is working.
> By adding the correct ids to the mceusb driver,
> the ir part works correctly and all keys of the remote are correctly
> recognized with the existing Hauppauge keymap.
>
> Regards
> Matthias
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--089e013d19cc2ae0df04e82c69fa
Content-Type: application/octet-stream; name="usblyzer2usbsnoop.awk"
Content-Disposition: attachment; filename="usblyzer2usbsnoop.awk"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmi58qi30

IyEvdXNyL2Jpbi9hd2sgLWYKCmZ1bmN0aW9uIGdldF90eXBlKGZpZWxkKSB7Cglzd2l0Y2goZmll
bGQpIHsKCQljYXNlIC9Db250cm9sIFRyYW5zZmVyLzoKCQkJcmV0dXJuICJDb250cm9sVHJhbnNm
ZXIiOwoJCWNhc2UgL0J1bGsvOgoJCQlyZXR1cm4gIkJVTEsiOwoJCWRlZmF1bHQ6CgkJCXJldHVy
bjsKCX0KfQoKCmZ1bmN0aW9uIGdldF9kaXJlY3Rpb24oZmllbGQpIHsKCXN3aXRjaChmaWVsZCkg
ewoJCWNhc2UgImluIjogCXJldHVybiAiPDw8IjsKCQljYXNlICJvdXQiOiByZXR1cm4gIj4+PiI7
CgkJZGVmYXVsdDogcmV0dXJuICItLS0iOwoJfQp9CgojIFVTQkx5emVyIEM6STpFIGZpZWxkCmZ1
bmN0aW9uIGdldF9jaWUoZmllbGQpIHsKCXJldCA9IHNwbGl0KGZpZWxkLGVsZW1lbnQsIjoiLHNl
cHMpOwoJaWYocmV0PT0zKQoJCXJldHVybiBzdHJ0b251bShlbGVtZW50WzNdKTsKfQoKCmZ1bmN0
aW9uIGdldF9lbGFwc2VkKGZpZWxkKSB7CglyZXR1cm4gc3RydG9udW0oZmllbGQpKjEwMDA7Cn0K
CgpmdW5jdGlvbiBnZXRfZHVyYXRpb24oZmllbGQpIHsKCWlmKGZpZWxkIT0iIikgewoJCXNwbGl0
KGZpZWxkLGVsZW1lbnQsIiAiLHNlcHMpOwoJCW51bSA9IHN0cnRvbnVtKGVsZW1lbnRbMV0pOwoJ
CXN3aXRjaChlbGVtZW50WzJdKSB7CgkJCWNhc2UgInVzIjogbnVtKjE7CgkJCWNhc2UgIm1zIjog
bnVtKjEwMDA7CgkJCWRlZmF1bHQ6IGJyZWFrOwoJCQkKCQl9CgkJcmV0dXJuIG51bTsKCX0KCWVs
c2UgcmV0dXJuIDA7Cn0KCgpmdW5jdGlvbiBnZXRfYnl0ZXMoZmllbGQpIHsKCXJldCA9IHNwbGl0
KGZpZWxkLGVsZW1lbnQsIiAiLHNlcHMpOwoJaWYocmV0PT0zKQoJCXJldHVybiBzdHJ0b251bShl
bGVtZW50WzFdKTsKfQoKQkVHSU4gewoJRlM9IiwiOwoJbXlOUj0wOwoJZmxpcF9oZWFkZXI9MTsK
fQoKewoJaWYoJDYgfiAvQ29udHJvbCBUcmFuc2Zlci8gfHwgKCQ2IH4gL0J1bGsvICYmICQ3IH4g
L2RhdGEvKSkKCQlteU5SKys7Cn0KCgooJDYgfiAvQ29udHJvbCBUcmFuc2Zlci8gfHwgKCQ2IH4g
L0J1bGsvICYmICQ3IH4gL2RhdGEvKSkgewogCgkJdHlwZSA9IGdldF90eXBlKCQ2KTsKCQlkaXJl
Y3Rpb24gPSBnZXRfZGlyZWN0aW9uKCQ5KTsKCQljaWUgPSBnZXRfY2llKCQxMCk7CgkJZWxhcHNl
ZCA9IGdldF9lbGFwc2VkKCQ0KTsKCQlkdXJhdGlvbiA9IGdldF9kdXJhdGlvbigkNSk7CgkJYnl0
ZXMgPSBnZXRfYnl0ZXMoJDcpOwoKCQlpZih0eXBlID09ICJCVUxLIikgewoJCQlpZihmbGlwX2hl
YWRlcikgewoJCQkJZmxpcF9oZWFkZXI9MDsKCQkJCXByaW50ZigiJTA2ZDogIFVSQl9GVU5DVElP
Tl9TRUxFQ1RfQ09ORklHVVJBVElPTlxuIixteU5SKyspOwoJCQl9CgkJCSMgKCUwMmQgYnl0ZXMp
CgkJCXByaW50ZigiJTA2ZDogIE9VVDogJTA3ZCB1cyAlMDdkIG1zIEJVTEtbJTA1ZF0gJXMgJXNc
biIsbXlOUixkdXJhdGlvbixlbGFwc2VkLGNpZSxkaXJlY3Rpb24sdG9sb3dlcigkMTYpKTsKCQl9
CgoJCWlmKHR5cGUgPT0gIkNvbnRyb2xUcmFuc2ZlciIpCgkJCXByaW50ZigiJTA2ZDogIE9VVDog
JTA3ZCB1cyAlMDdkIG1zIENvbnRyb2xUcmFuc2ZlciAlcyAlc1xuIixteU5SLGR1cmF0aW9uLGVs
YXBzZWQsZGlyZWN0aW9uLHRvbG93ZXIoJDE2KSk7IAp9Cgo=
--089e013d19cc2ae0df04e82c69fa--
