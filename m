Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab3CTOC2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:28 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 0/5] Improve DRX-K statistics
Date: Wed, 20 Mar 2013 11:02:11 -0300
Message-Id: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Jean, the drxk statistics are not ok.

While we don't have enough documentation about this device, it is possible
to do better, by using what's available. In particular, the AZ6007 driver
released a few years ago by Terratec, with served as the basis for the
Kernel's driver has a version of the drxk driver with some statistics code
on it.

Import the needed bits from it, in order to provide a better set of
statistics.

After this change, the stats looks nicer, especially if used with a
dvbv5 stats application:

Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 3.55dB UCB= 135 postBER= 22.3x10^-6 PER= 0

Yet:

- Signal is a relative measure. Didn't find a way to convert it to
  a real scale, and that would also depend on a proper tuner setting;
- Carrier S/N ratio seems too low for DVB-C. I suspect that it is not
  being measured ok.

However, this seems better than before.

Mauro Carvalho Chehab (5):
  [media] drxk: remove dummy BER read code
  [media] drxk: Add pre/post BER and PER/UCB stats
  [media] drxk: use a better calculus for RF strength
  [media] drxk: Fix bogus signal strength indicator
  [media] dvb-core: don't clear stats at DTV_CLEAR

 drivers/media/dvb-core/dvb_frontend.c   |   2 +-
 drivers/media/dvb-frontends/drxk_hard.c | 302 ++++++++++++++++++++++++++------
 drivers/media/dvb-frontends/drxk_hard.h |   2 +
 drivers/media/dvb-frontends/drxk_map.h  |   3 +
 4 files changed, 259 insertions(+), 50 deletions(-)

-- 
1.8.1.4

