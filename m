Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48394 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbcEKHLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 03:11:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] cec: remove WARN_ON
Date: Wed, 11 May 2016 09:11:27 +0200
Message-Id: <1462950688-23290-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
References: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If a transmit is issued and before cec_transmit_done() is called the HDMI cable
is unplugged, then it is possible that adap->transmitting == NULL.

So drop the WARN_ON, explain why it can happen and just ignore the tranmit.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index 3c5f084..9a62aa2 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -485,9 +485,13 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 	dprintk(2, "cec_transmit_done %02x\n", status);
 	mutex_lock(&adap->lock);
 	data = adap->transmitting;
-	if (WARN_ON(data == NULL)) {
-		/* This is weird and should not happen. Ignore this transmit */
-		dprintk(0, "cec_transmit_done without an ongoing transmit!\n");
+	if (data == NULL) {
+		/*
+		 * This can happen if a transmit was issued and the cable is
+		 * unplugged while the transmit is ongoing. Ignore this
+		 * transmit in that case.
+		 */
+		dprintk(1, "cec_transmit_done without an ongoing transmit!\n");
 		goto unlock;
 	}
 
-- 
2.8.1

