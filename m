Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40960
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755990AbdEROGy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:06:54 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [PATCH 2/4] [media] imon: better code the pad_mouse toggling
Date: Thu, 18 May 2017 11:06:44 -0300
Message-Id: <cdce7df07641f6f364a241bfa77ba76ade9cae68.1495116400.git.mchehab@s-opensource.com>
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic with toggles the pad_mouse is confusing. Now, gcc 7.1
complains about it:

drivers/media/rc/imon.c: In function 'imon_incoming_scancode':
drivers/media/rc/imon.c:1725:23: warning: '~' on a boolean expression [-Wbool-operation]
    ictx->pad_mouse = (~ictx->pad_mouse) & 0x1;
                       ^
drivers/media/rc/imon.c:1725:23: note: did you mean to use logical not?
    ictx->pad_mouse = (~ictx->pad_mouse) & 0x1;
                       ^
                       !

Rewrite it to be clearer for both code reviewers and gcc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3489010601b5..9c510fe54b2a 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1722,7 +1722,7 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 	if (kc == KEY_KEYBOARD && !ictx->release_code) {
 		ictx->last_keycode = kc;
 		if (!nomouse) {
-			ictx->pad_mouse = ~(ictx->pad_mouse) & 0x1;
+			ictx->pad_mouse = !(ictx->pad_mouse & 0x1);
 			dev_dbg(dev, "toggling to %s mode\n",
 				ictx->pad_mouse ? "mouse" : "keyboard");
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
-- 
2.9.3
