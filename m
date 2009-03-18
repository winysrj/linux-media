Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:4011 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZCRTag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 15:30:36 -0400
Received: by yw-out-2324.google.com with SMTP id 5so202252ywb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 12:30:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C145E2.9050205@gmx.de>
References: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
	 <49C145E2.9050205@gmx.de>
Date: Wed, 18 Mar 2009 15:30:34 -0400
Message-ID: <412bdbff0903181230t300421b0nb901cd94d5c96d04@mail.gmail.com>
Subject: Re: SNR status for demods
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 18, 2009 at 3:05 PM, wk <handygewinnspiel@gmx.de> wrote:
> What about signal strength and BER readout in parallel for each device
> listed here?

I'm having enough trouble even getting people to agree on the format
for the SNR field.  The strength field is even more subjective.  At
this point, I think it is best to focus on the SNR and once we get
some agreement there we can look at the strength and BER fields.

Updating the DVB documentation is the *easy* part.  The problem is
figuring out what the standard should be in the first place (which
requires some agreement among the demod developers).

> Needs the same docs and would not add too much work..

I agree this would be useful.  Feel free to get started on this.

> tda10021:  MSE[7..0] (= reg 0x18 )
> "Mean Square Error of the demodulated output signal. MSE can be used as a
> representation of the signal quality."
>
>   u8 quality = ~tda10021_readreg(state, 0x18);
>   *snr = (quality << 8) | quality;
>
> ves1820:    the same.
> tda10023:  seems to be the same. (no info, but chip is very close to
> tda10021)

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
