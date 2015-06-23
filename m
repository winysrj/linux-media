Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36214 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbbFWOpm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 10:45:42 -0400
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Alan Ott <alan@signal11.us>,
	Alexander Aring <alex.aring@gmail.com>,
	alsa-devel@alsa-project.org, Andrzej Hajda <a.hajda@samsung.com>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Jonathan Cameron <jic23@kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Karol Wrona <k.wrona@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Liam Girdwood <lgirdwood@gmail.com>, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-wpan@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	netdev@vger.kernel.org, patches@opensource.wolfsonmicro.com,
	Solomon Peachy <pizza@shaftnet.org>,
	Takashi Iwai <tiwai@suse.de>,
	Varka Bhadram <varkabhadram@gmail.com>
Cc: Antonio Borneo <borneo.antonio@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Remove redundant spi driver bus initialization
Date: Tue, 23 Jun 2015 22:45:08 +0800
Message-Id: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This cleanup was already completed between end 2011 and early 2012
with a patch series from Lars-Peter Clausen:
https://lkml.org/lkml/2011/11/24/190

Later on new redundant initialization re-appeared here and there.
Time to cleanup again.

And, yes, I'm lazy! I copy-paste the exact same commit message from
Lars-Peter; only minor reformat to stay in 75 char/line and fix the
name of spi_register_driver().

Regards,
Antonio

Antonio Borneo (6):
  ASoC: wm0010: Remove redundant spi driver bus initialization
  iio: ssp_sensors: Remove redundant spi driver bus initialization
  staging: mt29f_spinand: Remove redundant spi driver bus initialization
  net: ieee802154: Remove redundant spi driver bus initialization
  wireless: cw1200: Remove redundant spi driver bus initialization
  [media] s5c73m3: Remove redundant spi driver bus initialization

 drivers/iio/common/ssp_sensors/ssp_dev.c      | 1 -
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c       | 1 -
 drivers/net/ieee802154/cc2520.c               | 1 -
 drivers/net/ieee802154/mrf24j40.c             | 1 -
 drivers/net/wireless/cw1200/cw1200_spi.c      | 1 -
 drivers/staging/mt29f_spinand/mt29f_spinand.c | 1 -
 sound/soc/codecs/wm0010.c                     | 1 -
 7 files changed, 7 deletions(-)

-- 
2.4.4

