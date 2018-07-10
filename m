Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52724 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751153AbeGJIqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:46:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] media/mc: fix inconsistencies
Message-ID: <fe3bc5a2-7231-b434-5e22-1c72f6c87c51@xs4all.nl>
Date: Tue, 10 Jul 2018 10:46:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the pull request of v6 of my patch series to fix the mc inconsistencies.

Regards,

	Hans

The following changes since commit 666e994aa2278e948e2492ee9d81b4df241e7222:

  media: platform: s5p-mfc: simplify getting .drvdata (2018-07-04 11:45:40 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git media-missing2

for you to fetch changes up to 607488f06efa4e87be5eb229759105d990f7df18:

  media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage (2018-07-10 10:40:19 +0200)

----------------------------------------------------------------
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

 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst |  9 ++++++---
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    |  4 +++-
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 42 ++++++++++++++++++++++++++++++++++--------
 Documentation/media/uapi/mediactl/media-types.rst             |  9 ++++++++-
 drivers/media/i2c/ad9389b.c                                   |  1 +
 drivers/media/i2c/adv7180.c                                   |  2 +-
 drivers/media/i2c/adv7511.c                                   |  1 +
 drivers/media/i2c/adv7604.c                                   |  1 +
 drivers/media/i2c/adv7842.c                                   |  1 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c                      |  1 +
 drivers/media/i2c/mt9m032.c                                   |  1 +
 drivers/media/i2c/mt9p031.c                                   |  1 +
 drivers/media/i2c/mt9t001.c                                   |  1 +
 drivers/media/i2c/mt9v032.c                                   |  1 +
 drivers/media/i2c/tda1997x.c                                  |  2 +-
 drivers/media/i2c/tvp514x.c                                   |  2 +-
 drivers/media/i2c/tvp7002.c                                   |  2 +-
 drivers/media/media-device.c                                  |  2 ++
 include/uapi/linux/media.h                                    | 39 +++++++++++++++++++++++++++++++--------
 19 files changed, 97 insertions(+), 25 deletions(-)
