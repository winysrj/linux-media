Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51634 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752196AbeFYHbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 03:31:49 -0400
From: alanx.chiang@intel.com
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com,
        andriy.shevchenko@intel.com, rajmohan.mani@intel.com,
        "alanx.chiang" <alanx.chiang@intel.com>
Subject: [RESEND PATCH v1 0/2] Add a property in at24.c
Date: Mon, 25 Jun 2018 15:29:41 +0800
Message-Id: <1529911783-28576-1-git-send-email-alanx.chiang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "alanx.chiang" <alanx.chiang@intel.com>

In at24.c, it uses 8-bit addressing by default. In this patch,
add a property address-width that provides a flexible method to
pass the information to driver so that don't need to add the acpi
or i2c ids for specific module.

alanx.chiang (2):
  eeprom: at24: Add support for address-width property
  dt-bindings: at24: Add address-width property

 Documentation/devicetree/bindings/eeprom/at24.txt |  3 +++
 drivers/misc/eeprom/at24.c                        | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

-- 
2.7.4
