Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/15] drx-j: Cleanups, fixes and support for DVBv5 stats
Date: Mon, 10 Mar 2014 08:58:52 -0300
Message-Id: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is meant to:
1) fix some reported issues (sparse, smatch);

2) Fix one compilation issue with em28xx when drx-j is not selected;

3) Get rid of unused code. It is always possible to restore the code
   from git history. Removing the unused code helps to better understand
   what's actually there.

4) Add support for DVBv5 stats.

On my tests here with an AWGN noise generator, the CNR measure made by
drx-j was close enough to the SNR injected (with a difference of about
1 dB).

Mauro Carvalho Chehab (15):
  drx-j: Don't use 0 as NULL
  drx-j: Fix dubious usage of "&" instead of "&&"
  drx39xxj.h: Fix undefined reference to attach function
  drx-j: don't use mc_info before checking if its not NULL
  drx-j: get rid of dead code
  drx-j: remove external symbols
  drx-j: Fix usage of drxj_close()
  drx-j: propagate returned error from request_firmware()
  drx-j: get rid of some unused vars
  drx-j: Don't use "state" for DVB lock state
  drx-j: re-add get_sig_strength()
  drx-j: Prepare to use DVBv5 stats
  drx-j: properly handle bit counts on stats
  drx-j: Fix detection of no signal
  drx-j: enable DVBv5 stats

 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h   |     6 +
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |    24 -
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 11146 +++-----------------
 drivers/media/dvb-frontends/drx39xyj/drxj.h       |    30 -
 4 files changed, 1343 insertions(+), 9863 deletions(-)

-- 
1.8.5.3

