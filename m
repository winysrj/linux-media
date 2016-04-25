Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38952 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627AbcDYJc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 05:32:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 88BA51804B5
	for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 11:32:21 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] One bug fix, one regression
Message-ID: <571DE425.2020205@xs4all.nl>
Date: Mon, 25 Apr 2016 11:32:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two fixes for 4.6: one vb2 regression and one bug fix for 4k timings that
was wrong since the beginning.

Regards,

	Hans

The following changes since commit e07d46e7e0da86c146f199dae76f879096bc436a:

  [media] tpg: Export the tpg code from vivid as a module (2016-04-20 16:14:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6b

for you to fetch changes up to 94f40244bb886a9f4245a7123f1af9572c7cf82f:

  media: vb2: Fix regression on poll() for RW mode (2016-04-25 11:21:22 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-dv-timings.h: fix polarity for 4k formats

Ricardo Ribalda Delgado (1):
      media: vb2: Fix regression on poll() for RW mode

 drivers/media/v4l2-core/videobuf2-core.c | 10 ++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 14 ++++++--------
 include/media/videobuf2-core.h           |  4 ++++
 include/uapi/linux/v4l2-dv-timings.h     | 30 ++++++++++++++++++++----------
 4 files changed, 40 insertions(+), 18 deletions(-)
