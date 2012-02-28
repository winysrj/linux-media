Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1392 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab2B1KUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 05:20:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.4] tea575x update to latest V4L2 framework requirements
Date: Tue, 28 Feb 2012 11:19:42 +0100
Cc: alsa-devel@alsa-project.org,
	Ondrej Zary <linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202281119.42794.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series updates the tea575x drivers to the latest V4L2 framework
requirements, converts radio-maxiradio to tea575x as well and adds hwseek
support to these drivers.

All changes are V4L related, even though some of the patches touch sound
drivers (but only the V4L parts of those sound drivers).

Tested with SF16-FMR2, SF64-PCR, SF64-PCE2, SF256-PCP (Ondrej) and maxiradio
(Hans).

Regards,

	Hans

The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:

  [media] xc5000: declare firmware configuration structures as static const (2012-02-14 17:22:46 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git radio-pci

Hans Verkuil (4):
      tea575x-tuner: update to latest V4L2 framework requirements.
      tea575x: fix HW seek
      radio-maxiradio: use the tea575x framework.
      V4L2 Spec: return -EINVAL on unsupported wrap_around value.

 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    6 +-
 drivers/media/radio/Kconfig                        |    2 +-
 drivers/media/radio/radio-maxiradio.c              |  379 ++++----------------
 drivers/media/radio/radio-sf16fmr2.c               |   61 +++-
 include/sound/tea575x-tuner.h                      |    6 +-
 sound/i2c/other/tea575x-tuner.c                    |  169 ++++++---
 sound/pci/es1968.c                                 |   15 +
 sound/pci/fm801.c                                  |   20 +-
 8 files changed, 273 insertions(+), 385 deletions(-)
