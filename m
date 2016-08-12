Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57823 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbcHLJuH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:50:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for 4.8 1/2] pulse8-cec: set correct Signal Free Time
Date: Fri, 12 Aug 2016 11:49:56 +0200
Message-Id: <1470995397-47335-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470995397-47335-1-git-send-email-hverkuil@xs4all.nl>
References: <1470995397-47335-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't hardcode the signal free time to 3 bit periods, instead use
the value for the signal free time as passed in by the CEC framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 94f8590..28f853c 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -388,7 +388,7 @@ static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	int err;
 
 	cmd[0] = MSGCODE_TRANSMIT_IDLETIME;
-	cmd[1] = 3;
+	cmd[1] = signal_free_time;
 	err = pulse8_send_and_wait(pulse8, cmd, 2,
 				   MSGCODE_COMMAND_ACCEPTED, 1);
 	cmd[0] = MSGCODE_TRANSMIT_ACK_POLARITY;
-- 
2.8.1

