Return-path: <mchehab@gaivota>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1702 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab0LaNhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 08:37:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Use the control framework in various subdevs
Date: Fri, 31 Dec 2010 14:36:59 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311437.00074.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a pull request for a subset of the RFC patch series I posted almost
three weeks ago.

The only change is cx18 where Andy Walls pointed out some bugs. The same bugs
were introduced in cx25840 and Andy's fixes for those had to be applied as well
in cx18 for the AV core.

I dropped tvaudio, tda7432, tda9875 and ov7670 for now since these need more
testing.

This has been tested with the vivi, cx18, em28xx and vpif_capture/vpif_display
drivers.

Regards,

	Hans

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git subdev-ctrl1

Hans Verkuil (11):
      cs5345: use the control framework
      cx18: Use the control framework.
      adv7343: use control framework
      bt819: use control framework
      saa7110: use control framework
      tlv320aic23b: use control framework
      tvp514x: use the control framework
      tvp5150: use the control framework
      vpx3220: use control framework
      tvp7002: use control framework
      vivi: convert to the control framework and add test controls.

 drivers/media/video/adv7343.c            |  167 +++++++-----------
 drivers/media/video/adv7343_regs.h       |    8 +-
 drivers/media/video/bt819.c              |  129 +++++---------
 drivers/media/video/cs5345.c             |   87 ++++++---
 drivers/media/video/cx18/cx18-av-audio.c |   92 ++---------
 drivers/media/video/cx18/cx18-av-core.c  |  175 ++++++++-----------
 drivers/media/video/cx18/cx18-av-core.h  |   12 +-
 drivers/media/video/cx18/cx18-controls.c |  285 ++++--------------------------
 drivers/media/video/cx18/cx18-controls.h |    7 +-
 drivers/media/video/cx18/cx18-driver.c   |   30 ++--
 drivers/media/video/cx18/cx18-driver.h   |    2 +-
 drivers/media/video/cx18/cx18-fileops.c  |   32 +---
 drivers/media/video/cx18/cx18-ioctl.c    |   24 +--
 drivers/media/video/cx18/cx18-mailbox.c  |    5 +-
 drivers/media/video/cx18/cx18-mailbox.h  |    5 -
 drivers/media/video/cx18/cx18-streams.c  |   16 +-
 drivers/media/video/saa7110.c            |  115 +++++-------
 drivers/media/video/tlv320aic23b.c       |   74 +++++---
 drivers/media/video/tvp514x.c            |  236 ++++++-------------------
 drivers/media/video/tvp5150.c            |  157 +++++------------
 drivers/media/video/tvp7002.c            |  117 +++++--------
 drivers/media/video/vivi.c               |  228 +++++++++++++++---------
 drivers/media/video/vpx3220.c            |  137 ++++++---------
 23 files changed, 773 insertions(+), 1367 deletions(-)


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
