Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:60554 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZA0V1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 16:27:34 -0500
Message-ID: <497F7C40.6030300@gmail.com>
Date: Wed, 28 Jan 2009 01:27:28 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on	HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>	<497F6B2E.6010305@gmail.com> <c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
In-Reply-To: <c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alex Betis wrote:
> On Tue, Jan 27, 2009 at 10:14 PM, Manu Abraham <abraham.manu@gmail.com>wrote:
> 
>> Alex Betis wrote:
>>>> It won't. All you will manage to do is burn your demodulator, if you
>> happen
>>>> to
>>>> be that lucky one, with that change. At least a few people have burned
>>>> demodulators by now, from what i do see.
>>>>
>>> What are the symptoms of burned demodulator? How can someone know if its
>>> still ok?
>> The first time i saw it was that the DVB-S2 demod was returning no
>> carrier. After some time it was stating timing error for DVB-S as
>> well. Finally it all ended up with demodulator I2C ACK failure, and
>> eventually a frozen machine after a week (my test boxes run throughout)
>>
>> Touching the demodulator, i happened to have almost a burned finger.
>> I wanted to know whether this was a single case. During the
>> development phase, i did mention it to Julian about this, since he
>> was the very first person to test for the stb0899 driver. He
>> jovially laughed about a burned demodulator and a finger, left his
>> machine on after i did some tests on it. Eventually he too had the
>> same results. Finally we changed cards.
> 
> What frequency did you use to burn it?


It was a long time back, don't remember. It has nothing to do with
the frequency of the transponder, but just the master clock. You can
run it to a maximum of 108Mhz overclocked, 99Mhz to be safe and
sufficient.


> I didn't see anyone here on the list that reported a hardware failure so
> far.

May god help you. I didn't know that you knew more than the
demodulator manufacturer !


> By the way, Igor returned the chip frequency for 27.5 channels to 99MHz and
> raised it a bit for higher SR channels, so there is no danger for majority
> of the users.

Ok, be happy with his change and keep quiet. 135Mhz is out of bounds
of the hardware specification. You are on your own. Raising the
master clock, doesn't bring you any advantage.

>From your statement (and the patch), it is clearly evident that you
don't understand head or tail what you are stating or patched the
code for:

For a lower sampling frequency (aka Symbol rate), you need a higher
clock and or higher time period. For higher sampling rates (Symbol
Rates) the the master clock has to be decimated to  avoid overflows

This implies the patch to increase the master clock for acquisition
at a higher symbol rate was utter nonsense only.

All i have is to say:

Alas !

