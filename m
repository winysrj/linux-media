Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZCSNQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 09:16:33 -0400
Date: Thu, 19 Mar 2009 10:16:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
Message-ID: <20090319101601.2eba0397@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>
	<a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	<49B9DECC.5090102@nav6.org>
	<412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	<Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	<412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	<Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009 16:55:40 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Fri, 13 Mar 2009, Devin Heitmueller wrote:
> > On Fri, Mar 13, 2009 at 5:11 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > I like 8.8 fixed point a lot better.  It gives more precision.  The range
> > > is more in line with that the range of real SNRs are.  Computers are
> > > binary, so the math can end up faster.  It's easier to read when printed
> > > out in hex, since you can get the integer part of SNR just by looking at
> > > the first byte.  E.g., 25.3 would be 0x194C, 0x19 = 25 db, 0x4c = a little
> > > more than quarter.  Several drivers already use it.
> >
> > Wow, I know you said you like that idea alot better, but I read it and
> > it made me feel sick to my stomach.  Once we have a uniform format, we
> > won't need to show it in hex at all.  Tools like femon and scan can
> 
> But if you do see it in hex, it's easier to understand.  If it's not shown
> in hex, you still have better precision and better math.  What advantage is
> there to using something that's 4.1 decimal fixed point on a binary
> computer?

It is most important to set a SNR scale (whatever it is) than to keep this
decision up to each driver author. I'm sure we all agree with this.

A common good practice in the community is to try to achieve a common sense on
what's reasonable, when changing the API. However, sometimes this is not
possible. So, if a consensus is not archived, the maintainer should take the
hard decision of choosing one proposal in favor of another, after listening to
arguments from both sides.

I really believe that we can get a consensus in this case. So, I'm proposing
that we should discuss about it for some time, comparing each alternatives we
have, focused on SNR only. Later, use can use the same approach for the
other quality measurements on DVB.

In order to start such discussions, I'm summarizing both proposals under the
same perspective.

I'm also presenting some criteria that are important on this scope

People are welcome to contribute and to argue in favor/against each one.

Let's establish a timeframe for discussions up to Sunday, 29. It would be
really great if we can go into a consensus until then.

---

Being objective, we have right now 2 proposals, for using the 16 bit integer.
I'll assume that we'll have one bit used by signal on either proposal, since
negative SNR's can be measured as well. Yet, for the calculus bellow, I will
consider only absolute numbers.

So, on both proposals, we have 1 bit for signal and 15 bits to be used for
storing the absolute numbering representation.

Those are the proposals:

1) use a 0.1 dB in order to represent the SNR. 

This means that we'll range abs(SNR) from 0.0 dB to 3276.7 dB.
The minimal measure step is 0.1 dB. 

Doing some calculus, the proposal is to use:
	use 3.3219 bits = log2(10) - for representing the 0.1 step fractional
part;
	use 11.6781 bits for the decimal part (2^11.6781 ~= 3276).

The SNR(dB) will be given by:
	SNR(dB) = driver_SNR_measure / 10;

2) The second proposal is to represent the 7-bits MSB as the integer part of
the SNR, in dB, and the 8-bits LSB as the fractional part. 

Doing some calculus, to have the same set of values, for comparision:

The minimum fractional number we can represent is 1/256 = 0.039dB.
This means that we'll range abs(SNR) from 0.0 dB to 127.998 dB, with the
minimal measure step is 0.039 dB.

The SNR(dB) will be given by:
	SNR(dB) = driver_SNR_measure / 256;

If I didn't make any mistake, this is what we have:

-----------+------+--------+------+----------------------+-----------------------------------
           |  Abs |   Abs  | Step |     16 bits usage    | Formula for converting into dB 
           |Min dB| Max dB | in dB| signal/int/fraction  | 
-----------+------+--------+------+----------------------+-----------------------------------
Proposal 1 | 0.0  | 3276.7 |  0.1 | 1 / 11.6781 / 3.3219 | SNR(dB) = driver_SNR_measure  / 10
-----------+------+--------+------+----------------------+-----------------------------------
Proposal 2 | 0.0  | 127.998| 0.039| 1 /  7      / 8      | SNR(dB) = driver_SNR_measure / 256
-----------+------+--------+------+----------------------+-----------------------------------

In order to compare both proposals, we should establish some decision criteria.
Those are the ones that seems to be relevant for such discussions, in order
of relevance.

1) Max/min range analysis

We should choose the number of bits for the decimal to be capable enough to
represent the maximum absolute value for SNR, otherwise, we'll loose precision
at the part that interests most. So, we should have enough bits to represent
the maximum practical values for SNR.

2) Step analysis

The minimal step size, the better precision we'll have. This will help to
provide extra info for adjusting antenna, for example, or fine-tuning the
frequency to the one that offers more quality.

3) Computational efforts and Math precision

The computer math representation inside the non-math CPU circuits on
almost all architectures assume that numbers are represented as fractions,
instead of decimal numbers. So, using a fixed number of bits to represent the
fractional part means faster calculus, and minimizes imprecision caused by
rounding the numbers.

4) Comparison with other APIs

It is a good idea to see what other API's are doing on such cases. 

In the case of the analog V4L2 API, control values like bright, contrast, etc
are represented as a fraction, where there's an ioctl to provide the value range
(max, min and step values).

Also, due to historical reasons, the frequency is represented as a 62.5 Hz step
(or 62.5 kHz step, depending on a capability field), and this works fine: all
userspace apps know how to handle, and this is not a problem at all. On all
places where this is used, the values are correctly and quickly converted.

Cheers,
Mauro
