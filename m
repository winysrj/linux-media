Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:24006 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2JDKxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 06:53:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] Some videobuf2 multiplanar fixes
Date: Thu, 4 Oct 2012 12:52:56 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041252.56172.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a bunch of vb2 fixes for the vb2 multiplanar support.

It's unchanged from my RFCv2: http://www.spinics.net/lists/linux-media/msg54123.html
except for being rebased.

Regards,

	Hans

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx (2012-10-02 17:15:22 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2

for you to fetch changes up to 509de2634fef1755b8ed862bb323f00dc53520a9:

  DocBook: various updates w.r.t. v4l2_buffer and multiplanar. (2012-10-04 12:49:43 +0200)

----------------------------------------------------------------
Hans Verkuil (4):
      videobuf2-core: move plane verification out of __fill_v4l2/vb_buffer.
      videobuf2-core: fill in length field for multiplanar buffers.
      v4l2-ioctl.c: handle PREPARE_BUF like QUERYBUF.
      DocBook: various updates w.r.t. v4l2_buffer and multiplanar.

 Documentation/DocBook/media/v4l/io.xml              |    6 ++--
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml     |    3 +-
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml |   11 ++++---
 drivers/media/v4l2-core/v4l2-ioctl.c                |    1 +
 drivers/media/v4l2-core/videobuf2-core.c            |   79 +++++++++++++++++++++++++--------------------------
 5 files changed, 52 insertions(+), 48 deletions(-)
