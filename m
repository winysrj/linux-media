Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35162 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbcGOONz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 10:13:55 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D4F21180A30
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 16:13:49 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: cec: set timestamp for selfie transmits
Message-ID: <814b8ac4-670b-8289-2236-242564068282@xs4all.nl>
Date: Fri, 15 Jul 2016 16:13:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Attempts to send CEC messages to yourself are detected in the framework and
returned with a NACK error. However, the tx_ts was never filled in that case.
So just set it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index ca34339..bf25875 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -612,6 +612,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 			 * easy to handle it here so the behavior will be
 			 * consistent.
 			 */
+			msg->tx_ts = ktime_get_ns();
 			msg->tx_status = CEC_TX_STATUS_NACK |
 					 CEC_TX_STATUS_MAX_RETRIES;
 			msg->tx_nack_cnt = 1;
