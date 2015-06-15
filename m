Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55720 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930AbbFOKiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 06:38:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D4C2A2A007E
	for <linux-media@vger.kernel.org>; Mon, 15 Jun 2015 12:38:37 +0200 (CEST)
Message-ID: <557EAB2D.5090407@xs4all.nl>
Date: Mon, 15 Jun 2015 12:38:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Remove compat control ops and two other improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are mostly patches removing the compatibility control ops from
various subdevs where this is no longer needed.

Also a code cleanup and code to improve logging the framerate.

Regards,

	Hans

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2p

for you to fetch changes up to e6c8f2db405dda4a921463143417e4c204b0e39f:

  media/radio/saa7706h: Remove compat control ops (2015-06-15 12:23:53 +0200)

----------------------------------------------------------------
Prashant Laddha (1):
      v4l2-dv-timings: print refresh rate with better precision

Ricardo Ribalda Delgado (12):
      media/v4l2-ctrls: Code cleanout validate_new()
      media/i2c/adv7343: Remove compat control ops
      media/i2c/adv7393: Remove compat control ops
      media/i2c/cs5345: Remove compat control ops
      media/i2c/saa717x: Remove compat control ops
      media/i2c/tda7432: Remove compat control ops
      media/i2c/tlv320aic23: Remove compat control ops
      media/i2c/tvp514x: Remove compat control ops
      media/i2c/tvp7002: Remove compat control ops
      i2c/wm8739: Remove compat control ops
      pci/ivtv/ivtv-gpio: Remove compat control ops
      media/radio/saa7706h: Remove compat control ops

 drivers/media/i2c/adv7343.c               |  7 -------
 drivers/media/i2c/adv7393.c               |  7 -------
 drivers/media/i2c/cs5345.c                |  7 -------
 drivers/media/i2c/saa717x.c               |  7 -------
 drivers/media/i2c/tda7432.c               |  7 -------
 drivers/media/i2c/tlv320aic23b.c          |  7 -------
 drivers/media/i2c/tvp514x.c               | 11 -----------
 drivers/media/i2c/tvp7002.c               |  7 -------
 drivers/media/i2c/wm8739.c                |  7 -------
 drivers/media/pci/ivtv/ivtv-gpio.c        |  7 -------
 drivers/media/radio/saa7706h.c            | 16 ++--------------
 drivers/media/v4l2-core/v4l2-ctrls.c      | 15 ---------------
 drivers/media/v4l2-core/v4l2-dv-timings.c |  9 ++++++---
 13 files changed, 8 insertions(+), 106 deletions(-)
