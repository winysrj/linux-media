Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210Ab0KQPZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 10:25:46 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHFPk6O019731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 10:25:46 -0500
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHFPjbs010104
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 10:25:46 -0500
Date: Wed, 17 Nov 2010 10:25:45 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] streamzap: merge timeout space with trailing space
Message-ID: <20101117152545.GA24814@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There are cases where we get an ending space, and our trailing timeout
space then gets sent right after it, which breaks repeat, at least for
lirc userspace decoding. Merge the two spaces by way of using
ir_raw_event_store_filter, set a timeout value, and we're back to good.

Successfully tested with streamzap and windows mce remotes.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/streamzap.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 7781910..19652d4 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -137,7 +137,9 @@ static struct usb_driver streamzap_driver = {
 
 static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 {
-	ir_raw_event_store(sz->rdev, &rawir);
+	dev_dbg(sz->dev, "Storing %s with duration %u us\n",
+		(rawir.pulse ? "pulse" : "space"), rawir.duration);
+	ir_raw_event_store_with_filter(sz->rdev, &rawir);
 }
 
 static void sz_push_full_pulse(struct streamzap_ir *sz,
@@ -164,7 +166,6 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 			rawir.duration *= 1000;
 			rawir.duration &= IR_MAX_DURATION;
 		}
-		dev_dbg(sz->dev, "ls %u\n", rawir.duration);
 		sz_push(sz, rawir);
 
 		sz->idle = false;
@@ -177,7 +178,6 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 	sz->sum += rawir.duration;
 	rawir.duration *= 1000;
 	rawir.duration &= IR_MAX_DURATION;
-	dev_dbg(sz->dev, "p %u\n", rawir.duration);
 	sz_push(sz, rawir);
 }
 
@@ -197,7 +197,6 @@ static void sz_push_full_space(struct streamzap_ir *sz,
 	rawir.duration += SZ_RESOLUTION / 2;
 	sz->sum += rawir.duration;
 	rawir.duration *= 1000;
-	dev_dbg(sz->dev, "s %u\n", rawir.duration);
 	sz_push(sz, rawir);
 }
 
@@ -218,8 +217,6 @@ static void streamzap_callback(struct urb *urb)
 	struct streamzap_ir *sz;
 	unsigned int i;
 	int len;
-	static int timeout = (((SZ_TIMEOUT * SZ_RESOLUTION * 1000) &
-				IR_MAX_DURATION) | 0x03000000);
 
 	if (!urb)
 		return;
@@ -243,7 +240,7 @@ static void streamzap_callback(struct urb *urb)
 
 	dev_dbg(sz->dev, "%s: received urb, len %d\n", __func__, len);
 	for (i = 0; i < len; i++) {
-		dev_dbg(sz->dev, "sz idx %d: %x\n",
+		dev_dbg(sz->dev, "sz->buf_in[%d]: %x\n",
 			i, (unsigned char)sz->buf_in[i]);
 		switch (sz->decoder_state) {
 		case PulseSpace:
@@ -270,7 +267,7 @@ static void streamzap_callback(struct urb *urb)
 				DEFINE_IR_RAW_EVENT(rawir);
 
 				rawir.pulse = false;
-				rawir.duration = timeout;
+				rawir.duration = sz->rdev->timeout;
 				sz->idle = true;
 				if (sz->timeout_enabled)
 					sz_push(sz, rawir);
@@ -430,6 +427,8 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 	sz->decoder_state = PulseSpace;
 	/* FIXME: don't yet have a way to set this */
 	sz->timeout_enabled = true;
+	sz->rdev->timeout = (((SZ_TIMEOUT * SZ_RESOLUTION * 1000) &
+				IR_MAX_DURATION) | 0x03000000);
 	#if 0
 	/* not yet supported, depends on patches from maxim */
 	/* see also: LIRC_GET_REC_RESOLUTION and LIRC_SET_REC_TIMEOUT */
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

