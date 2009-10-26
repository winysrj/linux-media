Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:49337 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZJZPge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 11:36:34 -0400
Received: by fxm18 with SMTP id 18so12167243fxm.37
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 08:36:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE497B5.8050801@iki.fi>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	 <4AE497B5.8050801@iki.fi>
Date: Mon, 26 Oct 2009 11:36:37 -0400
Message-ID: <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti,

Sorry, I'm a couple of days behind on email.

On Sun, Oct 25, 2009 at 2:23 PM, Antti Palosaari <crope@iki.fi> wrote:
> Reddo DVB-C USB Box works fine with this patch. But whats the status of this
> patch, when this is going to Kernel? Reddo is added to the 2.6.32 and due to
> that I need this go 2.6.32 as bug fix. If this is not going to happen I
> should pull request my fix:
> http://linuxtv.org/hg/~anttip/reddo-dvb-c/rev/38f946af568f

I've received some very mixed results in terms of testing of the patch
(as you can see from the responses).  Even stranger, I received mixed
responses from people with the same boards.  I haven't had a chance to
debug *why* the people who raised problems still had an issue.  I
continue to believe it's the "right fix" but I don't know why those
people reported problems with it.

> And other issue raised as well. QAM256 channels are mosaic. I suspect there
> is some USB speed problems in Empia em28xx driver since demod UNC and BER
> counters are clean. It is almost 50 Mbit/sec stream... Any idea? I tested
> modprobe em28xx alt=N without success...

What do you mean by "mosaic"?  Can you try using dvbstreamer and see
what the overall throughput is?  That will tell us if we are not
getting the whole stream.

You cannot rely on the "alt=n" for DVB.  The max packet size is
determined by an em28xx register.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
