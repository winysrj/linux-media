Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:50038 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab0AFWEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 17:04:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	"Igor M. Liplianin" <liplianin@me.by>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: dvb/zl10039, jump to error on error
Date: Wed,  6 Jan 2010 23:04:07 +0100
Message-Id: <1262815447-4555-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stanse found an unreachable statement in zl10039_attach. There is
a `break' followed by `goto error'. Remove that break, so that it
can handle the error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Igor M. Liplianin <liplianin@me.by>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/frontends/zl10039.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/zl10039.c b/drivers/media/dvb/frontends/zl10039.c
index 11b29cb..c085e58 100644
--- a/drivers/media/dvb/frontends/zl10039.c
+++ b/drivers/media/dvb/frontends/zl10039.c
@@ -287,7 +287,6 @@ struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 		break;
 	default:
 		dprintk("Chip ID=%x does not match a known type\n", state->id);
-		break;
 		goto error;
 	}
 
-- 
1.6.5.7

