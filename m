Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63484 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2D3AJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 20:09:21 -0400
Received: by vbbff1 with SMTP id ff1so1728490vbb.19
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 17:09:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAMvbhH2o6SZVBU4D2dvUUVuOhtzLdO-R=TCuug7Y9hgZq2gmg@mail.gmail.com>
References: <jn2ibp$pot$1@dough.gmane.org>
	<1335307344.8218.11.camel@palomino.walls.org>
	<jn7pph$qed$1@dough.gmane.org>
	<1335624964.2665.37.camel@palomino.walls.org>
	<4F9C38BE.3010301@interlinx.bc.ca>
	<4F9C559E.6010208@interlinx.bc.ca>
	<4F9C6D68.3090202@interlinx.bc.ca>
	<CAAMvbhH2o6SZVBU4D2dvUUVuOhtzLdO-R=TCuug7Y9hgZq2gmg@mail.gmail.com>
Date: Sun, 29 Apr 2012 20:09:19 -0400
Message-ID: <CAGoCfiwB2jZfeZ2aSQ7FSG-k5XDGJY_ykLPSD3Y3rbrUXmuOdg@mail.gmail.com>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: "Brian J. Murrell" <brian@interlinx.bc.ca>, stoth@kernellabs.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 29, 2012 at 4:27 PM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> There are two measurements.
> 1) SNR.
> This is a measure of the quality of the signal. Bigger is better. 30dB is a
> good value. Spliters and amplifiers should only slightly reduce the SNR
> value.

30 dB for ClearQAM is actually a very marginal SNR.  It caps out at 40
dB, and as Andy pointed out, it's a logarithmic scale.  On a good
cable plant, you should expect an SNR between 35 and 40.  Anything
below 32 and you're very likely to have significant error rates.
Don't confuse it with Over-the-Air ATSC, which will typically cap out
at 30.0 dB.

I don't know why you're not seeing valid data on femon with the 950q.
It should be printing out fine, and it's on the same 0.1 dB scale.
Try running just azap and see if the SNR is reported there.

This indeed feels like a marginal signal condition problem, and Andy's
assertion is well founded that the mxl5005/s5h1409 isn't exactly the
best combo compared to more modern tuners and demodulators (Hauppauge
switched to the tda18271 and s5h1411 for the newer revision of the
HVR-1600).  The Linux driver support should be on-par with Windows
though in terms of performance as I did a bunch of work some time back
to analyze the differences which resulted in some fixes.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
