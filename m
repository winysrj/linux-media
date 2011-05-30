Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51009 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1E3As6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 20:48:58 -0400
Subject: [GIT PULL for 2.6.40] ivtv: Framebuffer, decoder, and msleep fixes
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ian Armstrong <ian@iarmst.demon.co.uk>, hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 May 2011 20:48:46 -0400
Message-ID: <1306716526.19653.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following changes.

Regards,
Andy


The following changes since commit 5e094096b93c9c48b4b90457e83cbca6fc2ff5d4:

  [media] v1.88 DM04/QQBOX Move remote to use rc_core dvb-usb-remote (2011-05-25 21:47:26 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git ivtv_40-rc

Ian Armstrong (3):
      ivtv: Make two ivtv_msleep_timeout calls uninterruptable
      ivtvfb: Add sanity check to ivtvfb_pan_display()
      ivtv: Internally separate encoder & decoder standard setting

Laurent Pinchart (1):
      ivtvfb: use display information in info not in var for panning

 drivers/media/video/ivtv/ivtv-driver.c   |   10 +-
 drivers/media/video/ivtv/ivtv-firmware.c |   11 ++-
 drivers/media/video/ivtv/ivtv-ioctl.c    |  129 ++++++++++++++++--------------
 drivers/media/video/ivtv/ivtv-ioctl.h    |    3 +-
 drivers/media/video/ivtv/ivtv-streams.c  |    4 +-
 drivers/media/video/ivtv/ivtv-vbi.c      |    2 +-
 drivers/media/video/ivtv/ivtvfb.c        |   33 +++++---
 7 files changed, 107 insertions(+), 85 deletions(-)


