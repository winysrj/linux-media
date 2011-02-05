Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53474 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab1BEVxj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 16:53:39 -0500
Received: by fxm20 with SMTP id 20so3639741fxm.19
        for <linux-media@vger.kernel.org>; Sat, 05 Feb 2011 13:53:38 -0800 (PST)
Message-ID: <4D4DC6DF.7020101@googlemail.com>
Date: Sat, 05 Feb 2011 22:53:35 +0100
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH] cx25840: fix probing of cx2583x chips
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix the probing of cx2583x chips, because two controls were clustered 
that are not created for these chips.

This regression was introduced in 2.6.36.

Signed-off-by: Sven Barth <pascaldragon@googlemail.com>

diff -aur linux-2.6.37/drivers/media/video/cx25840/cx25840-core.c 
linux-2.6.37-patched/drivers/media/video/cx25840/cx25840-core.c
--- linux-2.6.37/drivers/media/video/cx25840/cx25840-core.c	2011-01-05 
00:50:19.000000000 +0000
+++ linux-2.6.37-patched/drivers/media/video/cx25840/cx25840-core.c 
2011-02-05 15:58:27.733325238 +0000
@@ -2031,7 +2031,8 @@
  		kfree(state);
  		return err;
  	}
-	v4l2_ctrl_cluster(2, &state->volume);
+	if (!is_cx2583x(state))
+		v4l2_ctrl_cluster(2, &state->volume);
  	v4l2_ctrl_handler_setup(&state->hdl);

  	cx25840_ir_probe(sd);
