Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34801 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcF3Nl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 09:41:27 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so23017044wmz.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 06:41:26 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: kieran@ksquared.org.uk, linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v2] v4l: platform: Add Renesas R-Car FDP1 Driver
Date: Thu, 30 Jun 2016 14:41:22 +0100
Message-Id: <1467294083-1811-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Version 2 of the FDP1 driver introduces support for deinterlacing on top
of the previous patch which only supported pixel format conversion.

The FDP1, (Fine Display Processor) is a de-interlacer device, with capability
to convert from various YCbCr/YUV formats to both YCbCr/YUV and RGB formats
at the same time as converting interlaced content to progressive.

Kieran Bingham (1):
  v4l: platform: Add Renesas R-Car FDP1 Driver

 MAINTAINERS                        |    9 +
 drivers/media/platform/Kconfig     |   13 +
 drivers/media/platform/Makefile    |    1 +
 drivers/media/platform/rcar_fdp1.c | 2395 ++++++++++++++++++++++++++++++++++++
 4 files changed, 2418 insertions(+)
 create mode 100644 drivers/media/platform/rcar_fdp1.c

-- 
2.7.4

