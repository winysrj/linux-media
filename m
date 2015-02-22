Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63226 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbBVNsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 08:48:41 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so21021393wgg.11
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 05:48:40 -0800 (PST)
Message-ID: <54E9DDFE.4010507@gmail.com>
Date: Sun, 22 Feb 2015 14:47:42 +0100
From: Gilles Risch <gilles.risch@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com>
In-Reply-To: <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

most of the used components are identified:
- USB Controller: Empia EM2884
- Stereo A/V Decoder: Micronas AVF 49x0B
- Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A3 0.9.0
The only ambiguity is the tuner, but I think it could be a Xceive XC5000 
because the windows driver comprises the xc5000 firmware and it is 100% 
identical:
     $ mkdir extract-xc5000-fw
     $ cd extract-xc5000-fw
     $ wget http://linuxtv.org/downloads/firmware/dvb-fe-xc5000-1.6.114.fw
     $ wget 
http://elgatoweb.s3.amazonaws.com/Documents/Support/EyeTV_Hybrid/EyeTV_Hybrid_2008_509081301_W8.exe
     $ 7z -y e EyeTV_Hybrid_2008_509081301_W8.exe
     $ dd if=emBDA.sys of=dvb-fe-xc5000-test.fw bs=1 skip=518800 
count=12401 >/dev/null 2>&1
     $ md5sum dvb-fe-xc5000-1.6.114.fw dvb-fe-xc5000-test.fw
     b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-1.6.114.fw
     b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-test.fw

The Elgato_EyeTV_Hybrid.inf file contains a comment with "TerraTec H5", 
which components are assembled on that USB stick?


Regards,
Gilles

On 02/21/2015 08:08 PM, Olli Salonen wrote:
> Hi Gilles,
>
> Not sure if the following information will help you, but here comes.
> The USB bridge is EM2884, supported by em28xx driver. The Micronas
> demodulator is probably supported by drxk driver. Tuner I did not
> recognize after a quick glimpse. That sandwich construction look like
> something PCTV has used with some of their designs (290e and 292e for
> example).
>
> In order to have a driver for your device you need to have each
> individual component supported (USB bridge, demod and tuner). Then
> these can be combined into a driver (typically by modifying the USB
> bridge driver).
>
> Cheers,
> -olli
>
> On 20 February 2015 at 18:19, Gilles Risch <gilles.risch@gmail.com> wrote:
>> Hello,
>>
>> I'm owning an Elgato EyeTV hybrid USB stick that I'm using daily on my
>> iMac, now I'd like to use it on my laptop too but I'm unable to get it
>> running. Is this device already supported? If not, is there any way I
>> can help? I've already opened my device and uploaded the photos to the
>> linux TV wiki page
>> (http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_hybrid).
>> I'm not sure which tuner is mounted on the PCB, therefor I've made two
>> USB traces, maybe someone could interpret them and conclude which one
>> is used:
>> https://www.dropbox.com/s/99b2a17ohu0zqpz/20150219-EyeTV_Hybrid_capturedTV.pcap?dl=0
>> https://www.dropbox.com/s/q4k8zf8d3qpxznu/20150219-EyeTV_Hybrid_Pluggedin.pcap?dl=0
>>
>> Kind regards,
>> Gilles
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

