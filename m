Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f43.google.com ([209.85.128.43]:51596 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbeKTFcM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 00:32:12 -0500
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Cc: Stakanov Schufter <stakanov@freenet.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <s5hbm6l5cdi.wl-tiwai@suse.de> <20181119155326.24f6083f@coco.lan>
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <b5291f02-a40b-52f9-8824-5aa2ef0f1dcc@gmail.com>
Date: Mon, 19 Nov 2018 19:07:09 +0000
MIME-Version: 1.0
In-Reply-To: <20181119155326.24f6083f@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

On 19/11/2018 17:53, Mauro Carvalho Chehab wrote:
> Hi Takashi,
> 
> Em Mon, 19 Nov 2018 16:13:29 +0100
> Takashi Iwai <tiwai@suse.de> escreveu:
> 
>> Hi,
>>
>> we've got a regression report on openSUSE Bugzilla regarding DVB-S PCI
>> card:
>>   https://bugzilla.opensuse.org/show_bug.cgi?id=1116374
>>
>> According to the reporter (Stakanov, Cc'ed), the card worked fine on
>> 4.18.15, but since 4.19, it doesn't give any channels, sound nor
>> picture, but only EPG is received.
> 
> Receiving just EPG is weird.
> 
>>
>> The following errors might be relevant:
>>
>> ================
>> [    4.845180] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
>> [    4.869703] b2c2-flexcop: MAC address = xx:xx:xx:xx:xx:xx
>> [    5.100318] b2c2-flexcop: found 'ST STV0299 DVB-S' .
>> [    5.100323] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
>> [    5.100370] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> 
> 
>> [  117.513086] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 frequency 1549000 out of range (950000..2150)
>> [  124.905222] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 frequency 1880000 out of range (950000..2150)
>> [  127.337079] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 frequency 1353500 out of range (950000..2150)
> 
> That indicates that it is trying to tune to an unsupported frequency. For
> DVB-S, all frequencies above should be in kHz.

Kaffeine reports the wrong LNB frequency ranges for universal Europe... I just use Astra 1E settings instead which I am pretty sure is the same?

I am using the stv0299 / dvb_pll(opera1) combi and not reporting any problems other than the streaming issue with dvb-usb-v2 which I don't think this uses?

Regards

Malcolm
