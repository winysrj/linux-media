Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:55706 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1EDO2A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 10:28:00 -0400
Message-ID: <4DC1626C.1020206@linuxtv.org>
Date: Wed, 04 May 2011 16:27:56 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Ngene cam device name
References: <208PeDoec2016S01.1304517902@web01.cms.usa.net>
In-Reply-To: <208PeDoec2016S01.1304517902@web01.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/04/2011 04:05 PM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>> It wouldn't have multiple adapters numbers either.
> 
> What do you mean by they shouldn't have mulitple adapters numbers ? Multiple
> WinTV-CI devices should have distinct node parents, ie
> /dev/dvb/adapter[01]/<node>

I wrote "wouldn't", not "shouldn't". I'm fine with it.

>>> With the transmitted keys changed frequently (at least for viaccess),
> what's
>>> the point in supporting offline descrambling when it will not work
> reliably
>>> for all ?
>>
>> The reliability of offline descrambling depends on the network operators
>> policy. So while it won't be useful for everybody in the world, it might
>> well be useful to all customers of certain operators.
>>
>>> As for descrambling multiple tv channels from different transponders with
> only
>>> one cam, this is already possible. An example is what Digital Devices
> calls
>>> MTD (Multi Transponder Decrypting). But this is CAM dependent, some do
> not
>>> support it.
>>
>> What's the point if it doesn't work reliably for everybody? ;-)
> 
> 
> Well, isn't it easier to change a CAM than an operator ? For many of us in
> France/Belgium, you might even have no choice at all for the operator.

Again it depends on the operator, whether getting a working CAM at all
is possible, putting aside that there's no guarantee that it would work
with "MTD". But I really don't mind. See the smiley. I was just
referring to your similar question. I wasn't going to tell that foo was
better than or even related to bar, but just that foo is a good feature
for many people. I also consider bar a good feature.

>>>> Why don't you just create a new device, e.g. ciX, deprecate the use of
>>>> caX for CI devices, inherit CI-related existing ioctls from the CA API,
>>>> translate the existing read and write funtions to ioctls and then use
>>>> read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
>>>> pretty sure this can be done without too much code and in a backwards
>>>> compatible way.
>>>
>>>
>>> I'm open to this idea, but is there a consensus on this big API change ?
>>> (deprecating ca device) If yes, I will try to prepare something.
>>
>> The existing API could be copied to linux/dvb/ci.h and then simplified
>> and reviewed.
>>
> 
> As I said, if you can create a consensus behind your idea, then I will try to
> prepare something.

I don't think this is going to happen, as nobody really seems to care
(me included). I was just pointing out ways that I consider more likely
to succeed.

Regards,
Andreas
