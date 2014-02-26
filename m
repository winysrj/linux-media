Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54505 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaBZHEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 02:04:22 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v6 0/3] add new Dual LED FLASH LM3646
Date: Wed, 26 Feb 2014 16:04:08 +0900
Message-Id: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 This patch is to add new dual led flash, lm3646.
 LM3646 is the product of ti and it has two 1.5A sync. boost 
 converter with dual white current source.
 2 files are created and 4 files are modified.
 And 3 patch files are created and sent.

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
 drivers/media/i2c/lm3646.c                   |  419 ++++++++++++++++++++++++++
 include/media/lm3646.h                       |   87 ++++++
 include/uapi/linux/v4l2-controls.h           |    3 +
 6 files changed, 537 insertions(+)
 create mode 100644 drivers/media/i2c/lm3646.c
 create mode 100644 include/media/lm3646.h

-- 
1.7.9.5

