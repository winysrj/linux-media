Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42396 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751809AbdIVJez (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 05:34:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RESEND PATCH v3 0/4] AS3645A fixes
Date: Fri, 22 Sep 2017 12:34:49 +0300
Message-Id: <20170922093453.13250-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek and others,

(Resending, got devicetree list address wrong.)

Here are a few fixes for the as3645a DTS as well as changes in bindings.
The driver is not in a release yet.

Jacek: Could you take these to your fixes branch so we don't get faulty DT
bindings to a release? I've dropped the patches related to LED naming and
label property as the discusion appears to continue on that.

Thanks.


since v2:

- Drop patches related to LED naming.

- No other changes.

since v1:

- Add LED colour to the name of the LED, this adds two patches to the set.

- Add a patch to unregister the indicator LED in driver remove function.

- No changes to v1 patches.

Sakari Ailus (4):
  as3645a: Use ams,input-max-microamp as documented in DT bindings
  dt: bindings: as3645a: Use LED number to refer to LEDs
  as3645a: Use integer numbers for parsing LEDs
  as3645a: Unregister indicator LED on device unbind

 .../devicetree/bindings/leds/ams,as3645a.txt       | 28 +++++++++++++--------
 arch/arm/boot/dts/omap3-n950-n9.dtsi               | 10 +++++---
 drivers/leds/leds-as3645a.c                        | 29 +++++++++++++++++++---
 3 files changed, 51 insertions(+), 16 deletions(-)

-- 
2.11.0
