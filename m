Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37091 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbeIARSS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 13:18:18 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes/enhancements
Message-ID: <d175c470-80b2-0d23-39d0-cb4f889b4d07@xs4all.nl>
Date: Sat, 1 Sep 2018 15:06:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.20a

for you to fetch changes up to 8ce385273afa4ce9f48e26ed6a7811bf678137ed:

  vicodec: fix sparse warning (2018-09-01 14:59:20 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      mediactl/*.rst: document argp
      v4l2-tpg: show either Y'CbCr or HSV encoding
      v4l2-tpg: add Z16 support
      cec-func-poll.rst/func-poll.rst: update EINVAL description
      vicodec: fix wrong sizeimage
      videodev2.h.rst.exceptions: add V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
      vicodec: fix sparse warning

 Documentation/media/uapi/cec/cec-func-poll.rst                |  3 ++-
 Documentation/media/uapi/mediactl/media-ioc-device-info.rst   |  1 +
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst |  1 +
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    |  1 +
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    |  1 +
 Documentation/media/uapi/mediactl/media-ioc-setup-link.rst    |  1 +
 Documentation/media/uapi/v4l/func-poll.rst                    |  3 ++-
 Documentation/media/videodev2.h.rst.exceptions                |  1 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c                 | 11 +++++++++--
 drivers/media/platform/vicodec/vicodec-core.c                 | 18 +++++++++++-------
 10 files changed, 30 insertions(+), 11 deletions(-)
