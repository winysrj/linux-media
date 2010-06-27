Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0F0LTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 07:19:40 -0400
Message-ID: <4C2733BC.7080101@redhat.com>
Date: Sun, 27 Jun 2010 08:19:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] ir-core: convert em28xx to not use ir-functions.c
References: <20100607192830.21236.69701.stgit@localhost.localdomain> <20100607193223.21236.36477.stgit@localhost.localdomain> <4C2726B7.3050306@redhat.com>
In-Reply-To: <4C2726B7.3050306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-06-2010 07:23, Mauro Carvalho Chehab escreveu:
> Em 07-06-2010 16:32, David Härdeman escreveu:
>> Convert drivers/media/video/em28xx/em28xx-input.c to not use ir-functions.c
>>
>> Signed-off-by: David Härdeman <david@hardeman.nu>
> 
> This patch caused a bad effect: if some key were pressed before loading the driver, it
> causes endless repetitions of the last keycode:
> 
> [ 2126.019882] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
> [ 2126.126629] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
> [ 2126.233253] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
> [ 2126.339875] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
> [ 2126.446625] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
> 
> I'll try to fix it and apply a patch to solve it.

Hmm.. in a matter of fact, the problem were in the printk... it were generating one line for
each poll interval.

After fixing it, your patch looks ok:

[ 3072.019846] em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 1, key 0x1e01
[ 3072.028390] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e01 keycode 0x02
[ 3072.036655] ir_keydown: em28xx IR (em28xx #0): key down event, key 0x0002, scancode 0x1e01
[ 3072.143218] em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 2, key 0x1e01
[ 3072.151773] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e01 keycode 0x02
[ 3072.409709] ir_keyup: keyup key 0x0002

Also, the test for read_count > 0 is not needed, and, in fact, can cause loosing one key when
the 6-bits wide repetition counter reaches their maximum value:

[ 3484.999804] em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 127, key 0x1e02
[ 3485.116431] em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 0, key 0x1e02

---

em28xx-input: Don't generate one debug message for every get_key read

Instead of generating one printk for every IR read, prints it only when 
count is different from the last count.

While here, as this code is called on every 100ms during the runtime 
lifetime, do some performance optimization, assuming that, under normal 
circumstances, it is unlikely that the driver would get a new key/key
repeat on every poll.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index dd6d528..6759cd5 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -292,18 +292,15 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 
 	/* read the registers containing the IR status */
 	result = ir->get_key(ir, &poll_result);
-	if (result < 0) {
+	if (unlikely(result < 0)) {
 		dprintk("ir->get_key() failed %d\n", result);
 		return;
 	}
 
-	dprintk("ir->get_key result tb=%02x rc=%02x lr=%02x data=%02x%02x\n",
-		poll_result.toggle_bit, poll_result.read_count,
-		ir->last_readcount, poll_result.rc_address,
-		poll_result.rc_data[0]);
-
-	if (poll_result.read_count > 0 &&
-	    poll_result.read_count != ir->last_readcount) {
+	if (unlikely(poll_result.read_count != ir->last_readcount)) {
+		dprintk("%s: toggle: %d, count: %d, key 0x%02x%02x\n", __func__,
+			poll_result.toggle_bit, poll_result.read_count,
+			poll_result.rc_address, poll_result.rc_data[0]);
 		if (ir->full_code)
 			ir_keydown(ir->input,
 				   poll_result.rc_address << 8 |
@@ -313,17 +310,17 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 			ir_keydown(ir->input,
 				   poll_result.rc_data[0],
 				   poll_result.toggle_bit);
-	}
 
-	if (ir->dev->chip_id == CHIP_ID_EM2874)
-		/* The em2874 clears the readcount field every time the
-		   register is read.  The em2860/2880 datasheet says that it
-		   is supposed to clear the readcount, but it doesn't.  So with
-		   the em2874, we are looking for a non-zero read count as
-		   opposed to a readcount that is incrementing */
-		ir->last_readcount = 0;
-	else
-		ir->last_readcount = poll_result.read_count;
+		if (ir->dev->chip_id == CHIP_ID_EM2874)
+			/* The em2874 clears the readcount field every time the
+			   register is read.  The em2860/2880 datasheet says that it
+			   is supposed to clear the readcount, but it doesn't.  So with
+			   the em2874, we are looking for a non-zero read count as
+			   opposed to a readcount that is incrementing */
+			ir->last_readcount = 0;
+		else
+			ir->last_readcount = poll_result.read_count;
+	}
 }
 
 static void em28xx_ir_work(struct work_struct *work)
