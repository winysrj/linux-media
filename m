Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752999AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 03/35] [media] bt8xx/dst: use a more standard way to print messages
Date: Wed, 16 Nov 2016 14:42:35 -0200
Message-Id: <4300bfb9575159042fa3f4664dbc37485e050954.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver uses a weird, non-standard macro to print errors.
It allows hiding all messages, including error ones, with doesn't
seem a good idea.

Instead, replace it to pr_foo(), and, for error messages,
use pr_err().

The remaining messages were previouly classified as notice,
info or debug, but they all looked like debug messages.

So, add a dprintk() macro using the "verbose" modprobe
argument to select what will be displayed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/dst.c | 262 +++++++++++++++++++-----------------------
 1 file changed, 118 insertions(+), 144 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 35bc9b2287b4..faea3f06e350 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -18,6 +18,8 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -30,9 +32,9 @@
 #include "dst_priv.h"
 #include "dst_common.h"
 
-static unsigned int verbose = 1;
+static unsigned int verbose;
 module_param(verbose, int, 0644);
-MODULE_PARM_DESC(verbose, "verbose startup messages, default is 1 (yes)");
+MODULE_PARM_DESC(verbose, "verbosity level (0 to 3)");
 
 static unsigned int dst_addons;
 module_param(dst_addons, int, 0644);
@@ -46,29 +48,10 @@ MODULE_PARM_DESC(dst_algo, "tuning algo: default is 0=(SW), 1=(HW)");
 #define ATTEMPT_TUNE		2
 #define HAS_POWER		4
 
-#define DST_ERROR		0
-#define DST_NOTICE		1
-#define DST_INFO		2
-#define DST_DEBUG		3
-
-#define dprintk(x, y, z, format, arg...) do {				\
-	if (z) {							\
-		if	((x > DST_ERROR) && (x > y))			\
-			printk(KERN_ERR "dst(%d) %s: " format "\n",	\
-				state->bt->nr, __func__ , ##arg);	\
-		else if	((x > DST_NOTICE) && (x > y))			\
-			printk(KERN_NOTICE "dst(%d) %s: " format "\n",  \
-				state->bt->nr, __func__ , ##arg);	\
-		else if ((x > DST_INFO) && (x > y))			\
-			printk(KERN_INFO "dst(%d) %s: " format "\n",	\
-				state->bt->nr, __func__ , ##arg);	\
-		else if ((x > DST_DEBUG) && (x > y))			\
-			printk(KERN_DEBUG "dst(%d) %s: " format "\n",	\
-				state->bt->nr,  __func__ , ##arg);	\
-	} else {							\
-		if (x > y)						\
-			printk(format, ##arg);				\
-	}								\
+#define dprintk(level, fmt, arg...) do {				\
+	if (level >= verbose)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
 } while(0)
 
 static int dst_command(struct dst_state *state, u8 *data, u8 len);
@@ -91,9 +74,11 @@ static int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb,
 	enb.enb.mask = mask;
 	enb.enb.enable = enbb;
 
-	dprintk(verbose, DST_INFO, 1, "mask=[%04x], enbb=[%04x], outhigh=[%04x]", mask, enbb, outhigh);
+	dprintk(2, "mask=[%04x], enbb=[%04x], outhigh=[%04x]\n",
+		mask, enbb, outhigh);
 	if ((err = bt878_device_control(state->bt, DST_IG_ENABLE, &enb)) < 0) {
-		dprintk(verbose, DST_INFO, 1, "dst_gpio_enb error (err == %i, mask == %02x, enb == %02x)", err, mask, enbb);
+		dprintk(2, "dst_gpio_enb error (err == %i, mask == %02x, enb == %02x)\n",
+			err, mask, enbb);
 		return -EREMOTEIO;
 	}
 	udelay(1000);
@@ -105,7 +90,8 @@ static int dst_gpio_outb(struct dst_state *state, u32 mask, u32 enbb,
 	bits.outp.mask = enbb;
 	bits.outp.highvals = outhigh;
 	if ((err = bt878_device_control(state->bt, DST_IG_WRITE, &bits)) < 0) {
-		dprintk(verbose, DST_INFO, 1, "dst_gpio_outb error (err == %i, enbb == %02x, outhigh == %02x)", err, enbb, outhigh);
+		dprintk(2, "dst_gpio_outb error (err == %i, enbb == %02x, outhigh == %02x)\n",
+			err, enbb, outhigh);
 		return -EREMOTEIO;
 	}
 
@@ -119,7 +105,7 @@ static int dst_gpio_inb(struct dst_state *state, u8 *result)
 
 	*result = 0;
 	if ((err = bt878_device_control(state->bt, DST_IG_READ, &rd_packet)) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_inb error (err == %i)", err);
+		pr_err("dst_gpio_inb error (err == %i)\n", err);
 		return -EREMOTEIO;
 	}
 	*result = (u8) rd_packet.rd.value;
@@ -129,14 +115,14 @@ static int dst_gpio_inb(struct dst_state *state, u8 *result)
 
 int rdc_reset_state(struct dst_state *state)
 {
-	dprintk(verbose, DST_INFO, 1, "Resetting state machine");
+	dprintk(2, "Resetting state machine\n");
 	if (dst_gpio_outb(state, RDC_8820_INT, RDC_8820_INT, 0, NO_DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		return -1;
 	}
 	msleep(10);
 	if (dst_gpio_outb(state, RDC_8820_INT, RDC_8820_INT, RDC_8820_INT, NO_DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		msleep(10);
 		return -1;
 	}
@@ -147,14 +133,14 @@ EXPORT_SYMBOL(rdc_reset_state);
 
 static int rdc_8820_reset(struct dst_state *state)
 {
-	dprintk(verbose, DST_DEBUG, 1, "Resetting DST");
+	dprintk(3, "Resetting DST\n");
 	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		return -1;
 	}
 	udelay(1000);
 	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, RDC_8820_RESET, DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		return -1;
 	}
 
@@ -164,7 +150,7 @@ static int rdc_8820_reset(struct dst_state *state)
 static int dst_pio_enable(struct dst_state *state)
 {
 	if (dst_gpio_outb(state, ~0, RDC_8820_PIO_0_ENABLE, 0, NO_DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		return -1;
 	}
 	udelay(1000);
@@ -175,7 +161,7 @@ static int dst_pio_enable(struct dst_state *state)
 int dst_pio_disable(struct dst_state *state)
 {
 	if (dst_gpio_outb(state, ~0, RDC_8820_PIO_0_DISABLE, RDC_8820_PIO_0_DISABLE, NO_DELAY) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "dst_gpio_outb ERROR !");
+		pr_err("dst_gpio_outb ERROR !\n");
 		return -1;
 	}
 	if (state->type_flags & DST_TYPE_HAS_FW_1)
@@ -192,16 +178,16 @@ int dst_wait_dst_ready(struct dst_state *state, u8 delay_mode)
 
 	for (i = 0; i < 200; i++) {
 		if (dst_gpio_inb(state, &reply) < 0) {
-			dprintk(verbose, DST_ERROR, 1, "dst_gpio_inb ERROR !");
+			pr_err("dst_gpio_inb ERROR !\n");
 			return -1;
 		}
 		if ((reply & RDC_8820_PIO_0_ENABLE) == 0) {
-			dprintk(verbose, DST_INFO, 1, "dst wait ready after %d", i);
+			dprintk(2, "dst wait ready after %d\n", i);
 			return 1;
 		}
 		msleep(10);
 	}
-	dprintk(verbose, DST_NOTICE, 1, "dst wait NOT ready after %d", i);
+	dprintk(1, "dst wait NOT ready after %d\n", i);
 
 	return 0;
 }
@@ -209,7 +195,7 @@ EXPORT_SYMBOL(dst_wait_dst_ready);
 
 int dst_error_recovery(struct dst_state *state)
 {
-	dprintk(verbose, DST_NOTICE, 1, "Trying to return from previous errors.");
+	dprintk(1, "Trying to return from previous errors.\n");
 	dst_pio_disable(state);
 	msleep(10);
 	dst_pio_enable(state);
@@ -221,7 +207,7 @@ EXPORT_SYMBOL(dst_error_recovery);
 
 int dst_error_bailout(struct dst_state *state)
 {
-	dprintk(verbose, DST_INFO, 1, "Trying to bailout from previous error.");
+	dprintk(2, "Trying to bailout from previous error.\n");
 	rdc_8820_reset(state);
 	dst_pio_disable(state);
 	msleep(10);
@@ -232,13 +218,13 @@ EXPORT_SYMBOL(dst_error_bailout);
 
 int dst_comm_init(struct dst_state *state)
 {
-	dprintk(verbose, DST_INFO, 1, "Initializing DST.");
+	dprintk(2, "Initializing DST.\n");
 	if ((dst_pio_enable(state)) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "PIO Enable Failed");
+		pr_err("PIO Enable Failed\n");
 		return -1;
 	}
 	if ((rdc_reset_state(state)) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "RDC 8820 State RESET Failed.");
+		pr_err("RDC 8820 State RESET Failed.\n");
 		return -1;
 	}
 	if (state->type_flags & DST_TYPE_HAS_FW_1)
@@ -260,23 +246,21 @@ int write_dst(struct dst_state *state, u8 *data, u8 len)
 	};
 
 	int err;
-	u8 cnt, i;
+	u8 cnt;
 
-	dprintk(verbose, DST_NOTICE, 0, "writing [ ");
-	for (i = 0; i < len; i++)
-		dprintk(verbose, DST_NOTICE, 0, "%02x ", data[i]);
-	dprintk(verbose, DST_NOTICE, 0, "]\n");
+	dprintk(1, "writing [ %*ph ]\n", len, data);
 
 	for (cnt = 0; cnt < 2; cnt++) {
 		if ((err = i2c_transfer(state->i2c, &msg, 1)) < 0) {
-			dprintk(verbose, DST_INFO, 1, "_write_dst error (err == %i, len == 0x%02x, b0 == 0x%02x)", err, len, data[0]);
+			dprintk(2, "_write_dst error (err == %i, len == 0x%02x, b0 == 0x%02x)\n",
+				err, len, data[0]);
 			dst_error_recovery(state);
 			continue;
 		} else
 			break;
 	}
 	if (cnt >= 2) {
-		dprintk(verbose, DST_INFO, 1, "RDC 8820 RESET");
+		dprintk(2, "RDC 8820 RESET\n");
 		dst_error_bailout(state);
 
 		return -1;
@@ -300,23 +284,20 @@ int read_dst(struct dst_state *state, u8 *ret, u8 len)
 
 	for (cnt = 0; cnt < 2; cnt++) {
 		if ((err = i2c_transfer(state->i2c, &msg, 1)) < 0) {
-			dprintk(verbose, DST_INFO, 1, "read_dst error (err == %i, len == 0x%02x, b0 == 0x%02x)", err, len, ret[0]);
+			dprintk(2, "read_dst error (err == %i, len == 0x%02x, b0 == 0x%02x)\n",
+				err, len, ret[0]);
 			dst_error_recovery(state);
 			continue;
 		} else
 			break;
 	}
 	if (cnt >= 2) {
-		dprintk(verbose, DST_INFO, 1, "RDC 8820 RESET");
+		dprintk(2, "RDC 8820 RESET\n");
 		dst_error_bailout(state);
 
 		return -1;
 	}
-	dprintk(verbose, DST_DEBUG, 1, "reply is 0x%x", ret[0]);
-	for (err = 1; err < len; err++)
-		dprintk(verbose, DST_DEBUG, 0, " 0x%x", ret[err]);
-	if (err > 1)
-		dprintk(verbose, DST_DEBUG, 0, "\n");
+	dprintk(3, "reply is %*ph\n", len, ret);
 
 	return 0;
 }
@@ -326,11 +307,11 @@ static int dst_set_polarization(struct dst_state *state)
 {
 	switch (state->voltage) {
 	case SEC_VOLTAGE_13:	/*	Vertical	*/
-		dprintk(verbose, DST_INFO, 1, "Polarization=[Vertical]");
+		dprintk(2, "Polarization=[Vertical]\n");
 		state->tx_tuna[8] &= ~0x40;
 		break;
 	case SEC_VOLTAGE_18:	/*	Horizontal	*/
-		dprintk(verbose, DST_INFO, 1, "Polarization=[Horizontal]");
+		dprintk(2, "Polarization=[Horizontal]\n");
 		state->tx_tuna[8] |= 0x40;
 		break;
 	case SEC_VOLTAGE_OFF:
@@ -343,7 +324,7 @@ static int dst_set_polarization(struct dst_state *state)
 static int dst_set_freq(struct dst_state *state, u32 freq)
 {
 	state->frequency = freq;
-	dprintk(verbose, DST_INFO, 1, "set Frequency %u", freq);
+	dprintk(2, "set Frequency %u\n", freq);
 
 	if (state->dst_type == DST_TYPE_IS_SAT) {
 		freq = freq / 1000;
@@ -463,7 +444,7 @@ static int dst_set_symbolrate(struct dst_state *state, u32 srate)
 	if (state->dst_type == DST_TYPE_IS_TERR) {
 		return -EOPNOTSUPP;
 	}
-	dprintk(verbose, DST_INFO, 1, "set symrate %u", srate);
+	dprintk(2, "set symrate %u\n", srate);
 	srate /= 1000;
 	if (state->dst_type == DST_TYPE_IS_SAT) {
 		if (state->type_flags & DST_TYPE_HAS_SYMDIV) {
@@ -471,7 +452,7 @@ static int dst_set_symbolrate(struct dst_state *state, u32 srate)
 			sval <<= 20;
 			do_div(sval, 88000);
 			symcalc = (u32) sval;
-			dprintk(verbose, DST_INFO, 1, "set symcalc %u", symcalc);
+			dprintk(2, "set symcalc %u\n", symcalc);
 			state->tx_tuna[5] = (u8) (symcalc >> 12);
 			state->tx_tuna[6] = (u8) (symcalc >> 4);
 			state->tx_tuna[7] = (u8) (symcalc << 4);
@@ -486,7 +467,7 @@ static int dst_set_symbolrate(struct dst_state *state, u32 srate)
 				state->tx_tuna[8] |= 0x20;
 		}
 	} else if (state->dst_type == DST_TYPE_IS_CABLE) {
-		dprintk(verbose, DST_DEBUG, 1, "%s", state->fw_name);
+		dprintk(3, "%s\n", state->fw_name);
 		if (!strncmp(state->fw_name, "DCTNEW", 6)) {
 			state->tx_tuna[5] = (u8) (srate >> 8);
 			state->tx_tuna[6] = (u8) srate;
@@ -561,24 +542,24 @@ static void dst_type_flags_print(struct dst_state *state)
 {
 	u32 type_flags = state->type_flags;
 
-	dprintk(verbose, DST_ERROR, 0, "DST type flags :");
+	pr_err("DST type flags :\n");
 	if (type_flags & DST_TYPE_HAS_TS188)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x newtuner", DST_TYPE_HAS_TS188);
+		pr_err(" 0x%x newtuner\n", DST_TYPE_HAS_TS188);
 	if (type_flags & DST_TYPE_HAS_NEWTUNE_2)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x newtuner 2", DST_TYPE_HAS_NEWTUNE_2);
+		pr_err(" 0x%x newtuner 2\n", DST_TYPE_HAS_NEWTUNE_2);
 	if (type_flags & DST_TYPE_HAS_TS204)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x ts204", DST_TYPE_HAS_TS204);
+		pr_err(" 0x%x ts204\n", DST_TYPE_HAS_TS204);
 	if (type_flags & DST_TYPE_HAS_VLF)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x VLF", DST_TYPE_HAS_VLF);
+		pr_err(" 0x%x VLF\n", DST_TYPE_HAS_VLF);
 	if (type_flags & DST_TYPE_HAS_SYMDIV)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x symdiv", DST_TYPE_HAS_SYMDIV);
+		pr_err(" 0x%x symdiv\n", DST_TYPE_HAS_SYMDIV);
 	if (type_flags & DST_TYPE_HAS_FW_1)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x firmware version = 1", DST_TYPE_HAS_FW_1);
+		pr_err(" 0x%x firmware version = 1\n", DST_TYPE_HAS_FW_1);
 	if (type_flags & DST_TYPE_HAS_FW_2)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x firmware version = 2", DST_TYPE_HAS_FW_2);
+		pr_err(" 0x%x firmware version = 2\n", DST_TYPE_HAS_FW_2);
 	if (type_flags & DST_TYPE_HAS_FW_3)
-		dprintk(verbose, DST_ERROR, 0, " 0x%x firmware version = 3", DST_TYPE_HAS_FW_3);
-	dprintk(verbose, DST_ERROR, 0, "\n");
+		pr_err(" 0x%x firmware version = 3\n", DST_TYPE_HAS_FW_3);
+	pr_err("\n");
 }
 
 
@@ -603,10 +584,10 @@ static int dst_type_print(struct dst_state *state, u8 type)
 		break;
 
 	default:
-		dprintk(verbose, DST_INFO, 1, "invalid dst type %d", type);
+		dprintk(2, "invalid dst type %d\n", type);
 		return -EINVAL;
 	}
-	dprintk(verbose, DST_INFO, 1, "DST type: %s", otype);
+	dprintk(2, "DST type: %s\n", otype);
 
 	return 0;
 }
@@ -914,12 +895,12 @@ static int dst_get_mac(struct dst_state *state)
 	u8 get_mac[] = { 0x00, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	get_mac[7] = dst_check_sum(get_mac, 7);
 	if (dst_command(state, get_mac, 8) < 0) {
-		dprintk(verbose, DST_INFO, 1, "Unsupported Command");
+		dprintk(2, "Unsupported Command\n");
 		return -1;
 	}
 	memset(&state->mac_address, '\0', 8);
 	memcpy(&state->mac_address, &state->rxbuffer, 6);
-	dprintk(verbose, DST_ERROR, 1, "MAC Address=[%pM]", state->mac_address);
+	pr_err("MAC Address=[%pM]\n", state->mac_address);
 
 	return 0;
 }
@@ -929,11 +910,11 @@ static int dst_fw_ver(struct dst_state *state)
 	u8 get_ver[] = { 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	get_ver[7] = dst_check_sum(get_ver, 7);
 	if (dst_command(state, get_ver, 8) < 0) {
-		dprintk(verbose, DST_INFO, 1, "Unsupported Command");
+		dprintk(2, "Unsupported Command\n");
 		return -1;
 	}
 	memcpy(&state->fw_version, &state->rxbuffer, 8);
-	dprintk(verbose, DST_ERROR, 1, "Firmware Ver = %x.%x Build = %02x, on %x:%x, %x-%x-20%02x",
+	pr_err("Firmware Ver = %x.%x Build = %02x, on %x:%x, %x-%x-20%02x\n",
 		state->fw_version[0] >> 4, state->fw_version[0] & 0x0f,
 		state->fw_version[1],
 		state->fw_version[5], state->fw_version[6],
@@ -950,17 +931,17 @@ static int dst_card_type(struct dst_state *state)
 	u8 get_type[] = { 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	get_type[7] = dst_check_sum(get_type, 7);
 	if (dst_command(state, get_type, 8) < 0) {
-		dprintk(verbose, DST_INFO, 1, "Unsupported Command");
+		dprintk(2, "Unsupported Command\n");
 		return -1;
 	}
 	memset(&state->card_info, '\0', 8);
 	memcpy(&state->card_info, &state->rxbuffer, 7);
-	dprintk(verbose, DST_ERROR, 1, "Device Model=[%s]", &state->card_info[0]);
+	pr_err("Device Model=[%s]\n", &state->card_info[0]);
 
 	for (j = 0, p_tuner_list = tuner_list; j < ARRAY_SIZE(tuner_list); j++, p_tuner_list++) {
 		if (!strcmp(&state->card_info[0], p_tuner_list->board_name)) {
 			state->tuner_type = p_tuner_list->tuner_type;
-			dprintk(verbose, DST_ERROR, 1, "DST has [%s] tuner, tuner type=[%d]",
+			pr_err("DST has [%s] tuner, tuner type=[%d]\n",
 				p_tuner_list->tuner_name, p_tuner_list->tuner_type);
 		}
 	}
@@ -973,26 +954,19 @@ static int dst_get_vendor(struct dst_state *state)
 	u8 get_vendor[] = { 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	get_vendor[7] = dst_check_sum(get_vendor, 7);
 	if (dst_command(state, get_vendor, 8) < 0) {
-		dprintk(verbose, DST_INFO, 1, "Unsupported Command");
+		dprintk(2, "Unsupported Command\n");
 		return -1;
 	}
 	memset(&state->vendor, '\0', 8);
 	memcpy(&state->vendor, &state->rxbuffer, 7);
-	dprintk(verbose, DST_ERROR, 1, "Vendor=[%s]", &state->vendor[0]);
+	pr_err("Vendor=[%s]\n", &state->vendor[0]);
 
 	return 0;
 }
 
 static void debug_dst_buffer(struct dst_state *state)
 {
-	int i;
-
-	if (verbose > 2) {
-		printk("%s: [", __func__);
-		for (i = 0; i < 8; i++)
-			printk(" %02x", state->rxbuffer[i]);
-		printk("]\n");
-	}
+	dprintk(3, "%s: [ %*ph ]\n", __func__, 8, state->rxbuffer);
 }
 
 static int dst_check_stv0299(struct dst_state *state)
@@ -1001,13 +975,13 @@ static int dst_check_stv0299(struct dst_state *state)
 
 	check_stv0299[7] = dst_check_sum(check_stv0299, 7);
 	if (dst_command(state, check_stv0299, 8) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "Cmd=[0x04] failed");
+		pr_err("Cmd=[0x04] failed\n");
 		return -1;
 	}
 	debug_dst_buffer(state);
 
 	if (memcmp(&check_stv0299, &state->rxbuffer, 8)) {
-		dprintk(verbose, DST_ERROR, 1, "Found a STV0299 NIM");
+		pr_err("Found a STV0299 NIM\n");
 		state->tuner_type = TUNER_TYPE_STV0299;
 		return 0;
 	}
@@ -1021,13 +995,13 @@ static int dst_check_mb86a15(struct dst_state *state)
 
 	check_mb86a15[7] = dst_check_sum(check_mb86a15, 7);
 	if (dst_command(state, check_mb86a15, 8) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "Cmd=[0x10], failed");
+		pr_err("Cmd=[0x10], failed\n");
 		return -1;
 	}
 	debug_dst_buffer(state);
 
 	if (memcmp(&check_mb86a15, &state->rxbuffer, 8) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "Found a MB86A15 NIM");
+		pr_err("Found a MB86A15 NIM\n");
 		state->tuner_type = TUNER_TYPE_MB86A15;
 		return 0;
 	}
@@ -1042,21 +1016,21 @@ static int dst_get_tuner_info(struct dst_state *state)
 
 	get_tuner_1[7] = dst_check_sum(get_tuner_1, 7);
 	get_tuner_2[7] = dst_check_sum(get_tuner_2, 7);
-	dprintk(verbose, DST_ERROR, 1, "DST TYpe = MULTI FE");
+	pr_err("DST TYpe = MULTI FE\n");
 	if (state->type_flags & DST_TYPE_HAS_MULTI_FE) {
 		if (dst_command(state, get_tuner_1, 8) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Cmd=[0x13], Unsupported");
+			dprintk(2, "Cmd=[0x13], Unsupported\n");
 			goto force;
 		}
 	} else {
 		if (dst_command(state, get_tuner_2, 8) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Cmd=[0xb], Unsupported");
+			dprintk(2, "Cmd=[0xb], Unsupported\n");
 			goto force;
 		}
 	}
 	memcpy(&state->board_info, &state->rxbuffer, 8);
 	if (state->type_flags & DST_TYPE_HAS_MULTI_FE) {
-		dprintk(verbose, DST_ERROR, 1, "DST type has TS=188");
+		pr_err("DST type has TS=188\n");
 	}
 	if (state->board_info[0] == 0xbc) {
 		if (state->dst_type != DST_TYPE_IS_ATSC)
@@ -1066,7 +1040,7 @@ static int dst_get_tuner_info(struct dst_state *state)
 
 		if (state->board_info[1] == 0x01) {
 			state->dst_hw_cap |= DST_TYPE_HAS_DBOARD;
-			dprintk(verbose, DST_ERROR, 1, "DST has Daughterboard");
+			pr_err("DST has Daughterboard\n");
 		}
 	}
 
@@ -1074,7 +1048,7 @@ static int dst_get_tuner_info(struct dst_state *state)
 force:
 	if (!strncmp(state->fw_name, "DCT-CI", 6)) {
 		state->type_flags |= DST_TYPE_HAS_TS204;
-		dprintk(verbose, DST_ERROR, 1, "Forcing [%s] to TS188", state->fw_name);
+		pr_err("Forcing [%s] to TS188\n", state->fw_name);
 	}
 
 	return -1;
@@ -1103,7 +1077,7 @@ static int dst_get_device_id(struct dst_state *state)
 	if (read_dst(state, &reply, GET_ACK))
 		return -1;		/*	Read failure		*/
 	if (reply != ACK) {
-		dprintk(verbose, DST_INFO, 1, "Write not Acknowledged! [Reply=0x%02x]", reply);
+		dprintk(2, "Write not Acknowledged! [Reply=0x%02x]\n", reply);
 		return -1;		/*	Unack'd write		*/
 	}
 	if (!dst_wait_dst_ready(state, DEVICE_INIT))
@@ -1113,7 +1087,7 @@ static int dst_get_device_id(struct dst_state *state)
 
 	dst_pio_disable(state);
 	if (state->rxbuffer[7] != dst_check_sum(state->rxbuffer, 7)) {
-		dprintk(verbose, DST_INFO, 1, "Checksum failure!");
+		dprintk(2, "Checksum failure!\n");
 		return -1;		/*	Checksum failure	*/
 	}
 	state->rxbuffer[7] = '\0';
@@ -1125,7 +1099,7 @@ static int dst_get_device_id(struct dst_state *state)
 
 			/*	Card capabilities	*/
 			state->dst_hw_cap = p_dst_type->dst_feature;
-			dprintk(verbose, DST_ERROR, 1, "Recognise [%s]", p_dst_type->device_id);
+			pr_err("Recognise [%s]\n", p_dst_type->device_id);
 			strncpy(&state->fw_name[0], p_dst_type->device_id, 6);
 			/*	Multiple tuners		*/
 			if (p_dst_type->tuner_type & TUNER_TYPE_MULTI) {
@@ -1133,7 +1107,7 @@ static int dst_get_device_id(struct dst_state *state)
 				case DST_TYPE_IS_SAT:
 					/*	STV0299 check	*/
 					if (dst_check_stv0299(state) < 0) {
-						dprintk(verbose, DST_ERROR, 1, "Unsupported");
+						pr_err("Unsupported\n");
 						state->tuner_type = TUNER_TYPE_MB86A15;
 					}
 					break;
@@ -1141,7 +1115,7 @@ static int dst_get_device_id(struct dst_state *state)
 					break;
 				}
 				if (dst_check_mb86a15(state) < 0)
-					dprintk(verbose, DST_ERROR, 1, "Unsupported");
+					pr_err("Unsupported\n");
 			/*	Single tuner		*/
 			} else {
 				state->tuner_type = p_dst_type->tuner_type;
@@ -1149,7 +1123,7 @@ static int dst_get_device_id(struct dst_state *state)
 			for (j = 0, p_tuner_list = tuner_list; j < ARRAY_SIZE(tuner_list); j++, p_tuner_list++) {
 				if (!(strncmp(p_dst_type->device_id, p_tuner_list->fw_name, 7)) &&
 					p_tuner_list->tuner_type == state->tuner_type) {
-					dprintk(verbose, DST_ERROR, 1, "[%s] has a [%s]",
+					pr_err("[%s] has a [%s]\n",
 						p_dst_type->device_id, p_tuner_list->tuner_name);
 				}
 			}
@@ -1158,8 +1132,8 @@ static int dst_get_device_id(struct dst_state *state)
 	}
 
 	if (i >= ARRAY_SIZE(dst_tlist)) {
-		dprintk(verbose, DST_ERROR, 1, "Unable to recognize %s or %s", &state->rxbuffer[0], &state->rxbuffer[1]);
-		dprintk(verbose, DST_ERROR, 1, "please email linux-dvb@linuxtv.org with this type in");
+		pr_err("Unable to recognize %s or %s\n", &state->rxbuffer[0], &state->rxbuffer[1]);
+		pr_err("please email linux-dvb@linuxtv.org with this type in");
 		use_dst_type = DST_TYPE_IS_SAT;
 		use_type_flags = DST_TYPE_HAS_SYMDIV;
 	}
@@ -1176,7 +1150,7 @@ static int dst_probe(struct dst_state *state)
 	mutex_init(&state->dst_mutex);
 	if (dst_addons & DST_TYPE_HAS_CA) {
 		if ((rdc_8820_reset(state)) < 0) {
-			dprintk(verbose, DST_ERROR, 1, "RDC 8820 RESET Failed.");
+			pr_err("RDC 8820 RESET Failed.\n");
 			return -1;
 		}
 		msleep(4000);
@@ -1184,35 +1158,35 @@ static int dst_probe(struct dst_state *state)
 		msleep(100);
 	}
 	if ((dst_comm_init(state)) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "DST Initialization Failed.");
+		pr_err("DST Initialization Failed.\n");
 		return -1;
 	}
 	msleep(100);
 	if (dst_get_device_id(state) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "unknown device.");
+		pr_err("unknown device.\n");
 		return -1;
 	}
 	if (dst_get_mac(state) < 0) {
-		dprintk(verbose, DST_INFO, 1, "MAC: Unsupported command");
+		dprintk(2, "MAC: Unsupported command\n");
 	}
 	if ((state->type_flags & DST_TYPE_HAS_MULTI_FE) || (state->type_flags & DST_TYPE_HAS_FW_BUILD)) {
 		if (dst_get_tuner_info(state) < 0)
-			dprintk(verbose, DST_INFO, 1, "Tuner: Unsupported command");
+			dprintk(2, "Tuner: Unsupported command\n");
 	}
 	if (state->type_flags & DST_TYPE_HAS_TS204) {
 		dst_packsize(state, 204);
 	}
 	if (state->type_flags & DST_TYPE_HAS_FW_BUILD) {
 		if (dst_fw_ver(state) < 0) {
-			dprintk(verbose, DST_INFO, 1, "FW: Unsupported command");
+			dprintk(2, "FW: Unsupported command\n");
 			return 0;
 		}
 		if (dst_card_type(state) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Card: Unsupported command");
+			dprintk(2, "Card: Unsupported command\n");
 			return 0;
 		}
 		if (dst_get_vendor(state) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Vendor: Unsupported command");
+			dprintk(2, "Vendor: Unsupported command\n");
 			return 0;
 		}
 	}
@@ -1226,33 +1200,33 @@ static int dst_command(struct dst_state *state, u8 *data, u8 len)
 
 	mutex_lock(&state->dst_mutex);
 	if ((dst_comm_init(state)) < 0) {
-		dprintk(verbose, DST_NOTICE, 1, "DST Communication Initialization Failed.");
+		dprintk(1, "DST Communication Initialization Failed.\n");
 		goto error;
 	}
 	if (write_dst(state, data, len)) {
-		dprintk(verbose, DST_INFO, 1, "Trying to recover.. ");
+		dprintk(2, "Trying to recover..\n");
 		if ((dst_error_recovery(state)) < 0) {
-			dprintk(verbose, DST_ERROR, 1, "Recovery Failed.");
+			pr_err("Recovery Failed.\n");
 			goto error;
 		}
 		goto error;
 	}
 	if ((dst_pio_disable(state)) < 0) {
-		dprintk(verbose, DST_ERROR, 1, "PIO Disable Failed.");
+		pr_err("PIO Disable Failed.\n");
 		goto error;
 	}
 	if (state->type_flags & DST_TYPE_HAS_FW_1)
 		mdelay(3);
 	if (read_dst(state, &reply, GET_ACK)) {
-		dprintk(verbose, DST_DEBUG, 1, "Trying to recover.. ");
+		dprintk(3, "Trying to recover..\n");
 		if ((dst_error_recovery(state)) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Recovery Failed.");
+			dprintk(2, "Recovery Failed.\n");
 			goto error;
 		}
 		goto error;
 	}
 	if (reply != ACK) {
-		dprintk(verbose, DST_INFO, 1, "write not acknowledged 0x%02x ", reply);
+		dprintk(2, "write not acknowledged 0x%02x\n", reply);
 		goto error;
 	}
 	if (len >= 2 && data[0] == 0 && (data[1] == 1 || data[1] == 3))
@@ -1264,15 +1238,15 @@ static int dst_command(struct dst_state *state, u8 *data, u8 len)
 	if (!dst_wait_dst_ready(state, NO_DELAY))
 		goto error;
 	if (read_dst(state, state->rxbuffer, FIXED_COMM)) {
-		dprintk(verbose, DST_DEBUG, 1, "Trying to recover.. ");
+		dprintk(3, "Trying to recover..\n");
 		if ((dst_error_recovery(state)) < 0) {
-			dprintk(verbose, DST_INFO, 1, "Recovery failed.");
+			dprintk(2, "Recovery failed.\n");
 			goto error;
 		}
 		goto error;
 	}
 	if (state->rxbuffer[7] != dst_check_sum(state->rxbuffer, 7)) {
-		dprintk(verbose, DST_INFO, 1, "checksum failure");
+		dprintk(2, "checksum failure\n");
 		goto error;
 	}
 	mutex_unlock(&state->dst_mutex);
@@ -1348,19 +1322,19 @@ static int dst_get_tuna(struct dst_state *state)
 	else
 		retval = read_dst(state, &state->rx_tuna[2], FIXED_COMM);
 	if (retval < 0) {
-		dprintk(verbose, DST_DEBUG, 1, "read not successful");
+		dprintk(3, "read not successful\n");
 		return retval;
 	}
 	if ((state->type_flags & DST_TYPE_HAS_VLF) &&
 	   !(state->dst_type == DST_TYPE_IS_ATSC)) {
 
 		if (state->rx_tuna[9] != dst_check_sum(&state->rx_tuna[0], 9)) {
-			dprintk(verbose, DST_INFO, 1, "checksum failure ? ");
+			dprintk(2, "checksum failure ?\n");
 			return -EIO;
 		}
 	} else {
 		if (state->rx_tuna[9] != dst_check_sum(&state->rx_tuna[2], 7)) {
-			dprintk(verbose, DST_INFO, 1, "checksum failure? ");
+			dprintk(2, "checksum failure?\n");
 			return -EIO;
 		}
 	}
@@ -1387,7 +1361,7 @@ static int dst_write_tuna(struct dvb_frontend *fe)
 	int retval;
 	u8 reply;
 
-	dprintk(verbose, DST_INFO, 1, "type_flags 0x%x ", state->type_flags);
+	dprintk(2, "type_flags 0x%x\n", state->type_flags);
 	state->decode_freq = 0;
 	state->decode_lock = state->decode_strength = state->decode_snr = 0;
 	if (state->dst_type == DST_TYPE_IS_SAT) {
@@ -1397,7 +1371,7 @@ static int dst_write_tuna(struct dvb_frontend *fe)
 	state->diseq_flags &= ~(HAS_LOCK | ATTEMPT_TUNE);
 	mutex_lock(&state->dst_mutex);
 	if ((dst_comm_init(state)) < 0) {
-		dprintk(verbose, DST_DEBUG, 1, "DST Communication initialization failed.");
+		dprintk(3, "DST Communication initialization failed.\n");
 		goto error;
 	}
 //	if (state->type_flags & DST_TYPE_HAS_NEWTUNE) {
@@ -1412,19 +1386,19 @@ static int dst_write_tuna(struct dvb_frontend *fe)
 	}
 	if (retval < 0) {
 		dst_pio_disable(state);
-		dprintk(verbose, DST_DEBUG, 1, "write not successful");
+		dprintk(3, "write not successful\n");
 		goto werr;
 	}
 	if ((dst_pio_disable(state)) < 0) {
-		dprintk(verbose, DST_DEBUG, 1, "DST PIO disable failed !");
+		dprintk(3, "DST PIO disable failed !\n");
 		goto error;
 	}
 	if ((read_dst(state, &reply, GET_ACK) < 0)) {
-		dprintk(verbose, DST_DEBUG, 1, "read verify not successful.");
+		dprintk(3, "read verify not successful.\n");
 		goto error;
 	}
 	if (reply != ACK) {
-		dprintk(verbose, DST_DEBUG, 1, "write not acknowledged 0x%02x ", reply);
+		dprintk(3, "write not acknowledged 0x%02x\n", reply);
 		goto error;
 	}
 	state->diseq_flags |= ATTEMPT_TUNE;
@@ -1622,7 +1596,7 @@ static int dst_set_frontend(struct dvb_frontend *fe)
 		retval = dst_set_freq(state, p->frequency);
 		if(retval != 0)
 			return retval;
-		dprintk(verbose, DST_DEBUG, 1, "Set Frequency=[%d]", p->frequency);
+		dprintk(3, "Set Frequency=[%d]\n", p->frequency);
 
 		if (state->dst_type == DST_TYPE_IS_SAT) {
 			if (state->type_flags & DST_TYPE_HAS_OBS_REGS)
@@ -1630,7 +1604,7 @@ static int dst_set_frontend(struct dvb_frontend *fe)
 			dst_set_fec(state, p->fec_inner);
 			dst_set_symbolrate(state, p->symbol_rate);
 			dst_set_polarization(state);
-			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->symbol_rate);
+			dprintk(3, "Set Symbolrate=[%d]\n", p->symbol_rate);
 
 		} else if (state->dst_type == DST_TYPE_IS_TERR)
 			dst_set_bandwidth(state, p->bandwidth_hz);
@@ -1656,7 +1630,7 @@ static int dst_tune_frontend(struct dvb_frontend* fe,
 
 	if (re_tune) {
 		dst_set_freq(state, p->frequency);
-		dprintk(verbose, DST_DEBUG, 1, "Set Frequency=[%d]", p->frequency);
+		dprintk(3, "Set Frequency=[%d]\n", p->frequency);
 
 		if (state->dst_type == DST_TYPE_IS_SAT) {
 			if (state->type_flags & DST_TYPE_HAS_OBS_REGS)
@@ -1664,7 +1638,7 @@ static int dst_tune_frontend(struct dvb_frontend* fe,
 			dst_set_fec(state, p->fec_inner);
 			dst_set_symbolrate(state, p->symbol_rate);
 			dst_set_polarization(state);
-			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->symbol_rate);
+			dprintk(3, "Set Symbolrate=[%d]\n", p->symbol_rate);
 
 		} else if (state->dst_type == DST_TYPE_IS_TERR)
 			dst_set_bandwidth(state, p->bandwidth_hz);
@@ -1750,7 +1724,7 @@ struct dst_state *dst_attach(struct dst_state *state, struct dvb_adapter *dvb_ad
 		memcpy(&state->frontend.ops, &dst_atsc_ops, sizeof(struct dvb_frontend_ops));
 		break;
 	default:
-		dprintk(verbose, DST_ERROR, 1, "unknown DST type. please report to the LinuxTV.org DVB mailinglist.");
+		pr_err("unknown DST type. please report to the LinuxTV.org DVB mailinglist.\n");
 		kfree(state);
 		return NULL;
 	}
-- 
2.7.4


