Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2978 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaCQN43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 09:56:29 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2HDuQRw026445
	for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 14:56:28 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 254852A188B
	for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 14:56:16 +0100 (CET)
Message-ID: <5326FF00.4040909@xs4all.nl>
Date: Mon, 17 Mar 2014 14:56:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] saa7134: convert to vb2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds videobuf2-dvb support to vb2 (this was missing
until now) and converts saa7134 to vb2.

These patches are unchanged from the review patch series posted before:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/75376

except for being rebased to the latest code.

Regards,

	Hans

The following changes since commit ed97a6fe5308e5982d118a25f0697b791af5ec50:

  [media] af9033: Don't export functions for the hardware filter (2014-03-14 20:26:59 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git saa7134

for you to fetch changes up to b85c7ee2e578101b8b60abdc57afe58514235695:

  saa7134: convert to vb2 (2014-03-17 14:51:50 +0100)

----------------------------------------------------------------
Hans Verkuil (3):
      vb2: add thread support
      vb2: Add videobuf2-dvb support
      saa7134: convert to vb2

 drivers/media/pci/saa7134/Kconfig           |   4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c    | 106 +++++++++++--
 drivers/media/pci/saa7134/saa7134-core.c    | 107 +++++++------
 drivers/media/pci/saa7134/saa7134-dvb.c     |  43 ++++--
 drivers/media/pci/saa7134/saa7134-empress.c | 178 +++++++++-------------
 drivers/media/pci/saa7134/saa7134-ts.c      | 185 +++++++++++++----------
 drivers/media/pci/saa7134/saa7134-vbi.c     | 170 +++++++++------------
 drivers/media/pci/saa7134/saa7134-video.c   | 659 +++++++++++++++++++++++++++++---------------------------------------------------
 drivers/media/pci/saa7134/saa7134.h         | 106 ++++++-------
 drivers/media/v4l2-core/Kconfig             |   4 +
 drivers/media/v4l2-core/Makefile            |   1 +
 drivers/media/v4l2-core/videobuf2-core.c    | 147 ++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-dvb.c     | 336 +++++++++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h              |  32 ++++
 include/media/videobuf2-dvb.h               |  58 +++++++
 15 files changed, 1293 insertions(+), 843 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-dvb.c
 create mode 100644 include/media/videobuf2-dvb.h
