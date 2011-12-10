Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47535 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1LJNnF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:43:05 -0500
Received: by yenm11 with SMTP id m11so2770000yen.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 05:43:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE3345E.5050304@redhat.com>
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
	<4EE252E5.2050204@iki.fi>
	<4EE25A3C.9040404@redhat.com>
	<4EE25CB4.3000501@iki.fi>
	<4EE287A9.3000502@redhat.com>
	<CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com>
	<4EE29BA6.1030909@redhat.com>
	<4EE29D1A.6010900@redhat.com>
	<4EE2B7BC.9090501@linuxtv.org>
	<CAGoCfizNCqHv1iwrFNTdOxpawVB3NzJnOF=U4hn8CXZQne=Vkw@mail.gmail.com>
	<4EE2BE97.6020209@linuxtv.org>
	<CAGoCfiyx6JR_MiVdC=ZGw_G-hzrE7O8mZp1a8of8=PcxW_P82g@mail.gmail.com>
	<4EE3345E.5050304@redhat.com>
Date: Sat, 10 Dec 2011 08:43:04 -0500
Message-ID: <CAGoCfizdY84dRduX7uLjkBY-RAJ2c74nEnxFOZzU1cD_XKC4Mg@mail.gmail.com>
Subject: Re: [PATCH] DVB: dvb_frontend: fix delayed thread exit
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Sat, Dec 10, 2011 at 5:28 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Devin,
>
> You're over-reacting. This patch were a reply from Andreas to a thread,
> and not a separate patch submission.
>
> Patches like are generally handled as RFC, especially since it doesn't
> contain a description.

Any email that starts with "WTF, Devin, you again?" will probably not
get a very polite response.

I agree there's been some overreaction, but it hasn't been on my part.
 He took the time to split it onto a new thread, add the subject line
"PATCH", as well as adding an SOB.  Even if his intent was only to get
it reviewed, why should I waste half an hour of my time analyzing his
patch to try to figure out his intent if he isn't willing to simply
document it?

You have a history of blindly accepting such patches without review.
My only intent was to flag this patch to ensure that this didn't
happen here.  I've spent way more time than I should have to fixing
obscure race conditions in dvb core.  If the author of a patch cannot
take the time to document his findings to provide context then the
patch should be rejected without review until he does so.

And why isn't this broken into a patch series?  Even after you
analyzed the patch you still don't understand what the changes do and
why there are being made.  Your explanation for why he added the
"mb()" call was because "Probably Andreas added it because he noticed
some race condition".  What is the race condition?  Did he find
multiple race conditions?  Is this patch multiple fixes for a race
condition and some other crap at the same time?

If a developer wants a patch reviewed (as Andreas suggested was the
case here after-the-fact), then here's my feedback:  break this into a
series of small incremental patches which *in detail* describe the
problem that was found and how each patch addresses the issue.  Once
we have that, the maintainer can do a more in-depth analysis of
whether the patch should be accepted.  Code whose function cannot be
explicitly justified but simply 'looks better' should not be mixed in
with real functional changes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
