Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:4884 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2GBLvX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 07:51:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] cx88: convert to the control framework
Date: Mon, 2 Jul 2012 13:51:16 +0200
Cc: Steven Toth <stoth@kernellabs.com>,
	Mike Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021351.16201.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

I didn't get any comments since my RFC post:

http://www.spinics.net/lists/linux-media/msg48764.html

So it's time to send out the pull request.

Regards,

	Hans

The following changes since commit 704a28e88ab6c9cfe393ae626b612cab8b46028e:

  [media] drxk: prevent doing something wrong when init is not ok (2012-06-29 19:04:32 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx88

for you to fetch changes up to bc7432646ff6e276bee5490faefb6cd244b95464:

  cx88-blackbird: replace ioctl by unlocked_ioctl. (2012-07-02 13:47:29 +0200)

----------------------------------------------------------------
Hans Verkuil (11):
      cx88: fix querycap
      cx88: first phase to convert cx88 to the control framework.
      cx88: each device node gets the right controls.
      cx88: convert cx88-blackbird to the control framework.
      cx88: remove radio and type from cx8800_fh.
      cx88: move fmt, width and height to cx8800_dev.
      cx88: add priority support.
      cx88: support control events.
      cx88: fix a number of v4l2-compliance violations.
      cx88: don't use current_norm.
      cx88-blackbird: replace ioctl by unlocked_ioctl.

 drivers/media/video/cx88/cx88-alsa.c      |   31 +---
 drivers/media/video/cx88/cx88-blackbird.c |  234 ++++++++++--------------------
 drivers/media/video/cx88/cx88-cards.c     |   20 +++
 drivers/media/video/cx88/cx88-core.c      |    7 +-
 drivers/media/video/cx88/cx88-video.c     |  901 ++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------
 drivers/media/video/cx88/cx88.h           |   68 +++++----
 6 files changed, 540 insertions(+), 721 deletions(-)
