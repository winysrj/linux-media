Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:60154 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3AHX2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 18:28:54 -0500
Received: by mail-qc0-f171.google.com with SMTP id d1so1158392qca.2
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 15:28:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1718385.5pOCXcV7mc@f17simon>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com>
	<10526351.JB9QcZTfut@f17simon>
	<50EC5EAB.9050705@googlemail.com>
	<1718385.5pOCXcV7mc@f17simon>
Date: Tue, 8 Jan 2013 18:28:53 -0500
Message-ID: <CAGoCfiwwLwJkjZhEZP6-ek6cs6j51kNEDTC2LSmDnbimgX0KLQ@mail.gmail.com>
Subject: Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties for Quality of Service
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 8, 2013 at 6:18 PM, Simon Farnsworth
<simon.farnsworth@onelan.com> wrote:
> The wireless folk use dBm (reference point 1 milliwatt), as that's the
> reference point used in the 802.11 standard.
>
> Perhaps we need an extra FE_SCALE constant; FE_SCALE_DECIBEL has no reference
> point (so suitable for carrier to noise etc, or for when the reference point
> is unknown), and FE_SCALE_DECIBEL_MILLIWATT for when the reference point is
> 1mW, so that frontends report in dBm?
>
> Note that if the frontend internally uses a different reference point, the
> conversion is always going to be adding or subtracting a constant.

Hi Simon,

Probably the biggest issue you're going to have is that very few of
the consumer-grade demodulators actually report data in that format.
And only a small subset of those actually provide the documentation in
their datasheet.

The goal behind the "strength" indicator is to provide a field even an
idiot can understand.  While I appreciate the desire to be able to
access the data in it's an "advanced" format, in reality the number of
demodulator drivers that would actually be able to report such is very
small -- and the approach prevents a "lowest common denominator",
which is what 99% of the users *actually* care about.

For that matter, even the SNR field being reported in dB isn't going
to allow you to reliably compare across different demodulator chips.
If demod X says 28.3 dB and demod Y says 29.2 dB, that doesn't
*really* mean demod Y performs better - just that it's reporting a
better number.  However it *does* allow you to compare the demod
against itself either across multiple frequencies or under different
signal conditions - which is what typical users really care about.

And while I realize in your case, Simon, that your requirements may be
different from typical consumer-grade applications, I worry that
adding yet more complexity to the solution will just result in getting
*NOTHING*, as we have for all these years every time the issue of
signal statistics has been raised.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
