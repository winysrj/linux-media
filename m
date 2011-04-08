Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58843 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1DHSiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 14:38:05 -0400
Received: by ewy4 with SMTP id 4so1187080ewy.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 11:38:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	<AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
	<1302276147.1749.46.camel@gagarin>
	<B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
	<BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
	<44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com>
Date: Fri, 8 Apr 2011 14:38:03 -0400
Message-ID: <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com>
Subject: Re: [PATCH] Fix cx88 remote control input
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 8, 2011 at 2:00 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> Have to admit that I don't think it ever registered in my head that
> we were going to break that many existing keymaps. But something
> to consider: how many of those are *raw* rc-5 scancode keymaps, vs.
> cooked scancodes from drivers that only provide command? It may
> well be that we should have been more discriminating when building
> those keymaps, to distinguish which were truly raw IR scancodes that
> the in-kernel decoders ascertained, and which were just scancodes
> handed to us directly from the IR hardware.

As far as I know, keymaps didn't even support more than eight bit
codes until recently.  Even if the hardware had supported system
codes, there was nothing to compare it against since the keymaps were
limited to eight entries.

>> This decision was doomed to fail.  It basically said, "Yes, I know
>> full well that I'm breaking most of the keymaps currently supported,
>> but maybe some of those users will eventually report the issue and
>> I'll make them provide an updated keymap which will eventually be
>> merged upstream for others so that their remotes are no longer
>> broken."
>
> Well, ir-keytable -w is also an option, though that does kill the
> "Just Works"-ness when you first have to come up with the new map.

Agreed.

>> We should have introduced a RC profile property indicating how many
>> bits were "significant".  Then for those remotes which didn't have the
>> system code, we could have continued to match against only the key
>> code.
>
> This was a change in the raw rc-5 IR decoder. There's *always* going
> to be a system code (or at least, a resulting byte), isn't there?
> Otherwise, its simply not an rc-5 signal. The "no system code" case
> should really only apply to hardware decoders that strip it off
> internally.

I realize that the actual remote controls do have system codes, but
our remote control keymaps are missing the info.  Wouldn't it have
been better if for those cases we only compared against the key code,
thereby not resulting in those keymaps being broken?  IMHO, it would
be better to have had the relatively low risk of the receiver
responding to keypresses from an incorrect remote because the keymap
wasn't explicit enough than have those remote controls stop working
entirely.

> Speaking of which, something just occurred to me. Functionality of
> Hauppauge receivers and remotes *was* tested. With ir-kbd-i2c. Which
> was stripping off the system code at the time. It just wasn't tested
> with Hauppauge hardware that actually passed along raw IR. In 2.6.39,
> ir-kbd-i2c has been fixed so that it passes along system code and
> the Hauppauge keymaps were updated accordingly, which also happens
> to fix the cx88 raw IR case.

I don't doubt that the Hauppauge remote worked against ir-kbd-i2c
because of the deficiency you described in the ir-kbd-i2c driver.  I
question the notion of introducing the requirement that all keymap
definitions must have system codes without having really thought
through the notion that it would result in breaking every existing
keymap which hadn't been updated.

>> Then over time, as keymaps improved, those keymaps could be
>> updated and the number of significant bits could be adjusted to
>> indicate that the system code was present.
>>
>> This was a crappy call, and it was completely foreseeable.
>
> Possibly. I think too many of us are only hacking on this in their
> limited free time though, so things like this may get overlooked.
> I have quite a few pieces of Hauppauge hardware, several with IR
> receivers and remotes, but all of which use ir-kbd-i2c (or
> lirc_zilog), i.e., none of which pass along raw IR.

You don't have an HVR-950 or some other stick which announces RC5
codes?  If not, let me know and I will send you something.  It's kind
of silly for someone doing that sort of work to not have at least one
product in each category of receiver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
