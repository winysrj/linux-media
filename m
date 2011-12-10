Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1LJQQQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 11:16:16 -0500
Message-ID: <4EE385C2.6040108@redhat.com>
Date: Sat, 10 Dec 2011 14:16:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] DVB: dvb_frontend: fix delayed thread exit
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi> <4EE287A9.3000502@redhat.com> <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com> <4EE29BA6.1030909@redhat.com> <4EE29D1A.6010900@redhat.com> <4EE2B7BC.9090501@linuxtv.org> <CAGoCfizNCqHv1iwrFNTdOxpawVB3NzJnOF=U4hn8CXZQne=Vkw@mail.gmail.com> <4EE2BE97.6020209@linuxtv.org> <CAGoCfiyx6JR_MiVdC=ZGw_G-hzrE7O8mZp1a8of8=PcxW_P82g@mail.gmail.com> <4EE3345E.5050304@redhat.com> <CAGoCfizdY84dRduX7uLjkBY-RAJ2c74nEnxFOZzU1cD_XKC4Mg@mail.gmail.com>
In-Reply-To: <CAGoCfizdY84dRduX7uLjkBY-RAJ2c74nEnxFOZzU1cD_XKC4Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 11:43, Devin Heitmueller wrote:
> Hello Mauro,
>
> On Sat, Dec 10, 2011 at 5:28 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>> Devin,
>>
>> You're over-reacting. This patch were a reply from Andreas to a thread,
>> and not a separate patch submission.
>>
>> Patches like are generally handled as RFC, especially since it doesn't
>> contain a description.
>
> Any email that starts with "WTF, Devin, you again?" will probably not
> get a very polite response.
>
> I agree there's been some overreaction, but it hasn't been on my part.
>   He took the time to split it onto a new thread, add the subject line
> "PATCH", as well as adding an SOB.  Even if his intent was only to get
> it reviewed, why should I waste half an hour of my time analyzing his
> patch to try to figure out his intent if he isn't willing to simply
> document it?

Both overacted, but this doesn't bring anything good.

> You have a history of blindly accepting such patches without review.

No. I always review all patches I receive. Yeah, I have to confess:
I'm not a robot, I'm not infallible ;) (well, even a robot would
hardly be infallible, anyway).

> My only intent was to flag this patch to ensure that this didn't
> happen here.  I've spent way more time than I should have to fixing
> obscure race conditions in dvb core.  If the author of a patch cannot
> take the time to document his findings to provide context then the
> patch should be rejected without review until he does so.
>
> And why isn't this broken into a patch series?  Even after you
> analyzed the patch you still don't understand what the changes do and
> why there are being made.  Your explanation for why he added the
> "mb()" call was because "Probably Andreas added it because he noticed
> some race condition".  What is the race condition?  Did he find
> multiple race conditions?  Is this patch multiple fixes for a race
> condition and some other crap at the same time?
>
> If a developer wants a patch reviewed (as Andreas suggested was the
> case here after-the-fact), then here's my feedback:  break this into a
> series of small incremental patches which *in detail* describe the
> problem that was found and how each patch addresses the issue.  Once
> we have that, the maintainer can do a more in-depth analysis of
> whether the patch should be accepted.  Code whose function cannot be
> explicitly justified but simply 'looks better' should not be mixed in
> with real functional changes.

I understand that you want patches better documented, so do I, and it
would be great if this patch had a better description since the beginning.

Yet, I don't agree that this patch should be split. It does just one
thing: it fixes the timeout handling for the dvb core frontend thread.

Regards,
Mauro
