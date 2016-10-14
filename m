Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59073 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756547AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH 03/57] [media] firewire: don't break long lines
Date: Fri, 14 Oct 2016 17:19:51 -0300
Message-Id: <9ef158ab98e90748612c9294fff02a621a1accea.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/firewire/firedtv-avc.c | 5 +++--
 drivers/media/firewire/firedtv-rc.c  | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
index 251a556112a9..e04235ea23fb 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1181,8 +1181,9 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		if (es_info_length > 0) {
 			pmt_cmd_id = msg[read_pos++];
 			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
-				dev_err(fdtv->device, "invalid pmt_cmd_id %d "
-					"at stream level\n", pmt_cmd_id);
+				dev_err(fdtv->device,
+					"invalid pmt_cmd_id %d at stream level\n",
+					pmt_cmd_id);
 
 			if (es_info_length > sizeof(c->operand) - 4 -
 					     write_pos) {
diff --git a/drivers/media/firewire/firedtv-rc.c b/drivers/media/firewire/firedtv-rc.c
index f82d4a93feb3..babfb9cee20e 100644
--- a/drivers/media/firewire/firedtv-rc.c
+++ b/drivers/media/firewire/firedtv-rc.c
@@ -184,8 +184,9 @@ void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
 	else if (code >= 0x4540 && code <= 0x4542)
 		code = oldtable[code - 0x4521];
 	else {
-		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
-		       "from remote control\n", code);
+		printk(KERN_DEBUG
+		       "firedtv: invalid key code 0x%04x from remote control\n",
+		       code);
 		return;
 	}
 
-- 
2.7.4


