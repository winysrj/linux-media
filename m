Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36162 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbHRXyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 19:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <20150818171833.1c989c17@recife.lan>
References: <20150818171833.1c989c17@recife.lan>
Date: Tue, 18 Aug 2015 16:54:13 -0700
Message-ID: <CA+55aFzNkvRYbhfiwOOC+_okHKN+Hf93bTF0fpiEqn6fYtLmEw@mail.gmail.com>
Subject: Re: [GIT PULL for v4.2] media fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2015 at 1:18 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
>
>         - Revert the IR encode patches, as the API is not mature enough.
>           So, better to postpone the changes to a latter Kernel;

What the hell have you done with the commit messages?

The first line is completely corrupted for those reverts, and as a
result your own shortlog looks like crap and is completely misleading.

A revert is described as

     Revert ".. old patch name goes here .."

but your reverts are broken, and are described as

    .. old patch name goes here .."

presumably due to some horribly broken automation crap of yours that
adds the "[media]" prefix or something.

How did you not notice this when you sent the shortlog? Or even
earlier? This is some serious sh*t, since it basically means that your
log messages are very misleading, since the one-liner actually implies
exactly the reverse of what the commit does.

I unpulled this, because I think misleading commit messages is a
serious problem, and basically *half* (and patch-wise, the bulk) of
the commits in this queue are completely broken.

                Linus
