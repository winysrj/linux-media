Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:58147 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbbFOHbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 03:31:12 -0400
Message-ID: <557E7F2F.6070106@xs4all.nl>
Date: Mon, 15 Jun 2015 09:30:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>
Subject: [GIT FIXES FOR v4.2] Revert "[media] vb2: Push mmap_sem down to memops"
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge this revert asap. This patch introduces two serious regressions (first
noticed when testing the cobalt driver, later reproduced with the vivid driver).

This patch needs more work from Jan. Luckily I noticed in time and it should help
Jan that it is reproducible with vivid, so he does not need any hardware to test it.

Regards,

	Hans

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2o

for you to fetch changes up to 7d82ba199758c5de8e564b82579e4241d5b152c0:

  Revert "[media] vb2: Push mmap_sem down to memops" (2015-06-15 09:16:32 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      Revert "[media] vb2: Push mmap_sem down to memops"

 drivers/media/v4l2-core/videobuf2-core.c       | 2 ++
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 7 -------
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 6 ------
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 6 +-----
 4 files changed, 3 insertions(+), 18 deletions(-)
