Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1BMRaN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:30:13 -0500
Date: Sun, 13 Feb 2011 15:28:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Srinivasa.Deevi@conexant.com
Subject: [PATCH 0/5] Add support for PV Xcapture USB on cx231xx
Message-ID: <20110213152858.645175f4@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a simple grabber card, and its addition should be simple.
However, the cx231xx power management complains if some things
are powered and starts to generate error -71. So, before adding
the board entry, we need to apply a few fixes.

This series also have a change at tuner code that will (hopefully)
help to implement support for devices with xc3028.

Mauro Carvalho Chehab (5):
  [media] cx231xx: Simplify interface checking logic at probe
  [media] cx231xx: Use a generic check for TUNER_XC5000
  [media] cx231xx: Use parameters to describe some board variants
  [media] cx231xx: Allow some boards to not use I2C port 3
  [media] cx231xx: Add support for PV Xcapture USB

 drivers/media/video/cx231xx/cx231xx-avcore.c |   14 +-
 drivers/media/video/cx231xx/cx231xx-cards.c  |  228 +++++++++++++++-----------
 drivers/media/video/cx231xx/cx231xx-core.c   |   16 +-
 drivers/media/video/cx231xx/cx231xx-i2c.c    |   31 +++--
 drivers/media/video/cx231xx/cx231xx-video.c  |   20 +-
 drivers/media/video/cx231xx/cx231xx.h        |    5 +
 6 files changed, 180 insertions(+), 134 deletions(-)

