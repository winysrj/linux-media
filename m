Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:47074 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab2ESSp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 14:45:26 -0400
Received: from [192.168.239.74] (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4JIjKLe012764
	for <linux-media@vger.kernel.org>; Sat, 19 May 2012 21:45:22 +0300
Message-ID: <4FB7EA39.4070702@maxwell.research.nokia.com>
Date: Sat, 19 May 2012 21:45:13 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.5] SMIA(++) sensor driver improvements
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains improvements and fixes to the SMIA++ sensor
driver. The most interesting one is probably the use of clock framework
for sensor external clock control. The other changes are either fixes or
more generic sensor quirk handling.


The following changes since commit 61282daf505f3c8def09332ca337ac257b792029:

  [media] V4L2: mt9t112: fixup JPEG initialization workaround
(2012-05-15 16:15:35 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-smiapp

Sakari Ailus (10):
      smiapp: Allow using external clock from the clock framework
      smiapp: Pass struct sensor to register writing commands instead of
i2c_client
      smiapp: Quirk for sensors that only do 8-bit reads
      smiapp: Use 8-bit reads only before identifying the sensor
      smiapp: Round minimum pre_pll up rather than down in ip_clk_freq check
      smiapp: Initialise rval in smiapp_read_nvm()
      smiapp: Use non-binning limits if the binning limit is zero
      smiapp: Allow generic quirk registers
      smiapp: Add support for 8-bit uncompressed formats
      smiapp: Use v4l2_ctrl_new_int_menu() instead of v4l2_ctrl_new_custom()

 drivers/media/video/smiapp-pll.c          |    5 +-
 drivers/media/video/smiapp/smiapp-core.c  |  300
+++++++++++++++++-----------
 drivers/media/video/smiapp/smiapp-quirk.c |   50 +++++-
 drivers/media/video/smiapp/smiapp-quirk.h |   11 +
 drivers/media/video/smiapp/smiapp-regs.c  |   82 +++++++-
 drivers/media/video/smiapp/smiapp-regs.h  |    7 +-
 drivers/media/video/smiapp/smiapp.h       |    1 +
 include/media/smiapp.h                    |    1 +
 8 files changed, 322 insertions(+), 135 deletions(-)


Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
