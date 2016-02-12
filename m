Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48437 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbcBLIwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 03:52:43 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 877BA180DD6
	for <linux-media@vger.kernel.org>; Fri, 12 Feb 2016 09:52:38 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Various fixes
Message-ID: <56BD9D56.30206@xs4all.nl>
Date: Fri, 12 Feb 2016 09:52:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f7b4b54e63643b740c598e044874c4bffa0f04f2:

  [media] tvp5150: add HW input connectors support (2016-02-11 11:11:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6c

for you to fetch changes up to fecfd4e06e83fb2c97f7cd0440de36beb919dfe7:

  adv7511: TX_EDID_PRESENT is still 1 after a disconnect (2016-02-12 09:49:38 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      usb/cpia2_core: clean up a min_t() cast

Hans Verkuil (1):
      adv7511: TX_EDID_PRESENT is still 1 after a disconnect

Insu Yun (1):
      pvrusb2: correctly handling failed thread run

 drivers/media/i2c/adv7511.c                 | 21 +++++++++++++++------
 drivers/media/usb/cpia2/cpia2_core.c        |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-context.c |  2 +-
 3 files changed, 17 insertions(+), 8 deletions(-)
