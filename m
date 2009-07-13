Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw2.jenoptik.com ([213.248.109.130]:33433 "EHLO
	mailgw2.jenoptik.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZGMN4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 09:56:24 -0400
Date: Mon, 13 Jul 2009 15:46:19 +0200
From: "Jesko Schwarzer" <jesko.schwarzer@jena-optronik.de>
To: "'cyber.bogh'" <cyber.bogh@gmx.de>,
	"'Matthias Schwarzott'" <zzam@gentoo.org>
cc: <linux-media@vger.kernel.org>, <me@boris64.net>,
	"'Trent Piepho'" <xyzzy@speakeasy.org>
Message-ID: <"4430.36051247492794.hermes.jena-optronik.de*"@MHS>
In-Reply-To: <200907131529.25786.cyber.bogh@gmx.de>
Subject: AW: [GIT PATCHES for 2.6.31] V4L/DVB fixes
MIME-Version: 1.0
Content-Type: text/plain;
 	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
Hey cyber.bogh,

besides the fact that you MAY be right in your zhinking about such usage of
drivers and kernel elements ...

This is not the right way to complain about users/developers not so deeply
into the materia than you.
If you know more about special things in the area you work in - fine. Let
others participate - and if you don't want to - be gentle and calm.
If you need people testing your development output just ask. You are free to
remember those e-mail addresses as of boris and ask him directly.

Beside all this: What does you mean with

"So compiling those drivers a module is gold, and any other choice is simply
nonsense."

???

The concept of build in drivers and modules to my view is: use a "module" if
functionality is not really needed at boot time otherwise "build in".

What does this mean in regard of your statement?

Does funtionality change if I would use "build in" instead of "modules" ????

Regards
/Jesko


-----Ursprüngliche Nachricht-----
Von: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] Im Auftrag von cyber.bogh
Gesendet: Montag, 13. Juli 2009 15:29
An: Matthias Schwarzott
Cc: linux-media@vger.kernel.org; me@boris64.net; Trent Piepho
Betreff: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes

Am Montag 13 Juli 2009 14:13:50 schrieben Sie:
> On Sonntag, 12. Juli 2009, Boris Cuber wrote:
> > Hi kernel folks!
> >
> > Problem:
> > Since kernel-2.6.31-rc* my dvb-s adapter (Technisat SkyStar2 DVB 
> > card) refuses to work (worked fine in every kernel up to 2.6.30.1).
> > So anything pulled into the new kernel seems to have broken 
> > something (at least for me :/).
> >
> > I opened a detailed bug report here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13709
> > Please let me know if i can help in finding a solution or testing a 
> > patch /whatever.
>
> This looks like it is related to this patch:
>
> commit d66b94b4aa2f40e134f8c07c58ae74ef3d523ee0
> Author: Patrick Boettcher <pb@linuxtv.org>
> Date:   Wed May 20 05:08:26 2009 -0300
>
>     V4L/DVB (11829): Rewrote frontend-attach mechanism to gain 
> noise-less deactivation of submodules
>
>     This patch is reorganizing the frontend-attach mechanism in order to
>     gain noise-less (superflous prints) deactivation of submodules.
>
>     Credits go to Uwe Bugla for helping to clean and test the code.
>
>     Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
>     Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>
>
> All frontend-attach related code is wrapped by ifdefs like this:
> #if defined(CONFIG_DVB_MT312_MODULE) || 
> defined(CONFIG_DVB_STV0299_MODULE)
> <CODE>
> #endif
>
> So this code will only be compiled if one of the two drivers is 
> compiled as a module, having them compiled in will omit this code.

Yes. And that's exactly the way things were planned and should also stay,
even if there exist a thousands of "Boris64" who do not have the slightest
idea about what kernel compilation is or could be.....

No matter if we're talking about the main module, the frontend, the backend
or whatever other part of not only a DVB driver:
None of them is permanently needed while the machine is running. So kmod can
kick them out of the memory if they aren't needed, if they were compiled as
module.

But if you compile them into the kernel you are wasting system resources
because the main kernel becomes too big (I'd call that a "Windoze-effect").

So compiling those drivers a module is gold, and any other choice is simply
nonsense.

> Trent Piepho seems to already have a patch for this, but it is not yet 
> merged into the kernel.

May Trent Piepho do whatever he likes. I do not think that any further patch
is necessary for that driver section.

It would rather be necessary for some quirky users to enlarge their limited
brain and understand what kernel compilation means and is here for.

> Regards
> Matthias

CU

cyber.bogh

P. S.: The other part that really makes me utmost angry about the "Boris's"
in that world:

If you're doing really hard for months to enhance things, and you urgently
need testers to help and invest brain those Boris's aren't visible at all. 
Nowhere!

Once things are done they come back and all they have got to do then is to
complain for stupid nonsense...

How did Lou Reed say?
"Stick a fork in their ass, turn it over and they're done!"

> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

