Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51179 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751147AbeFUHTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 03:19:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/8] media/mc: fix inconsistencies
Date: Thu, 21 Jun 2018 09:19:06 +0200
Message-Id: <20180621071914.28729-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series sits on top of this pull request:

https://patchwork.linuxtv.org/patch/50453/

That pull request cleans up the tables in the documentation, making it
easier to add new entries.

This series is v3 of my previous attempt:

https://www.spinics.net/lists/linux-media/msg132218.html

The goal is to fix the inconsistencies between the 'old' and 'new' 
MC API. I hate the terms 'old' and 'new', there is nothing wrong IMHO with 
using an 'old' API if it meets the needs of the application.

The differences between v2 and v3 are that I changed that I changed
the defines that test if the index or flags fields are present:

/*
 * Appeared in 4.19.0.
 *
 * The media_version argument comes from the media_version field in
 * struct media_device_info.
 */
#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
       ((media_version) >= ((4 << 16) | (19 << 8) | 0))

KERNEL_VERSION cannot be used in a public header, and my previous
attempt used 0x00041300, which isn't as readable as what I do now.
I also expanded the comment before the define pointing to struct
media_device_info. I also did the same in the documentation.

I dropped the patches adding a function field to struct media_entity_desc.
Instead I started the work to ensure all drivers set function correctly.

I still want to add a 'function' field to struct media_entity_desc but
step one is to make sure drivers actually set function correctly. I'll
revisit this once that's done.

Making G_TOPOLOGY useful is urgently needed since I think that will be
very helpful for the work we want to do on library support for complex
cameras.

Regards,

	Hans

Hans Verkuil (8):
  media: add 'index' to struct media_v2_pad
  media-ioc-g-topology.rst: document new 'index' field
  media: add flags field to struct media_v2_entity
  media-ioc-g-topology.rst: document new 'flags' field
  media.h: add MEDIA_ENT_F_DTV_ENCODER
  ad9389b/adv7511: set proper media entity function
  adv7180/tvp514x/tvp7002: fix entity function
  media/i2c: add missing entity functions

 .../uapi/mediactl/media-ioc-g-topology.rst    | 21 ++++++++++++---
 .../media/uapi/mediactl/media-types.rst       |  7 +++++
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
 drivers/media/i2c/tvp514x.c                   |  2 +-
 drivers/media/i2c/tvp7002.c                   |  2 +-
 drivers/media/media-device.c                  |  2 ++
 include/uapi/linux/media.h                    | 27 ++++++++++++++++---
 16 files changed, 63 insertions(+), 9 deletions(-)

-- 
2.17.0
