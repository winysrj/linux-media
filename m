Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57267 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752218AbeGDO57 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 10:57:59 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: bpf: ensure bpf program is freed on detach
Date: Wed,  4 Jul 2018 15:57:58 +0100
Message-Id: <20180704145758.14363-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently we are leaking bpf programs when they are detached from the
lirc device; the refcount never reaches zero.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/bpf-lirc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index fcfab6635f9c..81b150e5dfdb 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -174,6 +174,7 @@ static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
 
 	rcu_assign_pointer(raw->progs, new_array);
 	bpf_prog_array_free(old_array);
+	bpf_prog_put(prog);
 unlock:
 	mutex_unlock(&ir_raw_handler_lock);
 	return ret;
-- 
2.17.1
