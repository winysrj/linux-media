Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1JjKBJ-0005bB-Ay
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 22:12:38 +0200
Received: by rn-out-0910.google.com with SMTP id e11so2501318rng.17
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 13:12:31 -0700 (PDT)
Message-ID: <3cc3561f0804081312g7e2436a0p54b0eaa7ca8c7f09@mail.gmail.com>
Date: Wed, 9 Apr 2008 00:12:29 +0400
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "Anssi Hannula" <anssi.hannula@gmail.com>
In-Reply-To: <47F021EB.6010104@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAASuTAGpqJw0asMd7tD3VNFwEAAAAA@tv-numeric.com>
	<47F021EB.6010104@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Interpretation of FE_READ_BER
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

>  > What is the interpretation of the value returned by ioctl FE_READ_BER?
> AFAIK the exact meaning of all the values is driver/device-specific.

I think you are right.

>  > There is no clue in the Linux DVB API doc. Google reports similar
>  > questions but none with an answer. I have just seen one note suggesting
>  > it could be a multiple of 10^-9. Looks good to me but since there is
>  > no good definition of this parameter in the docs, I wonder if drivers
>  > implement them in a consistent way.
> I don't think so.

Correct again. This is not consistent.

> > With my Nova-T 500 (Fedora 8, kernel 2.6.24.3-12, recent v4l hg tree),
> > the reception is quite fine, FE_READ_SIGNAL_STRENGTH returns 40000
> > (60%),
> > but FE_READ_BER always returns 0. Does this mean "not even the slightest
> > error" (to good to be true), "not supported" (should return errno ENOSYS),
> > "driver bug"?
> 0 can very well mean there is no errors, it is not that uncommon (I've
>  seen it with my devices in good conditions).

Again correct, but since there is no consistency on what this number
is supposed to represent, you really cannot know. This could be the
actual ber on reception ( BER before FEC as the pro's call it ), which
would usually be somewhere around 10^-5 to 10^-5, but not nessesarily.
With the 250 sqare meters (2500 sqare feet) antenna where I used to
work we usually got it bit-error free straight of the satellite, even
in really bad weather. It all depends on the signal level you get.
There are theoretical maximums on this, and you can usually quite
accurately calculate SNR and Eb/N0 from only having the BER rate.
If the number is BER after FEC, it should be somewhere around 10^-9 to
10^-10. If this is the case then the number is usually completely
wrong because it is often based on the Reed Solomon error correction
circuits/software, and one bit-error or ten will usually count as one.
It could even be a BER after RS, and if that is the case, you will
have distortions in your picture from time to time.

As mentioned it is impossible to tell. Having everyone doing the same
thing would be very nice, so that one could actually use this info for
something useful. This is the "problem" with open source and no real
project management. There is probably no real way of fixing it since
there will always be some developer for some new hardware that does
not really know what the different things are, and will just do
something. And I can appreciate the complexity of it, as some chips
give you a BER based on BER last second, while another will give you
Bit Errors since last time you read the register, while a third one
gives you an update BER every five seconds, and the fourth one gives
you Bit Errors since laste tune. Not an easy task by any means.

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
