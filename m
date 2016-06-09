Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33920 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbcFIRiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 13:38:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id n184so12409218wmn.1
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 10:38:03 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH RFC 0/2] v4l: platform: Add Renesas R-Car FDP1 Driver
Date: Thu,  9 Jun 2016 18:37:57 +0100
Message-Id: <1465493879-5419-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This early version of the driver, is submitted for review, and functions only
as a pixel format converter.

The FDP1, (Fine Display Processor) is a de-interlacer device, with capability
to convert from various YCbCr/YUV formats to both YCbCr/YUV and RGB formats
at the same time as converting interlaced content to progressive.

It can also function with progressive frames on input, and still act as a
pixel converter which is the current state of the driver.

The next phase of work will be to implement the de-interlacing fucntionality
on top of this code base, however as it is now a functional driver this seemed
like an apt point to start the review process.

Kieran Bingham (2):
  v4l: platform: Add Renesas R-Car FDP1 Driver
  MAINTAINERS: Add support for FDP driver

 MAINTAINERS                        |    9 +
 drivers/media/platform/Kconfig     |   13 +
 drivers/media/platform/Makefile    |    1 +
 drivers/media/platform/rcar_fdp1.c | 2038 ++++++++++++++++++++++++++++++++++++
 4 files changed, 2061 insertions(+)
 create mode 100644 drivers/media/platform/rcar_fdp1.c

-- 
2.7.4

