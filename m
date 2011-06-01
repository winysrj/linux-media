Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38695 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab1FAQYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 12:24:24 -0400
Received: by wya21 with SMTP id 21so4227809wya.19
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 09:24:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE64531.2050301@redhat.com>
References: <4C125DD5.6060604@anevia.com>
	<4CBD9543.2050107@anevia.com>
	<4CBDC1CC.6030704@gmail.com>
	<4DE64531.2050301@redhat.com>
Date: Wed, 1 Jun 2011 21:54:22 +0530
Message-ID: <BANLkTi=DED6Op1Viq7chGUZFcsMTYYdo6g@mail.gmail.com>
Subject: Re: [PATCH] stb0899: Removed an extra byte sent at init on DiSEqC bus
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Florent AUDEBERT <florent.audebert@anevia.com>,
	linux-media@vger.kernel.org,
	Florent Audebert <faudebert@anevia.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 6/1/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 19-10-2010 14:05, Mauro Carvalho Chehab escreveu:
>> Em 19-10-2010 10:55, Florent AUDEBERT escreveu:
>>> On 06/11/2010 06:01 PM, Florent AUDEBERT wrote:
>>>> I noticed a stray 0x00 at init on DiSEqC bus (KNC1 DVB-S2) with a DiSEqC
>>>> tool analyzer.
>>>>
>>>> I removed the register from initialization table and all seem to go well
>>>> (at least for my KNC board).
>>>
>>> Hi,
>>>
>>> This old small patch had been marked superseded on patchwork[1].
>>>
>>> Is there an non-obvious case when patches go superseded ? Perhaps I
>>> missed
>>> something but it seems to me no other patch replaced it.
>>
>> This is one of the bad things with patchwork: there's no "reason" field
>> associated
>> to a status change, nor it marks when the status were changed.
>>
>> A search on my linux-media box, showed that this patch were there, waiting
>> for
>> Manu review, at the email I sent on Jul, 6 2010. The patch still applies,
>> and
>> I didn't find any reply from Manu giving any feedback about it.
>>
>> So, I'm re-tagging it as under review.
>>
>> Manu, any comments about this patch (and the other remaining patches that
>> we're
>> waiting fro your review) ?
>
> Manu,
>
> Please ack or nack this patch. It was sent about 1,5 years ago! if you don't
> comment, I'll assume that this patch is ok and I'll apply it.
>
> Thanks,
> Mauro.

Mauro,

I have been away from home and not yet back due to a nasty back
sprain, but expect to return mid next week. Please hold off on the
patches that you need inputs from my side. I will get back on these,
the following weekend.

Sorry about any inconvenience caused.

Thanks,
Manu
