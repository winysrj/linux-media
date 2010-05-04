Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab0EDOD3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 10:03:29 -0400
Date: Tue, 4 May 2010 10:03:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] IR/imon: remove dead IMON_KEY_RELEASE_OFFSET
Message-ID: <20100504140318.GA10813@redhat.com>
References: <20100504122030.GX29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504122030.GX29093@bicker>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This hack was used when the imon driver was using internal key lookup
routines, but became dead weight when the driver was converted to use
ir-core's key lookup routines. These bits simply didn't get removed,
drop 'em now.

Pointed out by Dan Carpenter.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/imon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/imon.c b/drivers/media/IR/imon.c
index 27743eb..bce8ef8 100644
--- a/drivers/media/IR/imon.c
+++ b/drivers/media/IR/imon.c
@@ -55,7 +55,6 @@
 #define BIT_DURATION	250	/* each bit received is 250us */
 
 #define IMON_CLOCK_ENABLE_PACKETS	2
-#define IMON_KEY_RELEASE_OFFSET		1000
 
 /*** P R O T O T Y P E S ***/
 
@@ -1205,7 +1204,7 @@ static u32 imon_panel_key_lookup(u64 hw_code)
 		if (imon_panel_key_table[i].hw_code == (code | 0xffee))
 			break;
 
-	keycode = imon_panel_key_table[i % IMON_KEY_RELEASE_OFFSET].keycode;
+	keycode = imon_panel_key_table[i].keycode;
 
 	return keycode;
 }

-- 
Jarod Wilson
jarod@redhat.com

