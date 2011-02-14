Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1BNVRu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:17:50 -0500
Date: Mon, 14 Feb 2011 19:03:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 00/14] tuner-core cleanups
Message-ID: <20110214190323.31796200@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The entire subsystem internals have changed, but without enough
care to clean up tuner-core internals.

This patch series take care of tuner-core, removing some dead
code there, and avoiding the risk of returning T_STANDBY to
userspace.

Those changes were motivated by this thread:
	http://www.spinics.net/lists/linux-media/msg28266.html

The patches are tested with both radio and xawtv applications
with a Pixelview Ultra device (cx88 card=27). This device has
a separate FM tuner, with makes tuner-core life harder, as
tuner-core needs to filter if a tune event should go to
tea5767 FM tuner, or to an analogic tuner (Tena/TNF, in the
case of the board I used for tests).

Mauro Carvalho Chehab (14):
  [media] cx88: use unlocked_ioctl for cx88-video.
  [media] cx88: Don't allow opening a device while it is not ready
  [media] tuner-core: Remove V4L1/V4L2 API switch
  [media] tuner-core: remove the legacy is_stereo() call
  [media] tuner-core: move some messages to the proper place
  [media] tuner-core: Reorganize the functions internally
  [media] tuner-core: Some cleanups at check_mode/set_mode
  [media] tuner-core: Better implement standby mode
  [media] tuner-core: do the right thing for suspend/resume
  [media] tuner-core: CodingStyle cleanups
  [media] tuner-core: Don't use a static var for xc5000_cfg
  [media] tuner-core: dead code removal
  [media] tuner-core: Fix a few comments on it
  [media] Remove the remaining usages for T_STANDBY

 drivers/media/common/tuners/tda9887.c     |    9 +-
 drivers/media/common/tuners/tea5761.c     |   33 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h |    1 -
 drivers/media/video/cx88/cx88-video.c     |   26 +-
 drivers/media/video/tuner-core.c          | 1093 +++++++++++++++--------------
 include/media/tuner.h                     |   13 +-
 6 files changed, 596 insertions(+), 579 deletions(-)

