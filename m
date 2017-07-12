Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40794 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750738AbdGLUHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 16:07:12 -0400
Subject: [PATCH for 4.13] cec: cec_transmit_attempt_done: ignore
 CEC_TX_STATUS_MAX_RETRIES
To: linux-media@vger.kernel.org
References: <20170711133011.41139-1-hverkuil@xs4all.nl>
 <20170711133011.41139-4-hverkuil@xs4all.nl>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <106e748e-afe5-027b-0284-80e2928d1661@xs4all.nl>
Date: Wed, 12 Jul 2017 22:07:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170711133011.41139-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The switch in cec_transmit_attempt_done() should ignore the
CEC_TX_STATUS_MAX_RETRIES status bit.

Calling this function with e.g. CEC_TX_STATUS_NACK | CEC_TX_STATUS_MAX_RETRIES
is perfectly legal and should not trigger the WARN(1).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
After testing the DisplayPort CEC-Tunneling-over-AUX support with an adapter
that didn't hook up the CEC pin correctly I found a bug in this CEC core function
that is corrected with this patch.
---
 drivers/media/cec/cec-adap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bf45977b2823..d596b601ff42 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -559,7 +559,7 @@ EXPORT_SYMBOL_GPL(cec_transmit_done);

 void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status)
 {
-	switch (status) {
+	switch (status & ~CEC_TX_STATUS_MAX_RETRIES) {
 	case CEC_TX_STATUS_OK:
 		cec_transmit_done(adap, status, 0, 0, 0, 0);
 		return;
-- 
2.11.0
