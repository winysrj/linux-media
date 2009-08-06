Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbZHFXBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:25 -0400
Message-Id: <200908062301.n76N1Ho5029987@imap1.linux-foundation.org>
Subject: [patch 6/9] drivers/media/dvb: Use dst_type field instead of type_flags
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:17 -0700
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
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~drivers-media-dvb-use-dst_type-field-instead-of-type_flags drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~drivers-media-dvb-use-dst_type-field-instead-of-type_flags
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1059,7 +1059,7 @@ static int dst_get_tuner_info(struct dst
 		dprintk(verbose, DST_ERROR, 1, "DST type has TS=188");
 	}
 	if (state->board_info[0] == 0xbc) {
-		if (state->type_flags != DST_TYPE_IS_ATSC)
+		if (state->dst_type != DST_TYPE_IS_ATSC)
 			state->type_flags |= DST_TYPE_HAS_TS188;
 		else
 			state->type_flags |= DST_TYPE_HAS_NEWTUNE_2;
_
