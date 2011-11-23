Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3838 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1KWMOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 07:14:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Martin Dauskardt <martin.dauskardt@gmx.de>
Subject: Re: [RFC PATCH 4/4] ivtv: implement new decoder command ioctls.
Date: Wed, 23 Nov 2011 13:14:42 +0100
Cc: linux-media@vger.kernel.org
References: <201111231254.18805.martin.dauskardt@gmx.de>
In-Reply-To: <201111231254.18805.martin.dauskardt@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231314.42496.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, November 23, 2011 12:54:18 Martin Dauskardt wrote:
> Hi Hans,
> 
> I am not sure if I understand this right. You wrote:
> 
> "Comments are added on how to convert the legacy ioctls to standard V4L2 API 
> in applications. Perhaps these legacy ioctls in ivtv can even be removed in a 
> few years time."
> 
> But the patch looks for me as if the currently used ioctls shall be removed 
> now, which would immidiately break existing applications.

??? I'm not removing anything. All current ioctls remain present.

> This is an example of the currently used code:
> 
> void cPvr350Device::DecoderStop(int blank)
> {
> 	struct video_command cmd;
> 	memset(&cmd, 0, sizeof(cmd));
> 	cmd.cmd = VIDEO_CMD_STOP;
> 	if (blank) {
> 		cmd.flags = VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY;
> 	} else { //show last frame instead of a black screen
> 		cmd.flags = VIDEO_CMD_STOP_IMMEDIATELY;
> 	}
> 	if (IOCTL(fd_out, VIDEO_COMMAND, &cmd) < 0) {
> 		log(pvrERROR, "pvr350: VIDEO_CMD_STOP %s error=%d:%s", 
> 			blank ? "(blank)" : "", errno, strerror(errno));
> 	}
> }
> 
> As far as I know my pvr350-Plugin for vdr is the only application which uses 
> the hardware decoder of the PVR350 (mythtv has dropped support some years 
> ago). There are only a few users left in time of HDTV. 
> I don't really understand why it is necessary to do this changes. 

It's an DVB/V4L API cleanup: these ioctls ended up in the DVB API when they
should have been part of the V4L API. We're cleaning this up, especially
since the decoder API might become relevant for embedded systems where decoder
support is much more common.

> I suggest to increase the ivtv driver version number when implementing the 
> changes. The application (which must be backward compatible) should be able to 
> determine which ioctl it has to use.

These days the version number of all drivers is the same as the kernel version
number, so it is easy to check when new ioctls became available.
 
> It would be much better if the ivtv driver would continue to support the old 
> ioctl for the few years we still have any PVR350 user.

Don't worry, I won't be removing anything.

I checked the plugin code and you aren't using VIDEO_GET_EVENT. The VIDEO_GET_EVENT
ioctl is the only one I'd really like to get rid of in ivtv in favor of the
V4L2 event API. It's only used as far as I can tell in ivtv-ctl and ivtvplay,
both ivtv utilities that can easily be changed.

Are you perhaps aware of any other userspace applications that use that
ioctl?

Regards,

	Hans
