Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DEEC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125CA2146F
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfBKJSV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:18:21 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56785 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfBKJSV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 04:18:21 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t7jEgrcjwRO5Zt7jHg2zBb; Mon, 11 Feb 2019 10:18:19 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/3] vb2: add requires_requests bitfield
Date:   Mon, 11 Feb 2019 10:18:13 +0100
Message-Id: <20190211091816.33022-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDT1aW5apAls7ohdba4iGqhxs2pHVmBPRRU01l4vcl8O+BgnaKVYkY73+wjqAUrtD0RwOCFugosN88EC/PbMfcGjtw3oINaTD1MauOZ5Z0YLuenXu939
 4RwkofVX2bBa6oE6a11Ab31VqRAtHCo5fR/8wqErfGfD2jyV+FRxnCob6P8jlG0I7O8Y5tK/NCKzSAmIGKDSst/NC6mevV5hvaKBvdu9OjX03PQ5D1IlFqJG
 Z7/OHr7bCWbSEUwmdzkvZjp+a+EmRc7ssCoR41ynZXz6VRaDHT9k6nAmKxWZxpfk
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently the supports_requests bitfield only indicates if the
Request API is supported by the vb2_queue. But for stateless
codecs the use of the Request API is actually a requirement.

So add a requires_requests bitfield and corresponding capability
to indicate that userspace has to use requests. And of course
reject direct VIDIOC_QBUF calls (i.e. V4L2_BUF_FLAG_REQUEST_FD
isn't set) if requires_requests is set.

Finally set this bitfield in the cedrus driver.

Regards,

	Hans

Hans Verkuil (3):
  vb2: add requires_requests bit for stateless codecs
  videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
  cedrus: set requires_requests

 Documentation/media/uapi/v4l/vidioc-reqbufs.rst   | 4 ++++
 drivers/media/common/videobuf2/videobuf2-core.c   | 5 ++++-
 drivers/media/common/videobuf2/videobuf2-v4l2.c   | 6 ++++++
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 include/media/videobuf2-core.h                    | 3 +++
 include/uapi/linux/videodev2.h                    | 1 +
 6 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.20.1

