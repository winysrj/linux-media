Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58551 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab0AMXoC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 18:44:02 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:43:58 +0000
Message-ID: <1263426238.3852.131.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 11/11] dabusb: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Mauro,

You nacked my previous patches for media because they would result in
many false dependencies.  However, I think this driver at least will
always depend on the same files.

Ben.

 drivers/media/video/dabusb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index ee43876..9b413a3 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -913,6 +913,8 @@ static void __exit dabusb_cleanup (void)
 MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("dabusb/firmware.fw");
+MODULE_FIRMWARE("dabusb/bitstream.bin");
 
 module_param(buffers, int, 0);
 MODULE_PARM_DESC (buffers, "Number of buffers (default=256)");
-- 
1.6.5.7


