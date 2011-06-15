Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab1FOPpE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 11:45:04 -0400
Message-ID: <4DF8D37C.7010307@redhat.com>
Date: Wed, 15 Jun 2011 12:45:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com>
In-Reply-To: <4DF8C32A.7090004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-06-2011 11:35, Hans de Goede escreveu:

>>> This is a combination of the assumption there is a shared period size between
>>> the input device and the output device + the broken error handling.
>>
>> The code is doing a negotiation, in order to find a period that are acceptable
>> by both. Ok, there are other ways of doing it, but sharing the same period
>> probably means less overhead.
>>
> 
> This is what we call a premature optimization, there is not all that much
> overhead here, and demanding that both sizes will support a share period size
> may not always fly, and may likely lead to unnecessary large period sizes
> and thus too much latency in some cases.

I didn't write that part of the code, although I fixed it to work with a device
that provides audio at 32kHZ to play back on my audio card at 44.1kHz, using
software interpolation for the frame rate. It came from Devin's tree, that, in
turn, came from an alsa example (alsa-driver test tool latency.c, according with
the source code) but, IMHO, the code should do:

1) try to find a common buffer size that are acceptable by both drivers,
   as using the same buffer size helps to avoid memcpy's, especially if
   mmap mode is enabled;

2) If the buffer size means that the latency will be more than a reasonable
   time interval [1], then fall back to use different periods;

3) inform the latency introduced by the audio driver, in order to allow
   xawtv to sync audio and video.

(3) is not simple, because alsa doesn't provide a reliable timestamp, but
it shouldn't be that hard to implement some logic that will at least 
compensate for the additional delay introduced by the buffer size.

[1] Not sure what would be a reasonable delay. The original code were using a
buffer of 600 bytes, meaning a delay of 600/4800 (12,5 ms). Maybe twice this
value would still be reasonable. If we don't want to create a complicated
sync processing for (3), the maximum upper limit is the video streaming DQBUF
rate (about 166 ms, for an interlaced video at 30 fps).

Cheers,
Mauro.
