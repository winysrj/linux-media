Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:47629 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726868AbeH0QPV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 12:15:21 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] drm/i2c/tda9950.c: set MAX_RETRIES for errors only
Message-ID: <6109476a-e8fa-6d82-3ed8-3833f0f18615@xs4all.nl>
Date: Mon, 27 Aug 2018 14:28:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC_TX_STATUS_MAX_RETRIES should be set for errors only to
prevent the CEC framework from retrying the transmit. If the
transmit was successful, then don't set this flag.

Found by running 'cec-compliance -A' on a beaglebone box.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/i2c/tda9950.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda9950.c b/drivers/gpu/drm/i2c/tda9950.c
index 5d2f0d548469..4a14fc3b5011 100644
--- a/drivers/gpu/drm/i2c/tda9950.c
+++ b/drivers/gpu/drm/i2c/tda9950.c
@@ -191,7 +191,8 @@ static irqreturn_t tda9950_irq(int irq, void *data)
 			break;
 		}
 		/* TDA9950 executes all retries for us */
-		tx_status |= CEC_TX_STATUS_MAX_RETRIES;
+		if (tx_status != CEC_TX_STATUS_OK)
+			tx_status |= CEC_TX_STATUS_MAX_RETRIES;
 		cec_transmit_done(priv->adap, tx_status, arb_lost_cnt,
 				  nack_cnt, 0, err_cnt);
 		break;
-- 
2.18.0
