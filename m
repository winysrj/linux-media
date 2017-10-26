Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46238 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752128AbdJZJLz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 05:11:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] v4l2 core: simplify streaming ioctls, fix y2038
Date: Thu, 26 Oct 2017 11:11:47 +0200
Message-Id: <20171026091149.29606-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These two patches have been sitting in my tree for some time. I'm posting these
just to get some discussion started.

The first patch adds new extended streaming ioctls that fix y2038 and that simplify
the single/multiplanar handling which is very hard on userspace at the moment. Note
that I dropped support for the timecode here as well, it's not used by any driver
other than the 'virtual' drivers.

The second fixes y2038 for the DQEVENT ioctl.

It's very preliminary and there is no documentation yet.

Regards,

	Hans

Hans Verkuil (2):
  v4l2: add extended streaming operations
  v4l2-core: make VIDIOC_DQEVENT y2038 proof.

 drivers/media/v4l2-core/v4l2-common.c         |  72 ++++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   4 +-
 drivers/media/v4l2-core/v4l2-dev.c            |   4 +
 drivers/media/v4l2-core/v4l2-event.c          |  22 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          | 152 +++++++++++-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  97 ++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c      | 332 ++++++++++++--------------
 include/media/v4l2-common.h                   |   5 +
 include/media/v4l2-ioctl.h                    |  17 ++
 include/media/v4l2-mem2mem.h                  |   8 +
 include/media/videobuf2-v4l2.h                |   9 +
 include/uapi/linux/videodev2.h                |  50 +++-
 12 files changed, 577 insertions(+), 195 deletions(-)

-- 
2.14.2
