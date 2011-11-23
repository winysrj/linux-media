Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36511 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753909Ab1KWLyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 06:54:22 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 4/4] ivtv: implement new decoder command ioctls.
Date: Wed, 23 Nov 2011 12:54:18 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231254.18805.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I am not sure if I understand this right. You wrote:

"Comments are added on how to convert the legacy ioctls to standard V4L2 API 
in applications. Perhaps these legacy ioctls in ivtv can even be removed in a 
few years time."

But the patch looks for me as if the currently used ioctls shall be removed 
now, which would immidiately break existing applications.

This is an example of the currently used code:

void cPvr350Device::DecoderStop(int blank)
{
	struct video_command cmd;
	memset(&cmd, 0, sizeof(cmd));
	cmd.cmd = VIDEO_CMD_STOP;
	if (blank) {
		cmd.flags = VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY;
	} else { //show last frame instead of a black screen
		cmd.flags = VIDEO_CMD_STOP_IMMEDIATELY;
	}
	if (IOCTL(fd_out, VIDEO_COMMAND, &cmd) < 0) {
		log(pvrERROR, "pvr350: VIDEO_CMD_STOP %s error=%d:%s", 
			blank ? "(blank)" : "", errno, strerror(errno));
	}
}

As far as I know my pvr350-Plugin for vdr is the only application which uses 
the hardware decoder of the PVR350 (mythtv has dropped support some years 
ago). There are only a few users left in time of HDTV. 
I don't really understand why it is necessary to do this changes. 

I suggest to increase the ivtv driver version number when implementing the 
changes. The application (which must be backward compatible) should be able to 
determine which ioctl it has to use.

It would be much better if the ivtv driver would continue to support the old 
ioctl for the few years we still have any PVR350 user.

Greets,

Martin
