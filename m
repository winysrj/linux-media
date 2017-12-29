Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57462 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750708AbdL2M7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:59:16 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, yong.zhi@intel.com
Subject: [PATCH 0/2] A few IPU3 CIO2 fixes
Date: Fri, 29 Dec 2017 14:59:12 +0200
Message-Id: <20171229125914.7218-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong and Mauro,

The two patches are addressing a few matters Mauro pointed out whilst
handling the CIO2 driver pull request.

Yong: could you review especially the latter patch?

Sakari Ailus (2):
  v4l: Fix references in Intel IPU3 Bayer documentation
  intel-ipu3: Rename arr_size macro, use min

 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst |  8 ++++----
 drivers/media/pci/intel/ipu3/ipu3-cio2.c             | 11 ++++-------
 2 files changed, 8 insertions(+), 11 deletions(-)

-- 
2.11.0
