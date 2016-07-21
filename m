Return-path: <linux-media-owner@vger.kernel.org>
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:57871 "EHLO
	15.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbcGUOvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 10:51:10 -0400
Received: from player734.ha.ovh.net (b7.ovh.net [213.186.33.57])
	by mo3.mail-out.ovh.net (Postfix) with ESMTP id 5D87E10142C1
	for <linux-media@vger.kernel.org>; Thu, 21 Jul 2016 16:51:08 +0200 (CEST)
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
To: linux-media@vger.kernel.org
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH v4 0/2] Add GS1662 driver
Date: Thu, 21 Jul 2016 16:51:00 +0200
Message-Id: <1469112662-969-1-git-send-email-charles-antoine.couret@nexvision.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add a driver for GS1662 component, a video serializer which
supports CEA and SDI timings.
To perform that, we need to determine SDI definition and some flags.

The associated documentation will be into another patchset to be
Sphinx comaptible.

This patchset add:
	* rename V4L2_DV_FIRST_FIELD_EXTRA_LINE to V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE
	* change V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE value and comments

Charles-Antoine Couret (2):
  SDI: add flag for SDI formats and SMPTE 125M definition
  Add GS1662 driver, a video serializer

Charles-Antoine Couret (2):
  SDI: add flag for SDI formats and SMPTE 125M definition
  Add GS1662 driver, a video serializer

 drivers/media/Kconfig                     |   1 +
 drivers/media/Makefile                    |   2 +-
 drivers/media/spi/Kconfig                 |   9 +
 drivers/media/spi/Makefile                |   1 +
 drivers/media/spi/gs1662.c                | 472 ++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c |  11 +-
 include/uapi/linux/v4l2-dv-timings.h      |  12 +
 include/uapi/linux/videodev2.h            |   8 +
 8 files changed, 511 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/gs1662.c

-- 
2.7.4

