Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:45250 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIHV5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 17:57:11 -0400
Received: by ey-out-2122.google.com with SMTP id 25so1137132eya.19
        for <linux-media@vger.kernel.org>; Tue, 08 Sep 2009 14:57:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090908212733.GA19438@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
	 <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
	 <20090907151809.GA12556@systol-ng.god.lan>
	 <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
	 <20090908212733.GA19438@systol-ng.god.lan>
Date: Tue, 8 Sep 2009 17:57:12 -0400
Message-ID: <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 8, 2009 at 5:27 PM, <spam@systol-ng.god.lan> wrote:
> On Mon, Sep 07, 2009 at 12:12:15PM -0400, Michael Krufky wrote:
>> Henk,
>>
>> Something is up with your mailer, making it difficult to reply to your
>> emails.... going to some spam account instead of your email address...
>> Please look into that, maybe set up a reply-to or something.
>>
>> Anyway, thanks for your responses -- that clears a lot up.  I
>> recommend to also create your own tda18271 config structure, as I have
>> a pending pull request that will tweak the tda18271 configuration
>> within that hcw_tda18271_config structure -- Id hate for your board to
>> break as a result of using somebody else's config.
>>
>> About the SAA7131 - correct -- it is a SAA713x combined with a TDA8295
>> analog IF demod.  I was just checking to see that it was actually what
>> your board uses.  Looks good to me.
>>
>> As far as the analog input setup, have you verified that those work
>> properly, or did you also copy those from the HVR1120 configuration?
>> If you havent verified those yourself, I recommend removing them from
>> your patch -- better to not check in untested configurations, as it
>> may lead others to believe that it should work, causing support
>> problems for the future.
>>
>> After you re-submit with the above recommended changes, I'll be happy
>> to push the patch for you.
>>
>> Regards,
>>
>> Mike
>
> Hi Mike,
>
> I tested the analog part (PAL-B), sound and picture work but with
> some issues:
>
> - Sometimes picture is noisy, but it becomes crystal clear after
>  switching between channels. (happens for example at 687.25 Mhz)
> - On a lower frequency (511.25 Mhz) the picture is always sharp, but
>  lacks colour.
> - No sound problems.
> - radio untested.
>
> Digital:
> - DVB-T/H stream reception works.
> - Would expect to see some more channels in the higher frequency region.
>
> Overall is the impression that sensitivity still needs improvement
> both in analog and digital modes.
>
> If you look at the dmesg, analog tuner is detected as 8290 instead of
> the expected 8295 could this be a problem?
>>> [280192.420033] tda829x 3-004b: type set to tda8290+18271
>
>
> For information on the card see:
> http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
>
> Signed-off-by: Henk.Vergonet@gmail.com

Henk,

Why do you expect a 8295?  If your board uses the SAA7131, then we
would expect an 8290 IF demod.

Ah, I just checked the history of this email thread -- I must have
read one of your previous emails too quickly.  :-)  Perhaps there is a
typo in the document that you read -- tda8290 is correct.

About the analog noise and quality issues that you report, perhaps
there is some tweaking that can be done to help the situation.  I dont
have that Zolid board, myself, so I can't reallt help much in that
respect, unfortunately.

At this point, I feel that your patch is fine to merge into the
development repository, although I have some small cleanup requests:

#1)  You can omit this line from the tda18271_config struct:

.config  = 0,	/* no AGC config */

This is not necessary, as it is initialized at zero and this serves no
purpose even for documentation's sake.

#2) The configuration inside saa7134-cards.c should be moved to the
end of the boards array.

#3) The configuration case inside saa7134-dvb.c should be moved to the
end of the switch..case block.

I'll wait for these cleanups, then I have no issue pushing up your
patch.  Any quality improvements that we find along the way can
certainly be added afterwards.

Good work.

Regards,

Mike
