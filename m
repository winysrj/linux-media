Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52720 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725952AbeJFE1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 6 Oct 2018 00:27:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [PATCH 0/2] dw9807 driver fix, dw9714 cleanup
Date: Sat,  6 Oct 2018 00:26:52 +0300
Message-Id: <20181005212654.14664-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj, others,

One fix and one cleanup for the dw9807 and dw9714 drivers. The dw9807
driver had the same issue than what you fixed in dw9714.

Sakari Ailus (2):
  dw9714: Remove useless error message
  dw9807: Fix probe error handling

 drivers/media/i2c/dw9714.c     | 2 +-
 drivers/media/i2c/dw9807-vcm.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.11.0
