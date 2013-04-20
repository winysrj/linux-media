Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2325 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3DTLrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 07:47:33 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id r3KBlMGn035731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:47:32 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 6BDAA11E00F1
	for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:47:21 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Various fixes
Date: Sat, 20 Apr 2013 13:47:20 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304201347.20412.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is my set of patches for 3.10, various fixes for cx88, go7007, em28xx and solo6x10.

Regards,

	Hans

The following changes since commit 6695be6863b75620ffa6d422965680ce785cb7c8:

  [media] DT: export of_get_next_parent() for use by modules: fix modular V4L2 (2013-04-17 12:28:57 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.10

for you to fetch changes up to acf69c28717a80f2240b49a81c10b37bd8998148:

  em28xx: add a missing le16_to_cpu conversion (2013-04-20 13:42:41 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      cx88: Fix unsafe locking in suspend-resume

Dan Carpenter (1):
      go7007: dubious one-bit signed bitfields

Frank Schaefer (1):
      em28xx: add a missing le16_to_cpu conversion

Ismael Luceno (2):
      solo6x10: Update the encoder mode on VIDIOC_S_FMT
      solo6x10: Fix pixelformat accepted/reported by the encoder

 drivers/media/pci/cx88/cx88-mpeg.c                 |   10 ++++++----
 drivers/media/pci/cx88/cx88-video.c                |   10 ++++++----
 drivers/media/usb/em28xx/em28xx-cards.c            |    3 ++-
 drivers/staging/media/go7007/go7007-priv.h         |    4 ++--
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   44 +++++++++++++++++++++++++++++++++-----------
 5 files changed, 49 insertions(+), 22 deletions(-)
