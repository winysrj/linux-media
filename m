Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4113 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161005Ab3CVQqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:46:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "edubezval@gmail.com" <edubezval@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] media: si4713: minor updates
Date: Fri, 22 Mar 2013 17:45:55 +0100
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com> <201303221504.06707.hverkuil@xs4all.nl> <CAC-25o-Y=0d9=W2L9-_THvK2cR+jwp=gcZ6URSa6byaR3mKpiw@mail.gmail.com>
In-Reply-To: <CAC-25o-Y=0d9=W2L9-_THvK2cR+jwp=gcZ6URSa6byaR3mKpiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221745.55932.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 22 2013 17:26:57 edubezval@gmail.com wrote:
> Hello Hans,
> 
> On Fri, Mar 22, 2013 at 10:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> <snip>
> 
> >>
> >> # on your branch on the other hand I get a NULL pointer:
> >
> > I've fixed that (v4l2_dev was never initialized), and I've also rebased my tree
> > to the latest code. Can you try again?
> >
> 
> This time I get a kernel crash at _power. Unfortunately I cannot fetch
> the crash log as I am not having access to a serial line (using vga
> console) and in my setup mtdoops is not working somehow.
> 
> 
> Sequence is v4l2_ioctl->video_usercopy->__video_do_ioctl->v4l_s_ctrl->v4l2_s_ctrl->set_ctrl_lock->try_or_set_cluster->si4713_s_ctrl->si4713_set_power_state->mutex_lock_nested->lock_acquire.
> 
> 
> I 'd need to spend some time on it to understand better your patches
> and help you to get this working. And for that I'd prob need to spend
> some time to either hack a serial line or get mtdoops to work :-)

You're doing fine: that was all the info I needed. Can you do a git pull and
try again?

Regards,

	Hans
