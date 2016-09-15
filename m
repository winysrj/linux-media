Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:39382 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbcIOPaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 11:30:09 -0400
Received: from player711.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 061881010C20
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 17:30:06 +0200 (CEST)
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
To: linux-media@vger.kernel.org
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH v7 0/2] Add GS1662 driver
Date: Thu, 15 Sep 2016 17:29:49 +0200
Message-Id: <1473953391-3974-1-git-send-email-charles-antoine.couret@nexvision.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add a driver for GS1662 component, a video serializer which
supports CEA and SDI timings.
To perform that, we need to determine SDI definition and some flags.

The associated documentation will be into another patchset to be
Sphinx comaptible.

This patchset add:
	* driver in the MAINTAINERS file

Charles-Antoine Couret (2):
  SDI: add flag for SDI formats and SMPTE 125M definition
  Add GS1662 driver, a video serializer

 MAINTAINERS                               |   7 +
 drivers/media/Kconfig                     |   1 +
 drivers/media/Makefile                    |   2 +-
 drivers/media/spi/Kconfig                 |   9 +
 drivers/media/spi/Makefile                |   1 +
 drivers/media/spi/gs1662.c                | 472 ++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-dv-timings.c |  11 +-
 include/uapi/linux/v4l2-dv-timings.h      |  12 +
 include/uapi/linux/videodev2.h            |   8 +
 9 files changed, 518 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/gs1662.c

-- 
2.7.4

