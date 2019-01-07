Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30A5C43444
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD2D82089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfAGLev (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:51 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56887 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfAGLer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:47 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB7gNVGL; Mon, 07 Jan 2019 12:34:45 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Subject: [PATCHv6 0/8] vb2/cedrus: use timestamps to identify buffers
Date:   Mon,  7 Jan 2019 12:34:33 +0100
Message-Id: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfL7yrtaprygR5r3Y6+G/G6g5EWnu3yOv6gz2s0phEE2+inUfwGJyeCoBj6LREXXenpzUVoghw7H+rrR1kwa9Z5NAScEhOD8NZICiaVswZWE6EOdsudZo
 Bi5DNELkmDufrj/ZyMiwf9lzgX82bYC+Ph/sx2mZ0U59oQXtR7Be/157QCWr+5HS4ADFRJRTiUXKUQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

As was discussed here (among other places):

https://lkml.org/lkml/2018/10/19/440

using capture queue buffer indices to refer to reference frames is
not a good idea. 

Instead, after a long irc discussion:

https://linuxtv.org/irc/irclogger_log/v4l?date=2018-12-12,Wed

it was decided to use the timestamp in v4l2_buffer for this.

However, struct timeval cannot be used in a compound control since
the size of struct timeval differs between 32 and 64 bit architectures,
and there are also changes upcoming for y2038 support.

But internally the kernel converts the timeval to a u64 (nsecs since
boot). So we provide a helper function in videodev2.h that converts
the timeval to a u64, and that u64 can be used inside compound controls.

In the not too distant future we want to create a new struct v4l2_buffer,
and then we'll use u64 from the start, so in that case the helper function
would no longer be needed.

The first three patches add a new m2m helper function to correctly copy
the relevant data from an output buffer to a capture buffer. This will
simplify m2m drivers (in fact, many m2m drivers do not do this quite
right, so a helper function was really needed).

The fourth patch clears up messy timecode documentation that I came
across while working on this.

Patch 5 adds the new v4l2_timeval_to_ns helper function to videodev2.h.
The next patch adds the vb2_find_timestamp() function to find buffers
with a specific u64 timestamp.

Finally the cedrus driver and documentation are updated to use a
timestamp as buffer identifier.

I also removed the 'pad' fields from the mpeg2 control structs (it
should never been added in the first place) and aligned the structs
to a u32 boundary.

Regards,

        Hans

Changes since v5:

- fix broken v4l2_timeval_to_ns prototype (used u64 instead of __u64)
- rebased to 4.20-rc7
- dropped two unrelated chunks:

	@@ -32,7 +32,7 @@
	  *		&enum v4l2_field.
	  * @timecode:	frame timecode.
	  * @sequence:	sequence count of this frame.
	- * @request_fd:	the request_fd associated with this buffer
	+ * @request_fd:	the request_fd associated with this buffer.
	  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
	  *
	  * Should contain enough information to be able to cover all the fields

  and:

	@@ -460,7 +460,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
		b->flags = vbuf->flags;
		b->field = vbuf->field;
		b->timestamp = ns_to_timeval(vb->timestamp);
	-	b->timecode = vbuf->timecode;
	+	if (b->flags & V4L2_BUF_FLAG_TIMECODE)
	+		b->timecode = vbuf->timecode;
		b->sequence = vbuf->sequence;
		b->reserved2 = 0;
		b->request_fd = 0;

Hans Verkuil (8):
  v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
  vim2m: use v4l2_m2m_buf_copy_data
  vicodec: use v4l2_m2m_buf_copy_data
  buffer.rst: clean up timecode documentation
  videodev2.h: add v4l2_timeval_to_ns inline function
  vb2: add vb2_find_timestamp()
  cedrus: identify buffers by timestamp
  extended-controls.rst: update the mpeg2 compound controls

 Documentation/media/uapi/v4l/buffer.rst       | 11 ++++----
 .../media/uapi/v4l/extended-controls.rst      | 28 +++++++++++--------
 .../media/common/videobuf2/videobuf2-v4l2.c   | 19 ++++++++++++-
 drivers/media/platform/vicodec/vicodec-core.c | 12 +-------
 drivers/media/platform/vim2m.c                | 12 +-------
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ------
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 20 +++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 23 ++++++++-------
 include/media/mpeg2-ctrls.h                   | 14 ++++------
 include/media/v4l2-mem2mem.h                  | 20 +++++++++++++
 include/media/videobuf2-v4l2.h                | 17 +++++++++++
 include/uapi/linux/videodev2.h                | 12 ++++++++
 14 files changed, 135 insertions(+), 73 deletions(-)

-- 
2.19.2

