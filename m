Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53915 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2CUTSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 15:18:24 -0400
Received: by vcqp1 with SMTP id p1so1339814vcq.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 12:18:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XRREN9d8_aB+1Nfa9VEaTeYQCo9sEDa5sBuzo5rcbfjw@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<1332291909.26972.3.camel@palomino.walls.org>
	<CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
	<CAGoCfiz1RmNwYBsHnXr5__qTy58k2BTp-P3d_sqSdWt9tS7TjQ@mail.gmail.com>
	<CALF0-+XRREN9d8_aB+1Nfa9VEaTeYQCo9sEDa5sBuzo5rcbfjw@mail.gmail.com>
Date: Wed, 21 Mar 2012 15:18:23 -0400
Message-ID: <CAGoCfiwm3XryRD4d+bMpZhTWCqvzdURGFqTr9nemfbqztj5MwQ@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/21 Ezequiel García <elezegarcia@gmail.com>:
> Ok. So, it's not saa7113 related, but rather stk1160 related?

Yes.

> When there is no video, isoc urbs are received with actual length=4.
> This is header right?

I'm not sure what you mean by "no video".  Do you have capture
disabled?  Are you saying that you didn't connect the video cable to
your input?  Most devices will continue to generate video frames over
isoc even if there is no actual video signal present.

But yeah, most of the solutions I have seen have every isoc packet
starting with a header that includes descriptors for things like start
of video frame, odd/even field, etc.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
