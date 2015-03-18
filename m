Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47623 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbCRWum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 18:50:42 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 8B92D2000D
	for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 23:49:25 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] Sensor drivers fixes
Date: Thu, 19 Mar 2015 00:50:46 +0200
Message-ID: <23794796.56S4XQrc2k@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 
13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 884673a6abe3c1e0b7162fd97b133d06cf587556:

  v4l: mt9v032: Add OF support (2015-03-18 23:24:22 +0200)

----------------------------------------------------------------
Enrico Scholz (1):
      mt9p031: fixed calculation of clk_div

Lad, Prabhakar (2):
      media: i2c: mt9p031: make sure we destroy the mutex
      media: i2c: mt9p031: add support for asynchronous probing

Laurent Pinchart (4):
      v4l: mt9p031: Convert to the gpiod API
      v4l: mt9v032: Consider control initialization errors as fatal
      of: Add vendor prefix for Aptina Imaging
      v4l: mt9v032: Add OF support

 Documentation/devicetree/bindings/media/i2c/mt9v032.txt | 39 +++++++++++++
 Documentation/devicetree/bindings/vendor-prefixes.txt   |  1 +
 MAINTAINERS                                             |  1 +
 drivers/media/i2c/mt9p031.c                             | 45 +++++++-------
 drivers/media/i2c/mt9v032.c                             | 78 ++++++++++++++--
 include/media/mt9p031.h                                 |  2 -
 6 files changed, 137 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9v032.txt

-- 
Regards,

Laurent Pinchart

