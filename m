Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1453 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3JDOCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/14] drxk_hard: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:45 +0200
Message-Id: <1380895312-30863-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/drxk_hard.c:1086:62: warning: Using plain integer as NULL pointer
drivers/media/dvb-frontends/drxk_hard.c:2784:63: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/drxk_hard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 082014d..d416c15 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -1083,7 +1083,7 @@ static int hi_cfg_command(struct drxk_state *state)
 			 SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 	if (status < 0)
 		goto error;
-	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
+	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, NULL);
 	if (status < 0)
 		goto error;
 
@@ -2781,7 +2781,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool b_enable_bridge)
 			goto error;
 	}
 
-	status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
+	status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, NULL);
 
 error:
 	if (status < 0)
-- 
1.8.3.2

