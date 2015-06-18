Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52700 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbbFRVXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 17:23:10 -0400
Date: Thu, 18 Jun 2015 18:23:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org, James Hogan <james@albanarts.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
Message-ID: <20150618182305.577ba0df@recife.lan>
In-Reply-To: <3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
References: <20150519203851.GC18036@hardeman.nu>
	<CAKv9HNb=qK18mGj9dOdyqEPvABU8b8aAEmGa1s2NULC4g0KX-Q@mail.gmail.com>
	<20150520182901.GB13624@hardeman.nu>
	<CAKv9HNZdsse=ETkKpZWPN8Z+kLA_aNxpvEtr_WFGp5ZpaZ36dg@mail.gmail.com>
	<20150520204557.GB15223@hardeman.nu>
	<CAKv9HNZEQJkCE3b0OcOGg_o59aYiTwLhQ0f=ji1obcJcG7ePwA@mail.gmail.com>
	<32cae92aa099067315d1a13c7302957f@hardeman.nu>
	<CAKv9HNZ_JjCutG-V+77vu2xMEihbRrYJSr4QR+LESSdrM71+yQ@mail.gmail.com>
	<db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
	<CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
	<20150521194034.GB19532@hardeman.nu>
	<CAKv9HNbsCK_1XbYMgO3Monui9JnHc7knJL3yon9FUMJ_MCLppg@mail.gmail.com>
	<5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
	<CAKv9HNbGAta3BDSk=xjsviUuqMP7TBGtf4PhdfNn8B7N-Gz_dg@mail.gmail.com>
	<3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 14 Jun 2015 01:44:54 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On 2015-05-23 13:34, Antti Seppälä wrote:
> > On 22 May 2015 at 13:33, David Härdeman <david@hardeman.nu> wrote:
> >> On 2015-05-22 07:27, Antti Seppälä wrote:
> >>> I think that approach too is far from perfect as it leaves us with
> >>> questions such as: How do we let the user know what variant of
> >>> protocol the label "rc-6" really means? If in nvt we hardcode it to
> >>> mean RC6-0-16 and a new driver cames along which chooses
> >>> RC_TYPE_RC6_6A_24 how do we tell the user that the implementations
> >>> differ? What if the scancode that was fed was really RC_TYPE_RC6_MCE?
> >> 
> >> 
> >> I never claimed it was perfect.
> >> 
> >> For another (short-term, per-driver) solution, see the winbond-cir 
> >> driver.
> >> 
> > 
> > Heh, funny you should mention that... Back in late 2013/early 2014 I
> > submitted a patch for nuvoton which was modeled after winbond-cir. The
> > feedback from that could be summarized as:
> >  - Scancodes should be used instead of raw pulse/spaces (the initial
> > version of the patch worked without encoding)
> >  - Encoders should be generalized for others to use them too
> >  - Sysfs -api should be used instead of module parameters
> > 
> > So the suggestions were a pretty much the exact opposite of what
> > winbond-cir does.
> 
> Again, it was a short-term suggestion. A long-term "real" solution 
> requires a definitive identification of the intended protocol.
> 
> One idea that I've had in the back of my head for a long time is to use 
> the "flags" member of "struct rc_keymap_entry" in the new 
> EVIOC[GS]KEYCODE_V2 ioctl variant (see 
> http://www.spinics.net/lists/linux-media/msg88452.html).
> 
> If a RC_POWERON flag was defined, it could be used for that purpose...
> 
> >> It's entirely broken in the sense that a user has no idea of knowing 
> >> if the
> >> hardware has been properly configured to wake the computer or not. 
> >> It's just
> >> as broken as the connect() system call would be if it randomly rewrote 
> >> the
> >> destination address passed by the user, optionally connected, and most 
> >> of
> >> the time returned zero independently of the result.
> >> 
> > 
> > I think you may be misunderstanding the sysfs api or at least the
> > connect() analogue here as well as the userspace-kernelspace example
> > above are actually not how the api works. Remember that userspace does
> > not know about the protocol variants.
> 
> Userspace most definately does. Keymaps are a good example of that. 
> Distributing keymaps for a certain remote should be possible.
> 
> > Let me try to use your example and work-out how it really goes:
> > * Userspace: please set the hardware to wake up if the scancode
> > 0x800f040c is received. I know this is RC6 scancode because it came
> > from the rc-6 decoder but I don't know the variant (and I don't really
> > care)
> 
> First of all...you assume that the only way of generating a valid wakeup 
> scancode is by using the same remote on the same hardware first to see 
> what it generates (which - thanks to things like boneheaded decisions on 
> NEC scancode generation and the previously mentioned heuristics - may 
> differ). So distributing a keymap from a central repository or just 
> looking up scancodes from a vendor datasheet is no longer feasible with 
> this API.
> 
> Second, you have absolutely nothing that ensures that the same 
> heuristics are used in the decode/encode code paths and that the 
> heuristics will remain in sync.
> 
> > * Kernel: Ok (btw. based on the length of the scancode and the
> > bit-pattern in the front I've determined this to be rc6-mce type
> > scancode and encoded it accordingly)
> > * Userspace: Got it
> 
> The whole "btw" part won't be passed to userspace...so there's nothing 
> to "get"
> 
> > So no changing anything behind users back or not leading to
> > misconfigured hardware AFAICT.
> ...
> > I'm sorry that the encoding functionality clashes with your intentions
> > of improving the rc-core. I guess Mauro likes encoders more than
> > improving rc-core fundamentals :)
> > Kidding aside the fact that this series got merged might suggest that
> > you and Mauro don't necessarily share the same views about the future
> > and possible api breaks of rc-core.
> 
> If you've followed the development of rc-core during the last few years 
> it should be pretty clear that Mauro has little to no long-term plan, 
> understanding of the current issues or willingness to fix them. I 
> wouldn't read too much into the fact that the code was merged.

You completely missed the point. Adding new drivers and new features
don't require much time to review, and don't require testing.

What you're trying to send as "fixes" is actually series of patches that
change the behavior of the subsystem, with would cause regressions.

Btw, a lot of the pull requests you've sent over the past years did cause
regressions. So, I can only review/apply them when I have a bunch of
spare time to test them. As I don't usually have a bunch of spare time,
nor we have a sub-maintainer for remote controllers that would have
time for such tests, they're delayed.

> > Tell you what, I'll agree to reverting the series. In exchange I would
> > hope that you and Mauro mutually agree and let me know on:
> >  - What are the issues that need to be fixed in the encoding series
> > prefarably with how to fix them (e.g. module load order ambiquity,
> > whether a new api is needed, or switching to a more limited
> > functionality is desired like you suggested then so be it etc.)
> >  - When is a good chance to re-submit the series (e.g. after
> > ioctl/scancode/whatever api break is done or some pending series is
> > merged or some other core refactoring work is finished etc.)
> > 
> > Deal?
> 
> Mauro....wake up? I hope you're not planning to push the current code 
> upstream???

What's there are planned to be sent upstream. If you think that something
is not mature enough to be applied, please send a patch reverting it,
with "[PATCH FIXES]" in the subject, clearly explaining why it should be
reverted for me to analyze. Having Antti/James acks on that would help.

Regards,
Mauro
