Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:49188 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZCTOVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 10:21:49 -0400
Received: by yw-out-2324.google.com with SMTP id 5so993833ywb.1
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 07:21:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.0903191558530.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <Pine.LNX.4.58.0903191558530.28292@shell2.speakeasy.net>
Date: Fri, 20 Mar 2009 10:21:47 -0400
Message-ID: <412bdbff0903200721l63f038c5na461dda2f91ecc16@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2009 at 7:06 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
>> The argument being put forth is based on the relative efficiency of
>> the multiply versus divide opcodes on modern CPU architectures??  And
>
> Maybe I just like writing efficient code to do interesting things?

Wow, um, ok.  You realize that getting the SNR on most devices is
probably going to require an i2c call that is going to take a couple
hundred CPU instructions, not to mention I/O, right?  And that you're
doing this in an expensive ioctl call?  So perhaps a
micro-optimization with no visible gain, at the cost of readability
and complexity shouldn't be a overriding consideration?

>> that you're going to be able to get an SNR with a higher level of
>> precision than 0.1 dB?? (if the hardware suggests that it can then
>> it's LYING to you)
>
> Not really.  Absolute accuracy is not going to be that good of course.  But
> the error measurements from which SNR is calculated do support precision of
> better than 0.1 dB.  That precision does give you more power when fine
> tuning antenna position.
>
> Put another way, what advantage is there of less precision?

Well, here is one disadvantage:  The driver decides the SNR is 23.1.
So I convert that to your format:  0x1719.  Then userland gets it back
and goes to display it.  I'm going to show the user an SNR of
23.09765625, and I have no way to know what the expected precision
(and thus I don't know where to round).  So the end result is the user
sees a really stupid number in the GUI (and might actually think it is
more accurate than it really is).  Or when I push patches to
applications I just round to 0.1dB anyway.  It also means apps like
femon and zap are going to have to change to support a non-fixed width
result with no appreciable gain in value.

By saying explicitly there is one digit of precision - it allows for
applications to know how to round, and I continue to disagree with
your assertion that you will get any better accuracy with that anyway.
 We could *in theory* provide a separate ioctl so the driver can know
what the expected precision is, but I do not believe it is worthwhile
to over-engineer the interface.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
