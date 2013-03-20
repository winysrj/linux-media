Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4374 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3CTRUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 13:20:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Remove the dv_preset API from s5p-tv
Date: Wed, 20 Mar 2013 18:19:47 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303201819.48031.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This removes the dv_preset API from s5p-tv.

Tested and acked by Tomasz. Thank you very much for testing!

After this patch series is applied there should be no more users of the
DV_PRESET API and I'll post another patch series completely removing the API.

Regards,

	Hans

The following changes since commit 72873e51c578ae29463a5d146f68881fcd0924c0:

  [media] lmedm04: Remove redundant NULL check before kfree (2013-03-19 15:19:29 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git s5p

for you to fetch changes up to 6cb8bd1f2dd2da98abedd33ef03b4e5b2ddbc301:

  s5p-tv: remove the dv_preset API from hdmiphy. (2013-03-20 18:14:53 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      s5p-tv: add dv_timings support for hdmiphy.
      s5p-tv: add dv_timings support for hdmi.
      s5p-tv: add dv_timings support for mixer_video.
      s5p-tv: remove dv_preset support from mixer_video.
      s5p-tv: remove the dv_preset API from hdmi.
      s5p-tv: remove the dv_preset API from hdmiphy.

 drivers/media/platform/s5p-tv/hdmi_drv.c    |  129 ++++++++++++++++++++++++++++++++++++++++-------------------------------
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |   55 ++++++++++++------------------
 drivers/media/platform/s5p-tv/mixer_video.c |   48 ++++++++++++++++++---------
 3 files changed, 127 insertions(+), 105 deletions(-)
