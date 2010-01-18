Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tlenz@vorgon.com>) id 1NWkco-0003Go-1j
	for linux-dvb@linuxtv.org; Mon, 18 Jan 2010 06:58:06 +0100
Received: from mout.perfora.net ([74.208.4.195])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NWkcn-0005Lc-By; Mon, 18 Jan 2010 06:58:05 +0100
Message-ID: <4B53F864.3030608@vorgon.com>
Date: Sun, 17 Jan 2010 22:57:56 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem loading cx23885
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Trying to update a vdr system from kernel 2.6.26.8 and v4l drivers which 
I seem to have gotten 5/19/2009
9655c8cfeed8db5400551b7aeb916f05744f02fa 1275
9655c8cfeed8db5400551b7aeb916f05744f02fa default

I just tried building v4l using what I got on 12/29/2009. 
.hg/branch.cache says
799e3b75489ea4e3470e13399c264da799c76ed7 1320
799e3b75489ea4e3470e13399c264da799c76ed7 default

This version was before the posted patch that disables cx23885 for 
released kernel versions.

Tried building with kernel 2.6.32.2 and when I tried to load the drivers 
I got:

WARNING: Error inserting cx23885 
(/lib/modules/2.6.32.2.20100117.1/kernel/drivers/media/video/c 
      x23885/cx23885.ko): Unknown symbol in module, or unknown parameter 
(see dmesg)
WARNING: Error inserting ir_kbd_i2c 
(/lib/modules/2.6.32.2.20100117.1/kernel/drivers/media/vide 
o/ir-kbd-i2c.ko): Unknown symbol in module, or unknown parameter (see dmesg)

Nothing in dmesg, but /var/logs/messages had at the end:

Jan 17 14:43:08 LLLx64-32 kernel: Linux video capture interface: v2.00
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol 
ir_codes_hauppauge_new_table
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_rc5_timer_keyup
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_input_init
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_input_nokey
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_rc5_decode
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol 
ir_input_unregister
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_input_keydown
Jan 17 14:43:08 LLLx64-32 kernel: cx23885: Unknown symbol ir_input_register
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_empty_table
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_pv951_table
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_fusionhdtv_mce_table
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_hauppauge_new_table
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol ir_input_init
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol ir_input_nokey
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_input_unregister
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_rc5_tv_table
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_input_keydown
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_input_register
Jan 17 14:43:08 LLLx64-32 kernel: ir_kbd_i2c: Unknown symbol 
ir_codes_avermedia_cardbus_table

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
