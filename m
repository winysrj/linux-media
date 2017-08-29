Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51934 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751285AbdH2Ml2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 08:41:28 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0F9B1600C3
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 15:41:26 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] Better support for ACPI in smiapp
Date: Tue, 29 Aug 2017 15:41:21 +0300
Message-Id: <20170829124125.30879-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The few patches here fix a bug (power sequence error handling) and change
clock handling in a way that allow using the driver in systems without
explicit clock control, e.g. ACPI.

Sakari Ailus (4):
  smiapp: Fix error handling in power on sequence
  smiapp: Verify clock frequency after setting it, prevent changing it
  smiapp: Get clock rate if it's not available through DT
  smiapp: Make clock control optional

 drivers/media/i2c/smiapp/smiapp-core.c | 50 ++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 12 deletions(-)

-- 
2.11.0
