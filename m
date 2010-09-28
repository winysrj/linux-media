Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276Ab0I1S5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:57:47 -0400
Date: Tue, 28 Sep 2010 15:47:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/10] Several fixes for cx231xx
Message-ID: <20100928154702.52871362@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those patches do several fixes needed on cx231xx for it to properly work
with some new devices. They are meant to be applied after Devin's patches on
his tree:
	https://www.kernellabs.com/hg/~dheitmueller/polaris4/

I've applied his patch (fixing some merge conflicts) on a temporary git
tree at:
	http://git.linuxtv.org/mchehab/cx231xx.git

I have a few more patches adding experimental support for PixelView SBTVD
Hybrid, in analog mode, that needs a few more adjustments before pushing
at my tree, and I should start working on a driver for digital mode soon.

Mauro Carvalho Chehab (10):
  V4L/DVB: cx231xx: remove a printk warning at -avcore and at -417
  V4L/DVB: cx231xx: fix Kconfig dependencies
  V4L/DVB: tda18271: Add some hint about what tda18217 reg ID returned
  V4L/DVB: cx231xx: properly implement URB control messages log
  V4L/DVB: cx231xx: properly use the right tuner i2c address
  V4L/DVB: cx231xx: better handle the master port enable command
  V4L/DVB: cx231xx: Only change gpio direction when needed
  V4L/DVB: tda18271: allow restricting max out to 4 bytes
  V4L/DVB: tda18271: Add debug message with frequency divisor
  V4L/DVB: cx231xx-audio: fix some locking issues

 drivers/media/common/tuners/tda18271-common.c |   66 ++++++----
 drivers/media/common/tuners/tda18271-fe.c     |    2 +-
 drivers/media/common/tuners/tda18271.h        |    5 +-
 drivers/media/video/cx231xx/Kconfig           |    1 +
 drivers/media/video/cx231xx/cx231xx-417.c     |    2 +-
 drivers/media/video/cx231xx/cx231xx-audio.c   |   95 ++++++------
 drivers/media/video/cx231xx/cx231xx-avcore.c  |   91 +++++-------
 drivers/media/video/cx231xx/cx231xx-cards.c   |    7 +-
 drivers/media/video/cx231xx/cx231xx-core.c    |  192 +++++++++++--------------
 drivers/media/video/cx231xx/cx231xx-dvb.c     |   32 ++--
 drivers/media/video/cx231xx/cx231xx.h         |   17 ++-
 drivers/media/video/tuner-core.c              |    2 +-
 12 files changed, 243 insertions(+), 269 deletions(-)

