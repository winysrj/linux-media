Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52058 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727204AbeH2Osy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 10:48:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 0/3] Uniformly assign sub-device names
Date: Wed, 29 Aug 2018 13:52:30 +0300
Message-Id: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Recently we noticed the sub-device drivers used a few different naming
schemes, as well as a few more different implementations of that naming.
This set adds a framework function to call to name sub-devices for cases
where a sub-device driver exposes more than one sub-device.

This set brings no functional change.

Sakari Ailus (3):
  v4l: subdev: Add a function to set an I²C sub-device's name
  smiapp: Use v4l2_i2c_subdev_set_name
  v4l: sr030pc30: Remove redundant setting of sub-device name

 drivers/media/i2c/smiapp/smiapp-core.c | 10 ++++------
 drivers/media/i2c/sr030pc30.c          |  1 -
 drivers/media/v4l2-core/v4l2-common.c  | 18 ++++++++++++++----
 include/media/v4l2-common.h            | 12 ++++++++++++
 4 files changed, 30 insertions(+), 11 deletions(-)

-- 
2.11.0
