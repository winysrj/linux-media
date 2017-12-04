Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45861 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753525AbdLDI45 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 03:56:57 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-adap: add '0x' prefix when printing status
Message-ID: <a284aa68-2292-1532-aa45-6fe5b69b979c@xs4all.nl>
Date: Mon, 4 Dec 2017 09:56:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's not clear if the transmit status that is printed when debugging
is enabled is hex or decimal. Add 0x prefix to make this explicit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 9219dc96d575..2a097e016414 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -540,7 +540,7 @@ void cec_transmit_done_ts(struct cec_adapter *adap, u8 status,
 	unsigned int attempts_made = arb_lost_cnt + nack_cnt +
 				     low_drive_cnt + error_cnt;

-	dprintk(2, "%s: status %02x\n", __func__, status);
+	dprintk(2, "%s: status 0x%02x\n", __func__, status);
 	if (attempts_made < 1)
 		attempts_made = 1;

-- 
2.14.1
