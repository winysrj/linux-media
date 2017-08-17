Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31537 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdHQNpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:45:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 0/3] DW9714 DT support
Date: Thu, 17 Aug 2017 16:42:53 +0300
Message-Id: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset adds DT bindings as well as DT support for DW9714. The
unused ACPI match table is removed.

Sakari Ailus (3):
  dt-bindings: Add bindings for Dongwoon DW9714 voice coil
  dw9714: Add Devicetree support
  dw9714: Remove ACPI match tables, convert to use probe_new

 .../bindings/media/i2c/dongwoon,dw9714.txt         |  9 ++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/media/i2c/dw9714.c                         | 26 +++++++++-------------
 3 files changed, 21 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt

-- 
2.7.4
