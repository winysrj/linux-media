Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4295 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3C2Lq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 07:46:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] Move cypress_firmware to common
Date: Fri, 29 Mar 2013 12:46:39 +0100
Cc: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303291246.39331.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed earlier (http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/62438)
let's move this to common. It's a nice cleanup for go7007 as well which had a weird DVB
dependency.

Regards,

	Hans

The following changes since commit 9e7664e0827528701074875eef872f2be1dfaab8:

  [media] solo6x10: The size of the thresholds ioctls was too large (2013-03-29 08:34:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cypress-common

for you to fetch changes up to 6e69c66b2dafc4927b88a15801e0f84585a28336:

  media: move dvb-usb-v2/cypress_firmware.c to media/common. (2013-03-29 12:42:32 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      media: move dvb-usb-v2/cypress_firmware.c to media/common.

 drivers/media/common/Kconfig                                |    3 +++
 drivers/media/common/Makefile                               |    2 ++
 drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.c |   77 +++++++++++++++++++++++++++++++++---------------------------------
 drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.h |    9 +++-----
 drivers/media/usb/dvb-usb-v2/Kconfig                        |    6 +-----
 drivers/media/usb/dvb-usb-v2/Makefile                       |    5 +----
 drivers/media/usb/dvb-usb-v2/az6007.c                       |    2 +-
 drivers/staging/media/go7007/Kconfig                        |    3 ++-
 drivers/staging/media/go7007/Makefile                       |    6 +-----
 drivers/staging/media/go7007/go7007-loader.c                |    4 ++--
 10 files changed, 54 insertions(+), 63 deletions(-)
 rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.c (88%)
 rename drivers/media/{usb/dvb-usb-v2 => common}/cypress_firmware.h (68%)
