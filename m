Return-path: <linux-media-owner@vger.kernel.org>
Received: from 5ac77058.bb.sky.com ([90.199.112.88]:57369 "EHLO valkyrie."
	rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org with ESMTP
	id S1752656Ab1LUA2X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 19:28:23 -0500
Subject: [PATCH] qt1010: Fix tuner frequency selection for 546 to 578 MHz range
To: linux-media@vger.kernel.org
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Jyrki Kuoppala <jkp@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 20 Dec 2011 10:50:34 +0000
Message-ID: <20111220105034.5150.54234.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch fixes frequency selection for some UHF frequencies e.g.
channel 32 (562 MHz) on the qt1010 tuner. For those in the UK,
this now means they can tune to the BBC channels (tested on a Compro
Vista T750F).

One example of problem reports of the bug this fixes can be read at
http://www.freak-search.com/de/thread/330303/linux-dvb_tuning_problem_with_some_frequencies_qt1010,_dvb

Based on an original patch by Jyrki Kuoppala <jkp@iki.fi>

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Jyrki Kuoppala <jkp@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/common/tuners/qt1010.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
index 9f5dba2..8c57d8c 100644
--- a/drivers/media/common/tuners/qt1010.c
+++ b/drivers/media/common/tuners/qt1010.c
@@ -200,7 +200,8 @@ static int qt1010_set_params(struct dvb_frontend *fe,
 	if      (freq < 450000000) rd[15].val = 0xd0; /* 450 MHz */
 	else if (freq < 482000000) rd[15].val = 0xd1; /* 482 MHz */
 	else if (freq < 514000000) rd[15].val = 0xd4; /* 514 MHz */
-	else if (freq < 546000000) rd[15].val = 0xd7; /* 546 MHz */
+	else if (freq < 546000000) rd[15].val = 0xd6; /* 546 MHz */
+	else if (freq < 578000000) rd[15].val = 0xd8; /* 578 MHz */
 	else if (freq < 610000000) rd[15].val = 0xda; /* 610 MHz */
 	else                       rd[15].val = 0xd0;
 

