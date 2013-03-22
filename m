Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1352 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035Ab3CVRIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 13:08:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "edubezval@gmail.com" <edubezval@gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
Date: Fri, 22 Mar 2013 18:08:40 +0100
Cc: linux-media@vger.kernel.org
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com> <201303221745.55932.hverkuil@xs4all.nl> <CAC-25o_J1PrTk0gwSV=Fto-NGirZpmDa-otpaQV6X6+1E+xG0A@mail.gmail.com>
In-Reply-To: <CAC-25o_J1PrTk0gwSV=Fto-NGirZpmDa-otpaQV6X6+1E+xG0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221808.40894.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 22 2013 17:59:00 edubezval@gmail.com wrote:
> Hans,
> 
> 
> On Fri, Mar 22, 2013 at 12:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Fri March 22 2013 17:26:57 edubezval@gmail.com wrote:
> >> Hello Hans,
> >>
> >> On Fri, Mar 22, 2013 at 10:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> <snip>
> >>
> >> >>
> >> >> # on your branch on the other hand I get a NULL pointer:
> >> >
> >> > I've fixed that (v4l2_dev was never initialized), and I've also rebased my tree
> >> > to the latest code. Can you try again?
> >> >
> >>
> >> This time I get a kernel crash at _power. Unfortunately I cannot fetch
> >> the crash log as I am not having access to a serial line (using vga
> >> console) and in my setup mtdoops is not working somehow.
> >>
> >>
> >> Sequence is v4l2_ioctl->video_usercopy->__video_do_ioctl->v4l_s_ctrl->v4l2_s_ctrl->set_ctrl_lock->try_or_set_cluster->si4713_s_ctrl->si4713_set_power_state->mutex_lock_nested->lock_acquire.
> >>
> >>
> >> I 'd need to spend some time on it to understand better your patches
> >> and help you to get this working. And for that I'd prob need to spend
> >> some time to either hack a serial line or get mtdoops to work :-)
> >
> > You're doing fine: that was all the info I needed. Can you do a git pull and
> > try again?
> >
> 
> Sure. Your patch removes the locks but I believe the set_power is used in other
> places as well. And has a misspell: s/clocks/locks.
> 
> But now I still get the nested lock issue. But this time around
> si4713_setup, that is called from _s_ctrl and which in turns calls
> v4l2_ctrl_handler_setup, which call s_ctrl again.

One last try: again do a git pull and see what happens.

I'm on irc at the moment, that's a bit more interactive.

It's clear by the way that I need to study the locking scheme in this
driver, but I'd really like to see the v4l2-compliance output :-)

Regards,

	Hans
