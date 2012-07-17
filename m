Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55861 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2GQVtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 17:49:42 -0400
Received: from [10.2.0.129] (unknown [10.2.0.129])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id 61CC824422
	for <linux-media@vger.kernel.org>; Tue, 17 Jul 2012 23:50:12 +0200 (CEST)
Message-ID: <5005DE15.7020304@schinagl.nl>
Date: Tue, 17 Jul 2012 23:50:13 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: TechnoTrend Budget CI stutters and often fails at tuning encrypted
 channel.
References: <500522AE.9020900@schinagl.nl> <50053610.9010909@schinagl.nl>
In-Reply-To: <50053610.9010909@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/12 11:53, Oliver Schinagl wrote:
> On 17-07-12 10:30, Oliver Schinagl wrote:
>> Hi list,
>>
>> I have been using a tt1500, a saa7146 PCI DVB-T tuner for well over a
>> year now. Running gentoo 64bit tracking the ~amd64 branch (that only
>> get bi-monthly upgraded) I've been always more or less up to date.
>>
>> This card however has never properly worked. I've been running vdr
>> 1.6.* since that is what's stably in gentoo. Whilst writing this down
>> I realized I still have to test me-tv to double check my findings.
>>
>> Some background info. Here in NL we have 4 FTA channels and about 20
>> conax encrypted channels that the CAM in the CI module decrypts. I
>> have two smartcards, of which one is only in active use at the moment.
>>
>> When changing channels between the FTA channels, the first 'bug'
>> occurs. Somtimes (not predictably or anything, about 50% of the
>> channel changes) sound stutters the first few seconds, upto 30 seconds
>> sometimes. It sounds almost if the sound is being fed through some
>> sort of PWM, that slowly catches up. So first you hear 1 second of
>> audio, 3 seconds of nothing, then 1 second of audio again, then 2
>> seconds of nothing etc. This audio delay is random. E.g. sometimes it
>> stutters for about 30 seconds while it has a hard time to catch up,
>> other times the audio needs only 2 or 3 seconds to catch up. Very
>> occasionally it instantly works right. The stuttering appears to be
>> worse on encrypted channels.
>>
>> Encrypted channels has the additional annoyance, that quote often, an
>> entire channel is not available. That is, every channel in its bouqet.
>> Simply waiting on that channel for about a minute or two, mysteriously
>> brings the unavailable channel up. Allthough it 'feels' like changing
>> channel helps this fix faster, it's just a placebo effect if you ask
>> me ;)
>>
>> I cannot safely say that the same skipping happens to the video, I
>> have not noticed it really. I have checked signal strength etc and
>> though the strength is only at 55%, the SNR is at 99% quite stable and
>> the BER (unrecoverable errors? are at 0). If for some reason there is
>> interferance, bad whether, blocked antenna, then the BER goes up
>> followed by distorted imagery and with really bad signal bad audio as
>> well (humans are more sensitive to bad audio iirc).
>>
>> I'm not sure what to profile, where to enable debugging, what logs to
>> check or what to do to help 'fix' this.
>>
>> lspci output:
>> 00:0a.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>> Subsystem: Technotrend Systemtechnik GmbH DVB T-1500
>> Flags: bus master, medium devsel, latency 32, IRQ 18
>> Memory at f0162000 (32-bit, non-prefetchable) [size=512]
>> Kernel drive in use: budget_ci dvb
>>
>> /proc/interrupts
>> 18: 499 107651 IO-APIC-fasteoi saa7146 (0)
>>
>> Tuner: tda10046h dvb-t, firmware revision 20
>>
>>
>> Thank you for your time,
>> oliver
> P.S. I forgot to mention, that once tuned to a channel, I can receive
> (and decode) it fine for many hours. I think the longest I had one
> channel up was about 8 hours or so without issue. A dvb-t radio channel
> (thus not dab) i had up for even longer, so once it goes, it goes on
> happily forever!
> --

After spending about 5? Hours compiling Kaffeine and it's dependancies, 
I gave that a go. (me-tv does not support CAM's). While tuning went a 
little iffy at the start, not sure why, signal kept dropping and some 
SNR spikes, I managed to get all my channels tuned. Kaffeine is much 
much slower when changing channels. Takes about 2-4 seconds (haven't 
properly timed it). Kaffeine however never failed to tune a channel and 
sound always started properly.

Btw, I noticed the sound stuttering seems somewhat buffering related, it 
the sound that IS heard, is often the almost the same 'sample', but does 
slowly move forward in time.

I can immagine that Kaffeine does some really smart things VDR doesn't 
do, but even the slow channel change doesn't explain why VDR often fails 
to properly tune.


So it seems that the hardware is working quite well albeit slow on 
channel changing (in kaffeine anyway). I have tried a later version of 
VDR, as the whole reason i'm digging into this is, is because I was 
trying to get openbricks/geexbox/VDR/xbmc working where VDR is one of 
the development versions.

So anybody have any idea where to start finding the cause? Is it really 
VDR? Or is it something in the driver afterall? Anybody can share their 
experiences with a hardware! CAM?

P.S. I'm supprised about the bad signal, as I live about 500meters from 
the transmitter ...

Oliver
