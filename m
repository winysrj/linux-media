Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34672 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbeACSXW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 13:23:22 -0500
Received: by mail-pf0-f193.google.com with SMTP id a90so1071249pfk.1
        for <linux-media@vger.kernel.org>; Wed, 03 Jan 2018 10:23:22 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 0/4] media: mt9m111: media controller support and misc changes
Date: Thu,  4 Jan 2018 03:22:43 +0900
Message-Id: <1515003767-12006-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds media controller support and other miscellaneous changes
to the mt9m111 driver. The MT9M111 camera modules are easily available
for the hobbyists.

* Changelog v2
- Fix typo s/meida/media/ in the patch title, noticed by Sakari Ailus
- Improve the wording for "clock-names" property, suggested by Sakari Ailus

Akinobu Mita (4):
  media: mt9m111: create subdevice device node
  media: mt9m111: add media controller support
  media: mt9m111: document missing required clocks property
  media: mt9m111: add V4L2_CID_TEST_PATTERN control

 .../devicetree/bindings/media/i2c/mt9m111.txt      |  4 ++
 drivers/media/i2c/mt9m111.c                        | 51 +++++++++++++++++++++-
 2 files changed, 53 insertions(+), 2 deletions(-)

Cc: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
