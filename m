Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33807 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2AOUu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:50:26 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: wait demod lock for DVB-C too
Date: Sun, 15 Jan 2012 22:50:11 +0200
Message-Id: <1326660611-9334-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix yet another bug introduced be recent cxd2820r multi-frontend to
single-frontend change.

Finally, we have at least almost working picture for DVB-C too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index b789a90..372a4e7 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -492,6 +492,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	/* frontend lock wait loop count */
 	switch (priv->delivery_system) {
 	case SYS_DVBT:
+	case SYS_DVBC_ANNEX_A:
 		i = 20;
 		break;
 	case SYS_DVBT2:
-- 
1.7.4.4

