Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44545 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388315AbeGXMVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:21:44 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] v2: media/mc: fix inconsistencies
Message-ID: <03964063-7400-20a3-e689-cdb1de4e5b17@xs4all.nl>
Date: Tue, 24 Jul 2018 13:15:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the pull request of v6 of my patch series to fix the mc inconsistencies,
with patches 2 and 11 replaced by the v6.1 version (dropping the text about
stable index values).

Regards,

	Hans

The following changes since commit 39fbb88165b2bbbc77ea7acab5f10632a31526e6:

  media: bpf: ensure bpf program is freed on detach (2018-07-13 11:07:29 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git media-missing2

for you to fetch changes up to ff8d3722d295af44d75f4dce55e518d5258a2c0a:

  media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage (2018-07-24 13:05:53 +0200)

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
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    |  2 +-
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 40 ++++++++++++++++++++++++++++++++--------
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
 19 files changed, 93 insertions(+), 25 deletions(-)
