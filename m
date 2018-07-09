Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33926 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932699AbeGIPl3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 11:41:29 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH -next v3 0/2] introduce SCCB helpers
Date: Tue, 10 Jul 2018 00:41:12 +0900
Message-Id: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset introduces Serial Camera Control Bus (SCCB) helper functions
and convert ov772x driver to use the helpers.

* v3
- Rewrite the helpers based on the code provided by Wolfram
- Convert ov772x driver to use SCCB helpers

 v2
- Convert all helpers into static inline functions, and remove C source
  and Kconfig option.
- Acquire i2c adapter lock while issuing two requests for sccb_read_byte

Akinobu Mita (2):
  i2c: add SCCB helpers
  media: ov772x: use SCCB helpers

 drivers/media/i2c/ov772x.c | 20 +++---------
 include/linux/i2c-sccb.h   | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/i2c-sccb.h

Cc: Peter Rosin <peda@axentia.se>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
