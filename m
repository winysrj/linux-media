Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44410 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2CUTkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 15:40:11 -0400
Received: by obbeh20 with SMTP id eh20so903553obb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 12:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwm3XryRD4d+bMpZhTWCqvzdURGFqTr9nemfbqztj5MwQ@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<1332291909.26972.3.camel@palomino.walls.org>
	<CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
	<CAGoCfiz1RmNwYBsHnXr5__qTy58k2BTp-P3d_sqSdWt9tS7TjQ@mail.gmail.com>
	<CALF0-+XRREN9d8_aB+1Nfa9VEaTeYQCo9sEDa5sBuzo5rcbfjw@mail.gmail.com>
	<CAGoCfiwm3XryRD4d+bMpZhTWCqvzdURGFqTr9nemfbqztj5MwQ@mail.gmail.com>
Date: Wed, 21 Mar 2012 16:40:10 -0300
Message-ID: <CALF0-+XJUB3N4UbiCneE_EPmLwMmB5TaEbP1s4On-P09wFeNPQ@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/21 Devin Heitmueller <dheitmueller@kernellabs.com>:
> I'm not sure what you mean by "no video".  Do you have capture
> disabled?  Are you saying that you didn't connect the video cable to
> your input?  Most devices will continue to generate video frames over
> isoc even if there is no actual video signal present.

I mean there is no signal at video input.

>
> But yeah, most of the solutions I have seen have every isoc packet
> starting with a header that includes descriptors for things like start
> of video frame, odd/even field, etc.
>

Thanks, I'll keep reading sources and info. Hope it gets me somewhere.
