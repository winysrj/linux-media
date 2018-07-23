Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54310 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387834AbeGWLvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 07:51:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org,
        alanx.chiang@intel.com, andy.yeh@intel.com
Subject: [PATCH 0/2] dw9807 bindings and driver are just for VCM
Date: Mon, 23 Jul 2018 13:50:37 +0300
Message-Id: <20180723105039.20110-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I though of writing these two small patches to rename the dw9807 bindings
and driver to reflect what's apparent in the compatible string: this is
just the VCM part.

Sakari Ailus (2):
  dt-bindings: dw9714, dw9807-vcm: Add files to MAINTAINERS, rename
    files
  dw9807-vcm: Recognise this is just the VCM bit of the device

 .../bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} | 0
 MAINTAINERS                                                             | 2 ++
 drivers/media/i2c/Kconfig                                               | 2 +-
 drivers/media/i2c/Makefile                                              | 2 +-
 drivers/media/i2c/{dw9807.c => dw9807-vcm.c}                            | 0
 5 files changed, 4 insertions(+), 2 deletions(-)
 rename Documentation/devicetree/bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} (100%)
 rename drivers/media/i2c/{dw9807.c => dw9807-vcm.c} (100%)

-- 
2.11.0
