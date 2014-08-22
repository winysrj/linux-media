Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60486 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbaHVK6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 11/21] si2157: Add support for delivery system SYS_ATSC
Date: Fri, 22 Aug 2014 13:58:03 +0300
Message-Id: <1408705093-5167-12-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Set the property for delivery system also in case of SYS_ATSC. This
behaviour is observed in the sniffs taken with Hauppauge HVR-955Q
Windows driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 2281b7d..efb5cce 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -238,6 +238,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		bandwidth = 0x0f;
 
 	switch (c->delivery_system) {
+	case SYS_ATSC:
+			delivery_system = 0x00;
+			break;
 	case SYS_DVBT:
 	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
 			delivery_system = 0x20;
-- 
http://palosaari.fi/

