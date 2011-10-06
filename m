Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:10317 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 07:14:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: libv4l2 misbehavior after calling S_STD or S_DV_PRESET
Date: Thu, 6 Oct 2011 13:13:56 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110061313.56974.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans!

I've been looking into a problem with libv4l2 that occurs when you change TV 
standard or video preset using VIDIOC_S_STD or VIDIOC_S_DV_PRESET. These calls 
will change the format implicitly (e.g. if the current format is set for PAL 
at 720x576 and you select NTSC, then the format will be reset to 720x480).

However, libv4l2 isn't taking this into account and will keep using the cached 
dest_fmt value. It is easy to reproduce this using qv4l2.

The same problem is likely to occur with S_CROP (haven't tested that yet, 
though): calling S_CROP can also change the format.

To be precise: S_STD and S_DV_PRESET can change both the crop rectangle and 
the format, and S_CROP can change the format.

I've been trying to find a quick solution for this in libv4l2.c but without any 
luck.

Can you look at this? Or do you have ideas how this should be done?

Regards,

	Hans
