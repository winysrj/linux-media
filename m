Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4787 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab0EXNmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 09:42:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 03/15] [RFCv2] Documentation: add v4l2-controls.txt documenting the new controls API.
Date: Mon, 24 May 2010 15:43:53 +0200
Cc: linux-media@vger.kernel.org
References: <cover.1274015084.git.hverkuil@xs4all.nl> <201005240117.35431.laurent.pinchart@ideasonboard.com> <201005241144.16825.hverkuil@xs4all.nl>
In-Reply-To: <201005241144.16825.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005241543.53647.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 24 May 2010 11:44:16 Hans Verkuil wrote:
> Hi Laurent,
> 
> Thanks for your review! As always, it was very useful.

I've incorporated most points in my ctrlfw3 branch:

http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/ctrlfw3

Main changes:

- Replaced 'bridge driver' by 'V4L2 driver'.
- Added is_volatile and is_uninitialized flags (to control whether g_volatile_ctrl or
  init should be called).
- Added is_volatile, is_uninitialized and is_private flags to v4l2_ctrl_config.
- If the name field in struct v4l2_ctrl_config is NULL, then assume it is a standard
  control and fill in the defaults accordingly.

These two changes together make it possible to make an array of struct v4l2_ctrl_config
to create all controls. Perhaps v4l2_ctrl_new_custom should be renamed to v4l2_ctrl_new?

- v4l2_ctrl_new_std_menu now has a 'max' argument.
- v4l2_ctrl_new_std can no longer be used to create a standard menu control.
  This should prevent confusion regarding step and skip_mask.
- v4l2_ctrl_active and v4l2_ctrl_grab set the flag atomically, so can be called
  from anywhere.

I did not yet change anything regarding the init return type. I'm really not
sure what userspace is supposed to do here. If you fail initializing a control,
does that mean that -EIO should be returned? The only way this can fail is if
there is a hardware problem, right?

Can you give some background info on how this is currently handled in uvc?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
