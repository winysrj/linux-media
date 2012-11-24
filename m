Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:58893 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2KXNRQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 08:17:16 -0500
Message-ID: <50B0C8D2.7000903@free.fr>
Date: Sat, 24 Nov 2012 14:17:06 +0100
From: moebius <moebius1@free.fr>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: avermedia, new version of avertv volar green hd
References: <5096B744.40308@free.fr> <5097B2FE.3090100@inf.u-szeged.hu> <50997401.7050805@iki.fi> <50997C8F.6020006@iki.fi> <509A648F.3070803@free.fr> <509A7CD5.3030202@iki.fi> <50AF7911.8080500@free.fr> <50AFB59C.80404@iki.fi>
In-Reply-To: <50AFB59C.80404@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bonjour,

There's nothing on the PCB back ; all chips are on the front side, side 
that I've shot

cordialement,



Le 23/11/2012 18:42, Antti Palosaari a écrit :
> Totally new chipset (AV3007) or markings are changed. Did you look
> another side of PCB if there is some other chips?
>
> I suspect it is all integrated to that chip unless there is RF-tuner on
> the other side of PCB.
>
> Without the lsusb, driver, and any other info we cannot help more.
>
> regards
> Antti
>
>
>
> On 11/23/2012 03:24 PM, moebius wrote:
>> Bonjour,
>>
>> A little in late but here is the pic location :
>>
>> http://dl.free.fr/n7m8Gfe5q
>>
>> cordialement,
>>
>>
>>
>> Le 07/11/2012 16:23, Antti Palosaari a écrit :
>>> Hello
>>> If possible put those pictures somewhere to the net and give link
>>> everyone could take a look. If that's not possible then I am still happy
>>> to get those pics to my that email address.
>>>
>>> regards
>>> Antti
>>>
>>> On 11/07/2012 03:39 PM, moebius wrote:
>>>> Bonjour,
>>>>
>>>> This is not possible anymore : the device has returned to the seller !
>>>> But AV3007 is perhaps a compagny chip (AV = avermedia ?)
>>>>
>>>> cordialement,
>>>>
>>>> PS : if you give me an adress, I can post the picture of the opened
>>>> device
>>>>
>>>> Le 06/11/2012 22:09, Antti Palosaari a écrit :
>>>>> Also lsusb -vvd 07ca:3835 could be nice to see.
>>>>>
>>>>> Antti
>>>>>
>>>>> On 11/06/2012 10:33 PM, Antti Palosaari wrote:
>>>>>> Any idea about chipset? Those listed didn't sound any familiar. What
>>>>>> are
>>>>>> driver file names?
>>>>>>
>>>>>> regards
>>>>>> Antti
>>>>>>
>>>>>> On 11/05/2012 02:37 PM, Árvai Zoltán wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I asked the local guy from Avermedia about this tuner.
>>>>>>> He said it is a new product called  "AVerTV Volar HD M" (A835M). It
>>>>>>> has
>>>>>>> probably the same hardware like the Volar Green, but it has extended
>>>>>>> software bundle (e.g. Mac support).
>>>>>>> http://www.avermedia.com/Product/ProductDetail.aspx?Id=517
>>>>>>>
>>>>>>> Regards,
>>>>>>> Zoltan
>>>>>>>
>>>>>>>
>>>>>>> On 11/04/2012 07:43 PM, moebius wrote:
>>>>>>>> Bonjour,
>>>>>>>> It's a dvb-t usb dongle
>>>>>>>>
>>>>>>>> It's the same name than a former device but with new id : 07ca:3835
>>>>>>>> instead of 07ca:a835 and probably new hardware ; and it doesn't
>>>>>>>> work...
>>>>>>>>
>>>>>>>> I've tried to enter a new device in the v4l-dvb web list but
>>>>>>>> nothing
>>>>>>>> has happened ;  the source, can be found at
>>>>>>>> http://www.linuxtv.org/wiki/index.php?title=DVB-T_USB_Devices_ListData/Helper&action=edit&section=1
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> I've made a photo too but don't know how I can upload it.
>>>>>>>>
>>>>>>>> Anyway, here is the source :
>>>>>>>>
>>>>>>>> ==== AVerMedia AVerTV Volar Green HD 07ca:3835 ====
>>>>>>>> {{DeviceDisplayMedium|AVerMedia AVerTV Volar Green HD 07ca:3835}}
>>>>>>>> </noinclude><includeonly>
>>>>>>>> {{{{{renderwith}}}|src=USB_Device_Data|selatt1={{{selatt1|}}}|selval1={{{selval1|}}}|selatt2={{{selatt2|}}}|selval2={{{selval2|}}}|selatt3={{{selatt3|}}}|selval3={{{selval3|}}}|selatt4={{{selatt4|}}}|selval4={{{selval4|}}}
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> | did=AVerMedia AVerTV Volar Green HD 07ca:3835
>>>>>>>> | vendor=[[AVerMedia]]
>>>>>>>> | device=[[AVerMedia AVerTV Volar Green HD | AVerTV Volar Green
>>>>>>>> HD]]
>>>>>>>> | standard=DVB-T
>>>>>>>> | supported={{no}}
>>>>>>>> | pic=
>>>>>>>> | pic=
>>>>>>>> | url=
>>>>>>>> | url=
>>>>>>>> | hostinterface=USB2.0
>>>>>>>> | usbid=07ca:3835
>>>>>>>> | hw=unknown (see pic)
>>>>>>>> | tuner=
>>>>>>>> | demodulator=
>>>>>>>> | usbbridge=
>>>>>>>> | fw=
>>>>>>>> | comment= New version with same name ; main chipset (square, 4x12
>>>>>>>> pins) named AV3007 SXB1102 ; a little chip with 8 pins named 402R6
>>>>>>>> K207, another one with 5 pins 215L1(or "I" instead of "1") AC1H ;
>>>>>>>> last
>>>>>>>> small chip with metal on top T120 WtBF.
>>>>>>>> This device don't work on recent ubuntu kernel
>>>>>>>> (3.2.0-23-lowlatency),
>>>>>>>> even with the last (04/11/2012) v4l drivers that I've downloaded
>>>>>>>> and
>>>>>>>> install today.
>>>>>>>> }}
>>>>>>>>
>>>>>>>> cordialement,
>>>>>>>>
>>>>>>>>
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-media" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>> linux-media" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>
>
