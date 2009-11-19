Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:14323 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZKSWSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 17:18:06 -0500
Message-ID: <4B05C41E.20509@orange.fr>
Date: Thu, 19 Nov 2009 22:18:06 +0000
From: Andy Low <andrew.low@orange.fr>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [Fwd: Anyone got a KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)
 to work properly?]
References: <4B0576A7.7000103@orange.fr> <4B05879A.4040602@iki.fi>
In-Reply-To: <4B05879A.4040602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Antti Palosaari wrote:
>
> On 11/19/2009 06:47 PM, Andy Low wrote:
>> ...kernel: Quantek QT1010 successfully identified.
>
> The reason is QT1010 which does not perform very well. Generally it
> locks better to weak signals, you can try weaker antenna and signal
> attenuator.
>
> Antti

Thanks for your very fast response!!

I have tried again with various different arrangements of antennas.  Any
further reduction in signal strength causes the working multiplexes to
be lost.  Checking the relative signal strengths on my working dvb-t
system, the 2 multiplexes that the KWorld stick can receive are the 2
most powerful.  Maybe I need more signal, not less?  Under Windows the
KWorld works very well on all multiplexes - surely this means that the
QT1010 is OK here and that the linux drivers should be able to work?? 
The multiplexes that work are both FEC_3_4 and QAM16.  None of the
FEC_2_3/QAM64 channels work.  Could it be that the receiver is not being
set up correctly?

Thanks again for any suggestions.  Andy
