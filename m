Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:34685 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbdLHV26 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 16:28:58 -0500
MIME-Version: 1.0
In-Reply-To: <20171208135650.3f385c45@vento.lan>
References: <20171208135650.3f385c45@vento.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Dec 2017 13:28:57 -0800
Message-ID: <CA+55aFwBvXVQavgwDKVV3epFhd4MTaQvDktpDahkPhxweXnMmQ@mail.gmail.com>
Subject: Re: [GIT PULL for v4.15-rc3] media fixes
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 8, 2017 at 7:56 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
>
> - The largest amount of fixes in this series is with regards to comments
>   that aren't kernel-doc, but start with "/**". A new check added for
>   4.15 makes it to produce a *huge* amount of new warnings (I'm compiling
>   here with W=1). Most of the patches in this series fix those. No code
>   changes - just comment changes at the source files;

Guys, this was just pure garbage, and obviously noboduy actually
looked at that shit-for-brains patch.

There were several idiotic things like this:

  -/******************************
  +/*****************************

because part of it was apparently generated with some overly stupid
search-and-replace. So when replacing "/**" with "/*", it also just
removed a star from those boxed-in comments.

In the process that thing also made some of those boxes no longer aligned.

Now, box comments are stupid anyway, but they become truly
mind-bogglingly pointless when they are then edited like this.

I've pulled this, but dammit, show some amount of sense. We shouldn't
have this kind of pointless noise in the rc series. That pointless
noise may now be hiding the real changes.

              Linus
