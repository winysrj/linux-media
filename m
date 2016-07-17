Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51824 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbcGQJIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:23 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CDE00180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 11:08:17 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] dv-timings: add VICs and picture aspect ratio
Date: Sun, 17 Jul 2016 11:08:12 +0200
Message-Id: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_bt_timings struct is missing information about the picture aspect
ratio and the CEA-861 and HDMI VIC (Video Identification Code).

This patch series adds support for this.

Regards,

	Hans

Hans Verkuil (5):
  videodev2.h: add VICs and picture aspect ratio
  v4l2-dv-timings: add VICs and picture aspect ratio
  v4l2-dv-timings: add helpers to find vic and pixelaspect ratio
  cobalt: add cropcap support
  adv7604: add vic detect

 drivers/media/i2c/adv7604.c               | 18 +++++-
 drivers/media/pci/cobalt/cobalt-v4l2.c    | 21 +++++++
 drivers/media/v4l2-core/Kconfig           |  1 +
 drivers/media/v4l2-core/v4l2-dv-timings.c | 58 +++++++++++++++++-
 include/media/v4l2-dv-timings.h           | 18 ++++++
 include/uapi/linux/v4l2-dv-timings.h      | 97 ++++++++++++++++++++-----------
 include/uapi/linux/videodev2.h            | 75 +++++++++++++++++-------
 7 files changed, 229 insertions(+), 59 deletions(-)

-- 
2.8.1

