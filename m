Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55984 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756840AbbEVOAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/11] cx24120: fix sparse warning
Date: Fri, 22 May 2015 15:59:43 +0200
Message-Id: <1432303184-8594-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/cx24120.c:837:6: warning: symbol 'cx24120_calculate_ber_window' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/cx24120.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index a14d0f1..6880cd2 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -834,7 +834,7 @@ static int cx24120_get_fec(struct dvb_frontend *fe)
 }
 
 /* Calculate ber window time */
-void cx24120_calculate_ber_window(struct cx24120_state *state, u32 rate)
+static void cx24120_calculate_ber_window(struct cx24120_state *state, u32 rate)
 {
 	struct dvb_frontend *fe = &state->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-- 
2.1.4

