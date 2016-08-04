Return-path: <linux-media-owner@vger.kernel.org>
Received: from 3.mo68.mail-out.ovh.net ([46.105.58.60]:50451 "EHLO
	3.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153AbcHDRBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 13:01:49 -0400
Received: from player788.ha.ovh.net (b7.ovh.net [213.186.33.57])
	by mo68.mail-out.ovh.net (Postfix) with ESMTP id 194E6FF928B
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2016 17:43:08 +0200 (CEST)
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
To: linux-media@vger.kernel.org
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH v5 0/2] Add GS1662 driver
Date: Thu,  4 Aug 2016 17:42:52 +0200
Message-Id: <1470325374-14784-1-git-send-email-charles-antoine.couret@nexvision.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add a driver for GS1662 component, a video serializer which
supports CEA and SDI timings.
To perform that, we need to determine SDI definition and some flags.

The associated documentation will be into another patchset to be
Sphinx comaptible.

This patchset add:
	* redefine SMPTE-125M timings to be compliant to standard

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

