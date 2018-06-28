Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34026 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966093AbeF1NMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 09:12:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv4 00/10] media/mc: fix inconsistencies
Date: Thu, 28 Jun 2018 15:11:58 +0200
Message-Id: <20180628131208.28009-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This series is v4 of my previous attempt:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg132942.html

The goal is to fix the inconsistencies between the 'old' and 'new' 
MC API. I hate the terms 'old' and 'new', there is nothing wrong IMHO with 
using an 'old' API if it meets the needs of the application.

Making G_TOPOLOGY useful is urgently needed since I think that will be
very helpful for the work we want to do on library support for complex
cameras.

Changes since v3:

- Renamed MEDIA_ENT_F_DTV_ENCODER to MEDIA_ENT_F_DV_ENCODER
- Added a new patch renaming MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER.
- Added a new patch that reorders the function defines in media.h so that they
  are in increasing numerical order (the en/decoder functions where not in
  order).
- Added Sakari's Acks (except for the two new patches).

Regards,

	Hans

Hans Verkuil (10):
  media: add 'index' to struct media_v2_pad
  media-ioc-g-topology.rst: document new 'index' field
  media: add flags field to struct media_v2_entity
  media-ioc-g-topology.rst: document new 'flags' field
  media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
  media.h: add MEDIA_ENT_F_DV_ENCODER
  media.h: reorder video en/decoder functions
  ad9389b/adv7511: set proper media entity function
  adv7180/tvp514x/tvp7002: fix entity function
  media/i2c: add missing entity functions

 .../uapi/mediactl/media-ioc-g-topology.rst    | 21 ++++++++--
 .../media/uapi/mediactl/media-types.rst       |  9 ++++-
 drivers/media/i2c/ad9389b.c                   |  1 +
 drivers/media/i2c/adv7180.c                   |  2 +-
 drivers/media/i2c/adv7511.c                   |  1 +
 drivers/media/i2c/adv7604.c                   |  1 +
 drivers/media/i2c/adv7842.c                   |  1 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c      |  1 +
 drivers/media/i2c/mt9m032.c                   |  1 +
 drivers/media/i2c/mt9p031.c                   |  1 +
 drivers/media/i2c/mt9t001.c                   |  1 +
 drivers/media/i2c/mt9v032.c                   |  1 +
 drivers/media/i2c/tda1997x.c                  |  2 +-
 drivers/media/i2c/tvp514x.c                   |  2 +-
 drivers/media/i2c/tvp7002.c                   |  2 +-
 drivers/media/media-device.c                  |  2 +
 include/uapi/linux/media.h                    | 39 +++++++++++++++----
 17 files changed, 72 insertions(+), 16 deletions(-)

-- 
2.17.0
