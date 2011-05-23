Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2260 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1EWLHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:07:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.40] Fixes
Date: Mon, 23 May 2011 13:06:56 +0200
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231306.56050.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Here are a few fixes: the first fixes a bug in the wl12xx drivers (I hope Matti's
email is still correct). The second fixes a few DocBook validation errors, and
the last fixes READ_ONLY and GRABBED handling in the control framework.

Regards,

	Hans

The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:

  [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (3):
      wl12xx: g_volatile_ctrl fix: wrong field set.
      Media DocBook: fix validation errors.
      v4l2-ctrls: drivers should be able to ignore READ_ONLY and GRABBED flags

 Documentation/DocBook/dvb/dvbproperty.xml    |    5 ++-
 Documentation/DocBook/v4l/subdev-formats.xml |   10 ++--
 drivers/media/radio/radio-wl1273.c           |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c      |    2 +-
 drivers/media/video/v4l2-ctrls.c             |   59 +++++++++++++++++---------
 5 files changed, 50 insertions(+), 28 deletions(-)
