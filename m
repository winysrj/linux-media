Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57721 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbcF0M3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:29:17 -0400
Received: from avalon.localnet (33.154-246-81.adsl-dyn.isp.belgacom.be [81.246.154.33])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id A4FC220010
	for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 14:26:44 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.8] Sensors and decoders fixes
Date: Mon, 27 Jun 2016 15:29:38 +0300
Message-ID: <3710617.QTXFmHdbAK@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to 84052e33262dd7940408e179c68bbf70e93cacb1:

  adv7604: Don't ignore pad number in subdev DV timings pad operations 
(2016-06-27 15:27:53 +0300)

----------------------------------------------------------------
Axel Lin (1):
      v4l: mt9v032: Remove duplicate test for I2C_FUNC_SMBUS_WORD_DATA 
functionality

Guennadi Liakhovetski (1):
      v4l: mt9t001: fix clean up in case of power-on failures

Julia Lawall (1):
      v4l: mt9t001: constify v4l2_subdev_internal_ops structure

Laurent Pinchart (2):
      v4l: mt9v032: Remove unneeded header
      adv7604: Don't ignore pad number in subdev DV timings pad operations

Markus Pargmann (2):
      v4l: mt9v032: Do not unset master_mode
      v4l: mt9v032: Add V4L2 controls for AEC and AGC

Sakari Ailus (1):
      smiapp: Remove useless rval assignment in smiapp_get_pdata()

 drivers/media/i2c/adv7604.c            |  46 +++++--
 drivers/media/i2c/mt9t001.c            |  17 ++-
 drivers/media/i2c/mt9v032.c            | 279 ++++++++++++++++++++++++--------
 drivers/media/i2c/smiapp/smiapp-core.c |   4 +-
 4 files changed, 260 insertions(+), 86 deletions(-)

-- 
Regards,

Laurent Pinchart

