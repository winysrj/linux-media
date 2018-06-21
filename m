Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59488 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932481AbeFUGsT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 02:48:19 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various doc and media.h improvements
Message-ID: <04a1e73c-72bc-a515-352f-b9e532fd623c@xs4all.nl>
Date: Thu, 21 Jun 2018 08:48:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean up rst tables, fix wrong types in the documentation and remove the
ugly __NEED_MEDIA_LEGACY_API define.

Getting these three in first will simplify the follow-on patches that make
G_TOPOLOGY useful.

Regards,

	Hans

The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19e

for you to fetch changes up to 887caa58c226dc8d8c37d2d9981c9951ebf8e6bf:

  media.h: remove __NEED_MEDIA_LEGACY_API (2018-06-21 08:45:04 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      Documentation/media/uapi/mediactl: redo tables
      subdev-formats.rst: fix incorrect types
      media.h: remove __NEED_MEDIA_LEGACY_API

 Documentation/media/uapi/mediactl/media-ioc-device-info.rst   |  48 +---
 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst |  83 ++-----
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    |  70 +-----
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    | 204 +++-------------
 Documentation/media/uapi/mediactl/media-types.rst             | 499 +++++++++-----------------------------
 Documentation/media/uapi/v4l/subdev-formats.rst               |  15 +-
 drivers/media/media-device.c                                  |  13 +-
 include/uapi/linux/media.h                                    |   2 +-
 8 files changed, 205 insertions(+), 729 deletions(-)
