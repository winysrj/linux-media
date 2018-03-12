Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60351 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeCLOSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 10:18:35 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] Renesas CEU: SH7724 ECOVEC + Aptina mt9t112
Date: Mon, 12 Mar 2018 14:43:01 +0100
Message-Id: <1520862185-17150-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,
   I have squashed in the two patches I sent on top of v1 in this series, one
fix for the build error you reported me, and reduced the patch count fixing the
style changes on the patch that removes the soc_camera dependencies.

No frame rate control, but now a TODO note makes clear that is expected
v4l2 compliance tool to report errors.

v1 -> v2:
- Fix soc_camera driver build error
- Add TODO note for missing frame rate control
- Reduce patch count

Jacopo Mondi (4):
  media: i2c: Copy mt9t112 soc_camera sensor driver
  media: i2c: mt9t112: Remove soc_camera dependencies
  arch: sh: ecovec: Use new renesas-ceu camera driver
  media: MAINTAINERS: Add entry for Aptina MT9T112

 MAINTAINERS                            |    7 +
 arch/sh/boards/mach-ecovec24/setup.c   |  338 +++++-----
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    4 +-
 drivers/media/i2c/Kconfig              |   11 +
 drivers/media/i2c/Makefile             |    1 +
 drivers/media/i2c/mt9t112.c            | 1140 ++++++++++++++++++++++++++++++++
 drivers/media/i2c/soc_camera/mt9t112.c |    2 +-
 include/media/i2c/mt9t112.h            |   17 +-
 8 files changed, 1338 insertions(+), 182 deletions(-)
 create mode 100644 drivers/media/i2c/mt9t112.c

--
2.7.4
