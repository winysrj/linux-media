Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3004 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab0DHGzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 02:55:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Control Framework Roadmap
Date: Thu, 8 Apr 2010 08:55:47 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004080855.47063.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, the discussion in response to my RFC was very enlightening. Based on
that I decided on the following roadmap:

1) Remove the sysfs code from the framework for the time being.

It is not necessary for the first version. What I would like to do is to take
another good look at the data structures and code to see if I can organize it
in such a way that adding debugfs and/or sysfs in the future would be very
easy to do. I also want to make sure that 'remap' functionality would be
easy to add later. I strongly suspect that we will need that for certain
corner cases as Andy described.

2) Verify that uvc can work with this.

The UVC driver can dynamically add new controls for UVC webcams. It should
work with the framework but this needs to be verified. This will take some
time since both Laurent and myself are busy for the next two weeks.

3) If all is OK, then I can post a patch series for the basic framework.

4) Once merged the work can begin on converting bridge and subdev drivers.

5) Further discuss sysfs/debugfs support.

Support for sysfs (and possibly debugfs) will depend on the event patches
being merged (as that introduces struct v4l2_fh) and the proposed pre/post
hooks in ioctl_ops. Pre/post hooks in turn depend on improve core support for
v4l2_priority (which in turn depends on the struct v4l2_fh). It's all pretty
trivial code, but it is needed to provide a 'fixed' control path that drivers
can rely on. No matter whether the driver is approached via an ioctl, sysfs
or debugfs, from the point of view of the driver it should all look like an
ioctl. That way the driver doesn't have to deal with multiple points of entry.

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
