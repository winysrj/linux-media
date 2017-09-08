Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46796 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755161AbdIHMmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 08:42:15 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] AS3645A fixes
Date: Fri,  8 Sep 2017 15:42:10 +0300
Message-Id: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here are a few fixes for the as3645a DTS as well as changes in bindings.
The driver is not in a release yet. I'd like to get these in as through
the media tree fixes branch.

Sakari Ailus (3):
  as3645a: Use ams,input-max-microamp as documented in DT bindings
  dt: bindings: as3645a: Use LED number to refer to LEDs
  as3645a: Use integer numbers for parsing LEDs

 .../devicetree/bindings/leds/ams,as3645a.txt       | 28 ++++++++++++++--------
 arch/arm/boot/dts/omap3-n950-n9.dtsi               | 10 +++++---
 drivers/leds/leds-as3645a.c                        | 28 +++++++++++++++++++---
 3 files changed, 50 insertions(+), 16 deletions(-)

-- 
2.11.0
