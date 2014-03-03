Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43394 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaCCJwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:52:23 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v7 0/3] add new Dual LED FLASH LM3646
Date: Mon,  3 Mar 2014 18:52:07 +0900
Message-Id: <1393840330-11130-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 This patch is to add new dual led flash, lm3646.
 LM3646 is the product of ti and it has two 1.5A sync. boost 
 converter with dual white current source.
 2 files are created and 4 files are modified.
 And 3 patch files are created and sent.

 v7 - change log
   Changed V4L2_FLASH_FAULT_UNDER_VOLTAGE description in DocBook.
   Changed lm3646_get_ctrl

 v6 - change log
   Changed description in DocBook.

 v5 - change log
   Added control register caching to avoid redundant i2c access.
   Removed dt to create a seperate patch.
   Changed description in DocBook.

Daniel Jeong (3):
  [RFC] v4l2-controls.h:
  [RFC] DocBook:Media:v4l:controls.xml
  [RFC] media: i2c: add new dual LED Flash driver, lm3646

 Documentation/DocBook/media/v4l/controls.xml |   18 ++
 drivers/media/i2c/Kconfig                    |    9 +
 drivers/media/i2c/Makefile                   |    1 +
 drivers/media/i2c/lm3646.c                   |  414 ++++++++++++++++++++++++++
 include/media/lm3646.h                       |   87 ++++++
 include/uapi/linux/v4l2-controls.h           |    3 +
 6 files changed, 532 insertions(+)
 create mode 100644 drivers/media/i2c/lm3646.c
 create mode 100644 include/media/lm3646.h

-- 
1.7.9.5

