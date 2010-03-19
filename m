Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47806 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0CSGEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:20 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64HHH010385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:19 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 0/7] Bug Fixes& Enhancements for VPFE and TVP514x drivers
Date: Fri, 19 Mar 2010 11:34:06 +0530
Message-Id: <1268978653-32710-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

This series of patches will address some of the bug fixes & Enhancements
for VPFE capture and TVP514x driver.

Changes from Last Version (V1)- 
	- Refreshed with latest linuxtv/master repository
	- Fixed/Updated comments on UserPtr mode support patch
	- Removed "ti-media" directory patch, will submit seperate
	patch series for the same shortly.
	- Added new patch for TVP514x bug in s_input

Vaibhav Hiremath (7):
  AM3517 CCDC: Debug register read prints removed
  VPFE Capture: Add call back function for interrupt clear to vpfe_cfg
  DM644x CCDC: Add 10bit BT support
  Davinci VPFE Capture:Return 0 from suspend/resume
  DM644x CCDC : Add Suspend/Resume Support
  VPFE Capture: Add support for USERPTR mode of operation
  TVP514x: Add Powerup sequence during s_input to lock the signal
    properly

 drivers/media/video/davinci/dm644x_ccdc.c      |  131 +++++++++++++++++++++++-
 drivers/media/video/davinci/dm644x_ccdc_regs.h |   10 ++-
 drivers/media/video/davinci/vpfe_capture.c     |   78 ++++++++++-----
 drivers/media/video/tvp514x.c                  |   13 +++
 include/media/davinci/vpfe_capture.h           |    2 +
 5 files changed, 203 insertions(+), 31 deletions(-)

