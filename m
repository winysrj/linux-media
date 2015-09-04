Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:38674 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933034AbbIDNgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 09:36:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 690372A0080
	for <linux-media@vger.kernel.org>; Fri,  4 Sep 2015 15:35:44 +0200 (CEST)
Message-ID: <55E99E30.5000702@xs4all.nl>
Date: Fri, 04 Sep 2015 15:35:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.4] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and enhancements, nothing special.

Note that the v4l2-compat-ioctl32 fix has a CC for stable from 3.10 onwards.
The arm64 architecture was added in 3.10.

Regards,

	Hans

The following changes since commit 50ef28a6ac216fd8b796257a3768fef8f57b917d:

  [media] c8sectpfe: Remove select on undefined LIBELF_32 (2015-09-03 14:10:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.4a

for you to fetch changes up to f71d4170d11859760f70ce4667b9c1d4da8373eb:

  vivid: sdr cap: few enhancements (2015-09-04 15:24:42 +0200)

----------------------------------------------------------------
Alexander Kuleshov (1):
      media/pci/cobalt: Use %*ph to print small buffers

Andrew Milkovich (1):
      Staging: media: bcm2048: warnings for uninitialized variables fixed

Andrzej Hajda (1):
      v4l2-compat-ioctl32: fix alignment for ARM64

Antti Palosaari (2):
      vivid: SDR cap: add control for FM deviation
      vivid: sdr cap: few enhancements

Darek Zielski (1):
      saa7134: add Leadtek Winfast TV2100 FM card support

Nicolas Sugino (1):
      ivtv-alsa: Add index to specify device number

Zahari Doychev (1):
      m2m: fix bad unlock balance

 Documentation/video4linux/CARDLIST.saa7134    |  1 +
 drivers/media/pci/cobalt/cobalt-cpld.c        |  8 +++-----
 drivers/media/pci/ivtv/ivtv-alsa-main.c       | 14 ++++++++++++--
 drivers/media/pci/saa7134/saa7134-cards.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/saa7134/saa7134-input.c     |  7 +++++++
 drivers/media/pci/saa7134/saa7134.h           |  1 +
 drivers/media/platform/vivid/vivid-core.h     |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c    | 37 ++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-sdr-cap.c  | 37 +++++++++++++++++--------------------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  9 +++++----
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 23 ++++++++---------------
 drivers/staging/media/bcm2048/radio-bcm2048.c | 20 ++++++++++----------
 12 files changed, 144 insertions(+), 57 deletions(-)
