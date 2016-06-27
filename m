Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42656 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbcF0MbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:31:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4449F180836
	for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 14:31:02 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various fixes
Message-ID: <74472839-8078-c8e4-5d92-43557fdb3f6e@xs4all.nl>
Date: Mon, 27 Jun 2016 14:31:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note for Ulrich's patches: these are prerequisites for two other patch
series (one from Ulrich for HDMI support and one from Niklas for Gen3
support). It doesn't hurt to add these now, and it will simplify future
development.

Regards,

	Hans

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8c

for you to fetch changes up to ad124b474f36aa0581ca46a5f609e7d8c7e0a5a6:

  media: rcar-vin: add DV timings support (2016-06-27 11:34:52 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      radio-maxiradio: fix memory leak when device is removed

Hans Verkuil (1):
      v4l2-ctrl.h: fix comments

Helen Fornazier (1):
      stk1160: Check *nplanes in queue_setup

Ismael Luceno (1):
      solo6x10: Simplify solo_enum_ext_input

Ulrich Hecht (3):
      media: rcar_vin: Use correct pad number in try_fmt
      media: rcar-vin: pad-aware driver initialisation
      media: rcar-vin: add DV timings support

 drivers/media/pci/solo6x10/solo6x10-v4l2.c  |  34 ++++++++---------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/media/platform/rcar-vin/rcar-vin.h  |   2 +
 drivers/media/radio/radio-maxiradio.c       |   1 +
 drivers/media/usb/stk1160/stk1160-v4l.c     |   3 ++
 include/media/v4l2-ctrls.h                  |  24 ++++++------
 6 files changed, 143 insertions(+), 33 deletions(-)
