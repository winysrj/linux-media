Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab2COSGM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 14:06:12 -0400
Message-ID: <4F622F88.9080502@redhat.com>
Date: Thu, 15 Mar 2012 15:06:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Gianluca Gennari <gennarone@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] cxd2820r: tweak search algorithm, enable LNA in DVB-T
 mode
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <4F6229D4.8010302@redhat.com> <4F622BBD.7050605@iki.fi>
In-Reply-To: <4F622BBD.7050605@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-03-2012 14:49, Antti Palosaari escreveu:
> On 15.03.2012 19:41, Mauro Carvalho Chehab wrote:
>> Em 15-03-2012 14:33, Gianluca Gennari escreveu:
>>> The PCTV 290e had several issues on my mipsel-based STB (powered by a
>>> Broadcom 7405 SoC), running a Linux 3.1 kernel and the Enigma2 OS.
>>>
>>> The most annoying one was that the 290e was able to tune the lone DVB-T2
>>> frequency existing in my area, but was not able to tune any DVB-T channel.
>>>
>>> Following a suggestion of the original author of the driver, I tried to
>>> tweak the wait time in the lock loop. In fact, increasing the wait time
>>> from 50 to 200ms in the tuning loop was enough to get the lock on most
>>> channels.
>>> But channel change was quite slow and sometimes, doing an automatic scan,
>>> some frequency was not locked.
>>> So instead of playing with the timings I changed the behavior of the
>>> search algorithm as explained in the patch 1, with very good results.
>>>
>>> With this modification, the automatic scan is 100% reliable and zapping
>>> is quite fast (on the STB). There is no noticeable difference when using
>>> Kaffeine on the PC.
>>>
>>> But there was a further issue: a few weak channels were affected by high
>>> BER and badly corrupted pictures. The same channels were working fine on
>>> an Avermedia A867 stick (as well as other sticks).
>>>
>>> The driver has an option to enable a "Low Noise Amplifier" (LNA) before the
>>> demodulator. Enabling it, the reception of weak channels improved a lot,
>>> as reported in the description of patch 2.
>>
>> Hi Gianluca,
>>
>> With regards to LNA, the better is to add a DVBv5 property for it.
>>
>> The LNA is generally located at the antenna, and not at the device.
> 
> LNA inside antenna, or near antenna, is called amplifier. Power to that amplifier is feed by device or power supply using antenna cable.
> 
> I see LNA more likely amplifier that is inside device. It could be external chip between tuner IC and antenna connector or more usually logical part inside tuner IC.
> 
> Thus I see two different use cases here. 1) LNA, 2) power supply to amplifier.

Yes, there are those two types of amplifiers. Some vendors ship hardware with
a power amplify inside their antenna, and call it as LNA (as it is a low noise
amplifier).

>> As you know, more than one device may be connected to the same antenna,
>> and it is generally not a good idea to have two devices sending power to
>> the LNA.
>>
>> So, it is better to have a way to turn it on via the usespace API.
>>
>> Also, as this consumes power, the better is to do it only when the device
>> is actually used.
> 
> I think we need API support for LNA/amp + internal API support for AUTO LNA.

Yes.

> Originally I added LNA support as a module param for em28xx-dvb but Mauro NACKed it thus it is hard coded. Anyhow, some method switching LNA on/off is better than no method at all

Well, adding one or two DVBv5 properties to enable/disable the LNA is very easy.

So, instead of adding hacks, let's just do the right thing.

> 
> regards
> Antti
> 

Regards,
Mauro
