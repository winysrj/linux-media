Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:59519 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbZETORn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 10:17:43 -0400
Date: Wed, 20 May 2009 16:17:22 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
cc: linux-media@vger.kernel.org
Subject: Re: RE : Hauppauge Nova-TD-500 vs. T-500
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAzAGSQvKgtEem5YzUY4sYkAEAAAAA@tv-numeric.com>
Message-ID: <alpine.LRH.1.10.0905201609240.15868@pub4.ifh.de>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAzAGSQvKgtEem5YzUY4sYkAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2009, Thierry Lelegard wrote:
> 2) Since the TD-500 contains two aerial inputs instead of one for
> the T-500, I plugged in two antenna cables. Then, after some tests,
> I realized that this was a source of trouble:
> - Two antenna cables => lots of errors (mostly garbage sometimes,
>  depending on the frequency).
> - Top input only => still many errors but much better on both tuners.
> - Bottom input only => got nothing on both tuners.

Normally there is a RF switch + loop through to be controlled when 
switching between diversity (not supported in Linux) and dual-input - so 
that you can connect only one antenna but still doing the dual reception.

If this switch is not handled correctly, I could imagine that the second 
input connected is "receiving" spurious signals and disturbing the first 
input, but there can be a lot of other reason as well.

If I understand the code correctly, this switch (if it is really there :) 
) is not handled correctly. I don't know the TD 500 card, so maybe the 
Hauppauge guys can help on that. (Basically the question is, which GPIO is 
to be toggled)

> 3) There are still many uncorrectable errors (TS packets with "transport
> error indicator" set) in the input. The amount of uncorrectable errors is
> approximately 0.1% (depending on the frequency), while I do not have any
> with the T-500 using the same antenna.

When you tune both frontends at the same time, please try to not tune the 
same frequency.

> These errors occurs in groups of +/- 50 consecutive packets with TEI set.
> Sometimes, in the middle of packets with errors, one packet has TEI clear
> but it is still erroneous (invalid PID in this context for instance).
>
> Note: I forgot to mention in the initial post that I set the following option:
>    options dvb_usb_dib0700 force_lna_activation=1

This option has no effect on the TD 500. Though, if there is an LNA, it 
could be handled usefully.

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
