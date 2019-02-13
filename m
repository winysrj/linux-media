Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED570C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 14:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48E0222B5
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 14:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfBMOQU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:16:20 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49503 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729327AbfBMOQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 09:16:20 -0500
Received: from [IPv6:2001:420:44c1:2579:4ccb:9a9e:f164:d84f] ([IPv6:2001:420:44c1:2579:4ccb:9a9e:f164:d84f])
        by smtp-cloud9.xs4all.net with ESMTPA
        id tvKggSrzLI8AWtvKjgvhmJ; Wed, 13 Feb 2019 15:16:17 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Vivek Kasireddy <vivek.kasireddy@intel.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes and enhancements
Message-ID: <55f4130b-29a3-f2cf-bf2a-2648803c4454@xs4all.nl>
Date:   Wed, 13 Feb 2019 15:16:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBmFBtci2zlEOoE7iQ7Ghdmf3r0AtYBiSThfEmmJMLd3cP9/zyH39vogIKN3l82MWJiNQQMB1ArNz9dqZ1O5OQLqWLHcilpOuQ8Giv/uElzxxzjP7VFj
 j8qNB3x39xQlr44TwDtTactzm9plcn0V6Gc9WoCEVAkI6zWvaxcLOkI9P/oDhIpvCgqRwClfy6UPJL2RYguy95gjNCGWwq1Cy6qmHHVyqjCJQZd5vZwDAON/
 gF6AIoDpQCtAx+fqCqEulOtYLVgohvtgb88JRMdlvZd2sXf7F75UlJ5rrpYFBMTLJVs1zJ5iWeSAj+H9yrY2haLDpNHjBaDooI7fZVSp/o0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main addition is adding proper packed 32-bit YUV support and fixing epoll
support.

This supersedes https://patchwork.linuxtv.org/patch/54450/:

The vsp1 patch is dropped (will go through Laurent's repo) and
the epoll and vb2 bitfield patches were added.

Regards,

	Hans

The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1o2

for you to fetch changes up to f02795c61c21b5bc522d0e14f510e0f9ae0084cc:

  dvb-core: fix epoll() by calling poll_wait first (2019-02-13 13:59:21 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (11):
      extended-controls.rst: split up per control class
      vb2: replace bool by bitfield in vb2_buffer
      vb2: keep track of timestamp status
      cec: fix epoll() by calling poll_wait first
      media-request: fix epoll() by calling poll_wait first
      vb2: fix epoll() by calling poll_wait first
      v4l2-ctrls.c: fix epoll() by calling poll_wait first
      v4l2-mem2mem: fix epoll() by calling poll_wait first
      v4l2-mem2mem: add q->error check to v4l2_m2m_poll()
      videobuf: fix epoll() by calling poll_wait first
      dvb-core: fix epoll() by calling poll_wait first

Vivek Kasireddy (4):
      media: v4l: Add 32-bit packed YUV formats
      media: v4l2-tpg-core: Add support for 32-bit packed YUV formats (v2)
      media: vivid: Add definitions for the 32-bit packed YUV formats
      media: imx-pxp: Start using the format VUYA32 instead of YUV32 (v2)

 Documentation/media/uapi/v4l/common.rst                  |   11 +
 Documentation/media/uapi/v4l/ext-ctrls-camera.rst        |  508 ++++++++++
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst         | 2451 ++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/ext-ctrls-detect.rst        |   71 ++
 Documentation/media/uapi/v4l/ext-ctrls-dv.rst            |  166 ++++
 Documentation/media/uapi/v4l/ext-ctrls-flash.rst         |  192 ++++
 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst         |   95 ++
 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst         |  188 ++++
 Documentation/media/uapi/v4l/ext-ctrls-image-process.rst |   63 ++
 Documentation/media/uapi/v4l/ext-ctrls-image-source.rst  |   57 ++
 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst          |  113 +++
 Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst      |   96 ++
 Documentation/media/uapi/v4l/extended-controls.rst       | 3920 +----------------------------------------------------------------------------
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst       |  170 +++-
 drivers/media/cec/cec-api.c                              |    2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c            |   12 +
 drivers/media/common/videobuf2/videobuf2-core.c          |   19 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c          |    7 +-
 drivers/media/dvb-core/dmxdev.c                          |    8 +-
 drivers/media/dvb-core/dvb_ca_en50221.c                  |    5 +-
 drivers/media/media-request.c                            |    3 +-
 drivers/media/platform/imx-pxp.c                         |   14 +-
 drivers/media/platform/vivid/vivid-vid-common.c          |   30 +
 drivers/media/v4l2-core/v4l2-ctrls.c                     |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                     |    4 +
 drivers/media/v4l2-core/v4l2-mem2mem.c                   |   26 +-
 drivers/media/v4l2-core/videobuf-core.c                  |    6 +-
 include/media/videobuf2-core.h                           |    7 +-
 include/uapi/linux/videodev2.h                           |    4 +
 29 files changed, 4286 insertions(+), 3964 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-camera.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-codec.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-detect.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-dv.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-flash.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-process.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-source.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst
