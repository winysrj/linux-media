Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52861 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbdBTUds (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 15:33:48 -0500
Received: from linux.local ([88.67.44.205]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MYOCL-1csmpk0gqn-00VCTh for
 <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 21:33:45 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v1 1/2] ir-ctl: use strndup instead of strndupa (fixes musl compile)
Date: Mon, 20 Feb 2017 21:33:43 +0100
Message-Id: <20170220203344.17530-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes buildroot musl compile (see [1], [2]):

  ir-ctl.c:(.text+0xb06): undefined reference to `strndupa'

[1] http://autobuild.buildroot.net/results/b8b96c7bbf2147dacac62485cbfdbcfd758271a5
[2] http://lists.busybox.net/pipermail/buildroot/2017-February/184048.html

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/ir-ctl/ir-ctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index bc58cee0..f938b429 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -344,12 +344,14 @@ static struct file *read_scancode(const char *name)
 		return NULL;
 	}
 
-	pstr = strndupa(name, p - name);
+	pstr = strndup(name, p - name);
 
 	if (!protocol_match(pstr, &proto)) {
 		fprintf(stderr, _("error: protocol '%s' not found\n"), pstr);
+		free(pstr);
 		return NULL;
 	}
+	free(pstr);
 
 	if (!strtoscancode(p + 1, &scancode)) {
 		fprintf(stderr, _("error: invalid scancode '%s'\n"), p + 1);
-- 
2.11.0
