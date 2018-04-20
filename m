Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12066 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbeDTSvx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 14:51:53 -0400
From: Vladislav Zhurba <vzhurba@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        Daniel Fu <danifu@nvidia.com>,
        Vladislav Zhurba <vzhurba@nvidia.com>
Subject: [PATCH 1/1] media: nec-decoder: remove trailer_space state
Date: Fri, 20 Apr 2018 11:51:39 -0700
Message-ID: <20180420185139.29238-1-vzhurba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Fu <danifu@nvidia.com>

Remove STATE_TRAILER_SPACE from state machine.
Causing 2 issue:
- can not decode the keycode, if it didn't following with
  another keycode/repeat code
- will generate one more code in current logic.
  i.e. key_right + repeat code + key_left + repeat code.
  expect: key_right, key_left.
  Result: key_right, key_right, key_right.
  Reason: when receive repeat code of key_right, state machine will
  stay in STATE_TRAILER_SPACE state, then wait for a new interrupt,
  if an interrupt came after keyup_timer, then will generate another
  fake key.

According to the NEC protocol, it don't need a trailer space. Remove it.

Signed-off-by: Daniel Fu <danifu@nvidia.com>
Signed-off-by: Vladislav Zhurba <vzhurba@nvidia.com>
---
 drivers/media/rc/ir-nec-decoder.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 21647b809e6f..760b66affd1a 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -128,16 +128,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
 			break;
 
-		data->state = STATE_TRAILER_SPACE;
-		return 0;
-
-	case STATE_TRAILER_SPACE:
-		if (ev.pulse)
-			break;
-
-		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
-			break;
-
 		if (data->count == NEC_NBITS) {
 			address     = bitrev8((data->bits >> 24) & 0xff);
 			not_address = bitrev8((data->bits >> 16) & 0xff);
-- 
2.16.2
