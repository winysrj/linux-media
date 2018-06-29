Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52147 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936054AbeF2Lng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 07:43:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv5 00/12] media/mc: fix inconsistencies
Date: Fri, 29 Jun 2018 13:43:19 +0200
Message-Id: <20180629114331.7617-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This series is v5 of my previous attempt:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg133111.html

The goal is to fix the inconsistencies between the 'old' and 'new' 
MC API. I hate the terms 'old' and 'new', there is nothing wrong IMHO with 
using an 'old' API if it meets the needs of the application.

Making G_TOPOLOGY useful is urgently needed since I think that will be
very helpful for the work we want to do on library support for complex
cameras.

Changes since v4:

- Improve documentation of the new index field in patch 2.
- Added patch 11 to sync the index field documentation in media-ioc-enum-links.rst
  with the index field documentation from media-ioc-g-topology.rst.
- Added patch 12 that clarifies that you should not hardcode ID values
  in applications since they can change between instances of the device.
  Also document that the entity name is unique within the media topology.

Changes since v3:

- Renamed MEDIA_ENT_F_DTV_ENCODER to MEDIA_ENT_F_DV_ENCODER
- Added a new patch renaming MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER.
- Added a new patch that reorders the function defines in media.h so that they
  are in increasing numerical order (the en/decoder functions where not in
  order).
- Added Sakari's Acks (except for the two new patches).

Regards,

        Hans

Hans Verkuil (12):
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
  media-ioc-enum-links.rst: improve pad index description
  media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage

 .../uapi/mediactl/media-ioc-enum-entities.rst |  9 ++--
 .../uapi/mediactl/media-ioc-enum-links.rst    |  4 +-
 .../uapi/mediactl/media-ioc-g-topology.rst    | 42 +++++++++++++++----
 .../media/uapi/mediactl/media-types.rst       |  9 +++-
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
 include/uapi/linux/media.h                    | 39 +++++++++++++----
 19 files changed, 97 insertions(+), 25 deletions(-)

-- 
2.17.0
