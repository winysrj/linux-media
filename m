Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A495C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31ACD206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:20:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31ACD206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbeLEKUt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:20:49 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48137 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbeLEKUt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:20:49 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id UUIKgznz1aOW5UUIOgJegk; Wed, 05 Dec 2018 11:20:46 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com
Subject: [PATCHv4 00/10] As was discussed here (among other places):
Date:   Wed,  5 Dec 2018 11:20:30 +0100
Message-Id: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOfCknyIwxWeCBN9byJtboXx6sDdBQKUboebb2bpqWMhuSMDvb4h2KEgZBVGQShfqktSWz0Z1Ai+i0OglG3Gbqv1Lg1qntOEsnQgl6ohR1ZV5ZbKGNTO
 OSKfqm3n9vkuZhN8WCtwVP9qURwfzxEka0OW9iLi4KCS2dL1OvgQo708AKA8asZsXeTHF16z0BlK0VpXB7RBJ2zxgQg9Zuq/VulTc9c34BLdurtb+qTkQk7M
 R9yfqooIaaEOedBpOnenXoHbjod0XXKeFFMq3EXfBobQZJkJJ3VXm5lQafpuUcux9wjpCwXpWSFQw57AFZkYQCuIT6HxM+NROZO2ETDOmyGxKNBB3HMV44cr
 5R2ZLhwKDH+b9z9Mpod0bS+c3PqAIrsftK24s/YxmqhYRwgzfBCIs0UD64E4J4lPAptEL2Fx
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. A better idea is to use a 'tag' where the
application can assign a u32 tag to an output buffer, which is then 
copied to the capture buffer(s) derived from the output buffer.

It has been suggested that the timestamp can be used for this. But
there are a number of reasons why this is a bad idea:

1) the struct timeval is converted to a u64 in vb2. So there can be
   all sorts of unexpected conversion issues. In particular, the
   output of ns_to_timeval(timeval_to_ns(tv)) does not necessarily
   match the input.

2) it gets worse with the y2038 code where userspace either deals
   with a 32 bit tv_sec value or a 64 bit value.

In other words, using timestamp for this is not a good idea.

This implementation adds a new tag field in a union with the reserved2
field. The interpretation of that union depends on the flags field, so
it still can be used for other things as well. In addition, in the previous
patches the tag was in a union with the timecode field (again determined
by the flags field), so if we need to cram additional information in this
struct we can always put it in a union with the timecode field as well.
It worked for the tag, it should work for other things.

But we really need to start looking at a struct v4l2_ext_buffer.

The first three patches add core tag support, the next two patches document
the tag support, then a new helper function is added to v4l2-mem2mem.c
to easily copy data from a source to a destination buffer that drivers
can use.

Next a new supports_tags vb2_queue flag is added to indicate that
the driver supports tags. Ideally this should not be necessary, but
that would require that all m2m drivers are converted to using the
new helper function introduced in the previous patch. That takes more
time then I have now.

Finally the vim2m, vicodec and cedrus drivers are converted to support
tags.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary.

Note that this might change further (Paul suggested using bitfields).

Also note that the cedrus code doesn't set the sequence counter, that's
something that should still be added before this driver can be moved
out of staging.

Note: if no buffer is found for a certain tag, then the dma address
is just set to 0. That happened before as well with invalid buffer
indices. This should be checked in the driver!

Regards,

        Hans

Changes since v3:

- use reserved2 for the tag
- split the documentation in two: one documenting the tag, one
  cleaning up the timecode documentation.

Changes since v2:

- rebased
- added Reviewed-by tags
- fixed a few remaining references in the documentation to the old
  v4l2_buffer_tag struct that was used in early versions of this
  series.

Changes since v1:

- changed to a u32 tag. Using a 64 bit tag was overly complicated due
  to the bad layout of the v4l2_buffer struct, and there is no real
  need for it by applications.

Main changes since the RFC:

- Added new buffer capability flag
- Added m2m helper to copy data between buffers
- Added documentation
- Added tag logging in v4l2-ioctl.c


Hans Verkuil (10):
  videodev2.h: add tag support
  vb2: add tag support
  v4l2-ioctl.c: log v4l2_buffer tag
  buffer.rst: document the new buffer tag feature.
  buffer.rst: clean up timecode documentation
  v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
  vb2: add new supports_tags queue flag
  vim2m: add tag support
  vicodec: add tag support
  cedrus: add tag support

 Documentation/media/uapi/v4l/buffer.rst       | 28 +++++++++----
 .../media/uapi/v4l/vidioc-reqbufs.rst         |  4 ++
 .../media/common/videobuf2/videobuf2-v4l2.c   | 41 ++++++++++++++++---
 drivers/media/platform/vicodec/vicodec-core.c | 14 ++-----
 drivers/media/platform/vim2m.c                | 14 ++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ----
 drivers/media/v4l2-core/v4l2-ioctl.c          |  9 ++--
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 +++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++------
 .../staging/media/sunxi/cedrus/cedrus_video.c |  2 +
 include/media/v4l2-mem2mem.h                  | 21 ++++++++++
 include/media/videobuf2-core.h                |  2 +
 include/media/videobuf2-v4l2.h                | 21 +++++++++-
 include/uapi/linux/v4l2-controls.h            | 14 +++----
 include/uapi/linux/videodev2.h                |  9 +++-
 17 files changed, 168 insertions(+), 75 deletions(-)

-- 
2.19.1

