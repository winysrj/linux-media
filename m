Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1963 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3JDOCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [PATCH 08/14] fmdrv_common: fix sparse warning
Date: Fri,  4 Oct 2013 16:01:46 +0200
Message-Id: <1380895312-30863-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/radio/wl128x/fmdrv_common.c:178:6: warning: symbol 'g_st_write' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Manjunatha Halli <manjunatha_halli@ti.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 253f307..4b2e9e8 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -175,7 +175,7 @@ static int_handler_prototype int_handler_table[] = {
 	fm_irq_handle_intmsk_cmd_resp
 };
 
-long (*g_st_write) (struct sk_buff *skb);
+static long (*g_st_write) (struct sk_buff *skb);
 static struct completion wait_for_fmdrv_reg_comp;
 
 static inline void fm_irq_call(struct fmdev *fmdev)
-- 
1.8.3.2

