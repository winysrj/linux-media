Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35800 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750970AbeEBVbR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 17:31:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com
Subject: [PATCH 0/2] Add a property to tell camera sensor orientation, support it in smiapp
Date: Thu,  3 May 2018 00:31:13 +0300
Message-Id: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The two patches add an "upside-down" property to the video bindings and
support for the property in the smiapp driver.

Sakari Ailus (2):
  dt-bindings: media: Add "upside-down" property to tell sensor
    orientation
  smiapp: Support the "upside-down" property

 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt   | 2 ++
 Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
 drivers/media/i2c/smiapp/smiapp-core.c                       | 3 +++
 3 files changed, 8 insertions(+)

-- 
2.11.0
