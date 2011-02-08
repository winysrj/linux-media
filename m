Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61656 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1BHQjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 11:39:23 -0500
Received: by wyb28 with SMTP id 28so5898296wyb.19
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 08:39:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297122870.2355.21.camel@localhost>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	<20110206232800.GA83692@io.frii.com>
	<AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
	<6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
	<AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
	<1297122870.2355.21.camel@localhost>
Date: Tue, 8 Feb 2011 09:39:21 -0700
Message-ID: <AANLkTikwyL09v+KfNQ1Y3yOgjJy-XgjSuqg0at7tuU8K@mail.gmail.com>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Dave Johansen <davejohansen@gmail.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 7, 2011 at 4:54 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2011-02-06 at 22:18 -0700, Dave Johansen wrote:
>> On Sun, Feb 6, 2011 at 9:10 PM, Daniel O'Connor <darius@dons.net.au> wrote:
>> The error output happens after the scanning of 189028615:8VSB. No
>> additional output is added during or after it locks up at the warning
>> message that is displayed.
>>
>> Is there any additional information that I can provide to help debug this issue?
>
> You perhaps could
>
> A. provide the smallest window of known good vs known bad kernel
> versions.  Maybe someone with time and hardware can 'git bisect' the
> issue down to the problem commit.  (I'm guessing this problem might be
> specific to a particular 64 bit platform IOMMU type, given the bad
> dma_ops pointer.)
>
> B. Try the latest drivers and/or bleeding edege kernel to see if the
> problem has already been solved.  (Back up your current stuff first.)
>
> Regards,
> Andy
>
>> Thanks,
>> Dave
>
>
>

Is there some sort of instructions out there on how to do this sort of
testing to isolate where the problem started? Also, is it possible to
do it in a virtual machine or something to that effect to make the
deployment of the various systems easier?

Thanks,
Dave
