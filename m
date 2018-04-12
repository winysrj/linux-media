Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56158 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751855AbeDLKVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:21:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 0/4] Random ov7740 fixes
Date: Thu, 12 Apr 2018 13:21:46 +0300
Message-Id: <20180412102150.29997-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I wrote these fixes to the ov7740 driver for the problems I saw. Mostly
error handling as well as setting the events flag to enable control
events.

Sakari Ailus (4):
  ov7740: Fix number of controls hint
  ov7740: Check for possible NULL return value in control creation
  ov7740: Fix control handler error at the end of control init
  ov7740: Set subdev HAS_EVENT flag

 drivers/media/i2c/ov7740.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

-- 
2.11.0
