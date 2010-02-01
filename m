Return-path: <linux-media-owner@vger.kernel.org>
Received: from er-systems.de ([85.25.136.202]:57943 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0BAUup (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 15:50:45 -0500
Date: Mon, 1 Feb 2010 21:50:42 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: Chicken Shack <chicken.shack@gmx.de>
cc: obi@linuxtv.org, mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: Kernel Oops, dvb_dmxdev_filter_reset, bisected
In-Reply-To: <1265052321.19005.8.camel@brian.bconsult.de>
Message-ID: <alpine.LNX.2.00.1002012148310.9330@er-systems.de>
References: <alpine.LNX.2.00.1002011855590.30919@er-systems.de> <1265052321.19005.8.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 1 Feb 2010, Chicken Shack wrote:

> Hi Thomas,
>
> thanks for reproducing that kernel oops.
>
> Question:
>
> Can you also confirm / reproduce that alevt does not follow the new TV
> or radio channel if the new channel, tuned by dvbstream / mplayer for
> example, is part of another transponder?
>
> Normal, i. e. expected behaviour can be desribed in the following
> example:
>
> a. You start mplayer://ZDF, then you start alevt, and ZDF teletext
> should be visible.
>
> b. You change the channel to mplayer://Das Erste.
> Now alevt should follow the new tuning and tune one channel of the
> transponder containing the ARD bouquet.
>
> But instead of that alevt hangs and cannot be finished by an ordinary
> quit. You need _violence_ a la "killall -9 alevt" or, on the command
> line: STRG-C as shortcut.
>
> Can you reproduce / confirm that, Thomas?


Yes, I can confirm that. And yes, it is annoying.


thanks,

Thoams

