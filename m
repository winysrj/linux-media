Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:36874
	"EHLO QMTA12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZHSOMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 10:12:44 -0400
Message-ID: <41128.76.104.173.166.1250691148.squirrel@www.cyberseth.com>
In-Reply-To: <4A8A9D33.5050505@kernellabs.com>
References: <35375.76.104.173.166.1250492844.squirrel@www.cyberseth.com>
    <4A8A9D33.5050505@kernellabs.com>
Date: Wed, 19 Aug 2009 07:12:28 -0700 (PDT)
Subject: Re: Hauppauge 2250 - second tuner is only half working
From: seth@cyberseth.com
To: "Steven Toth" <stoth@kernellabs.com>
Cc: seth@cyberseth.com, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I'd really appreciate any help or guidance on this problem as i'm fully
>> perplexed by it.
>
> Hey Seth,
>
> I ran the same tests on my cable system (channel 103) on 669Mhz and had no
> issue, and my snr's reported as (0x172 and 0x17c).
>
> One possibility is that you're overwhelming the frontend. Try adding a
> small
> mount of attenuation to the signal for test purposes.
>
> Hard to believe but this is where I'd start looking.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
>

Thank you for reply!  Hearing that the same frequency works on another
card is pretty positive confirmation in my mind that this is a
hardware/setup issue.  I tried stopping by a local radio shack last night,
but wouldn't you know they no longer carried simple attenuators.  Looks
like i'll be picking one up online (or maybe ill lookup a schematic online
and try building a simple one).

On a side note - Thank you very much for hacking on the saa7164 - other
than this frequency glitch its been working great for me!
