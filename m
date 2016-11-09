Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51635 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752871AbcKIPWd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 10:22:33 -0500
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: zero counters in cec_received_msg()
Message-ID: <37753590-ebe6-363a-5e5f-8207c89d2d1d@xs4all.nl>
Date: Wed, 9 Nov 2016 16:22:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the TX counters are zeroed in the cec_msg struct.
Non-zero TX counters make no sense when a message is received,
and applications should not see non-zero values here.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
This sits on top of my earlier cec pull request that moves cec to the 
mainline.
---
  drivers/media/cec/cec-adap.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index ed76d70..d9c6f2c 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -874,6 +874,10 @@ void cec_received_msg(struct cec_adapter *adap, 
struct cec_msg *msg)
  	msg->sequence = msg->reply = msg->timeout = 0;
  	msg->tx_status = 0;
  	msg->tx_ts = 0;
+	msg->tx_arb_lost_cnt = 0;
+	msg->tx_nack_cnt = 0;
+	msg->tx_low_drive_cnt = 0;
+	msg->tx_error_cnt = 0;
  	msg->flags = 0;
  	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);

-- 
2.7.0

