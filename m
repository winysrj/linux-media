Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2735 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3FMG13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 02:27:29 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5D6RH2w074015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:27:20 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id A1A8C35E0047
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:27:15 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates Part 1
Date: Thu, 13 Jun 2013 08:27:16 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306130827.16668.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro prefers to have the original large pull request split up in smaller pieces.

So this is the first patch set.

Note that the pull requests need to be done in order since there are dependencies
between them.

Regards,

	Hans

The following changes since commit 62d54876c511628daed2246753e2fe348da022f1:

  [media] s5p-tv: Don't ignore return value of regulator_bulk_enable() in hdmi_drv.c (2013-06-12 22:17:59 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11a

for you to fetch changes up to 59834c3c791a01d9b7e460bf90d7ec4b47aaeab8:

  media: i2c: ths7303: make the pdata as a constant pointer (2013-06-13 08:14:07 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
      radio-keene: add delay in order to settle hardware

Hans Verkuil (5):
      hdpvr: fix querystd 'unknown format' return.
      hdpvr: code cleanup
      hdpvr: improve error handling
      ml86v7667: fix the querystd implementation
      radio-keene: set initial frequency.

Lad, Prabhakar (4):
      ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
      media: i2c: ths7303: remove init_enable option from pdata
      media: i2c: ths7303: remove unnecessary function ths7303_setup()
      media: i2c: ths7303: make the pdata as a constant pointer

Vladimir Barinov (2):
      adv7180: add more subdev video ops
      ML86V7667: new video decoder driver

 arch/arm/mach-davinci/board-dm365-evm.c |    1 -
 drivers/media/i2c/Kconfig               |    9 +++
 drivers/media/i2c/Makefile              |    1 +
 drivers/media/i2c/adv7180.c             |   46 +++++++++++
 drivers/media/i2c/ml86v7667.c           |  431 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths7303.c             |   48 +++---------
 drivers/media/radio/radio-keene.c       |    7 +-
 drivers/media/usb/hdpvr/hdpvr-control.c |   21 +++--
 drivers/media/usb/hdpvr/hdpvr-video.c   |   72 +++++++++--------
 drivers/media/usb/hdpvr/hdpvr.h         |    1 +
 include/media/ths7303.h                 |    2 -
 11 files changed, 552 insertions(+), 87 deletions(-)
 create mode 100644 drivers/media/i2c/ml86v7667.c
