Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1BWWHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 17:07:25 -0500
Received: by eyx24 with SMTP id 24so1489663eyx.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 14:07:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298498021.2408.14.camel@localhost>
References: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
	<1298498021.2408.14.camel@localhost>
Date: Wed, 23 Feb 2011 17:07:24 -0500
Message-ID: <AANLkTingvqS5gYxG5DX4c6kYGGffMpSaFuNyxXqP5oZX@mail.gmail.com>
Subject: Re: Question on V4L2 S_STD call
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 23, 2011 at 4:53 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> "When the standard set is ambiguous drivers may return EINVAL or choose
> any of the requested standards."

Returning -EINVAL is really not desired behavior.

> If you don't have standard autodetection before the DIF, your
> safest bet is to have the driver return EINVAL, if you have flags
> that don't all fall into one of the compound statements in the if()
> statement.

This can be a bit tricky since setting the standard typically comes
before the tuning request.  Think of initial startup:  the device
isn't tuned at all.  You get the S_STD call, but you can't do
autodetect because you're not tuned to the target frequency yet.  I
suppose you could reconfigure the DIF after the S_FREQ call, but then
you will probably have to make the driver wait long enough to get a
tuning lock (or have some sort of deferred handler code which polls
for the tuning lock and configured the DIF after the lock is
achieved).

Admittedly I haven't yet dug into how other drivers do this, so I
figured I would ask around first.  Also, I'm not really sure what sort
of standard autodetection capabilities there are in the Polaris (I
should probably talk to the guy who did the DIF work on the cx23885).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
