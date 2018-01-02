Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26922 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbeABLNI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 06:13:08 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [RESEND PATCH 0/2] dw9714 fixes, cleanups
Date: Tue,  2 Jan 2018 13:12:10 +0200
Message-Id: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

(Fixed Raj's e-mail.)

The two patches address a small bug in dw9714 driver and clean it up a
little, too.

Raj: could you let me know if they work for you? Thanks.


Sakari Ailus (2):
  dw9714: Call pm_runtime_idle() at the end of probe()
  dw9714: Remove client field in driver's struct

 drivers/media/i2c/dw9714.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

-- 
2.7.4
