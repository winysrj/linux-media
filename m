Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:38834 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbZA0UFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 15:05:37 -0500
Message-ID: <497F6909.40109@gmail.com>
Date: Wed, 28 Jan 2009 00:05:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: ajurik@quick.cz
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com> <1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com> <157f4a8c0901261212i16af9570x60e6886039778ffe@mail.gmail.com> <200901262128.36242.ajurik@quick.cz>
In-Reply-To: <200901262128.36242.ajurik@quick.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ales Jurik wrote:
> On Monday 26 of January 2009, Chris Silva wrote:
>> On Mon, Jan 26, 2009 at 5:50 PM, Manu Abraham <abraham.manu@gmail.com> 
> wrote:
>>> On Mon, Jan 26, 2009 at 8:19 PM, Alex Betis <alex.betis@gmail.com> wrote:
>>>>> Latest changes I can see at
>>>>> http://mercurial.intuxication.org/hg/s2-liplianin/ were made about 7
>>>>> to 10 days ago. Is this correct? If that's correct, then I'm using
>>>>> latest Igor drivers. And behavior described above is what I'm getting.
>>>>>
>>>>> I can't see anything related do high SR channels on Igor repository.
>>>> He did it few months ago. If you're on latest than you should have it.
>>> It won't. All you will manage to do is burn your demodulator, if you
>>> happen to
>>> be that lucky one, with that change. At least a few people have burned
>>> demodulators by now, from what i do see.
>>>
>>>
>>> Regards,
>>> Manu
>> Manu, would you be so kind to explain why it will burn the demodulator?
>> It happens only with 30000 transponders? And only with this card?
>> Does this mean I can't use my card to see channels on 30000 transponders?
>>
>> Chris
> 
> Regarding the documentation the demodulator is designed to run at max. freq. 
> 99MHz. Some series of demods burn when the freq is set above this value. But 
> this value is enough for most of transponders with SR up to 30000.
> 
> Some Russian transponders have SR 43500 - so the demod is set a little bit 
> above 3x of this value. This could be dangerous.
> 
> This patch (or change) doesn't solve the problem with SR of 30000 and FEC 3/4 
> or 5/6.
> 
> BR,
> 
> Ales


True, very much.

Regards,
Manu
