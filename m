Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3LQSdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:47 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6] Add dvbv5 stats to dib8000 frontend
Date: Tue, 17 Dec 2013 13:30:40 -0200
Message-Id: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBv5 stats is more complete than the DVBv3 ones, and provide
scales to the statistics.

Add support for it with dib8000.

After this patchset, the stats will look like:

Lock   (0x1f) Quality= Poor Signal= -26.93dBm C/N= 22.45dB UCB= 229 postBER= 16.6x10^-6 PER= 1.12x10^-3

For the first version of dib8076. Newer versions should also have
per-layer stats, but I couldn't test here, due to the lack of a
newer hardware.

For those that want to test the new improvements on dib8000 frontend,
I added them on my experimental tree:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/dib0700_isdb

Mauro Carvalho Chehab (6):
  [media] dib8000: add DVBv5 stats
  [media] dib8000: estimate strength in dBm
  [media] dib8000: make a better estimation for dBm
  [media] dib8000: Fix UCB measure with DVBv5 stats
  [media] dib8000: be sure that stats are available before reading them
  [media] dib8000: improve block statistics

 drivers/media/dvb-frontends/dib8000.c | 404 +++++++++++++++++++++++++++++++++-
 1 file changed, 403 insertions(+), 1 deletion(-)

-- 
1.8.3.1

