Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:39641 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1EHPvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 11:51:38 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH 3/6] drxd: Fix warning caused by new entries in an enum
Date: Sun,  8 May 2011 16:51:10 +0100
Message-Id: <1304869873-9974-4-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4DC417DA.5030107@redhat.com>
References: <4DC417DA.5030107@redhat.com>
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
 drivers/media/dvb/frontends/drxd_hard.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 30a78af..f1d64f1 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -2325,6 +2325,9 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 		   InitEC and ResetEC
 		   functions */
 		switch (p->bandwidth) {
+		default:
+			printk(KERN_INFO "drxd: Unsupported bandwidth mode %u, reverting to default\n",
+				p->bandwidth);
 		case BANDWIDTH_AUTO:
 		case BANDWIDTH_8_MHZ:
 			/* (64/7)*(8/8)*1000000 */
-- 
1.7.1

