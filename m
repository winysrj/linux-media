Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45210 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbeIIONx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 10:13:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guilherme Gallo <gagallo7@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes.
Message-ID: <609e3963-5d16-408e-6838-06b1fde60dce@xs4all.nl>
Date: Sun, 9 Sep 2018 11:24:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regarding the vicodec license change: I decided to stay with LGPL, I see no reason
to do a dual license GPL/LGPL scheme.

Regards,

	Hans

The following changes since commit d842a7cf938b6e0f8a1aa9f1aec0476c9a599310:

  media: adv7842: enable reduced fps detection (2018-08-31 10:03:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.20b

for you to fetch changes up to 9742fca52c4482e03f75e9e2117063b8e191d454:

  vidioc-cropcap/g-crop.rst: fix confusing sentence (2018-09-09 11:15:46 +0200)

----------------------------------------------------------------
Guilherme Gallo (1):
      media: vimc: implement basic v4l2-ctrls

Hans Verkuil (2):
      vicodec: change codec license to LGPL
      vidioc-cropcap/g-crop.rst: fix confusing sentence

 Documentation/media/uapi/v4l/vidioc-cropcap.rst  |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst   |  2 +-
 drivers/media/platform/vicodec/codec-fwht.c      |  2 +-
 drivers/media/platform/vicodec/codec-fwht.h      |  2 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c |  2 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.h |  2 +-
 drivers/media/platform/vimc/vimc-sensor.c        | 20 ++++++++++++++++++++
 7 files changed, 26 insertions(+), 6 deletions(-)
