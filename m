Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:45336 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbbJNPho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2015 11:37:44 -0400
Date: Wed, 14 Oct 2015 17:37:35 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: v4l2-ctrl is unable to set autogain to 0 with gspca/ov534
Message-Id: <20151014173735.1580e747a9f79fc4c7364e5b@ao2.it>
In-Reply-To: <561B6798.7070909@xs4all.nl>
References: <20151007100524.3fc05282628a153591f5c13e@ao2.it>
	<561B6798.7070909@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Oct 2015 09:56:08 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Antonio,
> 
> On 10/07/2015 10:05 AM, Antonio Ospite wrote:
[...]
> > After a little investigation I figured out some more details: in my use
> > case the autogain is a master control in an auto cluster, and switching
> > it from auto to manual does not work when using VIDIOC_S_CTRL i.e. when
> > calling set_ctrl().
> > 
> > It works with qv4l2 because it uses VIDIOC_S_EXT_CTRLS.
> > 
> > So the difference is between v4l2-ctrls.c::v4l2_s_ctrl() and
> > v4l2-ctrls.c::v4l2_s_ext_ctrls().
> > 
> > Wrt. auto clusters going from auto to manual the two functions do
> > basically this:
> > 
> > 
> >   v4l2_s_ctrl()
> >     set_ctrl_lock()
> >       user_to_new()
> >       set_ctrl()
> >         update_from_auto_cluster(master)
> >         try_or_set_cluster()
> >       cur_to_user()
> >         
> >     
> >   v4l2_s_ext_ctrls()
> >     try_set_ext_ctrls()
> >       update_from_auto_cluster(master)
> >       user_to_new() for each control
> >       try_or_set_cluster()
> >       new_to_user()
> > 
> > 
> > I think the problem is that when update_from_auto_cluster(master) is
> > called it overrides the new master control value from userspace by
> > calling cur_to_new(). This also happens when calling VIDIOC_S_EXT_CTRLS
> > (in try_set_ext_ctrls), but in that case, AFTER the call to
> > update_from_auto_cluster(master), the code calls user_to_new() that sets
> > back again the correct new value in the control before making the value
> > permanent with try_or_set_cluster().
> > 
> > The regression may have been introduced in
> > 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca, in fact by just reverting
> > these two interdependent commits:
> > 
> > 7a7f1ab37dc8f66cf0ef10f3d3f1b79ac4bc67fc
> > 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca
> > 
> > the problem goes away, so the regression is about user_to_new() not
> > being called AFTER update_from_auto_cluster(master) anymore in
> > set_ctrl(), as per 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca.
> 
> Excellent analysis!
>

I think we can make the code paths of v4l2_s_ctrl() and
v4l2_s_ext_ctrls() more look alike to ease similar investigations.

In v4l2_s_ext_ctrls():

  1. Call user_to_new() before update_from_auto_cluster(master), I am
     still not 100% sure if this can introduce regressions.

  2. Use cur_to_user() instead of new_to_user(), to match the code path
     of v4l2_s_ctrl(), the effect of using either one or the other
     should be equivalent right _after_ a call to try_or_set_cluster(),
     shouldn't it?

I'll try to test these changes as time permits, but if anyone can
squeeze that in their paid time feel free to anticipate me.

[...] 
> Thanks for looking at this!
>

FWIW I got interested by this in particular:

  $ strace v4l2-ctl --set-ctrl=gain_automatic=0
  ...
  ioctl(3, VIDIOC_S_CTRL, {id=V4L2_CID_AUTOGAIN, value=1}) = 0
                                                       ^

Ciao ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
