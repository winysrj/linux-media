Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:36039 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3AMNbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 08:31:01 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id r0DDUvxf032498
	for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 14:30:57 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id r0DDUo4g019784
	for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 14:30:51 +0100
Message-ID: <50F2B70A.7070406@tvdr.de>
Date: Sun, 13 Jan 2013 14:30:50 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties
 for Quality of Service
References: <1357604750-772-1-git-send-email-mchehab@redhat.com> <1718385.5pOCXcV7mc@f17simon> <CAGoCfiwwLwJkjZhEZP6-ek6cs6j51kNEDTC2LSmDnbimgX0KLQ@mail.gmail.com> <9912400.S8YXz1JbUM@f17simon>
In-Reply-To: <9912400.S8YXz1JbUM@f17simon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.01.2013 12:02, Simon Farnsworth wrote:
> On Tuesday 8 January 2013 18:28:53 Devin Heitmueller wrote:
>> On Tue, Jan 8, 2013 at 6:18 PM, Simon Farnsworth
>> <simon.farnsworth@onelan.com> wrote:
>>> The wireless folk use dBm (reference point 1 milliwatt), as that's the
>>> reference point used in the 802.11 standard.
>>>
>>> Perhaps we need an extra FE_SCALE constant; FE_SCALE_DECIBEL has no reference
>>> point (so suitable for carrier to noise etc, or for when the reference point
>>> is unknown), and FE_SCALE_DECIBEL_MILLIWATT for when the reference point is
>>> 1mW, so that frontends report in dBm?
>>>
>>> Note that if the frontend internally uses a different reference point, the
>>> conversion is always going to be adding or subtracting a constant.
>>
>> Hi Simon,
>>
>> Probably the biggest issue you're going to have is that very few of
>> the consumer-grade demodulators actually report data in that format.
>> And only a small subset of those actually provide the documentation in
>> their datasheet.
>>
> <snip>
> My specific concern is that we already see people complaining that their cable
> system or aerial installer's meter comes up with one number, and our
> documentation has completely different numbers. When we dig, this usually
> turns out to be because our documentation is in dBm, while their installer is
> using dBmV or dBµW, and no-one at the customer site knows the differences.
>
> If consumer demods don't report in a dB scale at all, we should drop dB as a
> unit; if they do report in a true dB scale, but the reference point is
> normally not documented, we need some way to distinguish demods where the
> reference point is unknown, and demods where someone has taken the time to
> find the reference point (which can be done with a signal generator).
>
> This is sounding more and more like an argument for adding
> FE_SCALE_DECIBEL_MILLIWATT - it gives those applications that care a way to
> tell the user that the signal strength reading from the application should
> match up to the signal strength reading on your installer's kit. Said
> applications could even choose to do the conversions for you, giving you all
> four commonly seen units (dBm, dBmV at 50Ω, dBmV at 75Ω, dBµW).
>
>> For that matter, even the SNR field being reported in dB isn't going
>> to allow you to reliably compare across different demodulator chips.
>> If demod X says 28.3 dB and demod Y says 29.2 dB, that doesn't
>> really mean demod Y performs better - just that it's reporting a
>> better number.  However it does allow you to compare the demod
>> against itself either across multiple frequencies or under different
>> signal conditions - which is what typical users really care about.
>
> I'm not expecting people to compare across demods - I only care about the
> case where a user has got in a professional installer to help with their
> setup. The problem I want to avoid is a Linux application saying "-48 dB
> signal strength, 15 dB CNR", and the installer's kit saying "60 dBuV signal
> strength, 20 dB CNR", when we have enough information for the Linux
> application to say "-48 dBm (60 dBuV at 75Ω), 15 dB CNR", cueing the
> professional to remember that not all dB use the same reference point, and
> from there into accepting that Linux is reporting a similar signal strength
> and CNR to his kit.
>
> This also has implications for things like VDR - if the scale is
> FE_SCALE_DECIBEL but the measurement is absolute, the application probably
> doesn't want to report the measurement as a dB measure, but as an arbitrary
> scale; again, you don't want the application saying "50 dB", when the
> professional installer tells you that you have "0 dBuV".

Actually VDR doesn't care about "dB", "dBuV", "dBuW" or whatever. All it wants
to do is to display the signal strength and quality in a way that, as Devin stated
so very appropriately, even an idiot can understand ;-)
VDR displays a bar that goes from 0 ("no signal at all") to full extent ("perfect
signal"). So for VDR any value range that can be linearly converted to a range
between 0% and 100% would do just fine. The only important thing is that it is
the *same* for all frontends! Ideally I would expect values in the range 0x0000
thru 0xFFFF.

Klaus
