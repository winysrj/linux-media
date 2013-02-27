Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40702 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3B0GHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 01:07:25 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: mchehab@redhat.com
Cc: andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, sam@ravnborg.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/9] Driver for Si476x series of chips
Date: Tue, 26 Feb 2013 22:06:44 -0800
Message-Id: <1361945213-4280-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a fourth version of the patchset originaly posted here:
https://lkml.org/lkml/2012/9/13/590

Second version of the patch was posted here:
https://lkml.org/lkml/2012/10/5/598

Third version of the patch was posted here:
https://lkml.org/lkml/2012/10/23/510

Fourth version of the patch was posted here:
https://lkml.org/lkml/2013/2/18/572

Fifth version of the patch was posted here:
https://lkml.org/lkml/2013/2/26/45

Sixth version of the patch was posted here;
https://lkml.org/lkml/2013/2/26/257

To save everyone's time I'll repost the original description of it:

This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts: 
 1. Core device that provides all the other devices with basic
functionality and locking scheme.
 2. Radio device that translates between V4L2 subsystem requests into
Core device commands.
 3. Codec device that does similar to the earlier described task, but
for ALSA SoC subsystem.

v7 of this driver has following changes:
   - Minor Makefile/Kconfig changes 
   - MFD driver commit reordering

as per suggestions from Sam Ravnborg

Andrey Smirnov (9):
  mfd: Add commands abstraction layer for SI476X MFD
  mfd: Add the main bulk of core driver for SI476x code
  mfd: Add chip properties handling code for SI476X MFD
  mfd: Add header files and Kbuild plumbing for SI476x MFD core
  v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
  v4l2: Add standard controls for FM receivers
  v4l2: Add documentation for the FM RX controls
  v4l2: Add private controls base for SI476X
  v4l2: Add a V4L2 driver for SI476X MFD

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   74 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    9 +
 Documentation/video4linux/si476x.txt               |  187 +++
 drivers/media/radio/Kconfig                        |   17 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-si476x.c                 | 1574 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |   14 +-
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    4 +
 drivers/mfd/si476x-cmd.c                           | 1553 +++++++++++++++++++
 drivers/mfd/si476x-i2c.c                           |  878 +++++++++++
 drivers/mfd/si476x-prop.c                          |  234 +++
 include/linux/mfd/si476x-core.h                    |  525 +++++++
 include/media/si476x.h                             |  426 ++++++
 include/uapi/linux/v4l2-controls.h                 |   17 +
 16 files changed, 5524 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/video4linux/si476x.txt
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h

-- 
1.7.10.4

