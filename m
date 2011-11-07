Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:50958 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1KGTQo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 14:16:44 -0500
Message-ID: <4EB82E98.9030105@linuxtv.org>
Date: Mon, 07 Nov 2011 20:16:40 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Luca Olivetti <luca@ventoso.org>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon signal strength
References: <4EA78E3C.2020308@lockie.ca> <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com> <4EA86366.1020906@lockie.ca> <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com> <4EA86668.6090508@lockie.ca> <20111105111050.5b8762fa@grobi> <CAGoCfiwC+7pkY6ZchySBYRkyY1XjFjKeJYQEPTc2ZiBN-pdoyw@mail.gmail.com> <20111106141515.5b56a377@grobi> <CAGoCfixoOwZumohwJrLVKhfpUNGYwbD9uSq7nM0GhqriOx0FxA@mail.gmail.com> <20111106205907.47b9102b@grobi> <4EB7B75B.70004@linuxtv.org> <4EB7F57E.4060303@ventoso.org>
In-Reply-To: <4EB7F57E.4060303@ventoso.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.11.2011 16:13, Luca Olivetti wrote:
> Al 07/11/2011 11:47, En/na Andreas Oberritter ha escrit:
>> I didn't receive Devin's mail, so I'm replying to this one instead, see
>> below:
> 
> [...]
>> Quoting myself from three years ago, I propose to add an interface to
>> read SNR in units of db/100:
> 
> A previous version of the dvb api specified the unit of snr as db/1000000
> 
> http://linuxtv.org/downloads/legacy/old/linux_dvb_api-20020304.pdf
> 
> page 55, FE_READ_SIGNAL_STRENGTH
> 
> "The signal-to-noise ratio, as a multiple of 10E-6 dB, is stored into *snr.
> Example: a value of 12,300,000 corresponds to a signal-
> to-noise ratio of 12.3 dB."
> 
> It also defined the unit for ber (multiple of 10E-9).
> 
> However it was dropped from subsequent revisions, I don't know why.
> 
> Bye

It was dropped because most (or all?) of the drivers available at the
time were created without access to register descriptions and thus
nobody of the developers knew how to calculate meaningful values and/or
nobody was allowed to publish code based on confidential information. It
was decided that big values meant good signal instead, which was good
enough to print a signal meter bar without any real numbers.

The situation has changed since then. I think two decimal digits should
be sufficient. A value displayed to the user would probably have at most
one decimal digit. The SNR measured by a demodulator isn't very
accurate, so adding more decimal digits doesn't improve the precision.

Personally, I don't care much whether the unit is db/10, db/100 or
db/1000. I just think db/100 is a reasonable choice and IIRC it's the
unit that most of the vendor drivers I've seen in the past are using.

Regards,
Andreas
