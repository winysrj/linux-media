Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1DHRHB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 13:07:01 -0400
Received: by eyx24 with SMTP id 24so1166961eyx.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 10:07:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	<AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
	<1302276147.1749.46.camel@gagarin>
	<B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
Date: Fri, 8 Apr 2011 13:07:00 -0400
Message-ID: <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
Subject: Re: [PATCH] Fix cx88 remote control input
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 8, 2011 at 12:21 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> The problem is that there isn't a "the keytable". There are many
> many keytables. And a lot of different hardware. Testing all possible
> combinations of hardware (both receiver side and remote side) is
> next to impossible. We do what we can. Its unfortunate that your
> hardware regressed in functionality. It happens, but it *can* be
> fixed. The fix you provided just wasn't correct. The correct fix is
> trivially updating drivers/media/rc/keymaps/<insert-your-keymap-here>.

I think the fundamental failure here was avoidable.  We introduced a
new requirement that keytables included system codes, knowing full
well that the vast majority of them did not meet the requirement.  In
fact, a quick scan through the first 20 or so keymaps show that even
today only *HALF* of them are populated today.  That means that half
of the remote keymaps are also completely broken.

This decision was doomed to fail.  It basically said, "Yes, I know
full well that I'm breaking most of the keymaps currently supported,
but maybe some of those users will eventually report the issue and
I'll make them provide an updated keymap which will eventually be
merged upstream for others so that their remotes are no longer
broken."

We should have introduced a RC profile property indicating how many
bits were "significant".  Then for those remotes which didn't have the
system code, we could have continued to match against only the key
code.  Then over time, as keymaps improved, those keymaps could be
updated and the number of significant bits could be adjusted to
indicate that the system code was present.

This was a crappy call, and it was completely foreseeable.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
