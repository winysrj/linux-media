Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:12029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0L3LvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 06:51:10 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBpA3O002434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:51:10 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBjLCo031659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:51:07 -0500
Date: Thu, 30 Dec 2010 09:45:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] cx88: Add RC logic for Leadtek PVR 2000
Message-ID: <20101230094510.56bfb97a@gaivota>
In-Reply-To: <cover.1293709356.git.mchehab@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Currently, lirc-i2c has a decoding logic for Leadtek Remote
Control. Move it to cx88, as we intend to remove lirc-i2c.

For now, initialize LIRC remote keytable with RC_MAP_EMPTY, as
we don't know its keymap yet. It would be nice to later check
if is there any file on LIRC userspace with that keytable.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 4a3bf54..06f7d1d 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -68,6 +68,9 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 #define ir_dprintk(fmt, arg...)	if (ir_debug) \
 	printk(KERN_DEBUG "%s IR: " fmt , ir->core->name , ##arg)
 
+#define dprintk(fmt, arg...)	if (ir_debug) \
+	printk(KERN_DEBUG "cx88 IR: " fmt , ##arg)
+
 /* ---------------------------------------------------------------------- */
 
 static void cx88_ir_handle_key(struct cx88_IR *ir)
@@ -527,13 +530,47 @@ void cx88_ir_irq(struct cx88_core *core)
 	ir_raw_event_handle(ir->dev);
 }
 
+static int get_key_pvr2000(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	int flags, code;
+
+	/* poll IR chip */
+	flags = i2c_smbus_read_byte_data(ir->c, 0x10);
+	if (flags < 0) {
+		dprintk("read error\n");
+		return 0;
+	}
+	/* key pressed ? */
+	if (0 == (flags & 0x80))
+		return 0;
+
+	/* read actual key code */
+	code = i2c_smbus_read_byte_data(ir->c, 0x00);
+	if (code < 0) {
+		dprintk("read error\n");
+		return 0;
+	}
+
+	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
+		   code & 0xff, flags & 0xff);
+
+	*ir_key = code & 0xff;
+	*ir_raw = code;
+	return 1;
+}
+
 void cx88_i2c_init_ir(struct cx88_core *core)
 {
 	struct i2c_board_info info;
-	const unsigned short addr_list[] = {
+	const unsigned short default_addr_list[] = {
 		0x18, 0x6b, 0x71,
 		I2C_CLIENT_END
 	};
+	const unsigned short pvr2000_addr_list[] = {
+		0x18, 0x1a,
+		I2C_CLIENT_END
+	};
+	const unsigned short *addr_list = default_addr_list;
 	const unsigned short *addrp;
 	/* Instantiate the IR receiver device, if present */
 	if (0 != core->i2c_rc)
@@ -542,6 +579,16 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 
+	switch (core->boardnr) {
+	case CX88_BOARD_LEADTEK_PVR2000:
+		addr_list = pvr2000_addr_list;
+		core->init_data.name = "cx88 Leadtek PVR 2000 remote";
+		core->init_data.type = RC_TYPE_UNKNOWN;
+		core->init_data.get_key = get_key_pvr2000;
+		core->init_data.ir_codes = RC_MAP_EMPTY;
+		break;
+	}
+
 	/*
 	 * We can't call i2c_new_probed_device() because it uses
 	 * quick writes for probing and at least some RC receiver
-- 
1.7.3.4


