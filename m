Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4388 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751737AbeADDs4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 22:48:56 -0500
From: tian.shu.qiu@intel.com
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Qiu@vger.kernel.org, Tianshu <tian.shu.qiu@intel.com>
Subject: [Yavta Patches v1 0/2] Add support for intel ipu3 specific formats
Date: Thu,  4 Jan 2018 11:48:11 +0800
Message-Id: <1515037693-29631-1-git-send-email-tian.shu.qiu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tianshu Qiu <tian.shu.qiu@intel.com>

This patch set adds new pixel formats specific for intel 3rd generation ipu driver.

Tianshu Qiu (2):
  Update headers from upstream kernel
  Add support for intel ipu3 specific raw formats

 include/linux/videodev2.h | 15 +++++++++++++++
 yavta.c                   |  4 ++++
 2 files changed, 19 insertions(+)

-- 
2.7.4
