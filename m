Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35583 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbeBJP3A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 10:29:00 -0500
Received: by mail-pl0-f67.google.com with SMTP id j19so2841733pll.2
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 07:28:59 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 0/2] media: ov2640: fix issues in power-down mode
Date: Sun, 11 Feb 2018 00:28:36 +0900
Message-Id: <1518276518-14034-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov2640 driver has support for controlling the reset and power-down
pins via GPIO lines.  But enabling these GPIO controls will prevent the
device from working correctly due to the lack of considering the current
device power state.

This series contains the fixes based on how other sensor drivers handle
it correctly.

Akinobu Mita (2):
  media: ov2640: make set_fmt() work in power-down mode
  media: ov2640: make s_ctrl() work in power-down mode

 drivers/media/i2c/ov2640.c | 112 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 20 deletions(-)

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4
