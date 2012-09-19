Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60960 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab2ISKl6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 06:41:58 -0400
Message-ID: <5059A161.7040907@iki.fi>
Date: Wed, 19 Sep 2012 13:41:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus (attempt 2)
References: <1348006936-6334-1-git-send-email-oliver+list@schinagl.nl> <5058F8F2.90106@iki.fi> <505995D3.7010201@schinagl.nl>
In-Reply-To: <505995D3.7010201@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2012 12:52 PM, Oliver Schinagl wrote:
> On 19-09-12 00:42, Antti Palosaari wrote:
>> On 09/19/2012 01:22 AM, oliver@schinagl.nl wrote:
>>> From: Oliver Schinagl <oliver@schinagl.nl>
>>>
>>> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
>>> in its current form gets detected and loads properly. It uses the
>>> af9035 USB Bridge chip, with an af9033 demodulator. The tuner used is
>>> the FCI FC2580.
>>>
>>> I have only done a quick dvb scan, but it failed to tune to anything.
>>> Using dvbv5-scan -I CHANNEL <channelfile> It did show 'signal 100%' but
>>> failed to tune to anything, so I don't think signal strength works at
>>> all. Since I have really bad reception where my dev PC is, I may simple
>>> not receive anything here.
>>
>> Signal strength is very worst indicator. It should not be 100% in any
>> case. Switch off stupid % meter your are using and look plain numbers.
>> It is should be something between 0-0xffff (0xffff == 100% ?).
> I know 100% says nothing :p and I think especially with this driver? I
> didn't see the signal strength function implemented in the FC2580 (I
> have some code for it, once I have the device actually working :) But
> this is what dvbv5-scan reported.

Have to say have never used tool. Instead w_scan, scan (dvbscan, 
scandvb) and tzap. If you get working channels.conf file for your area 
you are able to use tzap.

Signal strength is reported by af9033 demodulator regardless if tuner 
could report it or not.

>> For me successful tzap reports (af9035 + tua9001):
>> status 1f | signal 5eb7 | snr 010e | ber 00000000 | unc 00000000 |
>> FE_HAS_LOCK
>>
>> FE_HAS_LOCK is most important, it says demodulator is locked to
>> channel and likely device is 100% working.
> I can't use tzap, as I can't scan for channel file. As I write this, I
> remember that I may have one on another system so should be able to use
> that to try tonight.
>
> Furthermore, when checking debug while it's running a scan (either
> dvbscan or dvbv5-scan) I notice that it passes the loop 5 times, but I
> think that's normal from what I can tell from the code. Also
> fc2580_get_if_frequency appears to be a stub, correct?

I suspect it tests different parameters. Like one iteration for each 
bandwidth. If you know your area transmission parameters you could skip 
whole scanning and just waste only two seconds using tzap to test.

fc2580_get_if_frequency is not stub, it is correctly implemented. FC2580 
is direct conversion tuner (== zero-IF, IF 0 Hz) which means it 
transfers RF band directly to the base-band. No IF used.

>> Biggest problem of your patch is fc2580 frontend callback. fc2580
>> driver does not use any callback and that code is simple dead. It is
>> never called.
> Ah, assumption eh, I simply thought the callback is always used by the
> driver. I noticed some tuners do have the callback, others do their init
> just once. What's the cleanest solution, leave the code in the callback,
> and call it from fc9035_tuner_attach? (As you otherwise get a huge
> tuner_attach function). Anyway, why do some tuners have the callback and
> others don't? I guess it's a design decision of the driver, but why
> aren't they more equal?

There should not be frontend callback unless needed. The basic (and only 
one I know?) use scenario for tuner callback is to control some tuner 
external pins using bridge GPIO. If there is no such pins then there is 
no need for callback. For example digital AGC you asked earlier is such 
control pin (actually 2 pins) but as it is not used no need for 
callback. TUA9001 is good example of tuner having control pins.

I think you refer fc0011 tuner callbacks. There seems to be reset and 
power. At least power sounds something like it should not be there, I 
suspect it is just some GPIO that turns on/off power from tuner and not 
control any fc0011 pin.

Antti

-- 
http://palosaari.fi/
