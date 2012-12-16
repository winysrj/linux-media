Return-path: <linux-media-owner@vger.kernel.org>
Received: from 88-149-150-131.v4.ngi.it ([88.149.150.131]:39439 "EHLO
	vajra.unixproducts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2LPVQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 16:16:36 -0500
To: <linux-media@vger.kernel.org>
Subject: Re: cannot make this Asus my cinema-u3100miniplusv2 work under linux
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 16 Dec 2012 22:16:31 +0100
From: Renato Gallo <renatogallo@unixproducts.com>
In-Reply-To: <50CE3070.10309@iki.fi>
References: <8e9f16405c8583e35cb97bb7d7daef4b@unixproducts.com>
 <50CDDF9A.1080509@iki.fi>
 <cd31dc6ada9161825c7dff975a3da945@unixproducts.com>
 <50CE0AFA.9030308@iki.fi>
 <1af6a5408ee3ebccebc3885bba06fc69@unixproducts.com> <50CE3070.10309@iki.fi>
Message-ID: <810ffd737b21a0f46e383a76dd4313a2@unixproducts.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stock one that came with the device

http://unixproducts.com/antenna.jpg


Il 16/12/2012 21:34 Antti Palosaari ha scritto:
> It is very likely weak signal issue as I said. What kind of antenna
> you are using?
>
> Antti
>
>
> On 12/16/2012 10:13 PM, Renato Gallo wrote:
>> i found it is a problem with kaffeine, with other programs i can 
>> lock a
>> signal but reception is very very sketchy (like in unviewable).
>>
>> GlovX xine-lib # dmesg |grep e4000
>> GlovX xine-lib # dmesg |grep FC0012
>> GlovX xine-lib # dmesg |grep FC0013
>> [   28.281685] fc0013: Fitipower FC0013 successfully attached.
>> GlovX xine-lib # dmesg |grep FC2580
>> GlovX xine-lib # dmesg |grep TUA
>> GlovX xine-lib #
>>
>>
>> Il 16/12/2012 18:55 Antti Palosaari ha scritto:
>>> On 12/16/2012 07:15 PM, Renato Gallo wrote:
>>>> now the modules loads and kaffeine recognizes the device but i 
>>>> cannot
>>>> find any channels.
>>>> can it be a tuner bug ?
>>>
>>> I think it is bad antenna / weak signal. Try w_scan, scan, tzap.
>>>
>>> Could you say which RF-tuner it finds from your device? use dmesg 
>>> to
>>> dump output. It could be for example e4000, FC0012, FC0013, FC2580,
>>> TUA9001 etc.
>>>
>>> Antti
>>>
>>>>
>>>>
>>>> kaffeine(5978) DvbDevice::frontendEvent: tuning failed
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 0 pid = 0
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 2 pid = 17
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 4 pid = 16
>>>> kaffeine(5978) DvbDevice::frontendEvent: tuning failed
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 0 pid = 0
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 2 pid = 17
>>>> kaffeine(5978) DvbScanFilter::timerEvent: timeout while reading 
>>>> section;
>>>> type = 4 pid = 16
>>>> kaffeine(5978) DvbDevice::frontendEvent: tuning failed
>>>>
>>>>
>>>> Il 16/12/2012 15:50 Antti Palosaari ha scritto:
>>>>> On 12/16/2012 04:23 PM, Renato Gallo wrote:
>>>>>> any news on this ?
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Asus my cinema-u3100miniplusv2
>>>>>>
>>>>>> Bus 001 Device 015: ID 1b80:d3a8 Afatech
>>>>>>
>>>>>> [ 6956.333440] usb 1-6.3.6: new high-speed USB device number 16 
>>>>>> using
>>>>>> ehci_hcd
>>>>>> [ 6956.453943] usb 1-6.3.6: New USB device found, idVendor=1b80,
>>>>>> idProduct=d3a8
>>>>>> [ 6956.453950] usb 1-6.3.6: New USB device strings: Mfr=1, 
>>>>>> Product=2,
>>>>>> SerialNumber=0
>>>>>> [ 6956.453955] usb 1-6.3.6: Product: Rtl2832UDVB
>>>>>> [ 6956.453959] usb 1-6.3.6: Manufacturer: Realtek
>>>>>>
>>>>>
>>>>> Seems to be Realtek RTL2832U. Add that USB ID to the driver and 
>>>>> test.
>>>>> It is very high probability it starts working.
>>>>>
>>>>> Here is the patch:
>>>>>
>>>>>
>>>>> 
>>>>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/rtl28xxu-usb-ids
>>>>>
>>>>>
>>>>>
>>>>> Please test and report.
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
