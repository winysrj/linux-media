Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52069 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755843AbZGMNa7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 09:30:59 -0400
From: "cyber.bogh" <cyber.bogh@gmx.de>
To: Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Date: Mon, 13 Jul 2009 15:29:25 +0200
References: <200907121550.36679.me@boris64.net> <200907131413.50826.zzam@gentoo.org>
In-Reply-To: <200907131413.50826.zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, me@boris64.net,
	Trent Piepho <xyzzy@speakeasy.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907131529.25786.cyber.bogh@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag 13 Juli 2009 14:13:50 schrieben Sie:
> On Sonntag, 12. Juli 2009, Boris Cuber wrote:
> > Hi kernel folks!
> >
> > Problem:
> > Since kernel-2.6.31-rc* my dvb-s adapter (Technisat SkyStar2 DVB card)
> > refuses to work (worked fine in every kernel up to 2.6.30.1).
> > So anything pulled into the new kernel seems to have broken
> > something (at least for me :/).
> >
> > I opened a detailed bug report here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13709
> > Please let me know if i can help in finding a solution
> > or testing a patch /whatever.
>
> This looks like it is related to this patch:
>
> commit d66b94b4aa2f40e134f8c07c58ae74ef3d523ee0
> Author: Patrick Boettcher <pb@linuxtv.org>
> Date:   Wed May 20 05:08:26 2009 -0300
>
>     V4L/DVB (11829): Rewrote frontend-attach mechanism to gain noise-less
> deactivation of submodules
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
> #if defined(CONFIG_DVB_MT312_MODULE) || defined(CONFIG_DVB_STV0299_MODULE)
> <CODE>
> #endif
>
> So this code will only be compiled if one of the two drivers is compiled as
> a module, having them compiled in will omit this code.

Yes. And that's exactly the way things were planned and should also stay, even 
if there exist a thousands of "Boris64" who do not have the slightest idea 
about what kernel compilation is or could be.....

No matter if we're talking about the main module, the frontend, the backend or 
whatever other part of not only a DVB driver:
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

P. S.: The other part that really makes me utmost angry about the "Boris's" in 
that world:

If you're doing really hard for months to enhance things, and you urgently 
need testers to help and invest brain those Boris's aren't visible at all. 
Nowhere!

Once things are done they come back and all they have got to do then is to 
complain for stupid nonsense...

How did Lou Reed say?
"Stick a fork in their ass, turn it over and they're done!"

> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

