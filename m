Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36770 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbcCASrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 13:47:03 -0500
Received: by mail-pf0-f172.google.com with SMTP id l6so20197514pfl.3
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2016 10:47:03 -0800 (PST)
Date: Wed, 2 Mar 2016 00:17:00 +0530
From: RitwikGopi <ritwikgopi@gmail.com>
To: jarod@wilsonet.com
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
	linux-media@vger.kernel.org, ritwikgopi@gmail.com
Subject: [PATCH] Staging: media/lirc: lirc_zilog.c : fixed a string split in
 multi-line issue
Message-ID: <20160301184659.GA25553@stark-labz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a quoted string split in to multiple line issue(Actually fixed 2 warnings since it was split in to 3 lines.)

Signed-off-by: Ritwik G <ritwikgopi@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index ce3b5f2..3551aed 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1680,9 +1680,7 @@ module_init(zilog_init);
 module_exit(zilog_exit);
 
 MODULE_DESCRIPTION("Zilog/Hauppauge infrared transmitter driver (i2c stack)");
-MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, "
-	      "Ulrich Mueller, Stefan Jahn, Jerome Brock, Mark Weaver, "
-	      "Andy Walls");
+MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, Ulrich Mueller, Stefan Jahn, Jerome Brock, Mark Weaver, Andy Walls");
 MODULE_LICENSE("GPL");
 /* for compat with old name, which isn't all that accurate anymore */
 MODULE_ALIAS("lirc_pvr150");
-- 
2.5.0

