Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42050 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933771AbeFONTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 09:19:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] media: doc fixes, drop __NEED_MEDIA_LEGACY_API
Date: Fri, 15 Jun 2018 15:19:43 +0200
Message-Id: <20180615131946.79802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series drops the '-  .. row 1' lines in the mediactl
documentation (the last media docs that used this), fixes incorrect
types in subdev-formats.rst and removes the __NEED_MEDIA_LEGACY_API
define.

The last two patches were also the first two patches in this older
patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg129417.html

These three should be uncontroversial and they simplify the other
media patches in that older patch series.

Regards,

	Hans

Hans Verkuil (3):
  Documentation/media/uapi/mediactl: redo tables
  subdev-formats.rst: fix incorrect types
  media.h: remove __NEED_MEDIA_LEGACY_API

 .../uapi/mediactl/media-ioc-device-info.rst   |  48 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst |  83 +--
 .../uapi/mediactl/media-ioc-enum-links.rst    |  70 +--
 .../uapi/mediactl/media-ioc-g-topology.rst    | 204 ++-----
 .../media/uapi/mediactl/media-types.rst       | 499 +++++-------------
 .../media/uapi/v4l/subdev-formats.rst         |  15 +-
 drivers/media/media-device.c                  |  13 +-
 include/uapi/linux/media.h                    |   2 +-
 8 files changed, 205 insertions(+), 729 deletions(-)

-- 
2.17.0
