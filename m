Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CE0C6783B
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777532084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 12:39:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 777532084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbeLLMjH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:39:07 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47143 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbeLLMjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 07:39:06 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X3n3gidc5uDWoX3n4gHoVh; Wed, 12 Dec 2018 13:39:03 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Subject: [PATCHv5 0/8] vb2/cedrus: use timestamps to identify buffers
Date:   Wed, 12 Dec 2018 13:38:53 +0100
Message-Id: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfN97++QiIjZz15hgZiW1mXVKIdnjO9YeAGtvu8dNZmRl09Pb8XpjmjxcWWqW2njD0rE9MWrN10Rv8SW4aa7smzM9/P1ZQ5ki/M4thQYSlNGtaWBUzZRV
 xYkLM05CQWz5rZppVsQHFoo5GYcLVdJdHO8rGj60ml/k+tmMPfdEHjwpbDWHNMypE4k+UWwWMujVf0CnSxx6t7CbMeKbGa4eXH3hSNtlUm7ZrxWsyj7OSu2j
 izpqCT7gc12x+KWgP/6HVhkjFoHaGYxFrgI5VzjAY2yswAxKhnHT4/D0NNtLV4fw3wdS9ZmgDbtvDQLXdFRdgShfvbwqseX5uFUy2SebsQmVYuWN68MRaL3l
 9gvZiqABs6CJkBLYGSCDZ9JuVBsJ1DSaZAfYpAWmutNfqtPZdb6Fndm0KloKUNOJv34aW/6v
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

Please note that this patch series will have to be updated one more
time when pending 4.20 fixes are merged back into our master since
those patches will move the cedrus mpeg controls to a different header.

Regards,

        Hans

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
 .../media/common/videobuf2/videobuf2-v4l2.c   | 22 +++++++++++++--
 drivers/media/platform/vicodec/vicodec-core.c | 12 +-------
 drivers/media/platform/vim2m.c                | 12 +-------
 drivers/media/v4l2-core/v4l2-ctrls.c          |  9 ------
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 20 +++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  9 ++++--
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  2 ++
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 21 ++++++--------
 include/media/v4l2-mem2mem.h                  | 20 +++++++++++++
 include/media/videobuf2-v4l2.h                | 19 ++++++++++++-
 include/uapi/linux/v4l2-controls.h            | 14 ++++------
 include/uapi/linux/videodev2.h                | 12 ++++++++
 14 files changed, 136 insertions(+), 75 deletions(-)

-- 
2.19.2

