Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab2IWSOQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 14:14:16 -0400
Message-ID: <505F5174.2020809@redhat.com>
Date: Sun, 23 Sep 2012 15:14:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Anders Thomson <aeriksson2@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com> <5054C521.1090200@gmail.com> <20120915192530.74aedaa6@redhat.com> <50559241.6070408@gmail.com> <505844A0.30001@redhat.com> <5059C242.3010902@gmail.com> <5059F68F.4050009@redhat.com> <505A1C16.40507@gmail.com> <CAGncdOae+VoAAUWz3x84zUA-TCMeMmNONf_ktNFd1p7c-o5H_A@mail.gmail.com> <505C7E64.4040507@redhat.com> <8ed8c988-fa8c-41fc-9f33-cccdceb1b232@email.android.com> <505EF455.9080604@redhat.com> <505F4CBC.1000201@gmail.com>
In-Reply-To: <505F4CBC.1000201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-09-2012 14:54, Anders Thomson escreveu:
> On 2012-09-23 13:36, Mauro Carvalho Chehab wrote:
>> Em 22-09-2012 11:32, Anders Eriksson escreveu:

>> I suspect that, in the case of your board, the LNA is at the antenna bundled
>> together with the device. If I'm right, by enabling LNA, your board is sending
>> some voltage through the cabling (you could easily check it with a voltmeter).
> I actually have a multimeter somewhere. We're talking about the
> antenna-in (unconnected) on the card, right? And what voltages
> should I expect?

zero (or close to zero) if LNA is disabled; some volts when LNA is enabled ;)
According with Wikipedia[1]:

Usually LNA require less operating voltage in the range of 2 .. 10 V. MAX 2640 operate at +2.7 .. +5.5 V.

[1] http://en.wikipedia.org/wiki/Low-noise_amplifier

(Satellites amplifiers are typically 13V-18V - I never actually tried to use LNA for
 terrestrial systems).

>>
>> What I think that your patch is actually doing is to disable LNA. As such, it
>> should be equivalent to:
>>
>>
>> diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
>> index bc08f1d..98b482e 100644
>> --- a/drivers/media/pci/saa7134/saa7134-cards.c
>> +++ b/drivers/media/pci/saa7134/saa7134-cards.c
>> @@ -3288,13 +3288,13 @@ struct saa7134_board saa7134_boards[] = {
>>           .name           = "Pinnacle PCTV 310i",
>>           .audio_clock    = 0x00187de7,
>>           .tuner_type     = TUNER_PHILIPS_TDA8290,
>>           .radio_type     = UNSET,
>>           .tuner_addr     = ADDR_UNSET,
>>           .radio_addr     = ADDR_UNSET,
>> -        .tuner_config   = 1,
>> +        .tuner_config   = 0,
>>           .mpeg           = SAA7134_MPEG_DVB,
>>           .gpiomask       = 0x000200000,
>>           .inputs         = {{
>>               .name = name_tv,
>>               .vmux = 4,
>>               .amux = TV,
>>
>>
>> Please test if the above patch fixes the issue you're suffering[1]. If so, then
>> we'll need to add a modprobe parameter to allow disabling LNA for saa7134 devices
>> with LNA.
>>
>> [1] Note: the above is not the fix, as some users of this board may be using the
>> original antenna, and changing tuner_config will break things for them; the right
>> fix is likely to allow controlling the LNA via userspace.
> Tried that patch on 3.5.3. No improvement, unfortunately.

That's weird. Well, then we need to read tda827x datasheets and to try get information
data from Pinnacle about this specific device configuration.

> 
> Regards,
> /Anders

