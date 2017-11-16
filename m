Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:41548 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932612AbdKPEdq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 23:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <20171115222806.5c86b85f@vento.lan>
References: <20171115222806.5c86b85f@vento.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Nov 2017 20:33:45 -0800
Message-ID: <CA+55aFxG5jWvCajaoJvZQXcVMGtsYuywDiJSc1psCkxB3sbJzQ@mail.gmail.com>
Subject: Re: [GIT PULL for v4.15-rc1] media updates
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 15, 2017 at 4:28 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
>
> PS.: This time, there is a merge from staging tree, from the same commit
>      you pulled on your tree, in order to solve a conflict at the
>      atomisp driver, as reported by Stephen Rothwell.

Please don't do that.

I got conflicts anyway, and I'd rather see them. Honestly, I want to
know, but I also am quite possibly better at resolving those conflicts
than most developers, because I do a *lot* of merges.

Why do I have to say this *every* single merge window?

Stop trying to hide your conflicts. Stop thinking that I prefer them
hidden over being there. Stop doing crazy merges from trees that
aren't yours and you were not asked to pull!

Really.

                Linus
