Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36815 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2KFUdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 15:33:35 -0500
Message-ID: <50997401.7050805@iki.fi>
Date: Tue, 06 Nov 2012 22:33:05 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?w4FydmFpIFpvbHTDoW4=?= <zarvai@inf.u-szeged.hu>
CC: linux-media@vger.kernel.org, moebius <moebius1@free.fr>
Subject: Re: avermedia, new version of avertv volar green hd
References: <5096B744.40308@free.fr> <5097B2FE.3090100@inf.u-szeged.hu>
In-Reply-To: <5097B2FE.3090100@inf.u-szeged.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any idea about chipset? Those listed didn't sound any familiar. What are 
driver file names?

regards
Antti

On 11/05/2012 02:37 PM, Árvai Zoltán wrote:
> Hi,
>
> I asked the local guy from Avermedia about this tuner.
> He said it is a new product called  "AVerTV Volar HD M" (A835M). It has
> probably the same hardware like the Volar Green, but it has extended
> software bundle (e.g. Mac support).
> http://www.avermedia.com/Product/ProductDetail.aspx?Id=517
>
> Regards,
> Zoltan
>
>
> On 11/04/2012 07:43 PM, moebius wrote:
>> Bonjour,
>> It's a dvb-t usb dongle
>>
>> It's the same name than a former device but with new id : 07ca:3835
>> instead of 07ca:a835 and probably new hardware ; and it doesn't work...
>>
>> I've tried to enter a new device in the v4l-dvb web list but nothing
>> has happened ;  the source, can be found at
>> http://www.linuxtv.org/wiki/index.php?title=DVB-T_USB_Devices_ListData/Helper&action=edit&section=1
>>
>> I've made a photo too but don't know how I can upload it.
>>
>> Anyway, here is the source :
>>
>> ==== AVerMedia AVerTV Volar Green HD 07ca:3835 ====
>> {{DeviceDisplayMedium|AVerMedia AVerTV Volar Green HD 07ca:3835}}
>> </noinclude><includeonly>
>> {{{{{renderwith}}}|src=USB_Device_Data|selatt1={{{selatt1|}}}|selval1={{{selval1|}}}|selatt2={{{selatt2|}}}|selval2={{{selval2|}}}|selatt3={{{selatt3|}}}|selval3={{{selval3|}}}|selatt4={{{selatt4|}}}|selval4={{{selval4|}}}
>>
>> | did=AVerMedia AVerTV Volar Green HD 07ca:3835
>> | vendor=[[AVerMedia]]
>> | device=[[AVerMedia AVerTV Volar Green HD | AVerTV Volar Green HD]]
>> | standard=DVB-T
>> | supported={{no}}
>> | pic=
>> | pic=
>> | url=
>> | url=
>> | hostinterface=USB2.0
>> | usbid=07ca:3835
>> | hw=unknown (see pic)
>> | tuner=
>> | demodulator=
>> | usbbridge=
>> | fw=
>> | comment= New version with same name ; main chipset (square, 4x12
>> pins) named AV3007 SXB1102 ; a little chip with 8 pins named 402R6
>> K207, another one with 5 pins 215L1(or "I" instead of "1") AC1H ; last
>> small chip with metal on top T120 WtBF.
>> This device don't work on recent ubuntu kernel (3.2.0-23-lowlatency),
>> even with the last (04/11/2012) v4l drivers that I've downloaded and
>> install today.
>> }}
>>
>> cordialement,
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
