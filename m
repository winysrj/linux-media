Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2103 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDLPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 07:15:50 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id s74BFkfP005118
	for <linux-media@vger.kernel.org>; Mon, 4 Aug 2014 13:15:49 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8B9EE2A2651
	for <linux-media@vger.kernel.org>; Mon,  4 Aug 2014 13:15:41 +0200 (CEST)
Message-ID: <53DF6B5D.2090009@xs4all.nl>
Date: Mon, 04 Aug 2014 13:15:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] vb2 and docbook fixes for v3.17
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some last minute fixes for v3.17:

vb2:
	- two comment fixes/improvements
	- a fix for a BUG_ON due to a wrong GFP mask
	- a regression fix for a previous commit that introduced a
	  new problem in case start_streaming would fail.

docbook:
	- fix a typo in the description of struct v4l2_subdev_selection
	- update changelog and update version number to 3.17

Regards,

	Hans

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

  [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.17i

for you to fetch changes up to 884cb96a1719af9494cce8f660a4568417833c15:

  DocBook media: update version number and V4L2 changes (2014-08-04 13:11:22 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      videobuf2-dma-sg: fix for wrong GFP mask to sg_alloc_table_from_pages
      videobuf2-core: add comments before the WARN_ON
      videobuf2-core.h: fix comment
      vb2: fix vb2 state check when start_streaming fails
      DocBook media: fix fieldname in struct v4l2_subdev_selection
      DocBook media: update version number and V4L2 changes

 Documentation/DocBook/media/v4l/compat.xml                    | 24 ++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml                      | 11 ++++++-----
 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c                      | 29 ++++++++++++++++++++++-------
 drivers/media/v4l2-core/videobuf2-dma-sg.c                    |  2 +-
 include/media/videobuf2-core.h                                |  2 +-
 6 files changed, 55 insertions(+), 15 deletions(-)
