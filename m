Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4191 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2EZNE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 09:04:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.5]  Two core, one tuner and three big-endian fixes
Date: Sat, 26 May 2012 15:04:06 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Steven Toth <stoth@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205261504.06075.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of assorted fixes for 3.5. The v4l2-ioctl patch fixes a
warning from v4l2-compliance, the v4l2-dev.c patch fixes a regression,
also related to g_parm, that I introduced. The tuner-core patch fixes the
corner case where the tuner is set to radio mode, but you call g_tuner
from a video node: you would suddenly get the radio FM frequency range
instead of the TV frequency range.

All three bugs were found with v4l2-compliance.

The last three fixes were found when I tested ivtv, cx18 and cx88 on
a big-endian ppc system. The cx88 driver would fail to load the firmware,
whereas ivtv and cx18 would immediately crash (and cx18 also had firmware
load problems).

Regards,

	Hans

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git fixes

for you to fetch changes up to 63f01d2497f87c9a6cb21f19bc05e1e828e8631c:

  cx88: fix firmware load on big-endian systems. (2012-05-26 14:28:02 +0200)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2-ioctl: set readbuffers to 2 in g_parm.
      v4l2-dev.c: fix g_parm regression in determine_valid_ioctls().
      tuner-core: return the frequency range of the correct tuner.
      ivtv: fix support for big-endian systems.
      cx18: support big-endian systems.
      cx88: fix firmware load on big-endian systems.

 drivers/media/video/cx18/cx18-driver.c    |   10 +++++-----
 drivers/media/video/cx18/cx18-driver.h    |    2 +-
 drivers/media/video/cx18/cx18-firmware.c  |    9 +++++++--
 drivers/media/video/cx18/cx18-mailbox.c   |   15 ++++++++++-----
 drivers/media/video/cx88/cx88-blackbird.c |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c    |   18 +++++++++---------
 drivers/media/video/ivtv/ivtv-driver.h    |    2 +-
 drivers/media/video/tuner-core.c          |    2 +-
 drivers/media/video/v4l2-dev.c            |    2 +-
 drivers/media/video/v4l2-ioctl.c          |    1 +
 10 files changed, 37 insertions(+), 26 deletions(-)
