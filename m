Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1526 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3CYKOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 06:14:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] go7007 updates
Date: Mon, 25 Mar 2013 11:14:18 +0100
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	Chen Gang <gang.chen@asianux.com>,
	Volokh Konstantin <volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251114.18661.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request takes care of some remaining go7007 changes.

Besides the patches posted by Sachin, Chen and Volokh I've applied the three
remaining patches from my ealier go7007 patch series:

- patch saa7134-go7007.c and include the remaining saa7134 patch to the README.
- update the register tables in tw9603/6.c as you suggested.
- add the 'don't continue if firmware can't be loaded.' patch that was skipped
  earlier.

I will post the patch that moves cypress-firmware to media/common separately.

pwclient update -s 'accepted' 17599
pwclient update -s 'accepted' 17600
pwclient update -s 'accepted' 17598

The patch from Volokh was posted here:

http://www.spinics.net/lists/linux-media/msg61607.html

but patchwork missed it, probably due to the mangled subject line.

Regards,

	Hans

The following changes since commit b781e6be79a394cd6980e9cd8fd5c25822d152b6:

  [media] sony-btf-mpx: v4l2_tuner struct is now constant (2013-03-24 14:04:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git go7007-updates

for you to fetch changes up to 82799d7b0d2cc480982b422d10a9191a532adbfb:

  tw2804: Revert ADC Control commit 523a4f7fbcf856fb1c2a4850f44edea6738ee37b (2013-03-25 11:05:29 +0100)

----------------------------------------------------------------
Chen Gang (1):
      go7007: using strlcpy instead of strncpy

Hans Verkuil (4):
      saa7134-go7007: convert to a subdev and the control framework
      go7007: update the README
      go7007: don't continue if firmware can't be loaded.
      tw9603/6.c: use two separate const tables for the 50/60hz setup.

Sachin Kamat (2):
      tw9906: Remove unneeded version.h header include
      go7007: Remove unneeded version.h header include

Volokh Konstantin (1):
      tw2804: Revert ADC Control commit 523a4f7fbcf856fb1c2a4850f44edea6738ee37b

 drivers/media/i2c/tw2804.c                    |   17 +------
 drivers/media/i2c/tw9903.c                    |   19 +++++---
 drivers/media/i2c/tw9906.c                    |   20 +++++---
 drivers/staging/media/go7007/Makefile         |    2 +-
 drivers/staging/media/go7007/README           |  142 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/staging/media/go7007/go7007-usb.c     |   76 +++++++++++++++---------------
 drivers/staging/media/go7007/go7007-v4l2.c    |    1 -
 drivers/staging/media/go7007/saa7134-go7007.c |  151 ++++++++++++++++++++++++++++++++++-------------------------
 8 files changed, 288 insertions(+), 140 deletions(-)
