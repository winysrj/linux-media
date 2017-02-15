Return-path: <linux-media-owner@vger.kernel.org>
Received: from cadetblue.ash.relay.mailchannels.net ([23.83.222.28]:36978 "EHLO
        cadetblue.ash.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752800AbdBOXGc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 18:06:32 -0500
Date: Wed, 15 Feb 2017 16:27:01 -0600
Message-ID: <20170215162701.Horde.XvDp43m8Ix1AzjBYbMccaA7@ocean.mxroute.com>
From: dc@cako.io
To: linux-media@vger.kernel.org
Cc: jarod@wilsonet.com, mchehab@kernel.org
Subject: [PATCH] staging: media: use octal permissions
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace all instances of permission macros with octal permissions

Signed-off-by: David Cako <dc@cako.io>
---
  drivers/staging/media/lirc/lirc_parallel.c | 10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c  
b/drivers/staging/media/lirc/lirc_parallel.c
index 0a43bac2b..94d2c61 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -756,17 +756,17 @@ MODULE_DESCRIPTION("Infrared receiver driver for  
parallel ports.");
  MODULE_AUTHOR("Christoph Bartelmus");
  MODULE_LICENSE("GPL");

-module_param(io, int, S_IRUGO);
+module_param(io, int, 0444);
  MODULE_PARM_DESC(io, "I/O address base (0x3bc, 0x378 or 0x278)");

-module_param(irq, int, S_IRUGO);
+module_param(irq, int, 0444);
  MODULE_PARM_DESC(irq, "Interrupt (7 or 5)");

-module_param(tx_mask, int, S_IRUGO);
+module_param(tx_mask, int, 0444);
  MODULE_PARM_DESC(tx_mask, "Transmitter mask (default: 0x01)");

-module_param(debug, bool, S_IRUGO | S_IWUSR);
+module_param(debug, bool, 0644);
  MODULE_PARM_DESC(debug, "Enable debugging messages");

-module_param(check_pselecd, bool, S_IRUGO | S_IWUSR);
+module_param(check_pselecd, bool, 0644);
  MODULE_PARM_DESC(check_pselecd, "Check for printer (default: 0)");
-- 
2.7.4
