Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62829 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754729AbeDWM3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:29:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] media: flexcop-i2c: get rid of KERN_CONT
Date: Mon, 23 Apr 2018 08:29:09 -0400
Message-Id: <bdc55e212dd60e8918151ddaa337931870ac254b.1524486539.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity complains about werid stuff at the debug logic:

	CID 113542 (#1 of 1): Out-of-bounds access (ARRAY_VS_SINGLETON)10.
	callee_ptr_arith: Passing buf to function flexcop_i2c_write4
	which uses it as an array. This might corrupt or misinterpret
	adjacent memory locations.

Instead of directly addressing the issue there, let's rework at
the logic there.

On newer kernels, KERN_CONT does nothing, as the previous message
won't wait for a continuation. Also, both flexcop_i2c_read4() and
flexcop_i2c_write4(), called by it, will print stuff if (debug &4).

So, the way it is is too buggy.

There are two kinds of debug stuff there: deb_i2c() and a code hidden
under #ifdef DUMP_I2C_MESSAGES, with can't be selected without touching
the source code.

Also, if both debug & 0x4 and DUMP_I2C_MESSAGES, flexcop_i2c_request()
will emit two debug messages per call with different data,
with sounds messy.

Simplify it by getting rid of DUMP_I2C_MESSAGES and adding a new
flag to debug (0x40), and making the debug logic there more
consistent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/b2c2/flexcop-i2c.c | 47 +++++++++++++--------------------
 drivers/media/common/b2c2/flexcop.c     |  2 +-
 drivers/media/common/b2c2/flexcop.h     |  1 +
 3 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-i2c.c b/drivers/media/common/b2c2/flexcop-i2c.c
index 564da6fa900d..db2f3b19abf7 100644
--- a/drivers/media/common/b2c2/flexcop-i2c.c
+++ b/drivers/media/common/b2c2/flexcop-i2c.c
@@ -105,40 +105,36 @@ static int flexcop_i2c_write4(struct flexcop_device *fc,
 }
 
 int flexcop_i2c_request(struct flexcop_i2c_adapter *i2c,
-		flexcop_access_op_t op, u8 chipaddr, u8 addr, u8 *buf, u16 len)
+			flexcop_access_op_t op, u8 chipaddr,
+			u8 start_addr, u8 *buf, u16 size)
 {
 	int ret;
-
-#ifdef DUMP_I2C_MESSAGES
-	int i;
-#endif
+	int len = size;
+	u8 *p;
+	u8 addr = start_addr;
 
 	u16 bytes_to_transfer;
 	flexcop_ibi_value r100;
 
-	deb_i2c("op = %d\n",op);
+	deb_i2c("port %d %s(%02x): register %02x, size: %d\n",
+		i2c->port,
+		op == FC_READ ? "rd" : "wr",
+	        chipaddr, start_addr, size);
 	r100.raw = 0;
 	r100.tw_sm_c_100.chipaddr = chipaddr;
 	r100.tw_sm_c_100.twoWS_rw = op;
 	r100.tw_sm_c_100.twoWS_port_reg = i2c->port;
 
-#ifdef DUMP_I2C_MESSAGES
-	printk(KERN_DEBUG "%d ", i2c->port);
-	if (op == FC_READ)
-		printk(KERN_CONT "rd(");
-	else
-		printk(KERN_CONT "wr(");
-	printk(KERN_CONT "%02x): %02x ", chipaddr, addr);
-#endif
-
 	/* in that case addr is the only value ->
 	 * we write it twice as baseaddr and val0
 	 * BBTI is doing it like that for ISL6421 at least */
 	if (i2c->no_base_addr && len == 0 && op == FC_WRITE) {
-		buf = &addr;
+		buf = &start_addr;
 		len = 1;
 	}
 
+	p = buf;
+
 	while (len != 0) {
 		bytes_to_transfer = len > 4 ? 4 : len;
 
@@ -146,26 +142,21 @@ int flexcop_i2c_request(struct flexcop_i2c_adapter *i2c,
 		r100.tw_sm_c_100.baseaddr = addr;
 
 		if (op == FC_READ)
-			ret = flexcop_i2c_read4(i2c, r100, buf);
+			ret = flexcop_i2c_read4(i2c, r100, p);
 		else
-			ret = flexcop_i2c_write4(i2c->fc, r100, buf);
-
-#ifdef DUMP_I2C_MESSAGES
-		for (i = 0; i < bytes_to_transfer; i++)
-			printk(KERN_CONT "%02x ", buf[i]);
-#endif
+			ret = flexcop_i2c_write4(i2c->fc, r100, p);
 
 		if (ret < 0)
 			return ret;
 
-		buf  += bytes_to_transfer;
+		p  += bytes_to_transfer;
 		addr += bytes_to_transfer;
 		len  -= bytes_to_transfer;
 	}
-
-#ifdef DUMP_I2C_MESSAGES
-	printk(KERN_CONT "\n");
-#endif
+	deb_i2c_dump("port %d %s(%02x): register %02x: %*ph\n",
+		i2c->port,
+		op == FC_READ ? "rd" : "wr",
+	        chipaddr, start_addr, size, buf);
 
 	return 0;
 }
diff --git a/drivers/media/common/b2c2/flexcop.c b/drivers/media/common/b2c2/flexcop.c
index 2e0ab55cd67e..cbaa61f10d5f 100644
--- a/drivers/media/common/b2c2/flexcop.c
+++ b/drivers/media/common/b2c2/flexcop.c
@@ -42,7 +42,7 @@ int b2c2_flexcop_debug;
 EXPORT_SYMBOL_GPL(b2c2_flexcop_debug);
 module_param_named(debug, b2c2_flexcop_debug,  int, 0644);
 MODULE_PARM_DESC(debug,
-		"set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able))."
+		"set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg,64=i2cdump (|-able))."
 		DEBSTATUS);
 #undef DEBSTATUS
 
diff --git a/drivers/media/common/b2c2/flexcop.h b/drivers/media/common/b2c2/flexcop.h
index 911ece59ea02..486fe2380b92 100644
--- a/drivers/media/common/b2c2/flexcop.h
+++ b/drivers/media/common/b2c2/flexcop.h
@@ -26,5 +26,6 @@ extern int b2c2_flexcop_debug;
 #define deb_ts(args...) dprintk(0x08, args)
 #define deb_sram(args...) dprintk(0x10, args)
 #define deb_rdump(args...) dprintk(0x20, args)
+#define deb_i2c_dump(args...) dprintk(0x40, args)
 
 #endif
-- 
2.14.3
