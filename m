Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60306 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726570AbeIMR7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:59:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/4] cec/v4l2: move v4l2-specific functions from cec to v4l2
Date: Thu, 13 Sep 2018 14:49:40 +0200
Message-Id: <20180913124944.39863-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Several cec functions that deal with parsing EDIDs and handling physical
addresses where stubbed out if CEC_CORE was not configured. The problem
with that is that those functions are needed, regardless of CEC, by
receivers to validate the EDID.

This patch series moves those functions out of the cec subsystem into
the media subsystem: this only affects HDMI receivers, so the media
subsystem is a much better place.

This problem was reported by Lars-Peter Clausen.

Regards,

	Hans

Hans Verkuil (4):
  cec: make cec_get_edid_spa_location() an inline function
  cec: integrate cec_validate_phys_addr() in cec-api.c
  cec/v4l2: move V4L2 specific CEC functions to V4L2
  cec: remove cec-edid.c

 drivers/media/cec/Makefile                    |   2 +-
 drivers/media/cec/cec-adap.c                  |  13 ++
 drivers/media/cec/cec-api.c                   |  19 ++-
 drivers/media/cec/cec-edid.c                  | 155 ------------------
 drivers/media/i2c/adv7604.c                   |   4 +-
 drivers/media/i2c/adv7842.c                   |   4 +-
 drivers/media/i2c/tc358743.c                  |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  |   4 +-
 .../media/platform/vivid/vivid-vid-common.c   |   2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 151 +++++++++++++++++
 include/media/cec.h                           | 150 ++++++++---------
 include/media/v4l2-dv-timings.h               |   6 +
 12 files changed, 267 insertions(+), 245 deletions(-)
 delete mode 100644 drivers/media/cec/cec-edid.c

-- 
2.18.0
