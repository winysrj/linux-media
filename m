Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759C8C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434AB20838
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfBKKOC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:14:02 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44868 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfBKKOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:14:02 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8b7gs8zWRO5Zt8bAg3Gn7; Mon, 11 Feb 2019 11:14:00 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCHv2 0/6] vb2/v4l2-ctrls: check if requests are required
Date:   Mon, 11 Feb 2019 11:13:51 +0100
Message-Id: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNRGBHM9Ix86ag92NrY8IVmxjtldnYwJqdalxYQhwBA7/ZqPaGeQT15a6m5Bdd8UQ5KZbjRVm3r/kigJ2jw0iO2vJPQvRrHwLalX22qjz4Llo22z4hdl
 dobOQrkoPrtBoVY4u8UVQMh+nqRmAgaktp/WWAshjqp9Gq3eXzXtaYEjypEUk8pGZaOzEId9iPVfc1mrvu7ytvBPvXZOrxBwXVCk0MXUK8qLtU3gWsE3aZhI
 2Bub7vhZk/pC8i2t4Ga5s+hz1YCFq6elqNlqfj55JmlXb4SmCTL/BOhFN5rWdhhu
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently the vb2 supports_requests bitfield only indicates if the
Request API is supported by the vb2_queue. But for stateless
codecs the use of the Request API is actually a requirement.

So add a requires_requests bitfield and corresponding capability
to indicate that userspace has to use requests. And of course
reject direct VIDIOC_QBUF calls (i.e. V4L2_BUF_FLAG_REQUEST_FD
isn't set) if requires_requests is set.

Finally set this bitfield in the cedrus driver.

Do the same for controls: it makes no sense to set state controls
for stateless codecs directly without going through a request.
Add a new flag to indicate this and check it.

Regards,

	Hans

Hans Verkuil (6):
  vb2: add requires_requests bit for stateless codecs
  videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
  cedrus: set requires_requests
  videodev2.h: add V4L2_CTRL_FLAG_REQUIRES_REQUESTS
  v4l2-ctrls: check for REQUIRES_REQUESTS flag
  v4l2-ctrls: mark MPEG2 stateless controls as REQUIRES_REQUESTS

 .../media/uapi/v4l/vidioc-queryctrl.rst       |  4 ++++
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++++
 .../media/videodev2.h.rst.exceptions          |  1 +
 .../media/common/videobuf2/videobuf2-core.c   |  5 +++-
 .../media/common/videobuf2/videobuf2-v4l2.c   |  6 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c          |  5 ++++
 .../staging/media/sunxi/cedrus/cedrus_video.c |  1 +
 include/media/videobuf2-core.h                |  3 +++
 include/uapi/linux/videodev2.h                | 24 ++++++++++---------
 9 files changed, 41 insertions(+), 12 deletions(-)

-- 
2.20.1

