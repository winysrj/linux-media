Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:49385 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZGUQu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 12:50:28 -0400
Date: Tue, 21 Jul 2009 18:47:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/dvb: Use dst_type field instead of type_flags
Message-ID: <Pine.LNX.4.64.0907211847190.26529@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

It seems from other code that it is the dst_type field rather than the
type_flags field that contains values of the form DST_TYPE_IS...
The type_flags field contains values of the form DST_TYPE_HAS...

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ struct dst_state E; @@

(
*E.type_flags == 
  \( DST_TYPE_IS_SAT\|DST_TYPE_IS_TERR\|DST_TYPE_IS_CABLE\|DST_TYPE_IS_ATSC \)
|
*E.type_flags != 
  \( DST_TYPE_IS_SAT\|DST_TYPE_IS_TERR\|DST_TYPE_IS_CABLE\|DST_TYPE_IS_ATSC \)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/bt8xx/dst.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index fec1d77..91353a6 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1059,7 +1059,7 @@ static int dst_get_tuner_info(struct dst_state *state)
 		dprintk(verbose, DST_ERROR, 1, "DST type has TS=188");
 	}
 	if (state->board_info[0] == 0xbc) {
-		if (state->type_flags != DST_TYPE_IS_ATSC)
+		if (state->dst_type != DST_TYPE_IS_ATSC)
 			state->type_flags |= DST_TYPE_HAS_TS188;
 		else
 			state->type_flags |= DST_TYPE_HAS_NEWTUNE_2;
