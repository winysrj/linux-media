Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58477 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaLPT7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 14:59:12 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so13417288wiv.17
        for <linux-media@vger.kernel.org>; Tue, 16 Dec 2014 11:59:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADBe_Tu72XRS=EFEcdLK8wLLsLO60NSvSw18=Rb0aaSeg3WiSg@mail.gmail.com>
References: <CAEzPJ9M=uOY_ujbp7XtrRq3N4jq6L3r_84qggfbQ4xEpX12u-w@mail.gmail.com>
	<CAEzPJ9NqYNo2BV0j2jujVO+p3w73qxZOoM3K8J+yebFMVwwhWQ@mail.gmail.com>
	<CADBe_Tu72XRS=EFEcdLK8wLLsLO60NSvSw18=Rb0aaSeg3WiSg@mail.gmail.com>
Date: Tue, 16 Dec 2014 20:59:10 +0100
Message-ID: <CAEzPJ9PsbZiDE8eZpXPFiZuHo9XjjTEdrz6ntYk+nZ-j9795_w@mail.gmail.com>
Subject: Re: Instalation issue on S960
From: Carlos Diogo <cdiogo@gmail.com>
To: Mark Clarkstone <hello@markclarkstone.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi , thanks for the inputs. Some more details on the issue.
When i try to build the drivers the m88ds3103 driver is not built (no
.o /.ko file generated) but also no error shows up. For whatever
reason the make process skips this drivers.
I enabled the i2c and re-started the build process which takes as
couple of hours.

At the end the module was still not compiled and the error continues.
Any other ideas?



On Tue, Dec 16, 2014 at 1:09 AM, Mark Clarkstone
<hello@markclarkstone.co.uk> wrote:
> Hi,
>
> I was recently trying to build drivers for another tuner on a Pi and
> also came across a similar problem [unable to find symbols], it turns
> out that the Raspberry Pi kernel doesn't have I2C_MUX enabled which is
> needed by some modules.
>
> You could try rebuilding the kernel with the above option enabled and
> see if that helps.
>
> Although I could be totally wrong and hopefully someone with more
> knowledge will know (I'm still pretty much a Linux noob :p).
>
> Hope this helps.
>
> On 15 December 2014 at 23:13, Carlos Diogo <cdiogo@gmail.com> wrote:
>> Dear support team ,
>> i have spent 4 days trying to get my S960 setup in my raspberrry Pi
>>
>> I have tried multiple options and using the linuxtv.org drivers the
>> power light switches on but then i get the below message
>>
>>
>>
>> [    8.561909] usb 1-1.5: dvb_usb_v2: found a 'DVBSky S960/S860' in warm state
>> [    8.576865] usb 1-1.5: dvb_usb_v2: will pass the complete MPEG2
>> transport stream to the software demuxer
>> [    8.591803] DVB: registering new adapter (DVBSky S960/S860)
>> [    8.603974] usb 1-1.5: dvb_usb_v2: MAC address: 00:18:42:54:96:0c
>> [    8.650257] DVB: Unable to find symbol m88ds3103_attach()
>> [    8.661452] usb 1-1.5: dvbsky_s960_attach fail.
>> [    8.683560] usbcore: registered new interface driver dvb_usb_dvbsky
>>
>> I have tried googling it but i have found nothing about this
>>
>> i'm using raspbian , with kernel 3.12.34
>>
>> Any help here?
>>
>> Thanks in advance
>> Carlos
>>
>>
>> --
>> Os meus cumprimentos / Best regards /  Mit freundlichen Grüße
>> Carlos Diogo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Os meus cumprimentos / Best regards /  Mit freundlichen Grüße
Carlos Diogo
