Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60713 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3AYXUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 18:20:13 -0500
Received: from mailout-de.gmx.net ([10.1.76.30]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MPb5D-1U2zAg2u13-004mzn for
 <linux-media@vger.kernel.org>; Sat, 26 Jan 2013 00:20:11 +0100
From: Peter Huewe <peterhuewe@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	David Howells <dhowells@redhat.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging/media/go7007: Use kmemdup rather than duplicating its implementation
Date: Sat, 26 Jan 2013 00:23:30 +0100
Message-Id: <1359156210-4482-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found with coccicheck.
The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/media/go7007/go7007-driver.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..0e299f0 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -108,14 +108,13 @@ static int go7007_load_encoder(struct go7007 *go)
 		return -1;
 	}
 	fw_len = fw_entry->size - 16;
-	bounce = kmalloc(fw_len, GFP_KERNEL);
+	bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
 	if (bounce == NULL) {
 		v4l2_err(go, "unable to allocate %d bytes for "
 				"firmware transfer\n", fw_len);
 		release_firmware(fw_entry);
 		return -1;
 	}
-	memcpy(bounce, fw_entry->data + 16, fw_len);
 	release_firmware(fw_entry);
 	if (go7007_interface_reset(go) < 0 ||
 			go7007_send_firmware(go, bounce, fw_len) < 0 ||
-- 
1.7.8.6

