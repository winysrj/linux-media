Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49943 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3LDTPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 0/6] MT9V032 sensor driver fixes and features
Date: Wed,  4 Dec 2013 20:15:47 +0100
Message-Id: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set fixes two issues in the mt9v032 driver (2/6 and 3/6) and then
adds support for monochrome sensors (4/6) and for the very similar MT9V034
sensor model.

The code is based on top of the latest linuxtv master branch and has been
tested with an MT9V034 on a Beagleboard-xM. I'd like to get it in mainline for
v3.14.

Laurent Pinchart (6):
  mt9v032: Remove unused macro
  mt9v032: Fix pixel array size
  mt9v032: Fix binning configuration
  mt9v032: Add support for monochrome models
  mt9v032: Add support for model-specific parameters
  mt9v032: Add support for the MT9V034

 drivers/media/i2c/mt9v032.c | 232 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 187 insertions(+), 45 deletions(-)

-- 
Regards,

Laurent Pinchart

