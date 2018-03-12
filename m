Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37742 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932388AbeCLQO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:14:28 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Renesas CEU: SH7724 ECOVEC + Aptina mt9t112
Message-ID: <7895bc0c-bd27-f1d1-24c1-b1ec43371da2@xs4all.nl>
Date: Mon, 12 Mar 2018 09:14:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This converts the ecovec platform to the renesas-ceu driver. As part of that
mt9t112 is converted to a 'regular' subdev driver.

Note: there is no sh arch maintainer, so that patch is also going through this
pull request.

Regards,

	Hans

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17d

for you to fetch changes up to ee24babd29f962b5eb7f751f88a2604c3c00b720:

  media: MAINTAINERS: Add entry for Aptina MT9T112 (2018-03-12 17:07:35 +0100)

----------------------------------------------------------------
Jacopo Mondi (4):
      media: i2c: Copy mt9t112 soc_camera sensor driver
      media: i2c: mt9t112: Remove soc_camera dependencies
      arch: sh: ecovec: Use new renesas-ceu camera driver
      media: MAINTAINERS: Add entry for Aptina MT9T112

 MAINTAINERS                            |    8 ++
 arch/sh/boards/mach-ecovec24/setup.c   |  338 +++++++++++++++++++++++++++++++++---------------------------------
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    4 +-
 drivers/media/i2c/Kconfig              |   11 +++
 drivers/media/i2c/Makefile             |    1 +
 drivers/media/i2c/mt9t112.c            | 1140
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/soc_camera/mt9t112.c |    2 +-
 include/media/i2c/mt9t112.h            |   17 ++--
 8 files changed, 1339 insertions(+), 182 deletions(-)
 create mode 100644 drivers/media/i2c/mt9t112.c
