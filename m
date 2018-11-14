Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39659 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbeKNSkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 13:40:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-pin: fix broken tx_ignore_nack_until_eom error injection
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <429529a0-b69b-9ff5-b5c3-bee0df9cd572@xs4all.nl>
Date: Wed, 14 Nov 2018 09:37:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the tx_ignore_nack_until_eom error injection was activated,
then tx_nacked was never set instead of setting it when the last
byte of the message was transmitted.

As a result the transmit was marked as OK, when it should have
been NACKed.

Modify the condition so that it always sets tx_nacked when the
last byte of the message was transmitted.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.17 and up
---
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index 635db8e70ead..8f987bc0dd88 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -601,8 +601,9 @@ static void cec_pin_tx_states(struct cec_pin *pin, ktime_t ts)
 			break;
 		/* Was the message ACKed? */
 		ack = cec_msg_is_broadcast(&pin->tx_msg) ? v : !v;
-		if (!ack && !pin->tx_ignore_nack_until_eom &&
-		    pin->tx_bit / 10 < pin->tx_msg.len && !pin->tx_post_eom) {
+		if (!ack && (!pin->tx_ignore_nack_until_eom ||
+		    pin->tx_bit / 10 == pin->tx_msg.len - 1) &&
+		    !pin->tx_post_eom) {
 			/*
 			 * Note: the CEC spec is ambiguous regarding
 			 * what action to take when a NACK appears
