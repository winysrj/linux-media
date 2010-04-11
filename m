Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DKDUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 23:20:13 -0400
Date: Sun, 11 Apr 2010 00:20:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] ir-core: Fix the delete logic
Message-ID: <20100411002000.0ba27cdd@pedra>
In-Reply-To: <ccda6144bee4797ab2f2524c4c4fe43c964c56e2.1270955959.git.mchehab@redhat.com>
References: <ccda6144bee4797ab2f2524c4c4fe43c964c56e2.1270955959.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of removing an entry, the logic were doing both a deletion and
a key addition, as shown by the log:

[11517.323314] ir_getkeycode: unknown key for scancode 0x0050
[11517.326529] ir_do_setkeycode: #80: Deleting scan 0x0050
[11517.326529] ir_do_setkeycode: #80: New scan 0x0050 with key 0x0000
[11517.340598] ir_getkeycode: unknown key for scancode 0x0051
[11517.343811] ir_do_setkeycode: #81: Deleting scan 0x0051
[11517.343811] ir_do_setkeycode: #81: New scan 0x0051 with key 0x0000
[11517.357889] ir_getkeycode: unknown key for scancode 0x0052
[11517.361104] ir_do_setkeycode: #82: Deleting scan 0x0052
[11517.361104] ir_do_setkeycode: #82: New scan 0x0052 with key 0x0000
[11517.375453] ir_getkeycode: unknown key for scancode 0x0053
[11517.378474] ir_do_setkeycode: #83: Deleting scan 0x0053
[11517.378474] ir_do_setkeycode: #83: New scan 0x0053 with key 0x0000

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 01bddc4..f0eb680 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -126,7 +126,7 @@ static int ir_do_setkeycode(struct input_dev *dev,
 		break;
 	}
 
-	if (old_keycode == KEY_RESERVED) {
+	if (old_keycode == KEY_RESERVED && keycode != KEY_RESERVED) {
 		/* No previous mapping found, we might need to grow the table */
 		if (ir_resize_table(rc_tab))
 			return -ENOMEM;
-- 
1.6.6.1

