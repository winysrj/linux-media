Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57791 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1ACEBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 23:01:00 -0500
Received: by wyb28 with SMTP id 28so13036743wyb.19
        for <linux-media@vger.kernel.org>; Sun, 02 Jan 2011 20:00:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293843343.7510.23.camel@localhost>
References: <1293843343.7510.23.camel@localhost>
Date: Sun, 2 Jan 2011 23:00:58 -0500
Message-ID: <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit fcb9757333df37cf4a7feccef7ef6f5300643864
From: Eric Sharkey <eric@lisaneric.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Dec 31, 2010 at 7:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Mauro,
>
> Please revert at least the wm8775.c portion of commit
> fcb9757333df37cf4a7feccef7ef6f5300643864:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864
>
> It completely trashes baseband line-in audio for PVR-150 cards, and
> likely does the same for any other ivtv card that has a WM8775 chip.

Confirmed.  I manually rolled back most of the changes in that commit
for wm8775.c, leaving all other files alone, and the audio is now
working correctly for me.  I haven't yet narrowed it down to exactly
which changes in that file cause the problem.  I'll try and do that
tomorrow if I have time.

Eric
