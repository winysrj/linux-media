Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45662 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab2BKMqn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 07:46:43 -0500
Message-ID: <4F36632A.3010700@iki.fi>
Date: Sat, 11 Feb 2012 14:46:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair Buxton <a.j.buxton@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: SDR FM demodulation
References: <4F33DFB8.4080702@iki.fi> <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
In-Reply-To: <CAO-Op+Fn0AxiqD4367O7H7AziR4g2vnFCMtsVcu1iRvf6P5iYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.02.2012 09:00, Alistair Buxton wrote:
> On 9 February 2012 15:01, Antti Palosaari<crope@iki.fi>  wrote:
>
>> Decode it and listen some Finnish speak ;)
>
> Done. grc and output.wav here: http://al.robotfuzz.com/~al/rtl2832/
>
> The trick was realising that the UChar to Float converter does not
> adjust it's output to the range -1.0,1.0 that the wideband FM
> demodulator block expects as input. Once I figured that out the rest
> was easy. Just set the quadrature rate to the samples per second in
> the source file, and the decimation to quadrature rate/output sink
> rate. The source file appears to be about 2 to 2.2 million samples per
> second. Any higher than that and the person speaking sounds like a
> chipmunk. Maybe 22050 * 1000 or 1024? Does any Finnish station
> broadcast "pips" like the BBC does? That could be used to determine
> the actual rate.

Cool!
I did that whole last night up to 6 am. I also ended up very similar 
blocks, but failed to convert bytes as UChar. I tried to add constant 
between Deinterleave and UChar To Float but it wasn't possible. So my 
first idea was to make Python script to make for the sample when I 
wake-up. But no need anymore :)

It was very good learning session and I am very impressed about GNU 
Radio capability. Idea tool for learning signal handling in practise. I 
see that device has big potential for students as it is very cheap SDR, 
everyone can get own!

Now someone should make Linux driver that can tune that device to 
different frequencies and look what it really can do.

What kind of driver architecture should be used? Use device 100% 
userspace or make it working as Kernel driver? I suspect making it as 
Kernel driver could be too limited since V4L/DVB API restrictions?

regards
Antti
-- 
http://palosaari.fi/
