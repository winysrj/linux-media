Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:57750 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751172AbeEVLdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:33:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] adv7511: fix incorrect clear of CEC receive interrupt
Date: Tue, 22 May 2018 13:33:14 +0200
Message-Id: <20180522113314.14666-3-hverkuil@xs4all.nl>
In-Reply-To: <20180522113314.14666-1-hverkuil@xs4all.nl>
References: <20180522113314.14666-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If a CEC message was received and the RX interrupt was set, but
not yet processed, and a new transmit was issues, then the
transmit code would inadvertently clear the RX interrupt and
after that no new messages would ever be received.

Instead it should only clear TX interrupts since register 0x97
is a clear-on-write register.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index d23505a411ee..554261291e78 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -831,8 +831,8 @@ static int adv7511_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	 */
 	adv7511_cec_write_and_or(sd, 0x12, ~0x70, max(1, attempts - 1) << 4);
 
-	/* blocking, clear cec tx irq status */
-	adv7511_wr_and_or(sd, 0x97, 0xc7, 0x38);
+	/* clear cec tx irq status */
+	adv7511_wr(sd, 0x97, 0x38);
 
 	/* write data */
 	for (i = 0; i < len; i++)
-- 
2.17.0
