Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41520 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3DLJNF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 05:13:05 -0400
Received: from avalon.localnet (unknown [91.178.242.31])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D54863598B
	for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 11:12:45 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] Camera sensors patches
Date: Fri, 12 Apr 2013 11:13:06 +0200
Message-ID: <3775187.HOcoQVPfEE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design 
(2013-04-08 07:28:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to c890926a06339944790c5c265e21e8547aa55e49:

  mt9p031: Use the common clock framework (2013-04-12 11:07:07 +0200)

----------------------------------------------------------------
Laurent Pinchart (5):
      mt9m032: Fix PLL setup
      mt9m032: Define MT9M032_READ_MODE1 bits
      mt9p031: Use devm_* managed helpers
      mt9p031: Add support for regulators
      mt9p031: Use the common clock framework

 drivers/media/i2c/mt9m032.c | 46 +++++++++++++++++++++++++++++++-----------
 drivers/media/i2c/mt9p031.c | 58 ++++++++++++++++++++++++++++++--------------
 include/media/mt9p031.h     |  2 --
 3 files changed, 75 insertions(+), 31 deletions(-)

-- 
Regards,

Laurent Pinchart

