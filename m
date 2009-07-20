Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:34717 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbZGTCSt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 22:18:49 -0400
Message-ID: <4A63D407.6090109@rtr.ca>
Date: Sun, 19 Jul 2009 22:18:47 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca>	 <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>	 <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>	 <4A63A15F.8040804@rtr.ca> <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
In-Reply-To: <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
>
> Yeah, the situation with the seven second firmware load time is well
> known.  It's actually a result of the i2c's implementation in the
> au0828 hardware not properly supporting i2c clock stretching.  Because
> of some bugs in the hardware, I have it clocked down to something like
> 30KHz as a workaround.  I spent about a week investigating the i2c bus
> issue with my logic analyzer, and had to move on to other things.  I
> documented the gory details here back in March if you really care:
..

>From your livejournal comments, it sounded like the slow clock might
not be necessary until *after* the firmware transfer.

Mmm.. I wonder if perhaps a higher clock speed could be used
during the firmware download, and then switch to the slower 30KHz
speed afterward ?

This could reduce the firmware transfer to a couple of seconds,
much better than the current 6-7 second pause.

Cheers
