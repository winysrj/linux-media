Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:33400 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbcGTI7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 04:59:50 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C994318048D
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2016 10:59:42 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: don't handle CEC_MSG_SET_STREAM_PATH
Message-ID: <c76367b7-5b64-a67e-b025-6f7e224f3770@xs4all.nl>
Date: Wed, 20 Jul 2016 10:59:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vivid shouldn't process the CEC_MSG_SET_STREAM_PATH message: this will confuse
userspace follower code because it isn't aware of the state change of becoming
an active source.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index 66aa729..f9f878b 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -169,7 +169,6 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 	struct vivid_dev *dev = adap->priv;
 	struct cec_msg reply;
 	u8 dest = cec_msg_destination(msg);
-	u16 pa;
 	u8 disp_ctl;
 	char osd[14];

@@ -178,15 +177,6 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 	cec_msg_init(&reply, dest, cec_msg_initiator(msg));

 	switch (cec_msg_opcode(msg)) {
-	case CEC_MSG_SET_STREAM_PATH:
-		if (cec_is_sink(adap))
-			return -ENOMSG;
-		cec_ops_set_stream_path(msg, &pa);
-		if (pa != adap->phys_addr)
-			return -ENOMSG;
-		cec_msg_active_source(&reply, adap->phys_addr);
-		cec_transmit_msg(adap, &reply, false);
-		break;
 	case CEC_MSG_SET_OSD_STRING:
 		if (!cec_is_sink(adap))
 			return -ENOMSG;
