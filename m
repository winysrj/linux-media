Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3H3MCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 08:02:14 -0400
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 0/2] media: s5p-tv: clean-up and fixes
Date: Fri, 30 Aug 2013 14:01:59 +0200
Message-id: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add restoring previous vpll rate after driver offs stream 
or recives error.
It also replace mxr_info, mxr_dbg, mxr_warn and mxr_err macro 
by generic solution.

Mateusz Krawczuk (2):
  media: s5p-tv: Replace mxr_ macro by default dev_
  media: s5p-tv: Restore vpll clock rate

 drivers/media/platform/s5p-tv/mixer.h           |  12 ---
 drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
 drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
 drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
 drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c         |  25 +++++-
 7 files changed, 101 insertions(+), 93 deletions(-)

-- 
1.8.1.2

