Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43980 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTQdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:33:49 -0500
Received: by mail-pf0-f196.google.com with SMTP id e3so12761770pfi.10
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:33:49 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 0/4] media: mt9m111: media controller support and misc changes
Date: Thu, 21 Dec 2017 01:33:30 +0900
Message-Id: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds media controller support and other miscellaneous changes
to the mt9m111 driver. The MT9M111 camera modules are easily available
for the hobbyists.

Akinobu Mita (4):
  meida: mt9m111: create subdevice device node
  meida: mt9m111: add media controller support
  meida: mt9m111: document missing required clocks property
  meida: mt9m111: add V4L2_CID_TEST_PATTERN control

 .../devicetree/bindings/media/i2c/mt9m111.txt      |  4 ++
 drivers/media/i2c/mt9m111.c                        | 51 +++++++++++++++++++++-
 2 files changed, 53 insertions(+), 2 deletions(-)

Cc: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
