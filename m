Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55446 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1BHQvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 11:51:31 -0500
Received: by wwa36 with SMTP id 36so6233367wwa.1
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 08:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110208152525.GA47904@io.frii.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	<20110206232800.GA83692@io.frii.com>
	<AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
	<6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
	<AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
	<1297122870.2355.21.camel@localhost>
	<20110208152525.GA47904@io.frii.com>
Date: Tue, 8 Feb 2011 09:51:29 -0700
Message-ID: <AANLkTinD2JVkxzMQt+LWXQ78UBKoSzYXkWG1hJ6d9T5s@mail.gmail.com>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Dave Johansen <davejohansen@gmail.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Feb 8, 2011 at 8:25 AM, Mark Zimmerman <markzimm@frii.com> wrote:
> On Mon, Feb 07, 2011 at 06:54:30PM -0500, Andy Walls wrote:
>>
>> You perhaps could
>>
>> A. provide the smallest window of known good vs known bad kernel
>> versions.  Maybe someone with time and hardware can 'git bisect' the
>> issue down to the problem commit.  (I'm guessing this problem might be
>> specific to a particular 64 bit platform IOMMU type, given the bad
>> dma_ops pointer.)
>>
>
> FYI: I am on the process of doing a git bisect (10 kernels to go) to
> track down this problem:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg25342.html
>
> Which may or may not be related to the problem in this thread.
>

I'm using Mythbuntu 10.10 x64, which I believe uses 2.6.35 but I will
check tonight, so if the issue you're tracking down really is related
to 2.6.36, then I imagine that my problem wouldn't be caused by what
you're looking into. Plus, every time I've looked at dmesg the
firmware has loaded properly, so I'm guessing I'm on 2.6.35 and being
affected by a different issue.

Thanks for the heads up,
Dave
