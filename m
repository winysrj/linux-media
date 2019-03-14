Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D875AC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE1D721019
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 08:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfCNIEa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:04:30 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:33769 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbfCNIEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 04:04:30 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 4LLkhps4WLMwI4LLnhHjXN; Thu, 14 Mar 2019 09:04:27 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.2] vicodec: support the stateless decoder
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
Cc:     Helen Koike <helen.koike@collabora.com>
Message-ID: <147cd6cd-d5be-a183-ebb6-c6be03f71163@xs4all.nl>
Date:   Thu, 14 Mar 2019 09:04:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO5EoiAQH7EoP1ZBmVNqlAunO0SXWXm1H8BWLUf/STap7uXY+HJ79KyFexRUfJfO+xDgE7V6+K4gmnAG8xw54jwC4cZxOztGB/ViDwC9D2nSYg2jazMz
 lfUPRdBf4EdN+sDM35L91s9Wjb8LL6O3htJglot7Q90oiY+PvaODPi1gG/0pXNIFcCsq5wggF4msi8m2RNHnHI4jY+h2TCKLpQgJ1tqhg4KZcMaqe5Tdsx93
 zFHpKI2Mvqa3UU8TtM5MEw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

This series adds support for a stateless decoder to vicodec.

The first two patches are to vicodec bug fixes.

Patches 3-5 add the V4L2_BUF_CAP_REQUIRES_REQUESTS flag: this will be used
for stateless codecs that require the use of requests.

Patches 6-19 fix bugs and prepare vicodec for adding the stateless decoder.

Patches 20-22 document the new stateless FWHT pixelformat and the vicodec
controls. Patch 23-24 adds the core support for these new controls/pixelformat.

And finally, patches 25-27 add the actual stateless decoder.

Note that since the stateless codec spec isn't finalized yet, the fwht state
control is defined in media/fwht-ctrls.h instead of v4l2-controls.h. Once the
stateless codec spec is accepted, and once a stateless encoder has been added
as well, then this can be moved to v4l2-controls.h.

This work was done by Dafna Hirschfeld as the second part of her Outreachy project.
The first part was fixing the vicodec stateful codec so it was in line with the
proposed stateful codec specification, and that code has been merged already.

I would like to thank Dafna for her work on this, it is very much appreciated!

Regards,

	Hans

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.2d

for you to fetch changes up to a020eb7110b75adf4d6d21603bd56cdbb413047e:

  media: vicodec: set pixelformat to V4L2_PIX_FMT_FWHT_STATELESS for stateless decoder (2019-03-13 16:12:25 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Dafna Hirschfeld (20):
      media: vicodec: selection api should only check single buffer types
      media: vicodec: upon release, call m2m release before freeing ctrl handler
      media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
      media: vicodec: change variable name for the return value of v4l2_fwht_encode
      media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if decoding fails
      media: vicodec: bugfix: free compressed_frame upon device release
      media: vicodec: Move raw frame preparation code to a function
      media: vicodec: add field 'buf' to fwht_raw_frame
      media: vicodec: keep the ref frame according to the format in decoder
      media: vicodec: Validate version dependent header values in a separate function
      media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
      media: vicodec: Handle the case that the reference buffer is NULL
      media: vicodec: add struct for encoder/decoder instance
      media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
      media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
      media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
      media: vicodec: Introducing stateless fwht defs and structs
      media: vicodec: Register another node for stateless decoder
      media: vicodec: Add support for stateless decoder.
      media: vicodec: set pixelformat to V4L2_PIX_FMT_FWHT_STATELESS for stateless decoder

Hans Verkuil (7):
      vicodec: remove WARN_ON(1) from get_q_data()
      vicodec: reset last_src/dst_buf based on the IS_OUTPUT
      videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
      vb2: add requires_requests bit for stateless codecs
      cedrus: set requires_requests
      vicodec: fix g_selection: either handle crop or compose
      v4l2-ioctl.c: add V4L2_PIX_FMT_FWHT_STATELESS to v4l_fill_fmtdesc

 Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 130 +++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |   6 +
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   4 +
 drivers/media/common/videobuf2/videobuf2-core.c    |   5 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   6 +
 drivers/media/platform/vicodec/codec-fwht.c        |  92 +++---
 drivers/media/platform/vicodec/codec-fwht.h        |  12 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   | 431 +++++++++-------------------
 drivers/media/platform/vicodec/codec-v4l2-fwht.h   |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c      | 758 +++++++++++++++++++++++++++++++++++--------------
 drivers/media/v4l2-core/v4l2-ctrls.c               |  30 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   1 +
 include/media/fwht-ctrls.h                         |  31 ++
 include/media/v4l2-ctrls.h                         |   7 +-
 include/media/videobuf2-core.h                     |   3 +
 include/uapi/linux/v4l2-controls.h                 |   4 +
 include/uapi/linux/videodev2.h                     |   2 +
 18 files changed, 962 insertions(+), 568 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h
