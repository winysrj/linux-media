Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60958 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753631AbdHOKnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 06:43:18 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 0E44E60122
        for <linux-media@vger.kernel.org>; Tue, 15 Aug 2017 13:43:17 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dhZJc-0007BS-KJ
        for linux-media@vger.kernel.org; Tue, 15 Aug 2017 13:43:16 +0300
Date: Tue, 15 Aug 2017 13:43:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.14] Flash LED class improvements
Message-ID: <20170815104316.j6e6b7eugr42vxka@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is greybus flash memory leak fix as well as V4L2 flash class change
for making the interface more logical by creating a sub-device per LED.

since v1: Fix arguments in nop implementation of v4l2_flash_init().

Please pull.


The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git flash

for you to fetch changes up to f91e3cfb56025111d83d9d86a7024acc3a692c39:

  v4l2-flash-led-class: Document v4l2_flash_init() references (2017-08-15 13:38:02 +0300)

----------------------------------------------------------------
Rui Miguel Silva (1):
      staging: greybus: light: fix memory leak in v4l2 register

Sakari Ailus (2):
      v4l2-flash-led-class: Create separate sub-devices for indicators
      v4l2-flash-led-class: Document v4l2_flash_init() references

 drivers/leds/leds-aat1290.c                    |   4 +-
 drivers/leds/leds-max77693.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 113 +++++++++++++++----------
 drivers/staging/greybus/light.c                |  42 ++++-----
 include/media/v4l2-flash-led-class.h           |  46 +++++++---
 5 files changed, 127 insertions(+), 82 deletions(-)


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
