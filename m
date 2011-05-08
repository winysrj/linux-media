Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:55401 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1EHTRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 15:17:39 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH v2 2/5] drxd: Fix warning caused by new entries in an enum
Date: Sun,  8 May 2011 20:17:17 +0100
Message-Id: <1304882240-23044-3-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC6BF28.8070006@redhat.com>
References: <4DC6BF28.8070006@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Additional bandwidth modes have been added in frontend.h
drxd_hard.c had no default case so the compiler was warning about
a non-exhausive switch statement.

This has been fixed by making the default behaviour the same as
BANDWIDTH_AUTO, with the addition of a printk to notify if this
ever happens.

Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/dvb/frontends/drxd_hard.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 30a78af..b3b0704 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2325,6 +2325,10 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 		   InitEC and ResetEC
 		   functions */
 		switch (p->bandwidth) {
+		default:
+			printk(KERN_INFO "drxd: Unsupported bandwidth mode %u, reverting to default\n",
+				p->bandwidth);
+			/* Fall back to auto */
 		case BANDWIDTH_AUTO:
 		case BANDWIDTH_8_MHZ:
 			/* (64/7)*(8/8)*1000000 */
-- 
1.7.1

