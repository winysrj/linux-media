Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56572 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZKQGDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 01:03:39 -0500
Received: by bwz27 with SMTP id 27so6476912bwz.21
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 22:03:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B023AC9.8080403@linuxtv.org>
References: <15cfa2a50910071839j58026d10we2ccbaeb26527abc@mail.gmail.com>
	 <0C6DEB14-B32A-4A20-B569-16B2A028CE25@wilsonet.com>
	 <15cfa2a50910091827l449f0fb0t2974219b6ea76608@mail.gmail.com>
	 <4B00D91B.1000906@wilsonet.com> <4B00DB5B.10109@wilsonet.com>
	 <409C0215-68B1-4F90-A8E0-EBAF4F02AC1A@wilsonet.com>
	 <4B023AC9.8080403@linuxtv.org>
Date: Tue, 17 Nov 2009 01:03:43 -0500
Message-ID: <15cfa2a50911162203w1ad1584bhfdbe0213421abd6a@mail.gmail.com>
Subject: Re: KWorld UB435-Q Support
From: Robert Cicconetti <grythumn@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 17, 2009 at 12:55 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>>>>>> [ 812.465930] tda18271: performing RF tracking filter calibration
>>>>>> [ 818.572446] tda18271: RF tracking filter calibration complete
>>>>>> [ 818.953946] tda18271: performing RF tracking filter calibration
>>>>>> [ 825.093211] tda18271: RF tracking filter calibration complete
>
>
> If you see this happen more than once consecutively, and there is only 1
> silicon tuner present, then it means something very bad is happening, and
> there is a chance of burning out a part.  I still wouldnt not recommend any
> mainline merge until you can prevent this behavior -- I suspect that a GPIO
> reset is being toggled where it shouldnt be, which should be harmless ...
> but until we fix it, we cant be sure what damage might get done...
>
> The RF tracking filter calibration is a procedure that should only happen
> once while the tuner is powered on -- it should *only* be repeated if the
> tuner indicated that calibration is necessary, and that would only happen
> after a hardware reset.
>
> This still looks fishy to me...

It happened at every tuning operation, and made mythfrontend unhappy
(unable to tune after the first channel). I disabled the check for
RF_CAL_OK which triggered the recalibration, and mythfrontend worked.
The stick has been plugged in for a few months, so presumably would've
caught on fire by now if it was going to. It would be nice if the
tuning delay went away, though.. it still takes ~6 seconds to switch
frequencies.

I have not yet compiled and tested the lastest patches from Jarod.

R C
