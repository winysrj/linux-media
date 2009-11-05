Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2631 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZKEM42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 07:56:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH] V4L: adding digital video timings APIs
Date: Thu, 5 Nov 2009 13:56:29 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com> <76889a5297f775ff3e951ae3af801f96.squirrel@webmail.xs4all.nl> <A69FA2915331DC488A831521EAE36FE4015568EF61@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015568EF61@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051356.29540.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 October 2009 22:44:34 Karicheri, Muralidharan wrote:
> Hans,
> 
> >> following IOCTLS :-
> >>
> >>  -  verify the new v4l2_input capabilities flag added
> >>  -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
> >>  -  Set one of the supported preset using VIDIOC_S_DV_PRESET
> >>  -  Get current preset using VIDIOC_G_DV_PRESET
> >>  -  Detect current preset using VIDIOC_QUERY_DV_PRESET
> >>  -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
> >>     and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device.
> >>
> >> TODOs :
> >>
> >>  - Test it on a 64bit platform - I need help here since I don't have the
> >> platform.
> >>  - Add documentation (Can someone tell me which file to modify in the
> >> kernel tree?).
> >
> >Use the spec in media-spec/v4l.
> 
> [MK] Where can I access this? Is this part of kernel tree (I couldn't find
> it under Documentation/video4linux/ under the kernel tree? Is it just updating a text file or I need to have some tool installed to access
> this documentation and update it.

This has been moved around quite a bit lately. It is now in
linux/Documentation/DocBook/v4l. You build it using 'make media-spec'.

> >Please also add support to v4l2-ctl.cpp in v4l2-apps/util! That's handy
> >for testing.
> [MK] Are you referring to the following repository for this?
> 
> http://linuxtv.org/hg/~dougsland/tool/file/5b884b36bbab
> 
> Is there a way I can do a git clone for this?

Both the doc and the v4l2-ctl.cpp utility are in the master hg repository
(linuxtv.org/hg/v4l-dvb). The utility can be found here: v4l2-apps/util.
Build it using 'make apps'. The patches of the timings API, docs and utils
should all be done against the master hg tree since that is that latest and
greatest tree.

> 
> >
> >Setting the input/output capabilities should be done in v4l2-ioctl.c
> >rather than in the drivers. All the info you need to set these bits is
> >available in the core after all.
> >
> 
> [MK] Could you explain this to me? In my prototype, I had tvp5146 that
> implements S_STD and tvp7002 that implements S_PRESET. Since bridge driver
> has all the knowledge about the sub devices and their capabilities, it can
> set the flag for each of the input that it supports (currently I am
> setting this flag in the board setup file that describes all the inputs using v4l2_input structure). So it is a matter of setting relevant cap flag in this file for each of the input based on what the sub device supports. I am not sure how core can figure this out?

The problem is that we don't want to go through all drivers in order to set
the input/output capability flags. However, v4l2_ioctl.c can easily check
whether the v4l2_ioctl_ops struct has set vidioc_s_std, vidioc_s_dv_preset
and/or vidioc_s_dv_timings and fill in the caps accordingly. If this is done
before the vidioc_enum_input/output is called, then the driver can override
what v4l2_ioctl.c did if that is needed.

> 
> >I also noticed that not all new ioctls are part of video_ops. Aren't they
> >all required?
> >
> [MK] All new ioctls are supported in video_ops. I am not sure what you are
> referring to. For sub device ops, only few are required since bridge device
> can handle the rest.

OK.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
