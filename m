Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45191 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649AbbFOO0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 10:26:30 -0400
Message-ID: <557EE085.5020708@xs4all.nl>
Date: Mon, 15 Jun 2015 16:26:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [GIT FIXES FOR v4.2] Revert "[media] vb2: Push mmap_sem down to memops"
 & videodev2.h fix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge this revert asap. This patch introduces two serious regressions (first
noticed when testing the cobalt driver, later reproduced with the vivid driver).

This patch needs more work from Jan. Luckily I noticed in time and it should help
Jan that it is reproducible with vivid, so he does not need any hardware to test it.

The other patch I added (superseding my previous GIT FIXES request) fixes a stupid
copy-and-paste error in a macro newly added for 4.2. This bug breaks the correct
handling of transfer functions as I discovered while preparing for a presentation on
this topic.

Regards,

	Hans

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2o

for you to fetch changes up to 6da206bf3b501193398ccd55383ea0e8df1755d8:

  videodev2.h: fix copy-and-paste error in V4L2_MAP_XFER_FUNC_DEFAULT (2015-06-15 16:21:14 +0200)

----------------------------------------------------------------
Hans Verkuil (2):
      Revert "[media] vb2: Push mmap_sem down to memops"
      videodev2.h: fix copy-and-paste error in V4L2_MAP_XFER_FUNC_DEFAULT

 drivers/media/v4l2-core/videobuf2-core.c       | 2 ++
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 7 -------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 6 ------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 6 +-----
 include/uapi/linux/videodev2.h                 | 2 +-
 5 files changed, 4 insertions(+), 19 deletions(-)
