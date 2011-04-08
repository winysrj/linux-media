Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab1DHSAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 14:00:04 -0400
Received: by wwa36 with SMTP id 36so4534850wwa.1
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 11:00:02 -0700 (PDT)
References: <1302267045.1749.38.camel@gagarin> <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com> <1302276147.1749.46.camel@gagarin> <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com> <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
In-Reply-To: <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH] Fix cx88 remote control input
Date: Fri, 8 Apr 2011 14:00:08 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 8, 2011, at 1:07 PM, Devin Heitmueller wrote:

> On Fri, Apr 8, 2011 at 12:21 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> The problem is that there isn't a "the keytable". There are many
>> many keytables. And a lot of different hardware. Testing all possible
>> combinations of hardware (both receiver side and remote side) is
>> next to impossible. We do what we can. Its unfortunate that your
>> hardware regressed in functionality. It happens, but it *can* be
>> fixed. The fix you provided just wasn't correct. The correct fix is
>> trivially updating drivers/media/rc/keymaps/<insert-your-keymap-here>.
> 
> I think the fundamental failure here was avoidable.  We introduced a
> new requirement that keytables included system codes, knowing full
> well that the vast majority of them did not meet the requirement.  In
> fact, a quick scan through the first 20 or so keymaps show that even
> today only *HALF* of them are populated today.  That means that half
> of the remote keymaps are also completely broken.

Have to admit that I don't think it ever registered in my head that
we were going to break that many existing keymaps. But something
to consider: how many of those are *raw* rc-5 scancode keymaps, vs.
cooked scancodes from drivers that only provide command? It may
well be that we should have been more discriminating when building
those keymaps, to distinguish which were truly raw IR scancodes that
the in-kernel decoders ascertained, and which were just scancodes
handed to us directly from the IR hardware.


> This decision was doomed to fail.  It basically said, "Yes, I know
> full well that I'm breaking most of the keymaps currently supported,
> but maybe some of those users will eventually report the issue and
> I'll make them provide an updated keymap which will eventually be
> merged upstream for others so that their remotes are no longer
> broken."

Well, ir-keytable -w is also an option, though that does kill the
"Just Works"-ness when you first have to come up with the new map.


> We should have introduced a RC profile property indicating how many
> bits were "significant".  Then for those remotes which didn't have the
> system code, we could have continued to match against only the key
> code.

This was a change in the raw rc-5 IR decoder. There's *always* going
to be a system code (or at least, a resulting byte), isn't there?
Otherwise, its simply not an rc-5 signal. The "no system code" case
should really only apply to hardware decoders that strip it off
internally.

Speaking of which, something just occurred to me. Functionality of
Hauppauge receivers and remotes *was* tested. With ir-kbd-i2c. Which
was stripping off the system code at the time. It just wasn't tested
with Hauppauge hardware that actually passed along raw IR. In 2.6.39,
ir-kbd-i2c has been fixed so that it passes along system code and
the Hauppauge keymaps were updated accordingly, which also happens
to fix the cx88 raw IR case. 


> Then over time, as keymaps improved, those keymaps could be
> updated and the number of significant bits could be adjusted to
> indicate that the system code was present.
> 
> This was a crappy call, and it was completely foreseeable.

Possibly. I think too many of us are only hacking on this in their
limited free time though, so things like this may get overlooked.
I have quite a few pieces of Hauppauge hardware, several with IR
receivers and remotes, but all of which use ir-kbd-i2c (or
lirc_zilog), i.e., none of which pass along raw IR.

-- 
Jarod Wilson
jarod@wilsonet.com



