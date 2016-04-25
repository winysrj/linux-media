Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35883 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392AbcDYKVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 06:21:36 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 588421804B5
	for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 12:21:31 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] One bug fix, two regression fixes
Message-ID: <571DEFAB.2050305@xs4all.nl>
Date: Mon, 25 Apr 2016 12:21:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three fixes for 4.6: two vb2 regressions and one bug fix for 4k timings that
was wrong since the beginning.

Regards,

	Hans

The following changes since commit e07d46e7e0da86c146f199dae76f879096bc436a:

  [media] tpg: Export the tpg code from vivid as a module (2016-04-20 16:14:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6b

for you to fetch changes up to 5630e38582d970604daff4bb261734fe204e2791:

  vb2-memops: Fix over allocation of frame vectors (2016-04-25 12:19:30 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-dv-timings.h: fix polarity for 4k formats

Ricardo Ribalda Delgado (2):
      media: vb2: Fix regression on poll() for RW mode
      vb2-memops: Fix over allocation of frame vectors

 drivers/media/v4l2-core/videobuf2-core.c   | 10 ++++++++++
 drivers/media/v4l2-core/videobuf2-memops.c |  2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c   | 14 ++++++--------
 include/media/videobuf2-core.h             |  4 ++++
 include/uapi/linux/v4l2-dv-timings.h       | 30 ++++++++++++++++++++----------
 5 files changed, 41 insertions(+), 19 deletions(-)
