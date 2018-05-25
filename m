Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966506AbeEYM1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 08:27:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, andy.yeh@intel.com,
        sebastian.reichel@collabora.co.uk
Subject: [PATCH v2 0/2] Define rotation property for camera sensors
Date: Fri, 25 May 2018 15:27:24 +0300
Message-Id: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here's an update on my previous patchset adding an "upside-down" property.
Instead of dropping the first patch entirely as I first thought, I decided
to add documentation for the rotation property for sensors as well. The
updates to the patches are related to that.

Sakari Ailus (2):
  dt-bindings: media: Define "rotation" property for sensors
  smiapp: Support the "upside-down" property

 .../devicetree/bindings/media/i2c/nokia,smia.txt         |  2 ++
 .../devicetree/bindings/media/video-interfaces.txt       |  4 ++++
 drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++++++++
 3 files changed, 22 insertions(+)

-- 
2.11.0
