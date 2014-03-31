Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49791 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaCaRWt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 13:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <533921F8.1000508@xs4all.nl>
References: <53244092.6010906@xs4all.nl>
	<533921F8.1000508@xs4all.nl>
Date: Mon, 31 Mar 2014 10:22:49 -0700
Message-ID: <CA+55aFwpoVwyyUrCroFR1NWCGku=ath6Sxb8uertuBC=Pw0pLw@mail.gmail.com>
Subject: Re: sparse: ioctl defines and "error: bad integer constant expression"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sparse Mailing-list <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 31, 2014 at 1:06 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Running sparse over this gives:
>
> error: bad integer constant expression

So technically sparse is correct in this case. The kernel ends up
doing some questionable things that gcc allows. The index in an
assignment initializer is supposed to be a true constant expression,
not "constant expression after simplification and optimization".

So sparse warns about us playing games that just happen to work with
gcc. I'm not sure we should fix sparse for this case.

I'll think about it, but not right now (I did the previous one because
it was trivial, but now I'm in merge window mode, so I'd better go
back and look at kernel pull requests)

Chris, can you please add this to the test cases since Hans did the
work to create a nice small test-case?

            Linus
