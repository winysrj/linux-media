Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56473 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab1C0ED0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2011 00:03:26 -0400
Subject: [GIT PULL for 2.6.39] cx18: Make RF analog TV work for newer
 HVR-1600 models
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Jeff Campbell <jac1dlists@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Mar 2011 00:02:40 -0400
Message-ID: <1301198560.15581.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following changes that fix RF analog TV for the newest
models of HVR-1600 and increment the cx18 driver version number.  The
DTV RF tuner side was already working with Devin's previous change, but
analog RF side did not work.

Thanks go to Jeff Campbell and Mike Bradley for reporting the problem,
and also to Mike Bradley for doing a lot of the legwork to figure out
the tuner reset GPIO line, the demodulator I2C address, and that the
GPIOs have to be reinitialized after a cardtype switch.

Jeff also provided me with one of the newer HVR-1600's, so I was able to
test the changes and make addtional fixes for proper analog RF tuner
video standard setup.  These newer HVR-1600's have a worldwide analog
tuner. :)

Regards,
Andy


The following changes since commit b328817a2a391d1e879c4252cd3f11a352d3f3bc:

  [media] DM04/QQBOX Fix issue with firmware release and cold reset (2011-03-22 19:48:41 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git cx18_39

Andy Walls (2):
      cx18: Make RF analog TV work for newer HVR-1600 models with silicon tuners
      cx18: Bump driver version, since a new class of HVR-1600 is properly supported

 drivers/media/video/cx18/Kconfig        |    3 +++
 drivers/media/video/cx18/cx18-cards.c   |   18 ++++++++++++++----
 drivers/media/video/cx18/cx18-cards.h   |    2 +-
 drivers/media/video/cx18/cx18-driver.c  |   25 +++++++++++++++++++++++--
 drivers/media/video/cx18/cx18-version.h |    2 +-
 5 files changed, 42 insertions(+), 8 deletions(-)


