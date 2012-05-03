Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34588 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2ECMSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 08:18:03 -0400
Received: by vbbff1 with SMTP id ff1so1184161vbb.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 05:18:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA1FBB5.8050106@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>
	<1335307344.8218.11.camel@palomino.walls.org>
	<jn7pph$qed$1@dough.gmane.org>
	<1335624964.2665.37.camel@palomino.walls.org>
	<4F9C38BE.3010301@interlinx.bc.ca>
	<4F9C559E.6010208@interlinx.bc.ca>
	<4F9C6D68.3090202@interlinx.bc.ca>
	<CAAMvbhH2o6SZVBU4D2dvUUVuOhtzLdO-R=TCuug7Y9hgZq2gmg@mail.gmail.com>
	<CAGoCfiwB2jZfeZ2aSQ7FSG-k5XDGJY_ykLPSD3Y3rbrUXmuOdg@mail.gmail.com>
	<4FA1FBB5.8050106@interlinx.bc.ca>
Date: Thu, 3 May 2012 08:18:02 -0400
Message-ID: <CAGoCfixTLjnW=q+SHiiRzXaFtqp56Ng5nRMn-u1YfZ1f-zmtwA@mail.gmail.com>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: stoth@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resending with the ML back on the cc:.

On Wed, May 2, 2012 at 11:29 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> On 12-04-29 08:09 PM, Devin Heitmueller wrote:
>>
>> I don't know why you're not seeing valid data on femon with the 950q.
>> It should be printing out fine, and it's on the same 0.1 dB scale.
>> Try running just azap and see if the SNR is reported there.
>
> $ azap -c ~/last-channel-scan.prev 100-3
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 651000000 Hz
> video pid 0x0000, audio pid 0x07c1
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0190 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0190 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> ...
>
> Doesn't seem to be useful values.

That actually is useful data.  The SNR of 0x190 means 40.0 dB (which
is a max good signal).  The fact that it sometimes goes between 0x190
and 0x000 is actually a bug in the driver I discovered a couple of
months ago but haven't submitted a patch for.  In fact it's strong
enough that you might actually be over driving the tuner and may wish
to try an attenuator.

This suggests the signal is fine (although I would probably run it for
longer and make sure you don't see intermittent UNC conditions).  And
you're using the exact same cabling for the 1600 as you are for the
950q above?

Also, which version of the HVR-1600 is this?  The one with the
mxl5005s or the tda18271?  You can check the dmesg output to tell (and
if you cannot tell, please pastebin the dmesg output so I can look).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
