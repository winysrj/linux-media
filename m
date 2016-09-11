Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38257 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752650AbcIKJDK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 05:03:10 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
        by tschai.lan (Postfix) with ESMTPSA id 6813018026F
        for <linux-media@vger.kernel.org>; Sun, 11 Sep 2016 11:03:04 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pulse8-cec: fix compiler warning
Message-ID: <a9826651-11bb-4141-328f-cbe6cd456c6f@xs4all.nl>
Date: Sun, 11 Sep 2016 11:03:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pulse8-cec.c: In function 'pulse8_connect':
pulse8-cec.c:447:2: warning: 'pa' may be used uninitialized in this function [-Wmaybe-uninitialized]
  cec_s_phys_addr(pulse8->adap, pa, false);
  ^
pulse8-cec.c:609:6: note: 'pa' was declared here
  u16 pa;
      ^

As far as I can tell, this can't actually happen. Still, it is better to just
initialize it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index cb6a2a3..13e8f61 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -606,7 +606,7 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
 	struct pulse8 *pulse8;
 	int err = -ENOMEM;
 	struct cec_log_addrs log_addrs = {};
-	u16 pa;
+	u16 pa = CEC_PHYS_ADDR_INVALID;

 	pulse8 = kzalloc(sizeof(*pulse8), GFP_KERNEL);

-- 
2.8.1

