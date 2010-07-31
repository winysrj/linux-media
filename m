Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41835 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab0GaRWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 13:22:24 -0400
Subject: [PATCH] IR keymap: Add print button for HP OEM version of MCE
 remote
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Jon Smirl <jonsmirl@gmail.com>, Jarod Wilson <jarod@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 13:23:04 -0400
Message-ID: <1280596984.20879.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a defintion for the "Print" button found on HP OEM
versions of the MCE remote.  All of the other keys found on the HP OEM
version of the remote match the other keys as already defined.

Because, who doesn't need "remote printing", while one is sitting on the
couch across from one's PC? ;)

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

diff --git a/drivers/media/IR/keymaps/rc-rc6-mce.c b/drivers/media/IR/keymaps/rc
index c6726a8..3edda53 100644
--- a/drivers/media/IR/keymaps/rc-rc6-mce.c
+++ b/drivers/media/IR/keymaps/rc-rc6-mce.c
@@ -74,6 +74,8 @@ static struct ir_scancode rc6_mce[] = {
        { 0x800f045a, KEY_SUBTITLE }, /* Caption/Teletext */
        { 0x800f044d, KEY_TITLE },
 
+       { 0x800f044e, KEY_PRINT }, /* Print - HP OEM version of remote */
+
        { 0x800f040c, KEY_POWER },
        { 0x800f040d, KEY_PROG1 }, /* Windows MCE button */
 


