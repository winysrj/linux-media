Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:59540 "EHLO
        homiemail-a122.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751033AbdEaUBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 16:01:07 -0400
Subject: Re: Fwd: [PATCH] em28xx: add support for Hauppauge WinTV-dualHD DVB
 tuner
To: Christian Steiner <christian.steiner@outlook.de>,
        Olli Salonen <olli.salonen@iki.fi>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1459782772-21451-1-git-send-email-olli.salonen@iki.fi>
 <570A6FED.4090700@outlook.de>
 <CAAZRmGy1=8UXe0WqpucCt0qUfZQS+NHsHYmAq3yKu_pxK38yTw@mail.gmail.com>
 <CAAZRmGzXcHz21m4yL4rFOpippzLq07nYsenwTvUgqkhbRJ8X4w@mail.gmail.com>
 <VI1P194MB004719DAD98521F900F5D11191FD0@VI1P194MB0047.EURP194.PROD.OUTLOOK.COM>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <b2017939-2029-a306-8767-3f11e780959e@nextdimension.cc>
Date: Wed, 31 May 2017 15:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <VI1P194MB004719DAD98521F900F5D11191FD0@VI1P194MB0047.EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christian et al,

I am an engineer at Hauppauge. This repo is the staging area for all the
patches I am testing, with the intention of getting them upstreamed. I
will be inaccessible for the next 18 days however, so I will not be able
to put any effort until I get back.

Cheers,

Brad



On 2017-05-27 10:38, Christian Steiner wrote:
> Hello,
>
> I have found patches that add support for the second tuner:
> https://github.com/b-rad-NDi/Ubuntu-media-tree-kernel-builder/tree/master/patches/ubuntu-zesty-4.10.0/extra
>
> I can confirm that they also work with the latest kernel (4.12.0-rc2).
> Would it be possible to integrate these patches into mainline?
> Applying 0006-Hauppauge-WinTV-DualHD-DVB-ATSC-second-tuner-support.patch
> is sufficient for the second tuner to appear, but I guess we should
> include all patches.
>
> Best regards,
> Christian
>
>
> On 11.04.2016 11:14, Olli Salonen wrote:
>> Hi Christian,
>>
>> Thanks for reporting back your experience. Certainly there's a chance
>> of supporting the second tuner too. There are still two issues that I
>> have not solved:
>>
>> 1. I haven't gotten the 2nd tuner working yet (alone, without the
>> first tuner), even if I think all the pieces of the puzzle are there.
>> 2. em28xx driver is built with one tuner in mind and needs significant
>> structural changes. If there's anyone very familiar with the em28xx
>> driver here, I'd be happy to hear your idea of what is entailed for
>> this.
>>
>> Cheers,
>> -olli
>>
>> On 10 April 2016 at 18:23, Christian Steiner
>> <christian.steiner@outlook.de> wrote:
>>> On 04.04.2016 17:12, Olli Salonen wrote:
>>>> Hauppauge WinTV-dualHD is a USB 2.0 dual DVB-T/T2/C tuner with
>>>> following components:
>>>>
>>>> USB bridge: Empia EM28274 (chip id is the same as EM28174)
>>>> Demodulator: 2x Silicon Labs Si2168-B40
>>>> Tuner: 2x Silicon Labs Si2157-A30
>>>>
>>>> This patch adds support only for the first tuner.
>>>>
>>>> [...]
>>> Thank you very much!
>>> Works fine for me:
>>>
>>>> [  419.413188] em28xx: New device HCW dualHD @ 480 Mbps (2040:0265, interface 0, class 0)
>>>> [  419.413195] em28xx: DVB interface 0 found: isoc
>>>> [  419.413265] em28xx: chip ID is em28174
>>>> [  420.529619] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x7addc1c8
>>>> [  420.529626] em28174 #0: EEPROM info:
>>>> [  420.529630] em28174 #0:      microcode start address = 0x0004, boot configuration = 0x01
>>>> [  420.536077] em28174 #0:      AC97 audio (5 sample rates)
>>>> [  420.536084] em28174 #0:      500mA max power
>>>> [  420.536089] em28174 #0:      Table at offset 0x27, strings=0x0e6a, 0x1888, 0x087e
>>>> [  420.536188] em28174 #0: Identified as Hauppauge WinTV-dualHD DVB (card=98)
>>>> [  420.537974] tveeprom 8-0050: Hauppauge model 204109, rev B2I6, serial# 11XXXXXX
>>>> [  420.537981] tveeprom 8-0050: tuner model is SiLabs Si2157 (idx 186, type 4)
>>>> [  420.537986] tveeprom 8-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
>>>> [  420.537989] tveeprom 8-0050: audio processor is None (idx 0)
>>>> [  420.537993] tveeprom 8-0050: has no radio, has IR receiver, has no IR transmitter
>>>> [  420.537997] em28174 #0: dvb set to isoc mode.
>>>> [  420.538056] usbcore: registered new interface driver em28xx
>>>> [  420.541087] em28174 #0: Binding DVB extension
>>>> [  420.544008] i2c i2c-8: Added multiplexed i2c bus 9
>>>> [  420.544016] si2168 8-0064: Silicon Labs Si2168 successfully attached
>>>> [  420.548372] si2157 9-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
>>>> [  420.548389] DVB: registering new adapter (em28174 #0)
>>>> [  420.548396] usb 2-2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
>>>> [  420.549737] em28174 #0: DVB extension successfully initialized
>>>> [  420.549743] em28xx: Registered (Em28xx dvb Extension) extension
>>>> [  435.418798] si2168 8-0064: found a 'Silicon Labs Si2168-B40'
>>>> [  435.418823] si2168 8-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
>>>> [  435.617181] si2168 8-0064: firmware version: 4.0.11
>>>> [  435.619791] si2157 9-0060: found a 'Silicon Labs Si2157-A30'
>>>> [  435.642006] si2157 9-0060: firmware version: 3.0.5
>>> (I have replaced the last digits of the serial number with X)
>>>
>>> Is there any chance to add support for the second tuner, too?
>>> This would be awesome.
>>>
>>> Best,
>>> Christian
>>>
