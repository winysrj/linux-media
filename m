Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082B8C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50882184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfCTOmD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:42:03 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38992 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbfCTOmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:42:03 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6cPnhdnXVeXb86cPohCvqH; Wed, 20 Mar 2019 15:42:00 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Helen Koike <helen.koike@collabora.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [GIT PULL FOR v5.2] vicodec: support the stateless decoder
Message-ID: <d8b53a00-b786-22e8-1e4d-3a88c75225e8@xs4all.nl>
Date:   Wed, 20 Mar 2019 15:41:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAkaBDHaaJY0guGeGJKbmgUVYAdJmCBwNcwLbYv56uJYqBPTz74kWWP5Ek+SauTBSpKQtgDUtaEmSfkGMfeDX2noUNxshO0+efOGeCuqtyFSDjMxwr1k
 GxEzV6a2kgi23+o3EjK0VAzBWb6twiGwaA8yZAHfpqQSRZqmZ5PKvNchRpBhw7g1tsQ+PGci0o1fBpE4KUxOFygYkzMF4hJnaFbgSIQHdYSO8q2KjY/uXkzh
 vBsUQnNA01WKWlQXHIneNKnJhsV+nkA1nENpK1EPzjxJ92UOdUCTxrBGQTpV9792UGwtL9zSsixYCJErP9D2MkERaOTCfQW+XZQyxGGZrrlyf7DyEbVdsINu
 HWTujFu4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

This series adds support for a stateless decoder to vicodec.

Patches 1-3 add support for the vb2 requires_requests flag and return EBADR
instead of EACCES when requests are used when they shouldn't or vice versa.

Patches 4-17 fix bugs and prepare vicodec for adding the stateless decoder.

Patches 18-20 document the new stateless FWHT pixelformat and the vicodec
controls. Patch 21-22 adds the core support for these new controls/pixelformat.

And finally, patches 23-25 add the actual stateless decoder.

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

Changes since the previous pull request:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg145727.html

- Rebased (this dropped the first two patches of the previous pull request since
  those were merged)
- Patches 3-5 of the previous pull request are replaced by:

https://patchwork.linuxtv.org/patch/55159/
https://patchwork.linuxtv.org/patch/55160/
https://patchwork.linuxtv.org/patch/55162/

- All other patches are unchanged.


The following changes since commit 8a3946cad244e8453e26f3ded5fe40bf2627bb30:

  media: v4l2-fwnode: Add a deprecation note in the old ACPI parsing example (2019-03-20 06:37:55 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.2e

for you to fetch changes up to a3e73dfbba99f0c7ebef9c4ffeb03a491df3b172:

  media: vicodec: set pixelformat to V4L2_PIX_FMT_FWHT_STATELESS for stateless decoder (2019-03-20 15:32:33 +0100)

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

Hans Verkuil (5):
      vb2: add requires_requests bit for stateless codecs
      cedrus: set requires_requests
      media requests: return EBADR instead of EACCES
      vicodec: fix g_selection: either handle crop or compose
      v4l2-ioctl.c: add V4L2_PIX_FMT_FWHT_STATELESS to v4l_fill_fmtdesc

 Documentation/media/uapi/mediactl/request-api.rst  |   2 +-
 Documentation/media/uapi/v4l/buffer.rst            |   2 +-
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 130 +++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |   6 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  10 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   9 +
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   6 +-
 drivers/media/media-request.c                      |   4 +-
 drivers/media/platform/vicodec/codec-fwht.c        |  92 ++++---
 drivers/media/platform/vicodec/codec-fwht.h        |  12 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   | 431 +++++++++---------------------
 drivers/media/platform/vicodec/codec-v4l2-fwht.h   |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c      | 750 +++++++++++++++++++++++++++++++++++++---------------
 drivers/media/v4l2-core/v4l2-ctrls.c               |  30 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   1 +
 include/media/fwht-ctrls.h                         |  31 +++
 include/media/media-request.h                      |   4 +-
 include/media/v4l2-ctrls.h                         |   7 +-
 include/media/videobuf2-core.h                     |   3 +
 include/uapi/linux/v4l2-controls.h                 |   4 +
 include/uapi/linux/videodev2.h                     |   1 +
 22 files changed, 968 insertions(+), 575 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h
