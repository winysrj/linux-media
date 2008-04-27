Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JpvBj-0002w9-8t
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 02:56:26 +0200
From: Andy Walls <awalls@radix.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1209254711.28704.10.camel@palomino.walls.org>
References: <1209254711.28704.10.camel@palomino.walls.org>
Content-Type: multipart/mixed; boundary="=-sV+RHV5oDC78+HMX+wCS"
Date: Sat, 26 Apr 2008 20:35:41 -0400
Message-Id: <1209256541.28704.37.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] [PATCH 2/2] mxl500x: debug module param and
	checkpatch.pl	compliance
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-sV+RHV5oDC78+HMX+wCS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Patch 2/2: checkpatch.pl compliance for mxl500x

This patch implements checkpatch.pl compliance for mxl500x source files,
out of tree, using the v4l/scripts/checkpatch.pl scripts v 0.14.

The command

   $ find . -name "mxl500*" \
      -exec ../v4l/scripts/checkpatch.pl -q  --summary-file --notree --terse --file {} \; \
      | sed 's/:[0-9]*:/:/' | sort | uniq -c


initially returned:

      1 ./drivers/media/dvb/frontends/mxl500x.c: ERROR: do not use assignment in if condition
     44 ./drivers/media/dvb/frontends/mxl500x.c: ERROR: do not use C99 // comments
      1 ./drivers/media/dvb/frontends/mxl500x.c: ERROR: need a space before the open parenthesis '('
      7 ./drivers/media/dvb/frontends/mxl500x.c: ERROR: need space after that ',' (ctx:VxV)
      1 ./drivers/media/dvb/frontends/mxl500x.c total: 53 errors, 111 warnings, 1254 lines checked
      1 ./drivers/media/dvb/frontends/mxl500x.c: WARNING: braces {} are not necessary for single statement blocks
    107 ./drivers/media/dvb/frontends/mxl500x.c: WARNING: line over 80 characters
      3 ./drivers/media/dvb/frontends/mxl500x.c: WARNING: no space between function name and open parenthesis '('
      1 ./drivers/media/dvb/frontends/mxl500x.h: ERROR: do not use C99 // comments
      1 ./drivers/media/dvb/frontends/mxl500x.h total: 1 errors, 2 warnings, 109 lines checked
      2 ./drivers/media/dvb/frontends/mxl500x.h: WARNING: line over 80 characters
      1 ./drivers/media/dvb/frontends/mxl500x_reg.h: ERROR: do not use C99 // comments
      1 ./drivers/media/dvb/frontends/mxl500x_reg.h total: 1 errors, 9 warnings, 494 lines checked
      9 ./drivers/media/dvb/frontends/mxl500x_reg.h: WARNING: line over 80 characters

but now all warnings and errors are cleaned up.  (If you use the
--strict switch you'll see two "#if 0"'s I had to add to convert a bunch
of C99 comments to a mix of c89 comments and code that shouldn't be
run.)

Although I have reviewed and tested the changes, I really need another
set of eyes to check some things:

1. The macros in mxl500x_reg.h were long and used a few identical, hard
to parse (for a human) idioms. I used 3 new helper macros to get them
into a shorter, (subjectively) more readable form.  Please check that
nothing got lost in the translation.  Does anyone object that I changed
them in that way?

2. The MXL500x_SET_MAP macro in mxl500x.c was brought into compliance
with Documentation/CodingStyle and now calls the MXL500x_SETFIELD macro
in mxl500x_reg.h.  Again, please make sure I didn't lose anything in the
translation.

3. There are 2 "#if 0" blocks in mxl500x.c for mixed code/comments that
I didn't know if I should get rid of.  Please tell me if there was a
more acceptable way of commenting out those lines, or if they can be
removed all together.

4. When doing the cleanup, I noticed some apparent "MXL500x_DC1" to
"DC2_DN_" mismatches.  You can see some in the patch.  Can anyone
confirm that this is correct?

Regards,
Andy

--=-sV+RHV5oDC78+HMX+wCS
Content-Disposition: attachment; filename=mxl500x-checkpatch-cleanup.patch
Content-Type: text/x-patch; name=mxl500x-checkpatch-cleanup.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

# HG changeset patch
# User Andy Walls <awalls@radix.net>
# Date 1209253646 14400
# Node ID 3d9bbefb64a8d0d9ba746d2296cc41b31080bcb1
# Parent  979f9052fc7e4df5841244aad0bc0868bfe6c155
mxl500x checkpatch.pl compliance clean-up

From: Andy Walls <awalls@radix.net>

Clean up mxl500x.* source files to satisfy the checkpatch.pl script out of tree


Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 979f9052fc7e -r 3d9bbefb64a8 linux/drivers/media/dvb/frontends/mxl500x.c
--- a/linux/drivers/media/dvb/frontends/mxl500x.c	Thu Apr 24 23:02:08 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/mxl500x.c	Sat Apr 26 19:47:26 2008 -0400
@@ -71,7 +71,7 @@ struct mxl500x_state {
 };
 
 
-// Register init
+/* Register init */
 /* These are the default register values (in memory) */
 static struct mxl500x_reg reg_init[] = {
 
@@ -198,7 +198,8 @@ enum mxl_latch_t {
 
 #define MXL500x_LOWIF_TH	6280000
 
-static int mxl500x_write(struct mxl500x_state *state, u8 reg, u8 data, enum mxl_latch_t latch)
+static int mxl500x_write(struct mxl500x_state *state, u8 reg, u8 data,
+			 enum mxl_latch_t latch)
 {
 	struct dvb_frontend *fe = state->frontend;
 	const struct mxl500x_config *config = state->config;
@@ -259,7 +260,10 @@ static int mxl500x_write_regs(struct mxl
 			goto exit;
 	}
 	dprintk(1, "%s: Registers to Write=%d\n", __func__, count);
-	/* Look at the regs, copy those regs from the field map to the xfer buffer */
+	/*
+	 * Look at the regs,
+	 * copy those regs from the field map to the xfer buffer
+	 */
 	reg_nr = 0;
 	for (i = 0; i < count; i++) {
 		buf[2 * reg_nr + 0] = regs[i];
@@ -321,47 +325,59 @@ static int mxl500x_init(struct dvb_front
 	return 0;
 }
 
-#define MXL500x_SET_MAP(__reg, __field, __data)	({				\
-	u8 __tmp = mxl500x_get_reg(state, __reg);				\
-										\
-	(__tmp = (__tmp & (~(((1 << MXL500x_WIDTH_##__field) - 1) <<		\
-	MXL500x_OFFST_##__field))) | (__data << MXL500x_OFFST_##__field));	\
-										\
-	mxl500x_set_reg(state, __reg, __tmp);					\
-})
+#define MXL500x_SET_MAP(__reg, __field, __data)		  \
+	do {                                              \
+		u8 __tmp = mxl500x_get_reg(state, __reg); \
+		MXL500x_SETFIELD(__field, __tmp, __data); \
+		mxl500x_set_reg(state, __reg, __tmp);     \
+	} while (0)
 
 static void mxl500x_set_gpio(struct mxl500x_state *state, u8 gpio, u8 data)
 {
 	if (gpio == 1)
-		MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_1B, data ? 0:1);
-
-	// GPIO2 is not available
+		MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_1B,
+				data ? 0 : 1);
+
+	/* GPIO2 is not available */
+
 	if (gpio == 3) {
 		if (data == 1) {
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3, 0x0);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B, 0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3,
+					0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B,
+					0x0);
 		}
 		if (data == 0) {
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3, 0x1);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B, 0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3,
+					0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B,
+					0x1);
 		}
 		if (data == 3) { /* Tri-State */
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3, 0x0);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B, 0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3,
+					0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_3B,
+					0x1);
 		}
 	}
 	if (gpio == 4) {
 		if (data == 1) {
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4, 0x0);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B, 0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4,
+					0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B,
+					0x0);
 		}
 		if (data == 0) {
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4, 0x1);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B, 0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4,
+					0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B,
+					0x1);
 		}
 		if (data == 3) { /* Tri-State */
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4, 0x0);
-			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B, 0x1);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4,
+					0x0);
+			MXL500x_SET_MAP(MXL500x_MISC_TUNE3, MISC_TUNE3_GPIO_4B,
+					0x1);
 		}
 	}
 }
@@ -457,63 +473,72 @@ static void mxl500x_octfilter_c(struct m
 	MXL500x_SET_MAP(MXL500x_DAC1, DAC1_DAC_DIN_A, 0);
 
 	if (p->frequency >= 43000000 && p->frequency < 150000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0x0);
 		mxl500x_set_gpio(state, 3, 0); /* Bank 1 ON  */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 150000000 && p->frequency < 280000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0x0);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 2 ON  */
 		mxl500x_set_gpio(state, 4, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 280000000 && p->frequency < 360000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0x0);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 2 ON  */
 		mxl500x_set_gpio(state, 4, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 360000000 && p->frequency < 560000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0x0);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 560000000 && p->frequency < 580000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON  */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 29);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 580000000 && p->frequency < 630000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON  */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 630000000 && p->frequency < 700000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON  */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 16);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 700000000 && p->frequency < 760000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 7);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 4, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 760000000 && p->frequency <= 900000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_DIN_B, 0);
 		mxl500x_set_gpio(state, 3, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 2 OFF */
@@ -531,55 +556,64 @@ static void mxl500x_octfilter_ch(struct 
 	MXL500x_SET_MAP(MXL500x_DAC1, DAC1_DAC_DIN_A, 0);
 
 	if (p->frequency >= 43000000 && p->frequency < 150000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		mxl500x_set_gpio(state, 4, 0); /* Bank 1 ON  */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 150000000 && p->frequency < 280000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 ON  */
 		mxl500x_set_gpio(state, 3, 0); /* Bank 2 ON */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 280000000 && p->frequency < 360000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 0); /* Bank 2 ON  */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 360000000 && p->frequency < 560000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0); /* Bank 4 OFF */
+		/* Bank 4 OFF */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x0);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 560000000 && p->frequency < 580000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 580000000 && p->frequency < 630000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 0); /* Bank 3 ON  */
 	}
 	if (p->frequency >= 630000000 && p->frequency < 700000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 700000000 && p->frequency < 760000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 3 OFF */
 	}
 	if (p->frequency >= 760000000 && p->frequency < 900000000) {
-		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1); /* Bank 4 ON */
+		/* Bank 4 ON */
+		MXL500x_SET_MAP(MXL500x_DAC2, DAC2_DAC_A_ENABLE, 0x1);
 		mxl500x_set_gpio(state, 4, 1); /* Bank 1 OFF */
 		mxl500x_set_gpio(state, 3, 1); /* Bank 2 OFF */
 		mxl500x_set_gpio(state, 1, 1); /* Bank 3 OFF */
@@ -703,28 +737,34 @@ static int mxl500x_set_params(struct dvb
 	}
 
 	/* Use register defaults */
-	memcpy(state->reg_field, reg_init, sizeof (reg_init));
+	memcpy(state->reg_field, reg_init, sizeof(reg_init));
 
 	/* Step 1: Synthesizer RESET (Single AGC Mode) */
 	dprintk(1, "%s: Synthesizer RESET and latch\n", __func__);
-	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))  /* master reg, synth reset */
+	/* master reg, synth reset */
+	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))
 		goto exit;
 
 	/* Step 2: Block Init */
-	// OVERRIDE_1, 2, 3, 4 Set to 1
+	/* OVERRIDE_1, 2, 3, 4 Set to 1 */
 	MXL500x_SET_MAP(MXL500x_MISC1, MISC1_OVERRIDE1, 1); /* Override 1 */
 	MXL500x_SET_MAP(MXL500x_RFSYN4, RFSYN4_OVERRIDE2, 1); /* Override 2 */
 	MXL500x_SET_MAP(MXL500x_RFSYN6, RFSYN6_OVERRIDE3, 1); /* Override 3 */
 	MXL500x_SET_MAP(MXL500x_RFSYN7, RFSYN7_OVERRIDE4, 1); /* Override 4 */
-	// Downconverter control
-	MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_IQTN_AMP_CUT, 1); /* Digital mode, Analog:0 */
-	// Filter control
-	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_MODE, 0); /* Digital mode, Analog:1 */
-	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_BUF_0, 1); /* Digital mode, Analog: 0 */
-	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_BUF_0A, 1); /* Digital mode, Analog: 0 */
-	MXL500x_SET_MAP(MXL500x_LPF2, LPF2_BB_IQSWAP, 0); /* Digital mode, Analog: 1 */
+	/* Downconverter control */
+	/* Digital mode, Analog:0 */
+	MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_IQTN_AMP_CUT, 1);
+	/* Filter control */
+	/* Digital mode, Analog:1 */
+	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_MODE, 0);
+	/* Digital mode, Analog: 0 */
+	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_BUF_0, 1);
+	/* Digital mode, Analog: 0 */
+	MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_BUF_0A, 1);
+	/* Digital mode, Analog: 1 */
+	MXL500x_SET_MAP(MXL500x_LPF2, LPF2_BB_IQSWAP, 0);
 	MXL500x_SET_MAP(MXL500x_LPF2, LPF2_BB_INITSTATE_DLPF_TUNE, 0);
-	// Initialize LPF (Digital Mode)
+	/* Initialize LPF (Digital Mode) */
 	if (delsys == MXL500x_MODE_DVBT) {
 		switch (p->u.ofdm.bandwidth) {
 		case BANDWIDTH_8_MHZ:
@@ -745,70 +785,79 @@ static int mxl500x_set_params(struct dvb
 		/* ATSC/QAM = 6MHz default */
 		MXL500x_SET_MAP(MXL500x_LPF1, LPF1_BB_DLPF_BANDSEL, 3);
 	}
-	// Charge pump control
-	MXL500x_SET_MAP(MXL500x_RFSYN8, RFSYN8_RFSYN_CHP_GAIN, 5); /* Digital mode, Analog: 12 */
-	MXL500x_SET_MAP(MXL500x_RFSYN8, RFSYN8_RFSYN_EN_CHP_HIGAIN, 1); /* Digital mode, Analog: 0 */
-	// AGC TOP control
+	/* Charge pump control */
+	/* Digital mode, Analog: 12 */
+	MXL500x_SET_MAP(MXL500x_RFSYN8, RFSYN8_RFSYN_CHP_GAIN, 5);
+	/* Digital mode, Analog: 0 */
+	MXL500x_SET_MAP(MXL500x_RFSYN8, RFSYN8_RFSYN_EN_CHP_HIGAIN, 1);
+	/* AGC TOP control */
 	MXL500x_SET_MAP(MXL500x_AGC1, AGC1_AGC_IF, 0xb); /* TOP=252 */
 	MXL500x_SET_MAP(MXL500x_AGC1, AGC1_AGC_RF, 0xf);
 
-	// DAC Tracking filter
-	if(config->iflo_freq == 5380000) {
-		// IF Synthesizer control (Digital mode, 5.38MHz)
+	/* DAC Tracking filter */
+	if (config->iflo_freq == 5380000) {
+		/* IF Synthesizer control (Digital mode, 5.38MHz) */
 		MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, 0x07);
 		MXL500x_SET_MAP(MXL500x_IFSYN5, IFSYN5_IF_VCO_BIAS, 0x0c);
 	} else {
-		// IF Synthesizer control (Digital mode, 4.57MHz)
+		/* IF Synthesizer control (Digital mode, 4.57MHz) */
 		MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, 0x06);
 		MXL500x_SET_MAP(MXL500x_IFSYN5, IFSYN5_IF_VCO_BIAS, 0x08);
 	}
 
 	int_mod = config->ref_freq / config->xtal_freq;
 	MXL500x_SET_MAP(MXL500x_IFSYN1, IFSYN1_CHCAL_INT_MOD_IF, int_mod);
-	frac_mod = (config->ref_freq / 1000) - (config->xtal_freq / 1000) * int_mod;
+	frac_mod = (config->ref_freq / 1000);
+	frac_mod -= (config->xtal_freq / 1000) * int_mod;
 	frac_mod *= (2 << 15);
 	frac_mod /= (config->xtal_freq / 1000);
-	MXL500x_SET_MAP(MXL500x_IFSYN2, IFSYN2_CHCAL_FRAC_MOD_IF_MSB, (frac_mod >> 8));
-	MXL500x_SET_MAP(MXL500x_IFSYN3, IFSYN3_CHCAL_FRAC_MOD_IF_LSB, frac_mod & 0xff);
-	// IF Up converter control
+	MXL500x_SET_MAP(MXL500x_IFSYN2, IFSYN2_CHCAL_FRAC_MOD_IF_MSB,
+			(frac_mod >> 8));
+	MXL500x_SET_MAP(MXL500x_IFSYN3, IFSYN3_CHCAL_FRAC_MOD_IF_LSB,
+			frac_mod & 0xff);
+	/* IF Up converter control */
 	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_DRV_RES_SEL, 6);
-	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_I_DRIVER, 2); // Load = 200 ohms
-	// Anti alias filter control
+	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_I_DRIVER, 2); /* Load = 200 ohms */
+	/* Anti alias filter control */
 	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_EN_AAF, 1);
 	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_EN_3P, 1);
 	MXL500x_SET_MAP(MXL500x_IFUP2, IFUP2_EN_AUX_3P, 1);
 	MXL500x_SET_MAP(MXL500x_IFUP1, IFUP1_SEL_AAF_BAND, 0);
-	// Demodulator clock output
-	MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_ENCLK16_CLK_OUT, 0); /* disable clock output */
-	MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_SEL4_16B, 1); /* output divider */
-	// crystal control
-	MXL500x_SET_MAP(MXL500x_XTAL1, XTAL1_XTAL_CAPSELECT, 1); /* cap enabled */
+	/* Demodulator clock output */
+	/* disable clock output */
+	MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_ENCLK16_CLK_OUT, 0);
+	/* output divider */
+	MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_SEL4_16B, 1);
+	/* crystal control */
+	/* cap enabled */
+	MXL500x_SET_MAP(MXL500x_XTAL1, XTAL1_XTAL_CAPSELECT, 1);
 	MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_SEL_DBL, 1); /* Xtal=16MHz */
 	MXL500x_SET_MAP(MXL500x_RFSYN8, RFSYN8_RFSYN_R_DIV, 3); /* Xtal=16MHz */
 
 	if (config->rssi_ena) {
-		// RSSI control
+		/* RSSI control */
 		MXL500x_SET_MAP(MXL500x_RSSI4, RSSI4_SEQ_EXTSYNTHCALIF, 1);
 		MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_EXTDCCAL, 1);
 		MXL500x_SET_MAP(MXL500x_RSSI5, RSSI5_AGC_EN_RSSI, 1);
 		MXL500x_SET_MAP(MXL500x_RSSI1, RSSI1_RFA_ENCLKRFAGC, 1);
-		// RSSI reference point
+		/* RSSI reference point */
 		MXL500x_SET_MAP(MXL500x_RSSI1, RSSI1_RFA_RSSI_REF, 2);
 		MXL500x_SET_MAP(MXL500x_RSSI1, RSSI1_RFA_RSSI_REFH, 3);
 		MXL500x_SET_MAP(MXL500x_RSSI2, RSSI2_RFA_RSSI_REFL, 1);
-		// TOP
+		/* TOP */
 		MXL500x_SET_MAP(MXL500x_RSSI3, RSSI3_RFA_FLR, 0);
 		MXL500x_SET_MAP(MXL500x_RSSI3, RSSI3_RFA_CEIL, 12);
 	} else {
-		// RSSI control
+		/* RSSI control */
 		MXL500x_SET_MAP(MXL500x_RSSI4, RSSI4_SEQ_EXTSYNTHCALIF, 0);
 		MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_EXTDCCAL, 0);
 		MXL500x_SET_MAP(MXL500x_RSSI5, RSSI5_AGC_EN_RSSI, 0);
 		MXL500x_SET_MAP(MXL500x_RSSI1, RSSI1_RFA_ENCLKRFAGC, 0);
 	}
 
-	// miscellaneous controls
-	MXL500x_SET_MAP(MXL500x_MISC2, MISC2_SEQ_EXTIQFSMPULSE, 1); /* not analog low IF */
+	/* miscellaneous controls */
+	/* not analog low IF */
+	MXL500x_SET_MAP(MXL500x_MISC2, MISC2_SEQ_EXTIQFSMPULSE, 1);
 
 	MXL500x_SET_MAP(MXL500x_RSSI4, RSSI4_SEQ_EXTSYNTHCALIF, 1);
 	MXL500x_SET_MAP(MXL500x_DEMCLK, DEMCLK_SEQ_EXTDCCAL, 1);
@@ -856,16 +905,21 @@ static int mxl500x_set_params(struct dvb
 	else
 		MXL500x_SET_MAP(MXL500x_LPF2, LPF2_BB_IQSWAP, 1); /* High IF */
 
-	//11, 12, 13, 22, 43, 44, 53, 56, 59, 73, 76, 77, 91, 134, 135, 137, 147, 156, 166, 167, 168
-	// TODO! write registers (Init regs)
+	/*
+	 * 11, 12, 13, 22, 43, 44, 53, 56, 59, 73, 76, 77, 91, 134, 135, 137,
+	 * 147, 156, 166, 167, 168
+	 */
+	/* TODO! write registers (Init regs) */
 	dprintk(1, "%s: Writing Init Regs\n", __func__);
-	if (mxl500x_write_regs(state, mxl500x_init_regs, sizeof(mxl500x_init_regs)))
+	if (mxl500x_write_regs(state, mxl500x_init_regs,
+			       sizeof(mxl500x_init_regs)))
 		goto exit;
 
 	/* Step 3: ZIF Mode */
-	// Synthesizer reset
+	/* Synthesizer reset */
 	dprintk(1, "%s: Synthesizer RESET and latch\n", __func__);
-	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))  /* master reg, synth reset, latch */
+	/* master reg, synth reset, latch */
+	if (mxl500x_write(state, 0x09, 0xb1, MXL_LATCH))
 		goto exit;
 
 	if (p->frequency < 40000000)
@@ -874,56 +928,70 @@ static int mxl500x_set_params(struct dvb
 	if (p->frequency >= 40000000 && p->frequency <= 75000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 2);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 3);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 423)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 423)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 423)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 423)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 1);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 1);
 	}
 	if (p->frequency > 75000000 && p->frequency <= 100000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 3);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 222)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 222)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 222)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 222)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 1);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 1);
 	}
 	if (p->frequency > 100000000 && p->frequency <= 150000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 3);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 147)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 147)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 147)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 147)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 1);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 2);
 	}
 	if (p->frequency > 150000000 && p->frequency <= 200000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 3);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 9)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 9)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 9)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 9)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 1);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 2);
 	}
 	if (p->frequency > 200000000 && p->frequency <= 300000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 3);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 1);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 3);
 	}
 	if (p->frequency > 300000000 && p->frequency <= 650000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 1);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 0);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 3);
 	}
 	if (p->frequency > 650000000 && p->frequency <= 900000000) {
 		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_POLY, 3);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_RFGAIN, 2);
-		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0, (MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
-		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1, (MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_CAP_RFLPF_0,
+				(MXL500x_MSB(DC2_DN_CAP_RFLPF_0, 0)));
+		MXL500x_SET_MAP(MXL500x_DC1, DC1_DN_CAP_RFLPF_1,
+				(MXL500x_LSB(DC2_DN_CAP_RFLPF_0, 0)));
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_EN_VHFUHFBAR, 0);
 		MXL500x_SET_MAP(MXL500x_DC4, DC4_DN_GAIN_ADJUST, 3);
 	}
@@ -936,7 +1004,7 @@ static int mxl500x_set_params(struct dvb
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_IQTNBUF_AMP, 10);
 		MXL500x_SET_MAP(MXL500x_DC3, DC3_DN_IQTNGBFBIAS_BST, 1);
 	}
-	// Set RF synthesizer and LO path control
+	/* Set RF synthesizer and LO path control */
 	fmin_bin = 28000000, fmax_bin = 42500000;
 	if (p->frequency >= 40000000 && p->frequency <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_RFSYN6, RFSYN6_RFSYN_EN_OUTMUX, 1);
@@ -1057,23 +1125,32 @@ static int mxl500x_set_params(struct dvb
 		MXL500x_SET_MAP(MXL500x_DC2, DC2_DN_SEL_FREQ, 0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 4;
 	}
-	// Equation 3 RF synthesizer VCO Bias
-	eq_3 = (((f_max - p->frequency) / 1000) * 32) / ((f_max - f_min) / 1000) + 8;
+	/* Equation 3 RF synthesizer VCO Bias */
+	eq_3 = (((f_max - p->frequency) / 1000) * 32) / ((f_max - f_min) / 1000)
+		+ 8;
 	MXL500x_SET_MAP(MXL500x_RFSYN5, RFSYN5_RFSYN_VCO_BIAS, eq_3);
-	// Equation 4
+	/* Equation 4 */
 	eq_4 = (p->frequency * div / 1000) / (2 * config->xtal_freq * 2 / 1000);
 	MXL500x_SET_MAP(MXL500x_RFSYN1, RFSYN1_CHCAL_INT_MOD_RF, eq_4);
-	// Equation 5
-	eq_5 = ((2 << 17) * (p->frequency / 10000 * div - (eq_4 * (2 * config->xtal_freq * 2) / 10000))) / (2 * config->xtal_freq * 2 / 10000);
-
-	MXL500x_SET_MAP(MXL500x_RFSYN2, RFSYN2_CHCAL_FRAC_MOD_RF_2, ((eq_5 >> 10) & 0xff));
-	MXL500x_SET_MAP(MXL500x_RFSYN3, RFSYN3_CHCAL_FRAC_MOD_RF_1, ((eq_5 >>  2) & 0xff));
-	MXL500x_SET_MAP(MXL500x_RFSYN4, RFSYN4_CHCAL_FRAC_MOD_RF_0, (eq_5 & 0x03));
-	// Equation E5A
-	eq_5a = (((f_max - p->frequency) / 1000) * 4 / ((f_max - f_min) / 1000)) + 1;
+	/* Equation 5 */
+	eq_5 =  ((2 << 17)
+		 * (p->frequency / 10000 * div
+		    - (eq_4 * (2 * config->xtal_freq * 2) / 10000)))
+		/ (2 * config->xtal_freq * 2 / 10000);
+
+	MXL500x_SET_MAP(MXL500x_RFSYN2, RFSYN2_CHCAL_FRAC_MOD_RF_2,
+			((eq_5 >> 10) & 0xff));
+	MXL500x_SET_MAP(MXL500x_RFSYN3, RFSYN3_CHCAL_FRAC_MOD_RF_1,
+			((eq_5 >>  2) & 0xff));
+	MXL500x_SET_MAP(MXL500x_RFSYN4, RFSYN4_CHCAL_FRAC_MOD_RF_0,
+			(eq_5 & 0x03));
+	/* Equation E5A */
+	eq_5a = (((f_max - p->frequency) / 1000) * 4 / ((f_max - f_min) / 1000))
+		+ 1;
 	MXL500x_SET_MAP(MXL500x_RFSYN7, RFSYN7_RFSYN_LPF_R, eq_5a);
-	MXL500x_SET_MAP(MXL500x_RFSYN1, RFSYN1_CHCAL_EN_INT_RF, ((eq_5 == 0) ? 1:0));
-	// Set TG synthesizer
+	MXL500x_SET_MAP(MXL500x_RFSYN1, RFSYN1_CHCAL_EN_INT_RF,
+			((eq_5 == 0) ? 1 : 0));
+	/* Set TG synthesizer */
 	tg_lo = p->frequency - 750000;
 	if (tg_lo < 33000000)
 		return -1;
@@ -1081,78 +1158,102 @@ static int mxl500x_set_params(struct dvb
 	fmin_bin = 33000000, fmax_bin = 50000000;
 	if (tg_lo >= fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x6);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1, 0x0);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 36;
 	}
 	fmin_bin = 50000000, fmax_bin = 67000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1, 0x0);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 24;
 	}
 	fmin_bin = 67000000, fmax_bin = 100000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0xc);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 18;
 	}
 	fmin_bin = 100000000, fmax_bin = 150000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x8);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 12;
 	}
 	fmin_bin = 150000000, fmax_bin = 200000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x0);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x0);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x0);
 		f_min = fmin_bin, f_max = fmax_bin, div = 8;
 	}
 	fmin_bin = 200000000, fmax_bin = 300000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x8);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x1);
 		f_min = fmin_bin, f_max = fmax_bin, div = 6;
 	}
 	fmin_bin = 300000000, fmax_bin = 400000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x0);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x1);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x1);
 		f_min = fmin_bin, f_max = fmax_bin, div = 4;
 	}
 	fmin_bin = 400000000, fmax_bin = 600000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x8);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x3);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x3);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x1);
 		f_min = fmin_bin, f_max = fmax_bin, div = 3;
 	}
 	fmin_bin = 600000000, fmax_bin = 900000000;
 	if (tg_lo > fmin_bin && tg_lo <= fmax_bin) {
 		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_DIVVAL, 0x0);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,0x3);
-		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0, 0x1);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_LO_SELVAL_1,
+				0x3);
+		MXL500x_SET_MAP(MXL500x_IQCALSYN2, IQCALSYN2_TG_LO_SELVAL_0,
+				0x1);
 		f_min = fmin_bin, f_max = fmax_bin, div = 2;
 	}
 
-	// TG_DIV_VAL
-	tg_div = (tg_lo * div / 100000) * (mxl_ceil(config->xtal_freq, 1000000) * 100) / (config->xtal_freq / 1000);
-
-	if (tg_lo > 600000000) {
+	/* TG_DIV_VAL */
+	tg_div = (tg_lo * div / 100000)
+		 * (mxl_ceil(config->xtal_freq, 1000000) * 100)
+		 / (config->xtal_freq / 1000);
+
+	if (tg_lo > 600000000)
 		tg_div += 1;
-	}
-	MXL500x_SET_MAP(MXL500x_IQCALSYN3, IQCALSYN3_TG_DIV_VAL, (MXL500x_MSB(IQCALSYN4_TG_DIV_VAL, tg_div)));
-	MXL500x_SET_MAP(MXL500x_IQCALSYN4, IQCALSYN4_TG_DIV_VAL, (MXL500x_LSB(IQCALSYN4_TG_DIV_VAL, tg_div)));
+
+	MXL500x_SET_MAP(MXL500x_IQCALSYN3, IQCALSYN3_TG_DIV_VAL,
+			(MXL500x_MSB(IQCALSYN4_TG_DIV_VAL, tg_div)));
+	MXL500x_SET_MAP(MXL500x_IQCALSYN4, IQCALSYN4_TG_DIV_VAL,
+			(MXL500x_LSB(IQCALSYN4_TG_DIV_VAL, tg_div)));
 
 	f_max = 180000, f_min = 120000;
-	tg = (f_max * MXL500x_XTAL_INT - (tg_lo / 10000) * div * MXL500x_XTAL_INT) * 32 / ((f_max - f_min) * MXL500x_XTAL_INT) + 8;
+	tg = (f_max * MXL500x_XTAL_INT
+		- (tg_lo / 10000) * div * MXL500x_XTAL_INT) * 32
+	     / ((f_max - f_min) * MXL500x_XTAL_INT) + 8;
 	MXL500x_SET_MAP(MXL500x_IQCALSYN1, IQCALSYN1_TG_VCO_BIAS, tg);
 	switch (config->octf) {
 	case MXL500x_OCTF_OFF:
@@ -1170,31 +1271,42 @@ static int mxl500x_set_params(struct dvb
 	}
 
 	/* Step 4 */
-	// retrieve if divider
-	if_div = MXL500x_GETFIELD(IFSYN4_IF_DIVVAL, mxl500x_get_reg(state, MXL500x_IFSYN4));
+	/* retrieve if divider */
+	if_div = MXL500x_GETFIELD(IFSYN4_IF_DIVVAL,
+					mxl500x_get_reg(state, MXL500x_IFSYN4));
 	MXL500x_SET_MAP(MXL500x_MISC_TUNE1, MISC_TUNE1_SEQ_FSM_PULSE, 0);
 	MXL500x_SET_MAP(MXL500x_MISC_TUNE2, MISC_TUNE2_SEQ_EXTPOWERUP, 1);
 	MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, 8);
-	// Synthesizer LOAD Start
-//	dprintk(1, "%s: Synthesizer Load START\n", __func__);
-//	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH)) /* master reg, load start, don't latch */
-//		goto exit;
-	// write all changed regs (change regs)
-	// 14, 15, 16, 17, 22, 43, 68, 69, 70, 73, 92, 93, 106, 107, 108, 109, 110, 111, 112, 136, 138, 149
+#if 0
+	/* Synthesizer LOAD Start */
+	dprintk(1, "%s: Synthesizer Load START\n", __func__);
+	/* master reg, load start, don't latch */
+	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH))
+		goto exit;
+#endif
+	/* write all changed regs (change regs) */
+	/*
+	 * 14, 15, 16, 17, 22, 43, 68, 69, 70, 73, 92, 93, 106, 107, 108, 109,
+	 * 110, 111, 112, 136, 138, 149
+	 */
 	mxl500x_set_reg(state, 0x09, 0xf3);
 	dprintk(1, "%s: Setup changed registers\n", __func__);
-	if (mxl500x_write_regs(state, mxl500x_zif_regs, sizeof(mxl500x_zif_regs)))
+	if (mxl500x_write_regs(state, mxl500x_zif_regs,
+				sizeof(mxl500x_zif_regs)))
 		goto exit;
 
 	msleep(50); /* wait for calibration */
 	MXL500x_SET_MAP(MXL500x_MISC_TUNE1, MISC_TUNE1_SEQ_FSM_PULSE, 1);
 	MXL500x_SET_MAP(MXL500x_IFSYN4, IFSYN4_IF_DIVVAL, if_div);
-	// Synthesizer LOAD Start
-//	dprintk(1, "%s: Synthesizer Load START\n", __func__);
-//	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH)) /* master reg, load start, don't latch */
-//		goto exit;
-	// write regs
-	// 43, 136
+#if 0
+	/* Synthesizer LOAD Start */
+	dprintk(1, "%s: Synthesizer Load START\n", __func__);
+	/* master reg, load start, don't latch */
+	if (mxl500x_write(state, 0x09, 0xf2, MXL_NO_LATCH))
+	goto exit;
+#endif
+	/* write regs */
+	/* 43, 136 */
 	dprintk(1, "%s: Tuner go\n", __func__);
 	if (mxl500x_write_regs(state, mxl500x_go_regs, sizeof(mxl500x_go_regs)))
 		goto exit;
@@ -1228,7 +1340,8 @@ struct dvb_frontend *mxl500x_attach(stru
 	struct mxl500x_state *state;
 
 	dprintk(1, "%s: Attaching ...\n", __func__);
-	if ((state = kzalloc(sizeof (struct mxl500x_state), GFP_KERNEL)) == NULL) {
+	state = kzalloc(sizeof(struct mxl500x_state), GFP_KERNEL);
+	if (state == NULL) {
 		fe = NULL;
 		goto exit;
 	}
@@ -1236,7 +1349,7 @@ struct dvb_frontend *mxl500x_attach(stru
 	state->frontend	= fe;
 	state->i2c	= i2c;
 
-	memcpy(&fe->ops.tuner_ops, &mxl500x_ops, sizeof (struct dvb_tuner_ops));
+	memcpy(&fe->ops.tuner_ops, &mxl500x_ops, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv	= state;
 
 	dprintk(1, "%s: MXL500x tuner succesfully attached\n", __func__);
diff -r 979f9052fc7e -r 3d9bbefb64a8 linux/drivers/media/dvb/frontends/mxl500x.h
--- a/linux/drivers/media/dvb/frontends/mxl500x.h	Thu Apr 24 23:02:08 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/mxl500x.h	Sat Apr 26 19:47:26 2008 -0400
@@ -92,18 +92,20 @@ struct mxl500x_config {
 	u8 addr;
 };
 
-#if defined(CONFIG_DVB_MXL500x) || (defined(CONFIG_DVB_MXL500x_MODULE) && defined(MODULE))
+#if defined(CONFIG_DVB_MXL500x) || \
+	(defined(CONFIG_DVB_MXL500x_MODULE) && defined(MODULE))
 extern struct dvb_frontend *mxl500x_attach(struct dvb_frontend *fe,
 					   const struct mxl500x_config *config,
 					   struct i2c_adapter *i2c);
 #else
-static inline struct dvb_frontend *mxl500x_attach(struct dvb_frontend *fe,
-						  const struct mxl500x_config *config,
-						  struct i2c_adapter *i2c)
+static inline struct dvb_frontend *mxl500x_attach(
+					    struct dvb_frontend *fe,
+					    const struct mxl500x_config *config,
+					    struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
 
-#endif //__MXL500x_H
+#endif /* __MXL500x_H */
diff -r 979f9052fc7e -r 3d9bbefb64a8 linux/drivers/media/dvb/frontends/mxl500x_reg.h
--- a/linux/drivers/media/dvb/frontends/mxl500x_reg.h	Thu Apr 24 23:02:08 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/mxl500x_reg.h	Sat Apr 26 19:47:26 2008 -0400
@@ -22,19 +22,33 @@
 #ifndef __MXL500x_REG_H
 #define __MXL500x_REG_H
 
-#define MXL500x_GETFIELD(bitf, val)		((val >> MXL500x_OFFST_##bitf) &				\
-						 ((1 << MXL500x_WIDTH_##bitf) - 1))
-
-#define MXL500x_SETFIELD(bitf, mask, val)	(mask = (mask & (~(((1 << MXL500x_WIDTH_##bitf) - 1)	<<	\
-							MXL500x_OFFST_##bitf))) | (val << MXL500x_OFFST_##bitf))
-
-#define MXL500x_MSB(bitf, val)		(val >> MXL500x_WIDTH_##bitf)
-#define MXL500x_LSB(bitf, val)		(val & ((1 << MXL500x_WIDTH_##bitf) - 1))
-
-#define MXL500x_BYTE0(bitf, val)	((val & 0x000000ff)         & ((1 << MXL500x_WIDTH_##bitf) - 1))
-#define MXL500x_BYTE1(bitf, val)	(((val & 0x0000ff00) >>  8) & ((1 << MXL500x_WIDTH_##bitf) - 1))
-#define MXL500x_BYTE2(bitf, val)	(((val & 0x00ff0000) >> 16) & ((1 << MXL500x_WIDTH_##bitf) - 1))
-#define MXL500x_BYTE3(bitf, val)	(((val & 0xff000000) >> 24) & ((1 << MXL500x_WIDTH_##bitf) - 1))
+#define MXL500x_WIDTH_MASK(bitf)	((1 << MXL500x_WIDTH_##bitf) - 1)
+#define MXL500x_FIELD_SHIFT(bitf)	(MXL500x_OFFST_##bitf)
+
+#define MXL500x_FIELD_MASK(bitf) \
+		(MXL500x_WIDTH_MASK(bitf) << MXL500x_FIELD_SHIFT(bitf))
+
+#define MXL500x_GETFIELD(bitf, val) \
+		((val >> MXL500x_FIELD_SHIFT(bitf)) & MXL500x_WIDTH_MASK(bitf))
+
+#define MXL500x_SETFIELD(bitf, target, val) \
+		(target = (target & (~MXL500x_FIELD_MASK(bitf))) \
+				  | (val << MXL500x_FIELD_SHIFT(bitf)))
+
+#define MXL500x_MSB(bitf, val)	(val >> MXL500x_WIDTH_##bitf)
+#define MXL500x_LSB(bitf, val)	(val & MXL500x_WIDTH_MASK(bitf))
+
+#define MXL500x_BYTE0(bitf, val) \
+			(((val & 0x000000ff) >>  0) & MXL500x_WIDTH_MASK(bitf))
+
+#define MXL500x_BYTE1(bitf, val) \
+			(((val & 0x0000ff00) >>  8) & MXL500x_WIDTH_MASK(bitf))
+
+#define MXL500x_BYTE2(bitf, val) \
+			(((val & 0x00ff0000) >> 16) & MXL500x_WIDTH_MASK(bitf))
+
+#define MXL500x_BYTE3(bitf, val) \
+			(((val & 0xff000000) >> 24) & MXL500x_WIDTH_MASK(bitf))
 
 /* Master Control */
 #define MXL500x_PWRUD1				9
@@ -491,4 +505,4 @@
 #define MXl500x_WIDTH_MISC_TUNE3_INIT_0			1
 #define MXl500x_OFFST_MISC_TUNE3_INIT_0			0
 
-#endif //__MXL500x_REG_H
+#endif /* __MXL500x_REG_H */

--=-sV+RHV5oDC78+HMX+wCS
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-sV+RHV5oDC78+HMX+wCS--
