Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2621 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaCJRPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 13:15:23 -0400
Message-ID: <531DF324.5020205@xs4all.nl>
Date: Mon, 10 Mar 2014 18:15:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>
Subject: [GIT PULL FOR v3.15] adv7180 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f2d7313534072a5fe192e7cf46204b413acef479:

  [media] drx-d: add missing braces in drxd_hard.c:DRXD_init (2014-03-09 09:20:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15e

for you to fetch changes up to 72f965c6bbff5f0b3290e5019c90496dcb9462fe:

  adv7180: Add support for power down (2014-03-10 18:12:26 +0100)

----------------------------------------------------------------
Lars-Peter Clausen (7):
      adv7180: Fix remove order
      adv7180: Free control handler on remove()
      adv7180: Remove unnecessary v4l2_device_unregister_subdev() from probe error path
      adv7180: Remove duplicated probe error message
      adv7180: Use threaded IRQ instead of IRQ + workqueue
      adv7180: Add support for async device registration
      adv7180: Add support for power down

 drivers/media/i2c/adv7180.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------
 1 file changed, 59 insertions(+), 41 deletions(-)
