Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0KOL2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 06:28:06 -0500
Received: by fxm6 with SMTP id 6so1636978fxm.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 03:28:05 -0800 (PST)
Date: Mon, 15 Nov 2010 12:27:46 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: stefano.pompa@gmail.com
Subject: Hauppauge WinTV MiniStick IR in 2.6.36 - [PATCH]
Message-ID: <20101115112746.GB6607@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

for some users (thats at least one user in Italy and me) the following is required:

--- linux-2.6.36/drivers/media/dvb/siano/sms-cards.c.rz 2010-11-15 11:16:56.000000000 +0100
+++ linux-2.6.36/drivers/media/dvb/siano/sms-cards.c    2010-11-15 11:54:25.000000000 +0100
@@ -17,6 +17,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+//#include <media/ir-kbd-i2c.h>
+//#include <media/ir-core.h>
+
 #include "sms-cards.h"
 #include "smsir.h"
 
@@ -64,7 +67,7 @@
                .type   = SMS_NOVA_B0,
                .fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
                .fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
-               .rc_codes = RC_MAP_RC5_HAUPPAUGE_NEW,
+               .rc_codes = RC_MAP_DIB0700_RC5_TABLE,
                .board_cfg.leds_power = 26,
                .board_cfg.led0 = 27,
                .board_cfg.led1 = 28,

What is the way to achieve the effect without recompiling the kernel - is there any?
Could we combine the keymaps - as I understand it all RC5 maps could be combined into
one huge map without any problems except memory usage?

Richard
