Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45966 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaLPDku (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 22:40:50 -0500
Message-ID: <548FA9BE.8090509@iki.fi>
Date: Tue, 16 Dec 2014 05:40:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mark Clarkstone <hello@markclarkstone.co.uk>,
	Carlos Diogo <cdiogo@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Instalation issue on S960
References: <CAEzPJ9M=uOY_ujbp7XtrRq3N4jq6L3r_84qggfbQ4xEpX12u-w@mail.gmail.com>	<CAEzPJ9NqYNo2BV0j2jujVO+p3w73qxZOoM3K8J+yebFMVwwhWQ@mail.gmail.com> <CADBe_Tu72XRS=EFEcdLK8wLLsLO60NSvSw18=Rb0aaSeg3WiSg@mail.gmail.com>
In-Reply-To: <CADBe_Tu72XRS=EFEcdLK8wLLsLO60NSvSw18=Rb0aaSeg3WiSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2014 02:09 AM, Mark Clarkstone wrote:
> Hi,
>
> I was recently trying to build drivers for another tuner on a Pi and
> also came across a similar problem [unable to find symbols], it turns
> out that the Raspberry Pi kernel doesn't have I2C_MUX enabled which is
> needed by some modules.

That's likely the reason as I2C mux is needed by m88ds3103 driver.

Antti
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
