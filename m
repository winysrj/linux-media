Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4044 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCKfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 05:35:24 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id s13AZKfL051101
	for <linux-media@vger.kernel.org>; Mon, 3 Feb 2014 11:35:22 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.75.206] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 61CBD2A00A5
	for <linux-media@vger.kernel.org>; Mon,  3 Feb 2014 11:35:05 +0100 (CET)
Message-ID: <52EF70E8.6000101@xs4all.nl>
Date: Mon, 03 Feb 2014 11:35:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] Updates for 3.15
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The usual list of updates. I also decided to add my DocBook changes to this
pull request.

Regards,

	Hans

The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

  [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15a

for you to fetch changes up to 5979412aac4c8342c4f7d12c642a2ae955b0c68f:

  DocBook media: add revision entry for 3.15. (2014-02-03 11:29:03 +0100)

----------------------------------------------------------------
Hans Verkuil (11):
      usbvision: drop unused define USBVISION_SAY_AND_WAIT
      s3c-camif: Remove use of deprecated V4L2_CTRL_FLAG_DISABLED.
      v4l2-dv-timings.h: add new 4K DMT resolutions.
      v4l2-dv-timings: mention missing 'reduced blanking V2'
      DocBook media: fix email addresses.
      DocBook media: update copyright years and Introduction.
      DocBook media: partial rewrite of "Opening and Closing Devices"
      DocBook media: update four more sections
      DocBook media: update three sections
      DocBook media: drop the old incorrect packed RGB table.
      DocBook media: add revision entry for 3.15.

Martin Bugge (4):
      adv7842: adjust gain and offset for DVI-D signals
      adv7842: pixelclock read-out
      adv7842: log-status for Audio Video Info frames (AVI)
      adv7842: platform-data for Hotplug Active (HPA) manual/auto

Sachin Kamat (1):
      radio-keene: Use module_usb_driver

sensoray-dev (1):
      s2255drv: checkpatch fix: coding style fix

 Documentation/DocBook/media/dvb/dvbapi.xml            |   4 +-
 Documentation/DocBook/media/v4l/common.xml            | 413 +++++++++++++++++++++---------------------------------
 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 513 +++++++------------------------------------------------------------
 Documentation/DocBook/media/v4l/v4l2.xml              |  13 +-
 Documentation/DocBook/media_api.tmpl                  |  15 +-
 drivers/media/i2c/adv7842.c                           | 149 ++++++++++++++++----
 drivers/media/platform/s3c-camif/camif-capture.c      |  15 +-
 drivers/media/radio/radio-keene.c                     |  19 +--
 drivers/media/usb/s2255/s2255drv.c                    | 333 ++++++++++++++++++++-----------------------
 drivers/media/usb/usbvision/usbvision.h               |   8 --
 drivers/media/v4l2-core/v4l2-dv-timings.c             |   4 +
 include/media/adv7842.h                               |   3 +
 include/uapi/linux/v4l2-dv-timings.h                  |  17 +++
 13 files changed, 536 insertions(+), 970 deletions(-)
