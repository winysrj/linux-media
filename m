Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:41948 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZA0UOo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 15:14:44 -0500
Message-ID: <497F6B2E.6010305@gmail.com>
Date: Wed, 28 Jan 2009 00:14:38 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on	HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com> <c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
In-Reply-To: <c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alex Betis wrote:
> On Mon, Jan 26, 2009 at 7:50 PM, Manu Abraham <abraham.manu@gmail.com>wrote:
> 
>>
>> On Mon, Jan 26, 2009 at 8:19 PM, Alex Betis <alex.betis@gmail.com> wrote:
>>
>>> Latest changes I can see at
>>>> http://mercurial.intuxication.org/hg/s2-liplianin/ were made about 7
>>>> to 10 days ago. Is this correct? If that's correct, then I'm using
>>>> latest Igor drivers. And behavior described above is what I'm getting.
>>>>
>>>> I can't see anything related do high SR channels on Igor repository.
>>> He did it few months ago. If you're on latest than you should have it.
>>>
>>>
>>
>> It won't. All you will manage to do is burn your demodulator, if you happen
>> to
>> be that lucky one, with that change. At least a few people have burned
>> demodulators by now, from what i do see.
>>
> What are the symptoms of burned demodulator? How can someone know if its
> still ok?

The first time i saw it was that the DVB-S2 demod was returning no
carrier. After some time it was stating timing error for DVB-S as
well. Finally it all ended up with demodulator I2C ACK failure, and
eventually a frozen machine after a week (my test boxes run throughout)

Touching the demodulator, i happened to have almost a burned finger.
I wanted to know whether this was a single case. During the
development phase, i did mention it to Julian about this, since he
was the very first person to test for the stb0899 driver. He
jovially laughed about a burned demodulator and a finger, left his
machine on after i did some tests on it. Eventually he too had the
same results. Finally we changed cards.

> 
> Does your mantis driver work ok with such channels?

I don't have such channels. Tested with a max of 27.5 MSPS

Regards,
Manu

