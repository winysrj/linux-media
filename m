Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41638 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab2CUTJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 15:09:15 -0400
Received: by yhmm54 with SMTP id m54so1243967yhm.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 12:09:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz1RmNwYBsHnXr5__qTy58k2BTp-P3d_sqSdWt9tS7TjQ@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<1332291909.26972.3.camel@palomino.walls.org>
	<CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
	<CAGoCfiz1RmNwYBsHnXr5__qTy58k2BTp-P3d_sqSdWt9tS7TjQ@mail.gmail.com>
Date: Wed, 21 Mar 2012 16:09:14 -0300
Message-ID: <CALF0-+XRREN9d8_aB+1Nfa9VEaTeYQCo9sEDa5sBuzo5rcbfjw@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2012/3/21 Devin Heitmueller <dheitmueller@kernellabs.com>:
>
> Every USB bridge provides their raw video over isoc in a slightly
> different format (not just in terms of the colorspace but also how to
> read the isoc header to detect the start of video frame, which field
> is being sent, etc).  Regarding the colorspace, in many cases it's
> simply 16-bit YUYV, so I would probably start there.

Ok. So, it's not saa7113 related, but rather stk1160 related?

When there is no video, isoc urbs are received with actual length=4.
This is header right?
