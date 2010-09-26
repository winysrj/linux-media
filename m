Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2789 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0IZIbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 04:31:14 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8Q8V7GY049444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 10:31:12 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] Rename video_device et al to v4l2_devnode
Date: Sun, 26 Sep 2010 10:30:59 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261030.59772.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Most of the v4l2 framework has prefixes that start with v4l2_ except for
struct video_device in v4l2-dev.c. This name is becoming very confusing since
it closely resembles struct v4l2_device. Since video_device really represents
a v4l2 device node I propose to rename it to v4l2_devnode and rename the
v4l2-dev.[ch] to v4l2-devnode.[ch].
 
To make the transition easier I created a v4l2-dev.h that includes the new
v4l2-devnode.h and #defines the old names to the new names.
 
I also updated the documentation to reflect the new header and naming convention.

The patches are here:

http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/v4l2-devnode

Hans Verkuil (18):
      v4l2-devnode: renamed from v4l2-dev
      videodev2.h: update comment
      v4l2 core: use v4l2-devnode.h instead of v4l2-dev.h
      v4l2: rename to_video_device to v4l2_devnode_from_device
      v4l2: rename video_device_alloc to v4l2_devnode_alloc
      v4l2: rename video_device_release_empty to v4l2_devnode_release_empty
      v4l2: rename video_device_release to v4l2_devnode_release
      v4l2: rename video_device_node_name to v4l2_devnode_name
      v4l2: rename video_register_device to v4l2_devnode_register
      v4l2: rename video_unregister_device to v4l2_devnode_unregister
      v4l2: rename video_is_registered to v4l2_devnode_is_registered
      v4l2: rename video_get/set_drvdata to v4l2_devnode_get/set_drvdata
      v4l2: rename video_devdata to v4l2_devnode_from_file
      v4l2: rename video_drvdata to v4l2_drvdata_from_file
      v4l2: rename video_device to v4l2_devnode
      tea575x: convert to v4l2-devnode.h
      v4l2: include v4l2-devnode.h instead of v4l2-dev.h
      v4l2: issue warning if v4l2-dev.h is included

After converting all drivers I added a warning to v4l2-dev.h when it is used.
This header can be removed completely after this series has been merged in the
mainline 2.6.37 kernel.

It's all pretty trivial but I think the new names are much more understandable
and fit well within the v4l2 framework API.

Comments?

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
