Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34328 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab0BYEkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 23:40:00 -0500
Received: by bwz1 with SMTP id 1so2520647bwz.21
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 20:39:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002230853.36928.hverkuil@xs4all.nl>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <201002222254.05573.hverkuil@xs4all.nl>
	 <829197381002221400i6e4f4b17u42597d5138171e19@mail.gmail.com>
	 <201002230853.36928.hverkuil@xs4all.nl>
Date: Wed, 24 Feb 2010 23:39:58 -0500
Message-ID: <829197381002242039w4483c34dvd20ba7d96d88f569@mail.gmail.com>
Subject: Re: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 23, 2010 at 2:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Control enumeration is actually working fine.  The queryctrl does
>> properly return all of the controls, including my new private control.
>
> OK. So the problem is that v4l2-ctl uses G/S_EXT_CTRLS for non-user controls,
> right? Why not change v4l2-ctl: let it first try the EXT version but if that
> fails with EINVAL then try the old control API.

For what it's worth, I actually bisected the v4l2-ctl.cpp, and found
out the breakage got introduced in rev 12546:

==
v4l2-ctl: add support for string controls

From: Hans Verkuil <hverkuil@xs4all.nl>

Add support for string controls to v4l2-ctl.
Also refactor the code to generalize the handling of control classes.

Priority: normal
==

And this change breaks the v4l2-ctl application not just with my
driver but with *any* of the drivers which have private controls
implemented in g_ctrl or s_ctrl (including bttv, saa7134, and pwc)

The root of the issue is that private controls are not considered
"user controls".  Hence when getting or setting the control, the
v4l2-ctl app will always insist on attempting to use the
g_ext_ctrls/s_ext_ctrls ioctl calls, even though the underlying driver
doesn't have them implemented as extended controls.

The enumeration of all of control values (using the "-l" argument)
does include the private controls properly because the logic is
written such that it always uses g_ctrl for all cases where the
control ID >= V4L2_CID_PRIVATE_BASE.

I guess I'll see whether I can rework the logic a bit such that the
set/get routines work in a comparable manner to the routine to
enumerate all the controls.  I would prefer to avoid making the
g_ext_ctrls ioctl() call and then retrying it as g_ctrl if it fails,
since that will cause errors to be printed to the screen (due to the
abstraction of doioctl() function) and is generally a bad practice.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
