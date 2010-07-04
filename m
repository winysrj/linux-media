Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0GDQyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Jul 2010 12:54:21 -0400
Message-ID: <4C30B78D.8040903@redhat.com>
Date: Sun, 04 Jul 2010 13:32:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] support for Hauppauge WinTV MiniStic IR remote
References: <20100615162305.GA4585@linux-m68k.org>
In-Reply-To: <20100615162305.GA4585@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-06-2010 13:23, Richard Zidlicky escreveu:
> Hi,
> 
> I have guessed which gpio line to use and activated the ir-remote receiver.
> The keymap seems to work fairly well with the supplied DSR-0112 remote, mostly
> tested it with xev as I do not have a working lircd on this computer.
> 
> The patch is against 2.6.34.

There are a few CodingStyle issues. Also, please send your Signed-off-by:

Cheers,
Mauro

patching file drivers/media/dvb/siano/smsir.h
patching file drivers/media/dvb/siano/smsir.c
patching file drivers/media/dvb/siano/sms-cards.c
Patch applies OK
WARNING: please, no space before tabs
#77: FILE: drivers/media/dvb/siano/smsir.c:73:
+^I^I^I^I^IKEY_CHANNELUP, ^IKEY_CHANNELDOWN,$

WARNING: line over 80 characters
#115: FILE: drivers/media/dvb/siano/smsir.c:313:
+	key_map = keyboard_layout_maps[coredev->ir.ir_kb_type].keyboard_layout_map;

ERROR: trailing whitespace
#116: FILE: drivers/media/dvb/siano/smsir.c:314:
+^I^I$

WARNING: space prohibited between function name and open parenthesis '('
#117: FILE: drivers/media/dvb/siano/smsir.c:315:
+	memset (input_dev->keybit, 0, sizeof(input_dev->keybit));

ERROR: spaces required around that '=' (ctx:VxV)
#118: FILE: drivers/media/dvb/siano/smsir.c:316:
+	for (i=0; i<IR_KEYBOARD_LAYOUT_SIZE; i++) {
 	      ^

ERROR: spaces required around that '<' (ctx:VxV)
#118: FILE: drivers/media/dvb/siano/smsir.c:316:
+	for (i=0; i<IR_KEYBOARD_LAYOUT_SIZE; i++) {
 	           ^

WARNING: space prohibited between function name and open parenthesis '('
#120: FILE: drivers/media/dvb/siano/smsir.c:318:
+			set_bit (key_map[i], input_dev->keybit);

ERROR: Missing Signed-off-by: line(s)

total: 4 errors, 4 warnings, 79 lines checked

patches/lmml_106247_support_for_hauppauge_wintv_ministic_ir_remote.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
