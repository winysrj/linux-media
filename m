Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52958 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbeIZOVU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 10:21:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 0/2] Unlocked v4l2_ctrl_grab
Date: Wed, 26 Sep 2018 11:09:35 +0300
Message-Id: <20180926080937.19501-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set adds an unlocked variant of v4l2_ctrl_grab(). This is needed when
there's a need not to release the control lock for grabbing a control.

Used by the imx319 driver, but beneficial on a bunch of other sensor
drivers, too --- to grab the *flip controls.

Sakari Ailus (2):
  v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
  v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab

 drivers/media/v4l2-core/v4l2-ctrls.c | 14 ++++----------
 include/media/v4l2-ctrls.h           | 26 +++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 11 deletions(-)

-- 
2.11.0
