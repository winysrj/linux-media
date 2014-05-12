Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1268 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaELKLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 06:11:46 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s4CABgTP022696
	for <linux-media@vger.kernel.org>; Mon, 12 May 2014 12:11:44 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0CBBF2A19A4
	for <linux-media@vger.kernel.org>; Mon, 12 May 2014 12:11:32 +0200 (CEST)
Message-ID: <53709E53.4060604@xs4all.nl>
Date: Mon, 12 May 2014 12:11:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] More fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some more small fixes.

Regards,

	Hans

The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16e

for you to fetch changes up to 6451fb2f7fdd73edb4cdd47d4ea14d0aec57ab95:

  vb2: fix num_buffers calculation if req->count > VIDEO_MAX_FRAMES (2014-05-12 10:55:26 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-ioctl: drop spurious newline in string

Laurent Pinchart (1):
      v4l: vb2: Avoid double WARN_ON when stopping streaming

Philipp Zabel (1):
      vb2: fix num_buffers calculation if req->count > VIDEO_MAX_FRAMES

 drivers/media/v4l2-core/v4l2-ioctl.c     | 2 +-
 drivers/media/v4l2-core/videobuf2-core.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)
