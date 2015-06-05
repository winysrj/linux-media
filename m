Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:32841 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbbFEILa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 04:11:30 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C7D032A0085
	for <linux-media@vger.kernel.org>; Fri,  5 Jun 2015 10:11:16 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] Reserved field handling fixes
Date: Fri,  5 Jun 2015 10:11:13 +0200
Message-Id: <1433491875-42608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

VIDIOC_CREATE_BUFS didn't clear the reserved field in the kernel.

Update the documentation so that it is in sync with what v4l2-compliance
checks and what valgrind checks.

Hans Verkuil (2):
  v4l2-ioctl: clear the reserved field of v4l2_create_buffers
  DocBook media: correct description of reserved fields

 Documentation/DocBook/media/v4l/io.xml                       | 12 ++++++------
 Documentation/DocBook/media/v4l/pixfmt.xml                   |  8 ++++----
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml       |  3 ++-
 .../DocBook/media/v4l/vidioc-enum-frameintervals.xml         |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml   |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml            |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml       |  2 +-
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml          |  3 ++-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml           |  4 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c                         |  2 ++
 10 files changed, 25 insertions(+), 18 deletions(-)

-- 
2.1.4

