Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36526 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdCNWXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 18:23:53 -0400
Received: by mail-wr0-f193.google.com with SMTP id l37so25513269wrc.3
        for <linux-media@vger.kernel.org>; Tue, 14 Mar 2017 15:23:52 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends/drxk: don't log errors on unsupported operation mode
Date: Tue, 14 Mar 2017 23:22:37 +0100
Message-Id: <20170314222237.10365-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When fe_ops.read_status is called and no channel is tuned (yet), the
subsequent calls to get_lock_status() causes the kernel log to be filled
with

    drxk: Error -22 on get_lock_status

which either means a NULL pointer was passed for the p_lock_status var,
or neither QAM nor OFDM/DVBT operation mode are active. Instead of
filling the kernel log in the latter case, print out a message to the debug
level and return 0 (this isn't used in the calling drxk_get_stats() anyway).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/drxk_hard.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 7e1bbba..b5ea919 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -1904,7 +1904,9 @@ static int get_lock_status(struct drxk_state *state, u32 *p_lock_status)
 		status = get_dvbt_lock_status(state, p_lock_status);
 		break;
 	default:
-		break;
+		pr_debug("Unsupported operation mode %d in %s\n",
+			state->m_operation_mode, __func__);
+		return 0;
 	}
 error:
 	if (status < 0)
-- 
2.10.2
