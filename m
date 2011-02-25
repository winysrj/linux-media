Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42402 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1BYIWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 03:22:13 -0500
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ilho Lee <ilho215.lee@samsung.com>,
	Jiun Yu <jiun.yu@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH 3/5] [media] s5p-tvout: Add TVOUT interface control for S5P TVOUT driver
Date: Fri, 25 Feb 2011 16:53:31 +0900
Message-Id: <1298620413-24182-4-git-send-email-a.kesavan@samsung.com>
In-Reply-To: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
References: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jiun Yu <jiun.yu@samsung.com>

The S5P TVOUT interface has 3 classes.

- tvif ctrl class: controls hdmi and sdo ctrl class.
- hdmi ctrl class: contrls hdmi hardware by using hw_if/hdmi.c
- sdo  ctrl class: contrls sdo hardware by using hw_if/sdo.c

               +-----------------+
               | tvif ctrl class |
               +-----------------+
                      |   |
           +----------+   +----------+             ctrl class layer
           |                         |
           V                         V
  +-----------------+       +-----------------+
  | sdo ctrl class  |       | hdmi ctrl class |
  +-----------------+       +-----------------+
           |                         |
-----------+-------------------------+------------------------------
           V                         V
  +-----------------+       +-----------------+
  |   hw_if/sdo.c   |       |   hw_if/hdmi.c  |         hw_if layer
  +-----------------+       +-----------------+
           |                         |
-----------+-------------------------+------------------------------
           V                         V
  +-----------------+       +-----------------+
  |   sdo hardware  |       |   hdmi hardware |          Hardware
  +-----------------+       +-----------------+

[based on work originally written by Sunil Choi <sunil111.choi@samsung.com>]
Cc: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: KyungHwan Kim <kh.k.kim@samsung.com>
Signed-off-by: Jiun Yu <jiun.yu@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 drivers/media/video/s5p-tvout/hw_if/hdcp.c    | 1063 ++++++++++++++
 drivers/media/video/s5p-tvout/hw_if/hdmi.c    | 1365 +++++++++++++++++
 drivers/media/video/s5p-tvout/hw_if/sdo.c     | 1102 ++++++++++++++
 drivers/media/video/s5p-tvout/s5p_tvif_ctrl.c | 1945 +++++++++++++++++++++++++
 4 files changed, 5475 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/hdcp.c
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/hdmi.c
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/sdo.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvif_ctrl.c

diff --git a/drivers/media/video/s5p-tvout/hw_if/hdcp.c b/drivers/media/video/s5p-tvout/hw_if/hdcp.c
new file mode 100644
index 0000000..a254941
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/hdcp.c
@@ -0,0 +1,1063 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * HDCP Feature for Samsung S5P TVOUT
+ *
+ * This program is free software. you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/i2c.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/regs-hdmi.h>
+
+#include "hw_if.h"
+#include "../s5p_tvout_common_lib.h"
+
+#undef tvout_dbg
+
+#ifdef CONFIG_HDCP_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "\t\t[HDCP] %s(): " fmt,	\
+			__func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+
+#define AN_SZ			8
+#define AKSV_SZ			5
+#define BKSV_SZ			5
+#define MAX_KEY_SZ		16
+
+#define BKSV_RETRY_CNT		14
+#define BKSV_DELAY		100
+
+#define DDC_RETRY_CNT		400000
+#define DDC_DELAY		25
+
+#define KEY_LOAD_RETRY_CNT	1000
+#define ENCRYPT_CHECK_CNT	10
+
+#define KSV_FIFO_RETRY_CNT	50
+#define KSV_FIFO_CHK_DELAY	100 /* ms */
+#define KSV_LIST_RETRY_CNT	10000
+#define SHA_1_RETRY_CNT		4
+
+#define BCAPS_SIZE		1
+#define BSTATUS_SIZE		2
+#define SHA_1_HASH_SIZE		20
+#define HDCP_MAX_DEVS		128
+#define HDCP_KSV_SIZE		5
+
+#define HDCP_Bksv		0x00
+#define HDCP_Ri			0x08
+#define HDCP_Aksv		0x10
+#define HDCP_Ainfo		0x15
+#define HDCP_An			0x18
+#define HDCP_SHA1		0x20
+#define HDCP_Bcaps		0x40
+#define HDCP_BStatus		0x41
+#define HDCP_KSVFIFO		0x43
+
+#define KSV_FIFO_READY			(0x1 << 5)
+
+#define MAX_CASCADE_EXCEEDED_ERROR	(-2)
+#define MAX_DEVS_EXCEEDED_ERROR		(-3)
+#define REPEATER_ILLEGAL_DEVICE_ERROR	(-4)
+#define REPEATER_TIMEOUT_ERROR		(-5)
+
+#define MAX_CASCADE_EXCEEDED		(0x1 << 3)
+#define MAX_DEVS_EXCEEDED		(0x1 << 7)
+
+#define DDC_BUF_SIZE		32
+
+enum hdcp_event {
+	HDCP_EVENT_STOP			= 1 << 0,
+	HDCP_EVENT_START		= 1 << 1,
+	HDCP_EVENT_READ_BKSV_START	= 1 << 2,
+	HDCP_EVENT_WRITE_AKSV_START	= 1 << 4,
+	HDCP_EVENT_CHECK_RI_START	= 1 << 8,
+	HDCP_EVENT_SECOND_AUTH_START	= 1 << 16
+};
+
+enum hdcp_state {
+	NOT_AUTHENTICATED,
+	RECEIVER_READ_READY,
+	BCAPS_READ_DONE,
+	BKSV_READ_DONE,
+	AN_WRITE_DONE,
+	AKSV_WRITE_DONE,
+	FIRST_AUTHENTICATION_DONE,
+	SECOND_AUTHENTICATION_RDY,
+	SECOND_AUTHENTICATION_DONE,
+};
+
+struct s5p_hdcp_info {
+	u8			is_repeater;
+	u32			hdcp_enable;
+
+	spinlock_t		reset_lock;
+
+	enum hdcp_event		event;
+	enum hdcp_state		auth_status;
+
+	struct work_struct	work;
+};
+
+struct i2c_client *ddc_port;
+
+static bool sw_reset;
+
+static struct s5p_hdcp_info hdcp_info = {
+	.is_repeater	= false,
+	.hdcp_enable	= false,
+	.event		= HDCP_EVENT_STOP,
+	.auth_status	= NOT_AUTHENTICATED,
+};
+
+/* ddc i2c */
+static int s5p_ddc_read(u8 reg, int bytes, u8 *dest)
+{
+	struct i2c_client *i2c = ddc_port;
+	u8 addr = reg;
+	int ret, cnt = 0;
+
+	struct i2c_msg msg[] = {
+		{
+			.addr	= i2c->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= &addr
+		}, {
+			.addr	= i2c->addr,
+			.flags	= I2C_M_RD,
+			.len	= bytes,
+			.buf	= dest
+		}
+	};
+
+	do {
+		if (!s5p_hdmi_reg_get_hpd_status())
+			goto ddc_read_err;
+
+		ret = i2c_transfer(i2c->adapter, msg, 2);
+
+		if (ret < 0 || ret != 2)
+			tvout_dbg("ddc : can't read data, retry %d\n", cnt);
+		else
+			break;
+
+		if (hdcp_info.auth_status == FIRST_AUTHENTICATION_DONE
+			|| hdcp_info.auth_status == SECOND_AUTHENTICATION_DONE)
+			goto ddc_read_err;
+
+		msleep(DDC_DELAY);
+		cnt++;
+	} while (cnt < DDC_RETRY_CNT);
+
+	if (cnt == DDC_RETRY_CNT)
+		goto ddc_read_err;
+
+	tvout_dbg("ddc : read data ok\n");
+
+	return 0;
+ddc_read_err:
+	tvout_err("ddc : can't read data, timeout\n");
+	return -1;
+}
+
+static int s5p_ddc_write(u8 reg, int bytes, u8 *src)
+{
+	struct i2c_client *i2c = ddc_port;
+	u8 msg[bytes + 1];
+	int ret, cnt = 0;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+
+	do {
+		if (!s5p_hdmi_reg_get_hpd_status())
+			goto ddc_write_err;
+
+		ret = i2c_master_send(i2c, msg, bytes + 1);
+
+		if (ret < 0 || ret < bytes + 1)
+			tvout_dbg("ddc : can't write data, retry %d\n", cnt);
+		else
+			break;
+
+		msleep(DDC_DELAY);
+		cnt++;
+	} while (cnt < DDC_RETRY_CNT);
+
+	if (cnt == DDC_RETRY_CNT)
+		goto ddc_write_err;
+
+	tvout_dbg("ddc : write data ok\n");
+
+	return 0;
+
+ddc_write_err:
+	tvout_err("ddc : can't write data, timeout\n");
+
+	return -1;
+}
+
+static int __devinit s5p_ddc_probe(struct i2c_client *client,
+				   const struct i2c_device_id *dev_id)
+{
+	int ret = 0;
+
+	ddc_port = client;
+
+	dev_info(&client->adapter->dev, "attached s5p_ddc "
+		"into i2c adapter successfully\n");
+
+	return ret;
+}
+
+static int s5p_ddc_remove(struct i2c_client *client)
+{
+	dev_info(&client->adapter->dev, "detached s5p_ddc "
+		"from i2c adapter successfully\n");
+
+	return 0;
+}
+
+static int s5p_ddc_suspend(struct i2c_client *cl, pm_message_t mesg)
+{
+	return 0;
+};
+
+static int s5p_ddc_resume(struct i2c_client *cl)
+{
+	return 0;
+};
+
+static struct i2c_device_id ddc_idtable[] = {
+	{"s5p_ddc", 0},
+};
+MODULE_DEVICE_TABLE(i2c, ddc_idtable);
+
+static struct i2c_driver ddc_driver = {
+	.driver = {
+		.name	= "s5p_ddc",
+		.owner	= THIS_MODULE,
+	},
+	.id_table	= ddc_idtable,
+	.probe		= s5p_ddc_probe,
+	.remove		= __devexit_p(s5p_ddc_remove),
+	.suspend	= s5p_ddc_suspend,
+	.resume		= s5p_ddc_resume,
+};
+
+static int __init s5p_ddc_init(void)
+{
+	return i2c_add_driver(&ddc_driver);
+}
+
+static void __exit s5p_ddc_exit(void)
+{
+	i2c_del_driver(&ddc_driver);
+}
+module_init(s5p_ddc_init);
+module_exit(s5p_ddc_exit);
+
+MODULE_AUTHOR("Jiun Yu <jiun.yu@samsung.com>");
+MODULE_DESCRIPTION("Samsung S5P HDCP feature for TVOUT driver");
+MODULE_LICENSE("GPL");
+
+static int s5p_hdcp_encryption(bool on)
+{
+	u8 reg;
+
+	if (on)
+		reg = S5P_HDMI_HDCP_ENC_ENABLE;
+	else
+		reg = S5P_HDMI_HDCP_ENC_DISABLE;
+
+	writeb(reg, hdmi_base + S5P_HDMI_ENC_EN);
+	s5p_hdmi_reg_mute(!on);
+
+	return 0;
+}
+
+static int s5p_hdcp_write_key(int sz, int reg, int type)
+{
+	u8 buff[MAX_KEY_SZ] = {0,};
+	int cnt = 0, zero = 0;
+
+	hdmi_read_l(buff, hdmi_base, reg, sz);
+
+	for (cnt = 0; cnt < sz; cnt++)
+		if (buff[cnt] == 0)
+			zero++;
+
+	if (zero == sz) {
+		tvout_dbg("%s : null\n", type == HDCP_An ? "an" : "aksv");
+		goto write_key_err;
+	}
+
+	if (s5p_ddc_write(type, sz, buff) < 0)
+		goto write_key_err;
+
+#ifdef CONFIG_HDCP_DEBUG
+	{
+		u16 i = 0;
+
+		for (i = 1; i < sz + 1; i++)
+			tvout_dbg("%s[%d] : 0x%02x\n",
+				type == HDCP_An ? "an" : "aksv", i, buff[i]);
+	}
+#endif
+
+	return 0;
+
+write_key_err:
+	tvout_err("write %s : failed\n", type == HDCP_An ? "an" : "aksv");
+
+	return -1;
+}
+
+static int s5p_hdcp_read_bcaps(void)
+{
+	u8 bcaps = 0;
+
+	if (s5p_ddc_read(HDCP_Bcaps, BCAPS_SIZE, &bcaps) < 0)
+		goto bcaps_read_err;
+
+	writeb(bcaps, hdmi_base + S5P_HDMI_HDCP_BCAPS);
+
+	if (bcaps & S5P_HDMI_HDCP_BCAPS_REPEATER)
+		hdcp_info.is_repeater = 1;
+	else
+		hdcp_info.is_repeater = 0;
+
+	tvout_dbg("device : %s\n", hdcp_info.is_repeater ? "REPEAT" : "SINK");
+	tvout_dbg("[i2c] bcaps : 0x%02x\n", bcaps);
+	tvout_dbg("[sfr] bcaps : 0x%02x\n",
+		readb(hdmi_base + S5P_HDMI_HDCP_BCAPS));
+
+	return 0;
+
+bcaps_read_err:
+	tvout_err("can't read bcaps : timeout\n");
+
+	return -1;
+}
+
+static int s5p_hdcp_read_bksv(void)
+{
+	u8 bksv[BKSV_SZ] = {0, };
+	int i = 0, j = 0;
+	u32 one = 0, zero = 0, res = 0;
+	u32 cnt = 0;
+
+	do {
+		if (s5p_ddc_read(HDCP_Bksv, BKSV_SZ, bksv) < 0)
+			goto bksv_read_err;
+
+#ifdef CONFIG_HDCP_DEBUG
+		for (i = 0; i < BKSV_SZ; i++)
+			tvout_dbg("i2c read : bksv[%d]: 0x%x\n", i, bksv[i]);
+#endif
+
+		for (i = 0; i < BKSV_SZ; i++) {
+
+			for (j = 0; j < 8; j++) {
+				res = bksv[i] & (0x1 << j);
+
+				if (res == 0)
+					zero++;
+				else
+					one++;
+			}
+
+		}
+
+		if ((zero == 20) && (one == 20)) {
+			hdmi_write_l(bksv, hdmi_base,
+				S5P_HDMI_HDCP_BKSV_0_0, BKSV_SZ);
+			break;
+		}
+		tvout_dbg("invalid bksv, retry : %d\n", cnt);
+
+		msleep(BKSV_DELAY);
+		cnt++;
+	} while (cnt < BKSV_RETRY_CNT);
+
+	if (cnt == BKSV_RETRY_CNT)
+		goto bksv_read_err;
+
+	tvout_dbg("bksv read OK, retry : %d\n", cnt);
+
+	return 0;
+
+bksv_read_err:
+	tvout_err("can't read bksv : timeout\n");
+
+	return -1;
+}
+
+static int s5p_hdcp_read_ri(void)
+{
+	u8 ri[2] = {0, 0};
+	u8 rj[2] = {0, 0};
+
+	ri[0] = readb(hdmi_base + S5P_HDMI_HDCP_Ri_0);
+	ri[1] = readb(hdmi_base + S5P_HDMI_HDCP_Ri_1);
+
+	if (s5p_ddc_read(HDCP_Ri, 2, rj) < 0)
+		goto compare_err;
+
+	tvout_dbg("Rx(ddc) -> rj[0]: 0x%02x, rj[1]: 0x%02x\n",
+		rj[0], rj[1]);
+	tvout_dbg("Tx(register) -> ri[0]: 0x%02x, ri[1]: 0x%02x\n",
+		ri[0], ri[1]);
+
+	if ((ri[0] == rj[0]) && (ri[1] == rj[1]) && (ri[0] | ri[1])) {
+		writeb(S5P_HDMI_HDCP_Ri_MATCH_RESULT_Y,
+			hdmi_base + S5P_HDMI_HDCP_CHECK_RESULT);
+	} else {
+		writeb(S5P_HDMI_HDCP_Ri_MATCH_RESULT_N,
+			hdmi_base + S5P_HDMI_HDCP_CHECK_RESULT);
+		goto compare_err;
+	}
+
+	ri[0] = 0;
+	ri[1] = 0;
+	rj[0] = 0;
+	rj[1] = 0;
+
+	tvout_dbg("ri, ri' : matched\n");
+
+	return 0;
+
+compare_err:
+	hdcp_info.event		= HDCP_EVENT_STOP;
+	hdcp_info.auth_status	= NOT_AUTHENTICATED;
+	tvout_err("read ri : failed - missmatch\n");
+
+	return -1;
+}
+
+static void s5p_hdcp_reset_sw(void)
+{
+	u8 reg;
+
+	sw_reset = true;
+	reg = s5p_hdmi_reg_intc_get_enabled();
+
+	s5p_hdmi_reg_intc_enable(HDMI_IRQ_HPD_PLUG, 0);
+	s5p_hdmi_reg_intc_enable(HDMI_IRQ_HPD_UNPLUG, 0);
+
+	/* need some delay (at least 1 frame) */
+	mdelay(50);
+
+	s5p_hdmi_reg_sw_hpd_enable(true);
+	s5p_hdmi_reg_set_hpd_onoff(false);
+	s5p_hdmi_reg_set_hpd_onoff(true);
+	s5p_hdmi_reg_sw_hpd_enable(false);
+
+	if (reg & 1<<HDMI_IRQ_HPD_PLUG)
+		s5p_hdmi_reg_intc_enable(HDMI_IRQ_HPD_PLUG, 1);
+
+	if (reg & 1<<HDMI_IRQ_HPD_UNPLUG)
+		s5p_hdmi_reg_intc_enable(HDMI_IRQ_HPD_UNPLUG, 1);
+
+	sw_reset = false;
+}
+
+static void s5p_hdcp_reset_auth(void)
+{
+	u8 reg;
+
+	spin_lock_irq(&hdcp_info.reset_lock);
+
+	hdcp_info.event		= HDCP_EVENT_STOP;
+	hdcp_info.auth_status	= NOT_AUTHENTICATED;
+
+	writeb(0x0, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+	writeb(0x0, hdmi_base + S5P_HDMI_HDCP_CTRL2);
+	s5p_hdmi_reg_mute(true);
+
+	s5p_hdcp_encryption(false);
+
+	tvout_err("reset authentication\n");
+
+	reg = readb(hdmi_base + S5P_HDMI_STATUS_EN);
+	reg &= S5P_HDMI_INT_DIS_ALL;
+	writeb(reg, hdmi_base + S5P_HDMI_STATUS_EN);
+
+	writeb(S5P_HDMI_HDCP_CLR_ALL_RESULTS,
+				hdmi_base + S5P_HDMI_HDCP_CHECK_RESULT);
+
+	s5p_hdcp_reset_sw();
+
+	reg = readb(hdmi_base + S5P_HDMI_STATUS_EN);
+	reg |= S5P_HDMI_WTFORACTIVERX_INT_OCC |
+		S5P_HDMI_WATCHDOG_INT_OCC |
+		S5P_HDMI_WRITE_INT_OCC |
+		S5P_HDMI_UPDATE_RI_INT_OCC;
+	writeb(reg, hdmi_base + S5P_HDMI_STATUS_EN);
+	writeb(S5P_HDMI_HDCP_CP_DESIRED_EN, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+	spin_unlock_irq(&hdcp_info.reset_lock);
+}
+
+static int s5p_hdcp_loadkey(void)
+{
+	u8 reg;
+	int cnt = 0;
+
+	writeb(S5P_HDMI_EFUSE_CTRL_HDCP_KEY_READ,
+				hdmi_base + S5P_HDMI_EFUSE_CTRL);
+
+	do {
+		reg = readb(hdmi_base + S5P_HDMI_EFUSE_STATUS);
+		if (reg & S5P_HDMI_EFUSE_ECC_DONE)
+			break;
+		cnt++;
+		mdelay(1);
+	} while (cnt < KEY_LOAD_RETRY_CNT);
+
+	if (cnt == KEY_LOAD_RETRY_CNT)
+		goto key_load_err;
+
+	reg = readb(hdmi_base + S5P_HDMI_EFUSE_STATUS);
+
+	if (reg & S5P_HDMI_EFUSE_ECC_FAIL)
+		goto key_load_err;
+
+	tvout_dbg("load key : OK\n");
+
+	return 0;
+
+key_load_err:
+	tvout_err("can't load key\n");
+
+	return -1;
+}
+
+static int s5p_hdmi_start_encryption(void)
+{
+	u8 reg;
+	u32 cnt = 0;
+
+	do {
+		reg = readb(hdmi_base + S5P_HDMI_SYS_STATUS);
+
+		if (reg & S5P_HDMI_AUTHEN_ACK_AUTH) {
+			s5p_hdcp_encryption(true);
+			break;
+		}
+
+		cnt++;
+	} while (cnt < ENCRYPT_CHECK_CNT);
+
+	if (cnt == ENCRYPT_CHECK_CNT)
+		goto encrypt_err;
+
+
+	tvout_dbg("encrypt : start\n");
+
+	return 0;
+
+encrypt_err:
+	s5p_hdcp_encryption(false);
+	tvout_err("encrypt : failed\n");
+
+	return -1;
+}
+
+static int s5p_hdmi_check_repeater(void)
+{
+	int reg = 0;
+	int cnt = 0, cnt2 = 0;
+
+	u8 bcaps = 0;
+	u8 status[BSTATUS_SIZE] = {0, 0};
+	u8 rx_v[SHA_1_HASH_SIZE] = {0};
+	u8 ksv_list[HDCP_MAX_DEVS * HDCP_KSV_SIZE] = {0};
+
+	u32 dev_cnt;
+
+	memset(rx_v, 0x0, SHA_1_HASH_SIZE);
+	memset(ksv_list, 0x0, HDCP_MAX_DEVS * HDCP_KSV_SIZE);
+
+	do {
+		if (s5p_hdcp_read_bcaps() < 0)
+			goto check_repeater_err;
+
+		bcaps = readb(hdmi_base + S5P_HDMI_HDCP_BCAPS);
+
+		if (bcaps & KSV_FIFO_READY) {
+			tvout_dbg("repeater : ksv fifo not ready");
+			tvout_dbg(", retries : %d\n", cnt);
+			break;
+		}
+
+		msleep(KSV_FIFO_CHK_DELAY);
+
+		cnt++;
+	} while (cnt < KSV_FIFO_RETRY_CNT);
+
+	if (cnt == KSV_FIFO_RETRY_CNT)
+		return REPEATER_TIMEOUT_ERROR;
+
+	tvout_dbg("repeater : ksv fifo ready\n");
+
+	if (s5p_ddc_read(HDCP_BStatus, BSTATUS_SIZE, status) < 0)
+		goto check_repeater_err;
+
+	if (status[1] & MAX_CASCADE_EXCEEDED)
+		return MAX_CASCADE_EXCEEDED_ERROR;
+
+	else if (status[0] & MAX_DEVS_EXCEEDED)
+		return MAX_DEVS_EXCEEDED_ERROR;
+
+	writeb(status[0], hdmi_base + S5P_HDMI_HDCP_BSTATUS_0);
+	writeb(status[1], hdmi_base + S5P_HDMI_HDCP_BSTATUS_1);
+
+	tvout_dbg("status[0] :0x%02x\n", status[0]);
+	tvout_dbg("status[1] :0x%02x\n", status[1]);
+
+	dev_cnt = status[0] & 0x7f;
+
+	tvout_dbg("repeater : dev cnt = %d\n", dev_cnt);
+
+	if (dev_cnt) {
+
+		if (s5p_ddc_read(HDCP_KSVFIFO, dev_cnt * HDCP_KSV_SIZE,
+				ksv_list) < 0)
+			goto check_repeater_err;
+
+		cnt = 0;
+
+		do {
+			hdmi_write_l(&ksv_list[cnt*5], hdmi_base,
+				S5P_HDMI_HDCP_RX_KSV_0_0, HDCP_KSV_SIZE);
+
+			reg = S5P_HDMI_HDCP_KSV_WRITE_DONE;
+
+			if (cnt == dev_cnt - 1)
+				reg |= S5P_HDMI_HDCP_KSV_END;
+
+			writeb(reg, hdmi_base + S5P_HDMI_HDCP_KSV_LIST_CON);
+
+			if (cnt < dev_cnt - 1) {
+				cnt2 = 0;
+				do {
+					reg = readb(hdmi_base
+						+ S5P_HDMI_HDCP_KSV_LIST_CON);
+
+					if (reg & S5P_HDMI_HDCP_KSV_READ)
+						break;
+					cnt2++;
+				} while (cnt2 < KSV_LIST_RETRY_CNT);
+
+				if (cnt2 == KSV_LIST_RETRY_CNT)
+					tvout_dbg("ksv list not readed\n");
+			}
+			cnt++;
+		} while (cnt < dev_cnt);
+	} else {
+		writeb(S5P_HDMI_HDCP_KSV_LIST_EMPTY,
+			hdmi_base + S5P_HDMI_HDCP_KSV_LIST_CON);
+	}
+
+	if (s5p_ddc_read(HDCP_SHA1, SHA_1_HASH_SIZE, rx_v) < 0)
+		goto check_repeater_err;
+
+#ifdef S5P_HDCP_DEBUG
+	for (i = 0; i < SHA_1_HASH_SIZE; i++)
+		tvout_dbg("[i2c] SHA-1 rx :: %02x\n", rx_v[i]);
+#endif
+
+	hdmi_write_l(rx_v, hdmi_base, S5P_HDMI_HDCP_RX_SHA1_0_0,
+		SHA_1_HASH_SIZE);
+
+	reg = readb(hdmi_base + S5P_HDMI_HDCP_SHA_RESULT);
+	if (reg & S5P_HDMI_HDCP_SHA_VALID_RD) {
+		if (reg & S5P_HDMI_HDCP_SHA_VALID) {
+			tvout_dbg("SHA-1 result : OK\n");
+			writeb(0x0, hdmi_base + S5P_HDMI_HDCP_SHA_RESULT);
+		} else {
+			tvout_dbg("SHA-1 result : not vaild\n");
+			writeb(0x0, hdmi_base + S5P_HDMI_HDCP_SHA_RESULT);
+			goto check_repeater_err;
+		}
+	} else {
+		tvout_dbg("SHA-1 result : not ready\n");
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_SHA_RESULT);
+		goto check_repeater_err;
+	}
+
+	tvout_dbg("check repeater : OK\n");
+
+	return 0;
+
+check_repeater_err:
+	tvout_err("check repeater : failed\n");
+
+	return -1;
+}
+
+int s5p_hdcp_stop(void)
+{
+	u32  sfr_val = 0;
+
+	tvout_dbg("HDCP function Stop!!\n");
+
+	s5p_hdmi_reg_intc_enable(HDMI_IRQ_HDCP, 0);
+
+	hdcp_info.event		= HDCP_EVENT_STOP;
+	hdcp_info.auth_status	= NOT_AUTHENTICATED;
+	hdcp_info.hdcp_enable	= false;
+
+	writeb(0x0, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+	s5p_hdmi_reg_sw_hpd_enable(false);
+
+	sfr_val = readb(hdmi_base + S5P_HDMI_STATUS_EN);
+	sfr_val &= S5P_HDMI_INT_DIS_ALL;
+	writeb(sfr_val, hdmi_base + S5P_HDMI_STATUS_EN);
+
+	sfr_val = readb(hdmi_base + S5P_HDMI_SYS_STATUS);
+	sfr_val |= S5P_HDMI_INT_EN_ALL;
+	writeb(sfr_val, hdmi_base + S5P_HDMI_SYS_STATUS);
+
+	tvout_dbg("Stop Encryption by Stop!!\n");
+	s5p_hdcp_encryption(false);
+
+	writeb(S5P_HDMI_HDCP_Ri_MATCH_RESULT_N,
+			hdmi_base + S5P_HDMI_HDCP_CHECK_RESULT);
+	writeb(S5P_HDMI_HDCP_CLR_ALL_RESULTS,
+			hdmi_base + S5P_HDMI_HDCP_CHECK_RESULT);
+
+	return 0;
+}
+
+int s5p_hdcp_start(void)
+{
+	u32  sfr_val;
+
+	hdcp_info.event		= HDCP_EVENT_STOP;
+	hdcp_info.auth_status	= NOT_AUTHENTICATED;
+
+	tvout_dbg("HDCP function Start\n");
+
+	s5p_hdcp_reset_sw();
+
+	tvout_dbg("Stop Encryption by Start\n");
+
+	s5p_hdcp_encryption(false);
+
+	if (s5p_hdcp_loadkey() < 0)
+		return -1;
+
+	writeb(S5P_HDMI_GCP_CON_NO_TRAN, hdmi_base + S5P_HDMI_GCP_CON);
+	writeb(S5P_HDMI_INT_EN_ALL, hdmi_base + S5P_HDMI_STATUS_EN);
+
+	sfr_val = S5P_HDMI_HDCP_CP_DESIRED_EN;
+	writeb(sfr_val, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+	s5p_hdmi_reg_intc_enable(HDMI_IRQ_HDCP, 1);
+
+	hdcp_info.hdcp_enable = 1;
+
+	return 0;
+}
+
+static int s5p_hdcp_bksv(void)
+{
+	tvout_dbg("bksv start : start\n");
+
+	hdcp_info.auth_status = RECEIVER_READ_READY;
+
+	if (s5p_hdcp_read_bcaps() < 0)
+		goto bksv_start_err;
+
+	hdcp_info.auth_status = BCAPS_READ_DONE;
+
+	if (s5p_hdcp_read_bksv() < 0)
+		goto bksv_start_err;
+
+	hdcp_info.auth_status = BKSV_READ_DONE;
+
+	tvout_dbg("bksv start : OK\n");
+
+	return 0;
+
+bksv_start_err:
+	tvout_err("bksv start : failed\n");
+
+	return -1;
+}
+
+static int s5p_hdcp_second_auth(void)
+{
+	int reg = 0, ret = 0;
+
+	tvout_dbg("second auth : start\n");
+
+	if (!hdcp_info.hdcp_enable)
+		goto second_auth_err;
+
+	ret = s5p_hdmi_check_repeater();
+
+	if (!ret) {
+		hdcp_info.auth_status = SECOND_AUTHENTICATION_DONE;
+		s5p_hdmi_start_encryption();
+	} else {
+		switch (ret) {
+
+		case REPEATER_ILLEGAL_DEVICE_ERROR:
+			writeb(0x01, hdmi_base + S5P_HDMI_HDCP_CTRL2);
+
+			/* need before writing 0x0 */
+			mdelay(1);
+
+			writeb(0x0, hdmi_base + S5P_HDMI_HDCP_CTRL2);
+
+			tvout_dbg("repeater : illegal device\n");
+			break;
+		case REPEATER_TIMEOUT_ERROR:
+			reg = readb(hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+			reg |= S5P_HDMI_HDCP_SET_REPEATER_TIMEOUT;
+			writeb(reg, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+			reg &= ~S5P_HDMI_HDCP_SET_REPEATER_TIMEOUT;
+			writeb(reg, hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+			tvout_dbg("repeater : timeout\n");
+			break;
+		case MAX_CASCADE_EXCEEDED_ERROR:
+
+			tvout_dbg("repeater : exceeded MAX_CASCADE\n");
+			break;
+		case MAX_DEVS_EXCEEDED_ERROR:
+
+			tvout_dbg("repeater : exceeded MAX_DEVS\n");
+			break;
+		default:
+			break;
+		}
+
+		hdcp_info.auth_status = NOT_AUTHENTICATED;
+
+		goto second_auth_err;
+
+	}
+
+	tvout_dbg("second auth : OK\n");
+
+	return 0;
+
+second_auth_err:
+	tvout_err("second auth : failed\n");
+
+	return -1;
+}
+
+static int s5p_hdcp_write_aksv(void)
+{
+	tvout_dbg("aksv start : start\n");
+
+	if (hdcp_info.auth_status != BKSV_READ_DONE) {
+		tvout_dbg("aksv start : bksv is not ready\n");
+		goto aksv_write_err;
+	}
+
+	if (s5p_hdcp_write_key(AN_SZ, S5P_HDMI_HDCP_An_0_0, HDCP_An) < 0)
+		goto aksv_write_err;
+
+	hdcp_info.auth_status = AN_WRITE_DONE;
+
+	tvout_dbg("write an : done\n");
+
+	if (s5p_hdcp_write_key(AKSV_SZ, S5P_HDMI_HDCP_AKSV_0_0, HDCP_Aksv) < 0)
+		goto aksv_write_err;
+
+	hdcp_info.auth_status = AKSV_WRITE_DONE;
+
+	tvout_dbg("write aksv : done\n");
+	tvout_dbg("aksv start : OK\n");
+
+	return 0;
+
+aksv_write_err:
+	tvout_err("aksv start : failed\n");
+
+	return -1;
+}
+
+static int s5p_hdcp_check_ri(void)
+{
+	tvout_dbg("ri check : start\n");
+
+	if (hdcp_info.auth_status < AKSV_WRITE_DONE) {
+		tvout_dbg("ri check : not ready\n");
+		goto check_ri_err;
+	}
+
+	if (s5p_hdcp_read_ri() < 0)
+		goto check_ri_err;
+
+	if (hdcp_info.is_repeater)
+		hdcp_info.auth_status
+			= SECOND_AUTHENTICATION_RDY;
+	else {
+		hdcp_info.auth_status
+			= FIRST_AUTHENTICATION_DONE;
+		s5p_hdmi_start_encryption();
+	}
+
+	tvout_dbg("ri check : OK\n");
+
+	return 0;
+
+check_ri_err:
+	tvout_err("ri check : failed\n");
+
+	return -1;
+}
+
+static void s5p_hdcp_work(void *arg)
+{
+	if (hdcp_info.event & HDCP_EVENT_READ_BKSV_START) {
+		if (s5p_hdcp_bksv() < 0)
+			goto work_err;
+		else
+			hdcp_info.event &= ~HDCP_EVENT_READ_BKSV_START;
+	}
+
+	if (hdcp_info.event & HDCP_EVENT_SECOND_AUTH_START) {
+		if (s5p_hdcp_second_auth() < 0)
+			goto work_err;
+		else
+			hdcp_info.event &= ~HDCP_EVENT_SECOND_AUTH_START;
+	}
+
+	if (hdcp_info.event & HDCP_EVENT_WRITE_AKSV_START) {
+		if (s5p_hdcp_write_aksv() < 0)
+			goto work_err;
+		else
+			hdcp_info.event  &= ~HDCP_EVENT_WRITE_AKSV_START;
+	}
+
+	if (hdcp_info.event & HDCP_EVENT_CHECK_RI_START) {
+		if (s5p_hdcp_check_ri() < 0)
+			goto work_err;
+		else
+			hdcp_info.event &= ~HDCP_EVENT_CHECK_RI_START;
+	}
+	return;
+
+work_err:
+	s5p_hdcp_reset_auth();
+}
+
+irqreturn_t s5p_hdcp_irq_handler(int irq, void *dev_id)
+{
+	u32 event = 0;
+	u8 flag;
+
+	event = 0;
+
+	flag = readb(hdmi_base + S5P_HDMI_SYS_STATUS);
+
+	if (flag & S5P_HDMI_WTFORACTIVERX_INT_OCC) {
+		event |= HDCP_EVENT_READ_BKSV_START;
+		writeb(flag | S5P_HDMI_WTFORACTIVERX_INT_OCC,
+			 hdmi_base + S5P_HDMI_SYS_STATUS);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_I2C_INT);
+	}
+
+	if (flag & S5P_HDMI_WRITE_INT_OCC) {
+		event |= HDCP_EVENT_WRITE_AKSV_START;
+		writeb(flag | S5P_HDMI_WRITE_INT_OCC,
+			hdmi_base + S5P_HDMI_SYS_STATUS);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_AN_INT);
+	}
+
+	if (flag & S5P_HDMI_UPDATE_RI_INT_OCC) {
+		event |= HDCP_EVENT_CHECK_RI_START;
+		writeb(flag | S5P_HDMI_UPDATE_RI_INT_OCC,
+			hdmi_base + S5P_HDMI_SYS_STATUS);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_RI_INT);
+	}
+
+	if (flag & S5P_HDMI_WATCHDOG_INT_OCC) {
+		event |= HDCP_EVENT_SECOND_AUTH_START;
+		writeb(flag | S5P_HDMI_WATCHDOG_INT_OCC,
+			hdmi_base + S5P_HDMI_SYS_STATUS);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_WDT_INT);
+	}
+
+	if (!event) {
+		tvout_dbg("unknown irq\n");
+		return IRQ_HANDLED;
+	}
+
+	hdcp_info.event |= event;
+	schedule_work(&hdcp_info.work);
+
+	return IRQ_HANDLED;
+}
+
+int s5p_hdcp_init(void)
+{
+	INIT_WORK(&hdcp_info.work, (work_func_t) s5p_hdcp_work);
+
+	spin_lock_init(&hdcp_info.reset_lock);
+
+	s5p_hdmi_reg_intc_set_isr(s5p_hdcp_irq_handler,
+					(u8) HDMI_IRQ_HDCP);
+
+	return 0;
+}
+
+int s5p_hdcp_encrypt_stop(bool on)
+{
+	u32 reg;
+
+	spin_lock_irq(&hdcp_info.reset_lock);
+
+	if (hdcp_info.hdcp_enable) {
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_I2C_INT);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_AN_INT);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_RI_INT);
+		writeb(0x0, hdmi_base + S5P_HDMI_HDCP_WDT_INT);
+
+		s5p_hdcp_encryption(false);
+
+		if (!sw_reset) {
+			reg = readb(hdmi_base + S5P_HDMI_HDCP_CTRL1);
+
+			if (on) {
+				writeb(reg | S5P_HDMI_HDCP_CP_DESIRED_EN,
+					hdmi_base + S5P_HDMI_HDCP_CTRL1);
+				s5p_hdmi_reg_intc_enable(HDMI_IRQ_HDCP, 1);
+			} else {
+				hdcp_info.event	= HDCP_EVENT_STOP;
+				hdcp_info.auth_status = NOT_AUTHENTICATED;
+
+				writeb(reg & ~S5P_HDMI_HDCP_CP_DESIRED_EN,
+					hdmi_base + S5P_HDMI_HDCP_CTRL1);
+				s5p_hdmi_reg_intc_enable(HDMI_IRQ_HDCP, 0);
+			}
+		}
+
+		tvout_dbg("stop encryption by HPD\n");
+	}
+
+	spin_unlock_irq(&hdcp_info.reset_lock);
+
+	return 0;
+}
diff --git a/drivers/media/video/s5p-tvout/hw_if/hdmi.c b/drivers/media/video/s5p-tvout/hw_if/hdmi.c
new file mode 100644
index 0000000..84de0a0
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/hdmi.c
@@ -0,0 +1,1365 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * HDMI for Samsung S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/map.h>
+#include <mach/regs-hdmi.h>
+
+#include "../s5p_tvout_common_lib.h"
+#include "hw_if.h"
+
+#undef tvout_dbg
+
+#ifdef CONFIG_HDMI_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "\t\t[HDMI] %s(): " fmt,	\
+			__func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+
+/* Definitions for HDMI_PHY */
+
+#define PHY_I2C_ADDRESS		0x70
+#define PHY_REG_MODE_SET_DONE	0x1F
+
+#define I2C_ACK			(1 << 7)
+#define I2C_INT			(1 << 5)
+#define I2C_PEND		(1 << 4)
+#define I2C_INT_CLEAR		(0 << 4)
+#define I2C_CLK			(0x41)
+#define I2C_CLK_PEND_INT	(I2C_CLK | I2C_INT_CLEAR | I2C_INT)
+#define I2C_ENABLE		(1 << 4)
+#define I2C_START		(1 << 5)
+#define I2C_MODE_MTX		0xC0
+#define I2C_MODE_MRX		0x80
+#define I2C_IDLE		0
+
+#define STATE_IDLE		0
+#define STATE_TX_EDDC_SEGADDR	1
+#define STATE_TX_EDDC_SEGNUM	2
+#define STATE_TX_DDC_ADDR	3
+#define STATE_TX_DDC_OFFSET	4
+#define STATE_RX_DDC_ADDR	5
+#define STATE_RX_DDC_DATA	6
+#define STATE_RX_ADDR		7
+#define STATE_RX_DATA		8
+#define STATE_TX_ADDR		9
+#define STATE_TX_DATA		10
+#define STATE_TX_STOP		11
+#define STATE_RX_STOP		12
+
+static struct {
+	s32	state;
+	u8	*buffer;
+	s32	bytes;
+} i2c_hdmi_phy_context;
+
+/* Definitions for HDMI */
+
+#define HDMI_IRQ_TOTAL_NUM	6
+
+/* private data area */
+
+void __iomem	*hdmi_base;
+void __iomem	*i2c_hdmi_phy_base;
+
+irqreturn_t	(*s5p_hdmi_isr_ftn[HDMI_IRQ_TOTAL_NUM])(int irq, void *);
+spinlock_t	lock_hdmi;
+
+static const u8 phy_config[][3][32] = {
+	{ /* freq = 25.200 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x02, 0x51, 0x5f, 0xF1, 0x54, 0x7e,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xf3, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x02, 0x51, 0x9f, 0xF6, 0x54, 0x9e,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xB8, 0x10, 0xE0,
+			0x22, 0x40, 0xc2, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x02, 0x51, 0xFf, 0xF3, 0x54, 0xbd,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xA4, 0x10, 0xE0,
+			0x22, 0x40, 0xa2, 0x26, 0x00, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 25.175 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x1e, 0x20,
+			0x6B, 0x50, 0x10, 0x51, 0xf1, 0x31, 0x54, 0xbd,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xf3, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x2b, 0x40,
+			0x6B, 0x50, 0x10, 0x51, 0xF2, 0x32, 0x54, 0xec,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xB8, 0x10, 0xE0,
+			0x22, 0x40, 0xc2, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x1e, 0x20,
+			0x6B, 0x10, 0x02, 0x51, 0xf1, 0x31, 0x54, 0xbd,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xA4, 0x10, 0xE0,
+			0x22, 0x40, 0xa2, 0x26, 0x00, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 27 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x02, 0x08,
+			0x6A, 0x10, 0x02, 0x51, 0xCf, 0xF1, 0x54, 0xa9,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xB8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xfc, 0x08,
+			0x6B, 0x10, 0x02, 0x51, 0x2f, 0xF2, 0x54, 0xcb,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xA4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x00, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 27.027 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
+			0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe2, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x31, 0x50,
+			0x6B, 0x10, 0x02, 0x51, 0x8f, 0xF3, 0x54, 0xa9,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xB8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0x10, 0x10, 0x9C, 0x1b, 0x64,
+			0x6F, 0x10, 0x02, 0x51, 0x7f, 0xF8, 0x54, 0xcb,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xA4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x00, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 54 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x01, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe3, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x02, 0x08,
+			0x6A, 0x10, 0x01, 0x51, 0xCf, 0xF1, 0x54, 0xa9,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xfc, 0x08,
+			0x6B, 0x10, 0x01, 0x51, 0x2f, 0xF2, 0x54, 0xcb,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x01, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 54.054 MHz */
+		{
+			0x01, 0x05, 0x00, 0xd4, 0x10, 0x9C, 0x09, 0x64,
+			0x6B, 0x10, 0x01, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe2, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xd4, 0x10, 0x9C, 0x31, 0x50,
+			0x6B, 0x10, 0x01, 0x51, 0x8f, 0xF3, 0x54, 0xa9,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0x10, 0x10, 0x9C, 0x1b, 0x64,
+			0x6F, 0x10, 0x01, 0x51, 0x7f, 0xF8, 0x54, 0xcb,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x01, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 74.250 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+			0x6A, 0x10, 0x01, 0x51, 0xff, 0xF1, 0x54, 0xba,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xd6, 0x40,
+			0x6B, 0x10, 0x01, 0x51, 0x7f, 0xF2, 0x54, 0xe8,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0x83, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x34, 0x40,
+			0x6B, 0x10, 0x01, 0x51, 0xef, 0xF2, 0x54, 0x16,
+			0x85, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0xdc, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 74.176 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+			0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0x10, 0x10, 0x9C, 0xab, 0x5B,
+			0x6F, 0x10, 0x01, 0x51, 0xbf, 0xF9, 0x54, 0xe8,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0x84, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0xcd, 0x5B,
+			0x6F, 0x10, 0x01, 0x51, 0xdf, 0xF5, 0x54, 0x16,
+			0x85, 0x00, 0x30, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0xdc, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 148.500 MHz  - Pre-emph + Higher Tx amp. */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
+			0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xd6, 0x40,
+			0x6B, 0x18, 0x00, 0x51, 0x7f, 0xF2, 0x54, 0xe8,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x23, 0x41, 0x83, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x34, 0x40,
+			0x6B, 0x18, 0x00, 0x51, 0xef, 0xF2, 0x54, 0x16,
+			0x85, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x23, 0x41, 0x6d, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 148.352 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
+			0x6D, 0x18, 0x00, 0x51, 0xef, 0xF3, 0x54, 0xb9,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xa5, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0x10, 0x10, 0x9C, 0xab, 0x5B,
+			0x6F, 0x18, 0x00, 0x51, 0xbf, 0xF9, 0x54, 0xe8,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x23, 0x41, 0x84, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0xcd, 0x5B,
+			0x6F, 0x18, 0x00, 0x51, 0xdf, 0xF5, 0x54, 0x16,
+			0x85, 0x00, 0x30, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x23, 0x41, 0x6d, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 108.108 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x09, 0x64,
+			0x6B, 0x18, 0x00, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe2, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD4, 0x10, 0x9C, 0x31, 0x50,
+			0x6D, 0x18, 0x00, 0x51, 0x8f, 0xF3, 0x54, 0xa9,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0x10, 0x10, 0x9C, 0x1b, 0x64,
+			0x6F, 0x18, 0x00, 0x51, 0x7f, 0xF8, 0x54, 0xcb,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 72 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x10, 0x01, 0x51, 0xEf, 0xF1, 0x54, 0xb4,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xaa, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6F, 0x10, 0x01, 0x51, 0xBf, 0xF4, 0x54, 0xe1,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0x88, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6B, 0x18, 0x00, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0xe3, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 25 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x20, 0x40,
+			0x6B, 0x50, 0x10, 0x51, 0xff, 0xF1, 0x54, 0xbc,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xf5, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x08, 0x40,
+			0x6B, 0x50, 0x10, 0x51, 0x7f, 0xF2, 0x54, 0xea,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xB8, 0x10, 0xE0,
+			0x22, 0x40, 0xc4, 0x26, 0x00, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x20, 0x40,
+			0x6B, 0x10, 0x02, 0x51, 0xff, 0xF1, 0x54, 0xbc,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xA4, 0x10, 0xE0,
+			0x22, 0x40, 0xa3, 0x26, 0x00, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 65 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x02, 0x0c,
+			0x6B, 0x10, 0x01, 0x51, 0xBf, 0xF1, 0x54, 0xa3,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xbc, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf2, 0x30,
+			0x6A, 0x10, 0x01, 0x51, 0x2f, 0xF2, 0x54, 0xcb,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0x96, 0x26, 0x01, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xd0, 0x40,
+			0x6B, 0x10, 0x01, 0x51, 0x9f, 0xF2, 0x54, 0xf4,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0x7D, 0x26, 0x01, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 108 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6D, 0x18, 0x00, 0x51, 0xDf, 0xF2, 0x54, 0x87,
+			0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0xe3, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x02, 0x08,
+			0x6A, 0x18, 0x00, 0x51, 0xCf, 0xF1, 0x54, 0xa9,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x22, 0x40, 0xb5, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xfc, 0x08,
+			0x6B, 0x18, 0x00, 0x51, 0x2f, 0xF2, 0x54, 0xcb,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	}, { /* freq = 162 MHz */
+		{
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
+			0x6F, 0x18, 0x00, 0x51, 0x7f, 0xF8, 0x54, 0xcb,
+			0x84, 0x00, 0x32, 0x38, 0x00, 0x08, 0x10, 0xE0,
+			0x22, 0x40, 0x97, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0x18, 0x40,
+			0x6B, 0x18, 0x00, 0x51, 0xAf, 0xF2, 0x54, 0xfd,
+			0x84, 0x00, 0x10, 0x38, 0x00, 0xF8, 0x10, 0xE0,
+			0x23, 0x41, 0x78, 0x26, 0x02, 0x00, 0x00, 0x80,
+		}, {
+			0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xd0, 0x40,
+			0x6B, 0x18, 0x00, 0x51, 0x3f, 0xF3, 0x54, 0x30,
+			0x85, 0x00, 0x10, 0x38, 0x00, 0xE4, 0x10, 0xE0,
+			0x23, 0x41, 0x64, 0x26, 0x02, 0x00, 0x00, 0x80,
+		},
+	},
+};
+
+static void s5p_hdmi_reg_core_reset(void)
+{
+	writeb(0x0, hdmi_base + S5P_HDMI_CORE_RSTOUT);
+
+	/* need before writing 0x1 */
+	mdelay(10);
+
+	writeb(0x1, hdmi_base + S5P_HDMI_CORE_RSTOUT);
+}
+
+static int s5p_hdmi_i2c_phy_interruptwait(void)
+{
+	u8 status, reg;
+
+	do {
+		status = readb(i2c_hdmi_phy_base + HDMI_I2C_CON);
+
+		if (status & I2C_PEND) {
+			reg = readb(i2c_hdmi_phy_base + HDMI_I2C_STAT);
+			break;
+		}
+
+	} while (1);
+
+	return 0;
+}
+
+static int s5p_hdmi_i2c_phy_read(u8 addr, u8 nbytes, u8 *buffer)
+{
+	u8 reg;
+	s32 ret = 0;
+	u32 proc = true;
+
+	i2c_hdmi_phy_context.state = STATE_RX_ADDR;
+	i2c_hdmi_phy_context.buffer = buffer;
+	i2c_hdmi_phy_context.bytes = nbytes;
+
+	writeb(I2C_CLK | I2C_INT | I2C_ACK, i2c_hdmi_phy_base + HDMI_I2C_CON);
+	writeb(I2C_ENABLE | I2C_MODE_MRX, i2c_hdmi_phy_base + HDMI_I2C_STAT);
+	writeb(addr & 0xFE, i2c_hdmi_phy_base + HDMI_I2C_DS);
+	writeb(I2C_ENABLE | I2C_START | I2C_MODE_MRX,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+
+	while (proc) {
+
+		if (i2c_hdmi_phy_context.state != STATE_RX_STOP) {
+
+			if (s5p_hdmi_i2c_phy_interruptwait() != 0) {
+				tvout_err("interrupt wait failed!!!\n");
+				ret = -1;
+				break;
+			}
+
+		}
+
+		switch (i2c_hdmi_phy_context.state) {
+		case STATE_RX_DATA:
+			reg = readb(i2c_hdmi_phy_base + HDMI_I2C_DS);
+			*(i2c_hdmi_phy_context.buffer) = reg;
+
+			i2c_hdmi_phy_context.buffer++;
+			--(i2c_hdmi_phy_context.bytes);
+
+			if (i2c_hdmi_phy_context.bytes == 1) {
+				i2c_hdmi_phy_context.state = STATE_RX_STOP;
+				writeb(I2C_CLK_PEND_INT,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			} else {
+				writeb(I2C_CLK_PEND_INT | I2C_ACK,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			}
+
+			break;
+
+		case STATE_RX_ADDR:
+			i2c_hdmi_phy_context.state = STATE_RX_DATA;
+
+			if (i2c_hdmi_phy_context.bytes == 1) {
+				i2c_hdmi_phy_context.state = STATE_RX_STOP;
+				writeb(I2C_CLK_PEND_INT,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			} else {
+				writeb(I2C_CLK_PEND_INT | I2C_ACK,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			}
+
+			break;
+
+		case STATE_RX_STOP:
+			i2c_hdmi_phy_context.state = STATE_IDLE;
+
+			reg = readb(i2c_hdmi_phy_base + HDMI_I2C_DS);
+
+			*(i2c_hdmi_phy_context.buffer) = reg;
+
+			writeb(I2C_MODE_MRX|I2C_ENABLE,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+			writeb(I2C_CLK_PEND_INT,
+				i2c_hdmi_phy_base + HDMI_I2C_CON);
+			writeb(I2C_MODE_MRX,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+
+			while (readb(i2c_hdmi_phy_base + HDMI_I2C_STAT) & I2C_START)
+				msleep(20);
+
+			proc = false;
+			break;
+
+		case STATE_IDLE:
+		default:
+			tvout_err("error state!!!\n");
+
+			ret = -1;
+
+			proc = false;
+			break;
+		}
+	}
+	return ret;
+}
+
+static int s5p_hdmi_i2c_phy_write(u8 addr, u8 nbytes, u8 *buffer)
+{
+	u8 reg;
+	s32 ret = 0;
+	u32 proc = true;
+
+	i2c_hdmi_phy_context.state = STATE_TX_ADDR;
+	i2c_hdmi_phy_context.buffer = buffer;
+	i2c_hdmi_phy_context.bytes = nbytes;
+
+	writeb(I2C_CLK | I2C_INT | I2C_ACK, i2c_hdmi_phy_base + HDMI_I2C_CON);
+	writeb(I2C_ENABLE | I2C_MODE_MTX, i2c_hdmi_phy_base + HDMI_I2C_STAT);
+	writeb(addr & 0xFE, i2c_hdmi_phy_base + HDMI_I2C_DS);
+	writeb(I2C_ENABLE | I2C_START | I2C_MODE_MTX,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+
+	while (proc) {
+
+		if (s5p_hdmi_i2c_phy_interruptwait() != 0) {
+			tvout_err("interrupt wait failed!!!\n");
+			ret = -1;
+
+			break;
+		}
+
+		switch (i2c_hdmi_phy_context.state) {
+		case STATE_TX_ADDR:
+		case STATE_TX_DATA:
+			i2c_hdmi_phy_context.state = STATE_TX_DATA;
+
+			reg = *(i2c_hdmi_phy_context.buffer);
+
+			writeb(reg, i2c_hdmi_phy_base + HDMI_I2C_DS);
+
+			i2c_hdmi_phy_context.buffer++;
+			--(i2c_hdmi_phy_context.bytes);
+
+			if (i2c_hdmi_phy_context.bytes == 0) {
+				i2c_hdmi_phy_context.state = STATE_TX_STOP;
+				writeb(I2C_CLK_PEND_INT,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			} else {
+				writeb(I2C_CLK_PEND_INT | I2C_ACK,
+					i2c_hdmi_phy_base + HDMI_I2C_CON);
+			}
+
+			break;
+
+		case STATE_TX_STOP:
+			i2c_hdmi_phy_context.state = STATE_IDLE;
+
+			writeb(I2C_MODE_MTX | I2C_ENABLE,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+			writeb(I2C_CLK_PEND_INT,
+				i2c_hdmi_phy_base + HDMI_I2C_CON);
+			writeb(I2C_MODE_MTX,
+				i2c_hdmi_phy_base + HDMI_I2C_STAT);
+
+			while (readb(i2c_hdmi_phy_base + HDMI_I2C_STAT) & I2C_START)
+				msleep(20);
+
+			proc = false;
+			break;
+
+		case STATE_IDLE:
+		default:
+			tvout_err("error state!!!\n");
+
+			ret = -1;
+
+			proc = false;
+			break;
+		}
+	}
+	return ret;
+}
+
+#ifdef CONFIG_SND_SAMSUNG_SPDIF
+static void s5p_hdmi_audio_set_config(enum s5p_tvout_audio_codec_type audio_codec)
+{
+	u32 data_type = (audio_codec == PCM) ?
+			S5P_HDMI_SPDIFIN_CFG_LINEAR_PCM_TYPE :
+			(audio_codec == AC3) ?
+				S5P_HDMI_SPDIFIN_CFG_NO_LINEAR_PCM_TYPE : 0xff;
+
+	tvout_dbg("audio codec type = %s\n",
+		(audio_codec & PCM) ? "PCM" :
+		(audio_codec & AC3) ? "AC3" :
+		(audio_codec & MP3) ? "MP3" :
+		(audio_codec & WMA) ? "WMA" : "Unknown");
+
+	/* open SPDIF path on HDMI_I2S */
+	writeb(S5P_HDMI_I2S_CLK_EN, hdmi_base + S5P_HDMI_I2S_CLK_CON);
+	writeb(readl(hdmi_base + S5P_HDMI_I2S_MUX_CON) |
+		S5P_HDMI_I2S_CUV_I2S_ENABLE |
+		S5P_HDMI_I2S_MUX_ENABLE,
+		hdmi_base + S5P_HDMI_I2S_MUX_CON);
+	writeb(S5P_HDMI_I2S_CH_ALL_EN, hdmi_base + S5P_HDMI_I2S_MUX_CH);
+	writeb(S5P_HDMI_I2S_CUV_RL_EN, hdmi_base + S5P_HDMI_I2S_MUX_CUV);
+
+	writeb(S5P_HDMI_SPDIFIN_CFG_FILTER_2_SAMPLE | data_type |
+		S5P_HDMI_SPDIFIN_CFG_PCPD_MANUAL_SET |
+		S5P_HDMI_SPDIFIN_CFG_WORD_LENGTH_M_SET |
+		S5P_HDMI_SPDIFIN_CFG_U_V_C_P_REPORT |
+		S5P_HDMI_SPDIFIN_CFG_BURST_SIZE_2 |
+		S5P_HDMI_SPDIFIN_CFG_DATA_ALIGN_32BIT,
+		hdmi_base + S5P_HDMI_SPDIFIN_CONFIG_1);
+
+	writeb(S5P_HDMI_SPDIFIN_CFG2_NO_CLK_DIV,
+		hdmi_base + S5P_HDMI_SPDIFIN_CONFIG_2);
+}
+
+static void s5p_hdmi_audio_clock_enable(void)
+{
+	writeb(S5P_HDMI_SPDIFIN_CLK_ON, hdmi_base + S5P_HDMI_SPDIFIN_CLK_CTRL);
+	writeb(S5P_HDMI_SPDIFIN_STATUS_CHK_OP_MODE,
+		hdmi_base + S5P_HDMI_SPDIFIN_OP_CTRL);
+}
+
+static void s5p_hdmi_audio_set_repetition_time(
+				enum s5p_tvout_audio_codec_type audio_codec,
+				u32 bits, u32 frame_size_code)
+{
+	/* Only 4'b1011 24bit */
+	u32 wl = 5 << 1 | 1;
+	u32 rpt_cnt = (audio_codec == AC3) ? 1536 * 2 - 1 : 0;
+
+	tvout_dbg("repetition count = %d\n", rpt_cnt);
+
+	/* 24bit and manual mode */
+	writeb(((rpt_cnt & 0xf) << 4) | wl,
+		hdmi_base + S5P_HDMI_SPDIFIN_USER_VALUE_1);
+	/* if PCM this value is 0 */
+	writeb((rpt_cnt >> 4) & 0xff,
+		hdmi_base + S5P_HDMI_SPDIFIN_USER_VALUE_2);
+	/* if PCM this value is 0 */
+	writeb(frame_size_code & 0xff,
+		hdmi_base + S5P_HDMI_SPDIFIN_USER_VALUE_3);
+	/* if PCM this value is 0 */
+	writeb((frame_size_code >> 8) & 0xff,
+		hdmi_base + S5P_HDMI_SPDIFIN_USER_VALUE_4);
+}
+
+static void s5p_hdmi_audio_irq_enable(u32 irq_en)
+{
+	writeb(irq_en, hdmi_base + S5P_HDMI_SPDIFIN_IRQ_MASK);
+}
+
+#else
+
+static void s5p_hdmi_audio_i2s_config(
+		enum s5p_tvout_audio_codec_type audio_codec,
+		u32 sample_rate, u32 bits_per_sample,
+		u32 frame_size_code)
+{
+	u32 data_num, bit_ch, sample_frq;
+
+	if (bits_per_sample == 20) {
+		data_num = 2;
+		bit_ch  = 1;
+	} else if (bits_per_sample == 24) {
+		data_num = 3;
+		bit_ch  = 1;
+	} else {
+		data_num = 1;
+		bit_ch  = 0;
+	}
+
+	writeb((S5P_HDMI_I2S_IN_DISABLE | S5P_HDMI_I2S_AUD_I2S |
+		S5P_HDMI_I2S_CUV_I2S_ENABLE | S5P_HDMI_I2S_MUX_ENABLE),
+		hdmi_base + S5P_HDMI_I2S_MUX_CON);
+
+	writeb(S5P_HDMI_I2S_CH0_EN | S5P_HDMI_I2S_CH1_EN | S5P_HDMI_I2S_CH2_EN,
+		hdmi_base + S5P_HDMI_I2S_MUX_CH);
+
+	writeb(S5P_HDMI_I2S_CUV_RL_EN, hdmi_base + S5P_HDMI_I2S_MUX_CUV);
+
+	sample_frq = (sample_rate == 44100) ? 0 :
+			(sample_rate == 48000) ? 2 :
+			(sample_rate == 32000) ? 3 :
+			(sample_rate == 96000) ? 0xa : 0x0;
+
+	/* readl(hdmi_base + S5P_HDMI_YMAX) */
+	writeb(S5P_HDMI_I2S_CLK_DIS, hdmi_base + S5P_HDMI_I2S_CLK_CON);
+	writeb(S5P_HDMI_I2S_CLK_EN, hdmi_base + S5P_HDMI_I2S_CLK_CON);
+
+	writeb(readl(hdmi_base + S5P_HDMI_I2S_DSD_CON) | 0x01,
+		hdmi_base + S5P_HDMI_I2S_DSD_CON);
+
+	/* Configuration I2S input ports. Configure I2S_PIN_SEL_0~4 */
+	writeb(S5P_HDMI_I2S_SEL_SCLK(5) | S5P_HDMI_I2S_SEL_LRCK(6),
+		hdmi_base + S5P_HDMI_I2S_PIN_SEL_0);
+	writeb(S5P_HDMI_I2S_SEL_SDATA1(1) | S5P_HDMI_I2S_SEL_SDATA2(4),
+		hdmi_base + S5P_HDMI_I2S_PIN_SEL_1);
+	writeb(S5P_HDMI_I2S_SEL_SDATA3(1) | S5P_HDMI_I2S_SEL_SDATA2(2),
+		hdmi_base + S5P_HDMI_I2S_PIN_SEL_2);
+	writeb(S5P_HDMI_I2S_SEL_DSD(0), hdmi_base + S5P_HDMI_I2S_PIN_SEL_3);
+
+	/* I2S_CON_1 & 2 */
+	writeb(S5P_HDMI_I2S_SCLK_FALLING_EDGE | S5P_HDMI_I2S_L_CH_LOW_POL,
+		hdmi_base + S5P_HDMI_I2S_CON_1);
+	writeb(S5P_HDMI_I2S_MSB_FIRST_MODE |
+		S5P_HDMI_I2S_SET_BIT_CH(bit_ch) |
+		S5P_HDMI_I2S_SET_SDATA_BIT(data_num) |
+		S5P_HDMI_I2S_BASIC_FORMAT,
+		hdmi_base + S5P_HDMI_I2S_CON_2);
+
+	/* Configure register related to CUV information */
+	writeb(S5P_HDMI_I2S_CH_STATUS_MODE_0 |
+		S5P_HDMI_I2S_2AUD_CH_WITHOUT_PREEMPH |
+		S5P_HDMI_I2S_COPYRIGHT |
+		S5P_HDMI_I2S_LINEAR_PCM |
+		S5P_HDMI_I2S_CONSUMER_FORMAT,
+		hdmi_base + S5P_HDMI_I2S_CH_ST_0);
+	writeb(S5P_HDMI_I2S_CD_PLAYER,
+		hdmi_base + S5P_HDMI_I2S_CH_ST_1);
+	writeb(S5P_HDMI_I2S_SET_SOURCE_NUM(0),
+		hdmi_base + S5P_HDMI_I2S_CH_ST_2);
+	writeb(S5P_HDMI_I2S_CLK_ACCUR_LEVEL_2 |
+		S5P_HDMI_I2S_SET_SAMPLING_FREQ(sample_frq),
+		hdmi_base + S5P_HDMI_I2S_CH_ST_3);
+	writeb(S5P_HDMI_I2S_ORG_SAMPLING_FREQ_44_1 |
+		S5P_HDMI_I2S_WORD_LENGTH_MAX24_24BITS |
+		S5P_HDMI_I2S_WORD_LENGTH_MAX_24BITS,
+		hdmi_base + S5P_HDMI_I2S_CH_ST_4);
+
+	writeb(S5P_HDMI_I2S_CH_STATUS_RELOAD,
+		hdmi_base + S5P_HDMI_I2S_CH_ST_CON);
+}
+
+#endif /* CONFIG_SND_SAMSUNG_SPDIF */
+
+static u8 s5p_hdmi_checksum(int sum, int size, u8 *data)
+{
+	u32 i;
+
+	for (i = 0; i < size; i++)
+		sum += (u32)(data[i]);
+
+	return (u8)(0x100 - (sum & 0xff));
+}
+
+
+static int s5p_hdmi_phy_control(bool on, u8 addr, u8 offset, u8 *read_buffer)
+{
+	u8 buff[2] = {0};
+
+	buff[0] = addr;
+	buff[1] = (on) ? (read_buffer[addr] & (~(1 << offset))) :
+			(read_buffer[addr] | (1 << offset));
+
+	if (s5p_hdmi_i2c_phy_write(PHY_I2C_ADDRESS, 2, buff) != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool s5p_hdmi_phy_is_enable(void)
+{
+	/* will be populated later */
+
+	return 0;
+}
+
+static void s5p_hdmi_phy_enable(bool on)
+{
+	/* will be populated later */
+}
+
+int s5p_hdmi_phy_power(bool on)
+{
+	u32 size;
+	u8 *buffer;
+	u8 read_buffer[0x40] = {0, };
+
+	size = sizeof(phy_config[0][0])
+		/ sizeof(phy_config[0][0][0]);
+
+	buffer = (u8 *) phy_config[0][0];
+
+	if (on) {
+		if (!s5p_hdmi_phy_is_enable()) {
+			s5p_hdmi_phy_enable(1);
+
+			if (s5p_hdmi_i2c_phy_write(
+				PHY_I2C_ADDRESS, 1, buffer) != 0)
+				goto ret_on_err;
+
+			if (s5p_hdmi_i2c_phy_read(
+				PHY_I2C_ADDRESS, size, read_buffer) != 0) {
+				tvout_err("s5p_hdmi_i2c_phy_read failed.\n");
+				goto ret_on_err;
+			}
+
+			s5p_hdmi_phy_control(true, 0x1, 0x5, read_buffer);
+			s5p_hdmi_phy_control(true, 0x1, 0x7, read_buffer);
+			s5p_hdmi_phy_control(true, 0x5, 0x5, read_buffer);
+			s5p_hdmi_phy_control(true, 0x17, 0x0, read_buffer);
+			s5p_hdmi_phy_control(true, 0x17, 0x1, read_buffer);
+		}
+	} else {
+		if (s5p_hdmi_phy_is_enable()) {
+			if (s5p_hdmi_i2c_phy_write(
+				PHY_I2C_ADDRESS, 1, buffer) != 0)
+				goto ret_on_err;
+
+			if (s5p_hdmi_i2c_phy_read(
+				PHY_I2C_ADDRESS, size, read_buffer) != 0) {
+				tvout_err("s5p_hdmi_i2c_phy_read failed.\n");
+				goto ret_on_err;
+			}
+
+			s5p_hdmi_phy_control(false, 0x1, 0x5, read_buffer);
+			s5p_hdmi_phy_control(false, 0x1, 0x7, read_buffer);
+			s5p_hdmi_phy_control(false, 0x5, 0x5, read_buffer);
+			s5p_hdmi_phy_control(false, 0x17, 0x0, read_buffer);
+			s5p_hdmi_phy_control(false, 0x17, 0x1, read_buffer);
+
+			s5p_hdmi_phy_enable(0);
+		}
+	}
+
+	return 0;
+
+ret_on_err:
+	return -1;
+}
+
+s32 s5p_hdmi_phy_config(enum phy_freq freq, enum s5p_hdmi_color_depth cd)
+{
+	s32 index;
+	s32 size;
+	u8 buffer[32] = {0, };
+	u8 reg;
+
+	switch (cd) {
+	case HDMI_CD_24:
+		index = 0;
+		break;
+
+	case HDMI_CD_30:
+		index = 1;
+		break;
+
+	case HDMI_CD_36:
+		index = 2;
+		break;
+
+	default:
+		return -1;
+	}
+
+	buffer[0] = PHY_REG_MODE_SET_DONE;
+	buffer[1] = 0x00;
+
+	if (s5p_hdmi_i2c_phy_write(PHY_I2C_ADDRESS, 2, buffer) != 0) {
+		tvout_err("s5p_hdmi_i2c_phy_write failed.\n");
+		return -1;
+	}
+
+	writeb(0x5, i2c_hdmi_phy_base + HDMI_I2C_LC);
+
+	size = sizeof(phy_config[freq][index])
+		/ sizeof(phy_config[freq][index][0]);
+
+	memcpy(buffer, phy_config[freq][index], sizeof(buffer));
+
+	if (s5p_hdmi_i2c_phy_write(PHY_I2C_ADDRESS, size, buffer) != 0)
+		return -1;
+
+	buffer[0] = 0x01;
+
+	if (s5p_hdmi_i2c_phy_write(PHY_I2C_ADDRESS, 1, buffer) != 0) {
+		tvout_err("s5p_hdmi_i2c_phy_write failed.\n");
+		return -1;
+	}
+
+#ifdef CONFIG_HDMI_DEBUG
+{
+	int i = 0;
+	u8 read_buffer[0x40] = {0, };
+
+	/* read data */
+	if (s5p_hdmi_i2c_phy_read(PHY_I2C_ADDRESS, size, read_buffer) != 0) {
+		tvout_err("s5p_hdmi_i2c_phy_read failed.\n");
+		return -1;
+	}
+
+	tvout_dbg("read buffer :\n\t\t");
+
+	for (i = 1; i < size; i++) {
+		printk("0x%02x", read_buffer[i]);
+
+		if (i % 8)
+			printk(" ");
+		else
+			printk("\n\t\t");
+	}
+	printk("\n");
+}
+#endif
+	s5p_hdmi_reg_core_reset();
+
+	do {
+		reg = readb(hdmi_base + S5P_HDMI_PHY_STATUS);
+	} while (!(reg & S5P_HDMI_PHY_STATUS_READY));
+
+	writeb(I2C_CLK_PEND_INT, i2c_hdmi_phy_base + HDMI_I2C_CON);
+	writeb(I2C_IDLE, i2c_hdmi_phy_base + HDMI_I2C_STAT);
+
+	return 0;
+}
+
+void s5p_hdmi_set_gcp(enum s5p_hdmi_color_depth	depth, u8 *gcp)
+{
+	switch (depth) {
+	case HDMI_CD_48:
+		gcp[1] = S5P_HDMI_GCP_48BPP; break;
+	case HDMI_CD_36:
+		gcp[1] = S5P_HDMI_GCP_36BPP; break;
+	case HDMI_CD_30:
+		gcp[1] = S5P_HDMI_GCP_30BPP; break;
+	case HDMI_CD_24:
+		gcp[1] = S5P_HDMI_GCP_24BPP; break;
+
+	default:
+		break;
+	}
+}
+
+void s5p_hdmi_reg_acr(u8 *acr)
+{
+	u32 n	= acr[4] << 16 | acr[5] << 8 | acr[6];
+	u32 cts	= acr[1] << 16 | acr[2] << 8 | acr[3];
+
+	hdmi_write_24(n, hdmi_base + S5P_HDMI_ACR_N0);
+	hdmi_write_24(cts, hdmi_base + S5P_HDMI_ACR_MCTS0);
+	hdmi_write_24(cts, hdmi_base + S5P_HDMI_ACR_CTS0);
+
+	writeb(4, hdmi_base + S5P_HDMI_ACR_CON);
+}
+
+void s5p_hdmi_reg_asp(u8 *asp)
+{
+	writeb(S5P_HDMI_AUD_NO_DST_DOUBLE | S5P_HDMI_AUD_TYPE_SAMPLE |
+		S5P_HDMI_AUD_MODE_TWO_CH | S5P_HDMI_AUD_SP_ALL_DIS,
+		hdmi_base + S5P_HDMI_ASP_CON);
+
+	writeb(S5P_HDMI_ASP_SP_FLAT_AUD_SAMPLE,
+		hdmi_base + S5P_HDMI_ASP_SP_FLAT);
+
+	writeb(S5P_HDMI_SPK0R_SEL_I_PCM0R | S5P_HDMI_SPK0L_SEL_I_PCM0L,
+		hdmi_base + S5P_HDMI_ASP_CHCFG0);
+	writeb(S5P_HDMI_SPK0R_SEL_I_PCM0R | S5P_HDMI_SPK0L_SEL_I_PCM0L,
+		hdmi_base + S5P_HDMI_ASP_CHCFG1);
+	writeb(S5P_HDMI_SPK0R_SEL_I_PCM0R | S5P_HDMI_SPK0L_SEL_I_PCM0L,
+		hdmi_base + S5P_HDMI_ASP_CHCFG2);
+	writeb(S5P_HDMI_SPK0R_SEL_I_PCM0R | S5P_HDMI_SPK0L_SEL_I_PCM0L,
+		hdmi_base + S5P_HDMI_ASP_CHCFG3);
+}
+
+void s5p_hdmi_reg_gcp(u8 i_p, u8 *gcp)
+{
+	u32 gcp_con;
+
+	writeb(gcp[2], hdmi_base + S5P_HDMI_GCP_BYTE2);
+
+	gcp_con = readb(hdmi_base + S5P_HDMI_GCP_CON);
+
+	if (i_p)
+		gcp_con |= S5P_HDMI_GCP_CON_EN_1ST_VSYNC |
+				S5P_HDMI_GCP_CON_EN_2ST_VSYNC;
+	else
+		gcp_con &= (~(S5P_HDMI_GCP_CON_EN_1ST_VSYNC |
+				S5P_HDMI_GCP_CON_EN_2ST_VSYNC));
+
+	writeb(gcp_con, hdmi_base + S5P_HDMI_GCP_CON);
+
+}
+
+void s5p_hdmi_reg_acp(u8 *header, u8 *acp)
+{
+	writeb(header[1], hdmi_base + S5P_HDMI_ACP_TYPE);
+}
+
+void s5p_hdmi_reg_isrc(u8 *isrc1, u8 *isrc2)
+{
+	/* nothing here yet */
+}
+
+void s5p_hdmi_reg_gmp(u8 *gmp)
+{
+	/* nothing here yet */
+}
+
+void s5p_hdmi_reg_infoframe(struct s5p_hdmi_infoframe *info, u8 *data)
+{
+	u32 start_addr = 0, sum_addr = 0;
+	u8 sum;
+
+	switch (info->type) {
+	case HDMI_VSI_INFO:
+		break;
+	case HDMI_AVI_INFO:
+		sum_addr	= S5P_HDMI_AVI_CHECK_SUM;
+		start_addr	= S5P_HDMI_AVI_DATA;
+		break;
+	case HDMI_SPD_INFO:
+		sum_addr	= S5P_HDMI_SPD_DATA;
+		start_addr	= S5P_HDMI_SPD_DATA + 4;
+		/* write header */
+		writeb((u8)info->type, hdmi_base + S5P_HDMI_SPD_HEADER);
+		writeb((u8)info->version, hdmi_base + S5P_HDMI_SPD_HEADER + 4);
+		writeb((u8)info->length, hdmi_base + S5P_HDMI_SPD_HEADER + 8);
+		break;
+	case HDMI_AUI_INFO:
+		sum_addr	= S5P_HDMI_AUI_CHECK_SUM;
+		start_addr	= S5P_HDMI_AUI_BYTE1;
+		break;
+	case HDMI_MPG_INFO:
+		sum_addr	= S5P_HDMI_MPG_CHECK_SUM;
+		start_addr	= S5P_HDMI_MPG_DATA;
+		break;
+	default:
+		tvout_dbg("undefined infoframe\n");
+		return;
+	}
+
+	/* calculate checksum */
+	sum = (u8)info->type + info->version + info->length;
+	sum = s5p_hdmi_checksum(sum, info->length, data);
+
+	/* write checksum */
+	writeb(sum, hdmi_base + sum_addr);
+
+	/* write data */
+	hdmi_write_l(data, hdmi_base, start_addr, info->length);
+}
+
+void s5p_hdmi_reg_tg(struct s5p_hdmi_v_frame *frame)
+{
+	u16 reg;
+	u8 tg;
+
+	hdmi_write_16(frame->h_total, hdmi_base + S5P_HDMI_TG_H_FSZ_L);
+	hdmi_write_16(frame->h_blank, hdmi_base + S5P_HDMI_TG_HACT_ST_L);
+	hdmi_write_16(frame->h_active, hdmi_base + S5P_HDMI_TG_HACT_SZ_L);
+
+	hdmi_write_16(frame->v_total, hdmi_base + S5P_HDMI_TG_V_FSZ_L);
+	hdmi_write_16(frame->v_active, hdmi_base + S5P_HDMI_TG_VACT_SZ_L);
+
+
+	reg = (frame->i_p) ? (frame->v_total - frame->v_active*2) / 2 :
+				frame->v_total - frame->v_active;
+	hdmi_write_16(reg, hdmi_base + S5P_HDMI_TG_VACT_ST_L);
+
+	reg = (frame->i_p) ? 0x249 : 0x248;
+	hdmi_write_16(reg, hdmi_base + S5P_HDMI_TG_VACT_ST2_L);
+
+	reg = (frame->i_p) ? 0x233 : 1;
+	hdmi_write_16(reg, hdmi_base + S5P_HDMI_TG_VSYNC_BOT_HDMI_L);
+
+	/* write reg default value */
+	hdmi_write_16(0x1, hdmi_base + S5P_HDMI_TG_VSYNC_L);
+	hdmi_write_16(0x233, hdmi_base + S5P_HDMI_TG_VSYNC2_L);
+	hdmi_write_16(0x233, hdmi_base + S5P_HDMI_TG_FIELD_CHG_L);
+	hdmi_write_16(0x1, hdmi_base + S5P_HDMI_TG_VSYNC_TOP_HDMI_L);
+	hdmi_write_16(0x1, hdmi_base + S5P_HDMI_TG_FIELD_TOP_HDMI_L);
+	hdmi_write_16(0x233, hdmi_base + S5P_HDMI_TG_FIELD_BOT_HDMI_L);
+
+	tg = readb(hdmi_base + S5P_HDMI_TG_CMD);
+
+	hdmi_bit_set(frame->i_p, tg, S5P_HDMI_FIELD);
+
+	writeb(tg, hdmi_base + S5P_HDMI_TG_CMD);
+}
+
+void s5p_hdmi_reg_v_timing(struct s5p_hdmi_v_format *v)
+{
+	u32 reg32;
+
+	struct s5p_hdmi_v_frame	*frame = &(v->frame);
+
+	writeb(frame->polarity, hdmi_base + S5P_HDMI_SYNC_MODE);
+	writeb(frame->i_p, hdmi_base + S5P_HDMI_INT_PRO_MODE);
+
+	hdmi_write_16(frame->h_blank, hdmi_base + S5P_HDMI_H_BLANK_0);
+
+	reg32 = (frame->v_blank << 11) | (frame->v_blank + frame->v_active);
+	hdmi_write_24(reg32, hdmi_base + S5P_HDMI_V_BLANK_0);
+
+	reg32 = (frame->h_total << 12) | frame->v_total;
+	hdmi_write_24(reg32, hdmi_base + S5P_HDMI_H_V_LINE_0);
+
+	reg32 = frame->polarity << 20 | v->h_sync.end << 10 | v->h_sync.begin;
+	hdmi_write_24(reg32, hdmi_base + S5P_HDMI_H_SYNC_GEN_0);
+
+	reg32 = v->v_sync_top.begin << 12 | v->v_sync_top.end;
+	hdmi_write_24(reg32, hdmi_base + S5P_HDMI_V_SYNC_GEN_1_0);
+
+	if (frame->i_p) {
+		reg32 = v->v_blank_f.end << 11 | v->v_blank_f.begin;
+		hdmi_write_24(reg32, hdmi_base + S5P_HDMI_V_BLANK_F_0);
+
+		reg32 = v->v_sync_bottom.begin << 12 | v->v_sync_bottom.end;
+		hdmi_write_24(reg32, hdmi_base + S5P_HDMI_V_SYNC_GEN_2_0);
+
+		reg32 = v->v_sync_h_pos.begin << 12 | v->v_sync_h_pos.end;
+		hdmi_write_24(reg32, hdmi_base + S5P_HDMI_V_SYNC_GEN_3_0);
+	} else {
+		hdmi_write_24(0x0, hdmi_base + S5P_HDMI_V_BLANK_F_0);
+		hdmi_write_24(0x1001, hdmi_base + S5P_HDMI_V_SYNC_GEN_2_0);
+		hdmi_write_24(0x1001, hdmi_base + S5P_HDMI_V_SYNC_GEN_3_0);
+	}
+}
+
+void s5p_hdmi_reg_bluescreen_clr(u8 cb_b, u8 y_g, u8 cr_r)
+{
+	writeb(cb_b, hdmi_base + S5P_HDMI_BLUE_SCREEN_0);
+	writeb(y_g, hdmi_base + S5P_HDMI_BLUE_SCREEN_1);
+	writeb(cr_r, hdmi_base + S5P_HDMI_BLUE_SCREEN_2);
+}
+
+void s5p_hdmi_reg_bluescreen(bool en)
+{
+	u8 reg = readl(hdmi_base + S5P_HDMI_CON_0);
+
+	hdmi_bit_set(en, reg, S5P_HDMI_BLUE_SCR_EN);
+
+	writeb(reg, hdmi_base + S5P_HDMI_CON_0);
+}
+
+void s5p_hdmi_reg_clr_range(u8 y_min, u8 y_max, u8 c_min, u8 c_max)
+{
+	writeb(y_max, hdmi_base + S5P_HDMI_YMAX);
+	writeb(y_min, hdmi_base + S5P_HDMI_YMIN);
+	writeb(c_max, hdmi_base + S5P_HDMI_CMAX);
+	writeb(c_min, hdmi_base + S5P_HDMI_CMIN);
+}
+
+void s5p_hdmi_reg_tg_cmd(bool time, bool bt656, bool tg)
+{
+	u8 reg = 0;
+
+	reg = readb(hdmi_base + S5P_HDMI_TG_CMD);
+
+	hdmi_bit_set(time, reg, S5P_HDMI_GETSYNC_TYPE);
+	hdmi_bit_set(bt656, reg, S5P_HDMI_GETSYNC);
+	hdmi_bit_set(tg, reg, S5P_HDMI_TG);
+
+	writeb(reg, hdmi_base + S5P_HDMI_TG_CMD);
+}
+
+void s5p_hdmi_reg_enable(bool en)
+{
+	u8 reg;
+
+	reg = readl(hdmi_base + S5P_HDMI_CON_0);
+
+	if (en)
+		reg |= S5P_HDMI_EN;
+	else
+		reg &= ~(S5P_HDMI_EN | S5P_HDMI_ASP_EN);
+
+	writeb(reg, hdmi_base + S5P_HDMI_CON_0);
+}
+
+u8 s5p_hdmi_reg_intc_status(void)
+{
+	return readb(hdmi_base + S5P_HDMI_INTC_FLAG);
+}
+
+u8 s5p_hdmi_reg_intc_get_enabled(void)
+{
+	return readb(hdmi_base + S5P_HDMI_INTC_CON);
+}
+
+void s5p_hdmi_reg_intc_clear_pending(enum s5p_hdmi_interrrupt intr)
+{
+	u8 reg;
+
+	reg = readb(hdmi_base + S5P_HDMI_INTC_FLAG);
+	writeb(reg | (1 << intr), hdmi_base + S5P_HDMI_INTC_FLAG);
+}
+
+void s5p_hdmi_reg_sw_hpd_enable(bool enable)
+{
+	u8 reg;
+
+	reg = readb(hdmi_base + S5P_HDMI_HPD);
+	reg &= ~S5P_HDMI_HPD_SEL_I_HPD;
+
+	if (enable)
+		writeb(reg | S5P_HDMI_HPD_SEL_I_HPD, hdmi_base + S5P_HDMI_HPD);
+	else
+		writeb(reg, hdmi_base + S5P_HDMI_HPD);
+}
+
+void s5p_hdmi_reg_set_hpd_onoff(bool on_off)
+{
+	u8 reg;
+
+	reg = readb(hdmi_base + S5P_HDMI_HPD);
+	reg &= ~S5P_HDMI_SW_HPD_PLUGGED;
+
+	if (on_off)
+		writel(reg | S5P_HDMI_SW_HPD_PLUGGED,
+			hdmi_base + S5P_HDMI_HPD);
+	else
+		writel(reg | S5P_HDMI_SW_HPD_UNPLUGGED,
+			hdmi_base + S5P_HDMI_HPD);
+
+}
+
+u8 s5p_hdmi_reg_get_hpd_status(void)
+{
+	return readb(hdmi_base + S5P_HDMI_HPD_STATUS);
+}
+
+void s5p_hdmi_reg_hpd_gen(void)
+{
+	writeb(0xFF, hdmi_base + S5P_HDMI_HPD_GEN);
+}
+
+int s5p_hdmi_reg_intc_set_isr(irqreturn_t (*isr)(int, void *), u8 num)
+{
+	if (isr == NULL) {
+		tvout_err("invalid irq routine\n");
+		return -1;
+	}
+
+	if (num >= HDMI_IRQ_TOTAL_NUM) {
+		tvout_err("max irq_num exceeded\n");
+		return -1;
+	}
+
+	if (s5p_hdmi_isr_ftn[num])
+		tvout_dbg("irq %d already registered\n", num);
+
+	s5p_hdmi_isr_ftn[num] = isr;
+
+	tvout_dbg("success to register irq : %d\n", num);
+
+	return 0;
+}
+
+void s5p_hdmi_reg_intc_enable(enum s5p_hdmi_interrrupt intr, u8 en)
+{
+	u8 reg;
+
+	reg = s5p_hdmi_reg_intc_get_enabled();
+
+	if (en) {
+		if (!reg)
+			reg |= S5P_HDMI_INTC_EN_GLOBAL;
+
+		reg |= (1 << intr);
+	} else {
+		reg &= ~(1 << intr);
+
+		if (!reg)
+			reg &= ~S5P_HDMI_INTC_EN_GLOBAL;
+	}
+
+	writeb(reg, hdmi_base + S5P_HDMI_INTC_CON);
+}
+
+void s5p_hdmi_reg_audio_enable(u8 en)
+{
+	u8 con, mod;
+	con = readb(hdmi_base + S5P_HDMI_CON_0);
+	mod = readb(hdmi_base + S5P_HDMI_MODE_SEL);
+
+	if (en) {
+		if (mod & S5P_HDMI_DVI_MODE_EN)
+			return;
+
+		con |= S5P_HDMI_ASP_EN;
+		writeb(HDMI_TRANS_EVERY_SYNC, hdmi_base + S5P_HDMI_AUI_CON);
+	} else {
+		con &= ~S5P_HDMI_ASP_EN;
+		writeb(HDMI_DO_NOT_TANS, hdmi_base + S5P_HDMI_AUI_CON);
+	}
+
+	writeb(con, hdmi_base + S5P_HDMI_CON_0);
+}
+
+int s5p_hdmi_audio_init(
+		enum s5p_tvout_audio_codec_type audio_codec,
+		u32 sample_rate, u32 bits, u32 frame_size_code)
+{
+#ifdef CONFIG_SND_SAMSUNG_SPDIF
+	s5p_hdmi_audio_set_config(audio_codec);
+	s5p_hdmi_audio_set_repetition_time(audio_codec, bits, frame_size_code);
+	s5p_hdmi_audio_irq_enable(S5P_HDMI_SPDIFIN_IRQ_OVERFLOW_EN);
+	s5p_hdmi_audio_clock_enable();
+#else
+	s5p_hdmi_audio_i2s_config(audio_codec, sample_rate, bits,
+				  frame_size_code);
+#endif
+	return 0;
+}
+
+void s5p_hdmi_reg_mute(bool en)
+{
+	static u8 prev_audio;
+	u8 reg;
+
+	s5p_hdmi_reg_bluescreen(en);
+
+	if (en) {
+		reg = readb(hdmi_base + S5P_HDMI_CON_0);
+		prev_audio = reg & S5P_HDMI_ASP_EN;
+	} else
+		if (!prev_audio)
+			return;
+
+	s5p_hdmi_reg_audio_enable(!en);
+}
+
+irqreturn_t s5p_hdmi_irq(int irq, void *dev_id)
+{
+	u8 state, num = 0;
+
+	spin_lock_irq(&lock_hdmi);
+
+	state = readb(hdmi_base + S5P_HDMI_INTC_FLAG);
+
+	if (!state) {
+		tvout_err("undefined irq : %d\n", state);
+		goto irq_handled;
+	}
+
+	for (num = 0; num < HDMI_IRQ_TOTAL_NUM; num++) {
+
+		if (!(state & (1 << num)))
+			continue;
+
+		if (s5p_hdmi_isr_ftn[num])
+			(s5p_hdmi_isr_ftn[num])(num, NULL);
+		else
+			tvout_dbg("unregistered irq : %d\n", num);
+	}
+
+irq_handled:
+	spin_unlock_irq(&lock_hdmi);
+
+	return IRQ_HANDLED;
+}
+
+void s5p_hdmi_init(void __iomem *hdmi_addr, void __iomem *hdmi_phy_addr)
+{
+	hdmi_base = hdmi_addr;
+	i2c_hdmi_phy_base = hdmi_phy_addr;
+
+	spin_lock_init(&lock_hdmi);
+
+	writeb(0x5, i2c_hdmi_phy_base + HDMI_I2C_LC);
+}
+
+void s5p_hdmi_reg_output(struct s5p_hdmi_o_reg *reg)
+{
+	writeb(reg->pxl_limit, hdmi_base + S5P_HDMI_CON_1);
+	writeb(reg->preemble, hdmi_base + S5P_HDMI_CON_2);
+	writeb(reg->mode, hdmi_base + S5P_HDMI_MODE_SEL);
+}
+
+void s5p_hdmi_reg_packet_trans(struct s5p_hdmi_o_trans *trans)
+{
+	u8 reg;
+
+	writeb(trans->avi, hdmi_base + S5P_HDMI_AVI_CON);
+	writeb(trans->mpg, hdmi_base + S5P_HDMI_MPG_CON);
+	writeb(trans->spd, hdmi_base + S5P_HDMI_SPD_CON);
+	writeb(trans->gmp, hdmi_base + S5P_HDMI_GAMUT_CON);
+	writeb(trans->aui, hdmi_base + S5P_HDMI_AUI_CON);
+
+	reg = trans->gcp | readb(hdmi_base + S5P_HDMI_GCP_CON);
+	writeb(reg, hdmi_base + S5P_HDMI_GCP_CON);
+
+	reg = trans->isrc | readb(hdmi_base + S5P_HDMI_ISRC_CON);
+	writeb(reg, hdmi_base + S5P_HDMI_ISRC_CON);
+
+	reg = trans->acp | readb(hdmi_base + S5P_HDMI_ACP_CON);
+	writeb(reg, hdmi_base + S5P_HDMI_ACP_CON);
+
+	reg = trans->acr | readb(hdmi_base + S5P_HDMI_ACP_CON);
+	writeb(reg, hdmi_base + S5P_HDMI_ACR_CON);
+}
diff --git a/drivers/media/video/s5p-tvout/hw_if/sdo.c b/drivers/media/video/s5p-tvout/hw_if/sdo.c
new file mode 100644
index 0000000..a904e99
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/sdo.c
@@ -0,0 +1,1102 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Hardware interface functions for SDO (Standard Definition Output)
+ *	- SDO: Analog TV encoder + DAC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/regs-clock.h>
+#include <mach/regs-sdo.h>
+
+#include "../s5p_tvout_common_lib.h"
+#include "hw_if.h"
+
+#undef tvout_dbg
+
+#ifdef CONFIG_SDO_DEBUG
+#define tvout_dbg(fmt, ...)					\
+		printk(KERN_INFO "\t\t[SDO] %s(): " fmt,	\
+			__func__, ##__VA_ARGS__)
+#else
+#define tvout_dbg(fmt, ...)
+#endif
+
+void __iomem *sdo_base;
+
+static u32 s5p_sdo_calc_wss_cgms_crc(u32 value)
+{
+	u8 i;
+	u8 cgms[14], crc[6], old_crc;
+	u32 temp_in;
+
+	temp_in = value;
+
+	for (i = 0; i < 14; i++)
+		cgms[i] = (u8)(temp_in >> i) & 0x1;
+
+	/* initialize state */
+	for (i = 0; i < 6; i++)
+		crc[i] = 0x1;
+
+	/* round 20 */
+	for (i = 0; i < 14; i++) {
+		old_crc = crc[0];
+		crc[0] = crc[1];
+		crc[1] = crc[2];
+		crc[2] = crc[3];
+		crc[3] = crc[4];
+		crc[4] = old_crc ^ cgms[i] ^ crc[5];
+		crc[5] = old_crc ^ cgms[i];
+	}
+
+	/* recompose to return crc */
+	temp_in &= 0x3fff;
+
+	for (i = 0; i < 6; i++)
+		temp_in |= ((u32)(crc[i] & 0x1) << i);
+
+	return temp_in;
+}
+
+static int s5p_sdo_set_antialias_filter_coeff_default(enum s5p_sdo_level composite_level,
+						      enum s5p_sdo_vsync_ratio composite_ratio)
+{
+	tvout_dbg("%d, %d\n", composite_level, composite_ratio);
+
+	switch (composite_level) {
+	case SDO_LEVEL_0IRE:
+		switch (composite_ratio) {
+		case SDO_VTOS_RATIO_10_4:
+			writel(0x00000000, sdo_base + S5P_SDO_Y3);
+			writel(0x00000000, sdo_base + S5P_SDO_Y4);
+			writel(0x00000000, sdo_base + S5P_SDO_Y5);
+			writel(0x00000000, sdo_base + S5P_SDO_Y6);
+			writel(0x00000000, sdo_base + S5P_SDO_Y7);
+			writel(0x00000000, sdo_base + S5P_SDO_Y8);
+			writel(0x00000000, sdo_base + S5P_SDO_Y9);
+			writel(0x00000000, sdo_base + S5P_SDO_Y10);
+			writel(0x0000029a, sdo_base + S5P_SDO_Y11);
+			writel(0x00000000, sdo_base + S5P_SDO_CB0);
+			writel(0x00000000, sdo_base + S5P_SDO_CB1);
+			writel(0x00000000, sdo_base + S5P_SDO_CB2);
+			writel(0x00000000, sdo_base + S5P_SDO_CB3);
+			writel(0x00000000, sdo_base + S5P_SDO_CB4);
+			writel(0x00000001, sdo_base + S5P_SDO_CB5);
+			writel(0x00000007, sdo_base + S5P_SDO_CB6);
+			writel(0x00000015, sdo_base + S5P_SDO_CB7);
+			writel(0x0000002b, sdo_base + S5P_SDO_CB8);
+			writel(0x00000045, sdo_base + S5P_SDO_CB9);
+			writel(0x00000059, sdo_base + S5P_SDO_CB10);
+			writel(0x00000061, sdo_base + S5P_SDO_CB11);
+			writel(0x00000000, sdo_base + S5P_SDO_CR1);
+			writel(0x00000000, sdo_base + S5P_SDO_CR2);
+			writel(0x00000000, sdo_base + S5P_SDO_CR3);
+			writel(0x00000000, sdo_base + S5P_SDO_CR4);
+			writel(0x00000002, sdo_base + S5P_SDO_CR5);
+			writel(0x0000000a, sdo_base + S5P_SDO_CR6);
+			writel(0x0000001e, sdo_base + S5P_SDO_CR7);
+			writel(0x0000003d, sdo_base + S5P_SDO_CR8);
+			writel(0x00000061, sdo_base + S5P_SDO_CR9);
+			writel(0x0000007a, sdo_base + S5P_SDO_CR10);
+			writel(0x0000008f, sdo_base + S5P_SDO_CR11);
+			break;
+
+		case SDO_VTOS_RATIO_7_3:
+			writel(0x00000000, sdo_base + S5P_SDO_Y0);
+			writel(0x00000000, sdo_base + S5P_SDO_Y1);
+			writel(0x00000000, sdo_base + S5P_SDO_Y2);
+			writel(0x00000000, sdo_base + S5P_SDO_Y3);
+			writel(0x00000000, sdo_base + S5P_SDO_Y4);
+			writel(0x00000000, sdo_base + S5P_SDO_Y5);
+			writel(0x00000000, sdo_base + S5P_SDO_Y6);
+			writel(0x00000000, sdo_base + S5P_SDO_Y7);
+			writel(0x00000000, sdo_base + S5P_SDO_Y8);
+			writel(0x00000000, sdo_base + S5P_SDO_Y9);
+			writel(0x00000000, sdo_base + S5P_SDO_Y10);
+			writel(0x00000281, sdo_base + S5P_SDO_Y11);
+			writel(0x00000000, sdo_base + S5P_SDO_CB0);
+			writel(0x00000000, sdo_base + S5P_SDO_CB1);
+			writel(0x00000000, sdo_base + S5P_SDO_CB2);
+			writel(0x00000000, sdo_base + S5P_SDO_CB3);
+			writel(0x00000000, sdo_base + S5P_SDO_CB4);
+			writel(0x00000001, sdo_base + S5P_SDO_CB5);
+			writel(0x00000007, sdo_base + S5P_SDO_CB6);
+			writel(0x00000015, sdo_base + S5P_SDO_CB7);
+			writel(0x0000002a, sdo_base + S5P_SDO_CB8);
+			writel(0x00000044, sdo_base + S5P_SDO_CB9);
+			writel(0x00000057, sdo_base + S5P_SDO_CB10);
+			writel(0x0000005f, sdo_base + S5P_SDO_CB11);
+			writel(0x00000000, sdo_base + S5P_SDO_CR1);
+			writel(0x00000000, sdo_base + S5P_SDO_CR2);
+			writel(0x00000000, sdo_base + S5P_SDO_CR3);
+			writel(0x00000000, sdo_base + S5P_SDO_CR4);
+			writel(0x00000002, sdo_base + S5P_SDO_CR5);
+			writel(0x0000000a, sdo_base + S5P_SDO_CR6);
+			writel(0x0000001d, sdo_base + S5P_SDO_CR7);
+			writel(0x0000003c, sdo_base + S5P_SDO_CR8);
+			writel(0x0000005f, sdo_base + S5P_SDO_CR9);
+			writel(0x0000007b, sdo_base + S5P_SDO_CR10);
+			writel(0x00000086, sdo_base + S5P_SDO_CR11);
+			break;
+
+		default:
+			tvout_err("invalid composite_ratio parameter(%d)\n", composite_ratio);
+			return -1;
+		}
+
+		break;
+
+	case SDO_LEVEL_75IRE:
+		switch (composite_ratio) {
+		case SDO_VTOS_RATIO_10_4:
+			writel(0x00000000, sdo_base + S5P_SDO_Y0);
+			writel(0x00000000, sdo_base + S5P_SDO_Y1);
+			writel(0x00000000, sdo_base + S5P_SDO_Y2);
+			writel(0x00000000, sdo_base + S5P_SDO_Y3);
+			writel(0x00000000, sdo_base + S5P_SDO_Y4);
+			writel(0x00000000, sdo_base + S5P_SDO_Y5);
+			writel(0x00000000, sdo_base + S5P_SDO_Y6);
+			writel(0x00000000, sdo_base + S5P_SDO_Y7);
+			writel(0x00000000, sdo_base + S5P_SDO_Y8);
+			writel(0x00000000, sdo_base + S5P_SDO_Y9);
+			writel(0x00000000, sdo_base + S5P_SDO_Y10);
+			writel(0x0000025d, sdo_base + S5P_SDO_Y11);
+			writel(0x00000000, sdo_base + S5P_SDO_CB0);
+			writel(0x00000000, sdo_base + S5P_SDO_CB1);
+			writel(0x00000000, sdo_base + S5P_SDO_CB2);
+			writel(0x00000000, sdo_base + S5P_SDO_CB3);
+			writel(0x00000000, sdo_base + S5P_SDO_CB4);
+			writel(0x00000001, sdo_base + S5P_SDO_CB5);
+			writel(0x00000007, sdo_base + S5P_SDO_CB6);
+			writel(0x00000014, sdo_base + S5P_SDO_CB7);
+			writel(0x00000028, sdo_base + S5P_SDO_CB8);
+			writel(0x0000003f, sdo_base + S5P_SDO_CB9);
+			writel(0x00000052, sdo_base + S5P_SDO_CB10);
+			writel(0x0000005a, sdo_base + S5P_SDO_CB11);
+			writel(0x00000000, sdo_base + S5P_SDO_CR1);
+			writel(0x00000000, sdo_base + S5P_SDO_CR2);
+			writel(0x00000000, sdo_base + S5P_SDO_CR3);
+			writel(0x00000000, sdo_base + S5P_SDO_CR4);
+			writel(0x00000001, sdo_base + S5P_SDO_CR5);
+			writel(0x00000009, sdo_base + S5P_SDO_CR6);
+			writel(0x0000001c, sdo_base + S5P_SDO_CR7);
+			writel(0x00000039, sdo_base + S5P_SDO_CR8);
+			writel(0x0000005a, sdo_base + S5P_SDO_CR9);
+			writel(0x00000074, sdo_base + S5P_SDO_CR10);
+			writel(0x0000007e, sdo_base + S5P_SDO_CR11);
+			break;
+
+		case SDO_VTOS_RATIO_7_3:
+			writel(0x00000000, sdo_base + S5P_SDO_Y0);
+			writel(0x00000000, sdo_base + S5P_SDO_Y1);
+			writel(0x00000000, sdo_base + S5P_SDO_Y2);
+			writel(0x00000000, sdo_base + S5P_SDO_Y3);
+			writel(0x00000000, sdo_base + S5P_SDO_Y4);
+			writel(0x00000000, sdo_base + S5P_SDO_Y5);
+			writel(0x00000000, sdo_base + S5P_SDO_Y6);
+			writel(0x00000000, sdo_base + S5P_SDO_Y7);
+			writel(0x00000000, sdo_base + S5P_SDO_Y8);
+			writel(0x00000000, sdo_base + S5P_SDO_Y9);
+			writel(0x00000000, sdo_base + S5P_SDO_Y10);
+			writel(0x00000251, sdo_base + S5P_SDO_Y11);
+			writel(0x00000000, sdo_base + S5P_SDO_CB0);
+			writel(0x00000000, sdo_base + S5P_SDO_CB1);
+			writel(0x00000000, sdo_base + S5P_SDO_CB2);
+			writel(0x00000000, sdo_base + S5P_SDO_CB3);
+			writel(0x00000000, sdo_base + S5P_SDO_CB4);
+			writel(0x00000001, sdo_base + S5P_SDO_CB5);
+			writel(0x00000006, sdo_base + S5P_SDO_CB6);
+			writel(0x00000013, sdo_base + S5P_SDO_CB7);
+			writel(0x00000028, sdo_base + S5P_SDO_CB8);
+			writel(0x0000003f, sdo_base + S5P_SDO_CB9);
+			writel(0x00000051, sdo_base + S5P_SDO_CB10);
+			writel(0x00000056, sdo_base + S5P_SDO_CB11);
+			writel(0x00000000, sdo_base + S5P_SDO_CR1);
+			writel(0x00000000, sdo_base + S5P_SDO_CR2);
+			writel(0x00000000, sdo_base + S5P_SDO_CR3);
+			writel(0x00000000, sdo_base + S5P_SDO_CR4);
+			writel(0x00000002, sdo_base + S5P_SDO_CR5);
+			writel(0x00000005, sdo_base + S5P_SDO_CR6);
+			writel(0x00000018, sdo_base + S5P_SDO_CR7);
+			writel(0x00000037, sdo_base + S5P_SDO_CR8);
+			writel(0x0000005A, sdo_base + S5P_SDO_CR9);
+			writel(0x00000076, sdo_base + S5P_SDO_CR10);
+			writel(0x0000007e, sdo_base + S5P_SDO_CR11);
+			break;
+
+		default:
+			tvout_err("invalid composite_ratio parameter(%d)\n", composite_ratio);
+			return -1;
+		}
+
+		break;
+
+	default:
+		tvout_err("invalid composite_level parameter(%d)\n", composite_level);
+		return -1;
+	}
+
+	return 0;
+}
+
+
+int s5p_sdo_set_video_scale_cfg(enum s5p_sdo_level composite_level,
+				enum s5p_sdo_vsync_ratio composite_ratio)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d\n", composite_level, composite_ratio);
+
+	switch (composite_level) {
+	case SDO_LEVEL_0IRE:
+		temp_reg |= S5P_SDO_COMPOSITE_LEVEL_SEL_0IRE;
+		break;
+
+	case SDO_LEVEL_75IRE:
+		temp_reg |= S5P_SDO_COMPOSITE_LEVEL_SEL_75IRE;
+		break;
+
+	default:
+		tvout_err("invalid composite_level parameter(%d)\n", composite_ratio);
+		return -1;
+	}
+
+	switch (composite_ratio) {
+	case SDO_VTOS_RATIO_10_4:
+		temp_reg |= S5P_SDO_COMPOSITE_VTOS_RATIO_10_4;
+		break;
+
+	case SDO_VTOS_RATIO_7_3:
+		temp_reg |= S5P_SDO_COMPOSITE_VTOS_RATIO_7_3;
+		break;
+
+	default:
+		tvout_err("invalid composite_ratio parameter(%d)\n", composite_ratio);
+		return -1;
+	}
+
+	writel(temp_reg, sdo_base + S5P_SDO_SCALE);
+
+	return 0;
+}
+
+int s5p_sdo_set_vbi(bool wss_cvbs,
+		    enum s5p_sdo_closed_caption_type caption_cvbs)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d\n", wss_cvbs, caption_cvbs);
+
+	if (wss_cvbs)
+		temp_reg = S5P_SDO_CVBS_WSS_INS;
+	else
+		temp_reg = S5P_SDO_CVBS_NO_WSS;
+
+	switch (caption_cvbs) {
+	case SDO_NO_INS:
+		temp_reg |= S5P_SDO_CVBS_NO_CLOSED_CAPTION;
+		break;
+
+	case SDO_INS_1:
+		temp_reg |= S5P_SDO_CVBS_21H_CLOSED_CAPTION;
+		break;
+
+	case SDO_INS_2:
+		temp_reg |= S5P_SDO_CVBS_21H_284H_CLOSED_CAPTION;
+		break;
+
+	case SDO_INS_OTHERS:
+		temp_reg |= S5P_SDO_CVBS_USE_OTHERS;
+		break;
+
+	default:
+		tvout_err("invalid caption_cvbs parameter(%d)\n",
+			caption_cvbs);
+		return -1;
+	}
+
+
+	writel(temp_reg, sdo_base + S5P_SDO_VBI);
+
+	return 0;
+}
+
+void s5p_sdo_set_offset_gain(u32 offset, u32 gain)
+{
+	tvout_dbg("%d, %d\n", offset, gain);
+
+	writel(S5P_SDO_SCALE_CONV_OFFSET(offset) |
+		S5P_SDO_SCALE_CONV_GAIN(gain),
+		sdo_base + S5P_SDO_SCALE_CH0);
+}
+
+void s5p_sdo_set_delay(u32 delay_y, u32 offset_video_start,
+		       u32 offset_video_end)
+{
+	tvout_dbg("%d, %d, %d\n", delay_y, offset_video_start,
+		offset_video_end);
+
+	writel(S5P_SDO_DELAY_YTOC(delay_y) |
+		S5P_SDO_ACTIVE_START_OFFSET(offset_video_start) |
+		S5P_SDO_ACTIVE_END_OFFSET(offset_video_end),
+		sdo_base + S5P_SDO_YCDELAY);
+}
+
+void s5p_sdo_set_schlock(bool color_sucarrier_pha_adj)
+{
+	tvout_dbg("%d\n", color_sucarrier_pha_adj);
+
+	if (color_sucarrier_pha_adj)
+		writel(S5P_SDO_COLOR_SC_PHASE_ADJ,
+			sdo_base + S5P_SDO_SCHLOCK);
+	else
+		writel(S5P_SDO_COLOR_SC_PHASE_NOADJ,
+			sdo_base + S5P_SDO_SCHLOCK);
+}
+
+void s5p_sdo_set_brightness_hue_saturation(struct s5p_sdo_bright_hue_saturation bri_hue_sat)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d, %d, %d, %d, %d, %d\n",
+		bri_hue_sat.bright_hue_sat_adj,	bri_hue_sat.gain_brightness,
+		bri_hue_sat.offset_brightness, bri_hue_sat.gain0_cb_hue_sat,
+		bri_hue_sat.gain1_cb_hue_sat, bri_hue_sat.gain0_cr_hue_sat,
+		bri_hue_sat.gain1_cr_hue_sat, bri_hue_sat.offset_cb_hue_sat,
+		bri_hue_sat.offset_cr_hue_sat);
+
+	temp_reg = readl(sdo_base + S5P_SDO_CCCON);
+
+	if (bri_hue_sat.bright_hue_sat_adj)
+		temp_reg &= ~S5P_SDO_COMPENSATION_BHS_ADJ_OFF;
+	else
+		temp_reg |= S5P_SDO_COMPENSATION_BHS_ADJ_OFF;
+
+	writel(temp_reg, sdo_base + S5P_SDO_CCCON);
+
+
+	writel(S5P_SDO_BRIGHTNESS_GAIN(bri_hue_sat.gain_brightness) |
+		S5P_SDO_BRIGHTNESS_OFFSET(bri_hue_sat.offset_brightness),
+			sdo_base + S5P_SDO_YSCALE);
+
+	writel(S5P_SDO_HS_CB_GAIN0(bri_hue_sat.gain0_cb_hue_sat) |
+		S5P_SDO_HS_CB_GAIN1(bri_hue_sat.gain1_cb_hue_sat),
+			sdo_base + S5P_SDO_CBSCALE);
+
+	writel(S5P_SDO_HS_CR_GAIN0(bri_hue_sat.gain0_cr_hue_sat) |
+		S5P_SDO_HS_CR_GAIN1(bri_hue_sat.gain1_cr_hue_sat),
+			sdo_base + S5P_SDO_CRSCALE);
+
+	writel(S5P_SDO_HS_CR_OFFSET(bri_hue_sat.offset_cr_hue_sat) |
+		S5P_SDO_HS_CB_OFFSET(bri_hue_sat.offset_cb_hue_sat),
+			sdo_base + S5P_SDO_CB_CR_OFFSET);
+}
+
+void s5p_sdo_set_cvbs_color_compensation(struct s5p_sdo_cvbs_compensation cvbs_comp)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d, %d, %d\n",
+		cvbs_comp.cvbs_color_compen, cvbs_comp.y_lower_mid,
+		cvbs_comp.y_bottom, cvbs_comp.y_top,
+		cvbs_comp.y_upper_mid, cvbs_comp.radius);
+
+	temp_reg = readl(sdo_base + S5P_SDO_CCCON);
+
+	if (cvbs_comp.cvbs_color_compen)
+		temp_reg &= ~S5P_SDO_COMPENSATION_CVBS_COMP_OFF;
+	else
+		temp_reg |= S5P_SDO_COMPENSATION_CVBS_COMP_OFF;
+
+	writel(temp_reg, sdo_base + S5P_SDO_CCCON);
+
+
+	writel(S5P_SDO_Y_LOWER_MID_CVBS_CORN(cvbs_comp.y_lower_mid) |
+		S5P_SDO_Y_BOTTOM_CVBS_CORN(cvbs_comp.y_bottom),
+			sdo_base + S5P_SDO_CVBS_CC_Y1);
+
+	writel(S5P_SDO_Y_TOP_CVBS_CORN(cvbs_comp.y_top) |
+		S5P_SDO_Y_UPPER_MID_CVBS_CORN(cvbs_comp.y_upper_mid),
+			sdo_base + S5P_SDO_CVBS_CC_Y2);
+
+	writel(S5P_SDO_RADIUS_CVBS_CORN(cvbs_comp.radius),
+			sdo_base + S5P_SDO_CVBS_CC_C);
+}
+
+void s5p_sdo_set_component_porch(u32 back_525, u32 front_525, u32 back_625, u32 front_625)
+{
+	tvout_dbg("%d, %d, %d, %d\n",
+			back_525, front_525, back_625, front_625);
+
+	writel(S5P_SDO_COMPONENT_525_BP(back_525) |
+		S5P_SDO_COMPONENT_525_FP(front_525),
+			sdo_base + S5P_SDO_CSC_525_PORCH);
+	writel(S5P_SDO_COMPONENT_625_BP(back_625) |
+		S5P_SDO_COMPONENT_625_FP(front_625),
+			sdo_base + S5P_SDO_CSC_625_PORCH);
+}
+
+void s5p_sdo_set_ch_xtalk_cancel_coef(u32 coeff2, u32 coeff1)
+{
+	tvout_dbg("%d, %d\n", coeff2, coeff1);
+
+	writel(S5P_SDO_XTALK_COEF02(coeff2) |
+		S5P_SDO_XTALK_COEF01(coeff1),
+			sdo_base + S5P_SDO_XTALK0);
+}
+
+void s5p_sdo_set_closed_caption(u32 display_cc, u32 non_display_cc)
+{
+	tvout_dbg("%d, %d\n", display_cc, non_display_cc);
+
+	writel(S5P_SDO_DISPLAY_CC_CAPTION(display_cc) |
+		S5P_SDO_NON_DISPLAY_CC_CAPTION(non_display_cc),
+		sdo_base + S5P_SDO_ARMCC);
+}
+
+int s5p_sdo_set_wss525_data(struct s5p_sdo_525_data wss525)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d\n",
+		wss525.copy_permit, wss525.mv_psp,
+		wss525.copy_info, wss525.display_ratio);
+
+	switch (wss525.copy_permit) {
+	case SDO_525_COPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_WSS525_COPY_PERMIT;
+		break;
+
+	case SDO_525_ONECOPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_WSS525_ONECOPY_PERMIT;
+		break;
+
+	case SDO_525_NOCOPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_WSS525_NOCOPY_PERMIT;
+		break;
+
+	default:
+		tvout_err("invalid copy_permit parameter(%d)\n",
+			wss525.copy_permit);
+		return -1;
+	}
+
+	switch (wss525.mv_psp) {
+	case SDO_525_MV_PSP_OFF:
+		temp_reg |= S5P_SDO_WORD2_WSS525_MV_PSP_OFF;
+		break;
+
+	case SDO_525_MV_PSP_ON_2LINE_BURST:
+		temp_reg |= S5P_SDO_WORD2_WSS525_MV_PSP_ON_2LINE_BURST;
+		break;
+
+	case SDO_525_MV_PSP_ON_BURST_OFF:
+		temp_reg |= S5P_SDO_WORD2_WSS525_MV_PSP_ON_BURST_OFF;
+		break;
+
+	case SDO_525_MV_PSP_ON_4LINE_BURST:
+		temp_reg |= S5P_SDO_WORD2_WSS525_MV_PSP_ON_4LINE_BURST;
+		break;
+
+	default:
+		tvout_err("invalid mv_psp parameter(%d)\n", wss525.mv_psp);
+		return -1;
+	}
+
+	switch (wss525.copy_info) {
+	case SDO_525_COPY_INFO:
+		temp_reg |= S5P_SDO_WORD1_WSS525_COPY_INFO;
+		break;
+
+	case SDO_525_DEFAULT:
+		temp_reg |= S5P_SDO_WORD1_WSS525_DEFAULT;
+		break;
+
+	default:
+		tvout_err("invalid copy_info parameter(%d)\n",
+				wss525.copy_info);
+		return -1;
+	}
+
+	if (wss525.analog_on)
+		temp_reg |= S5P_SDO_WORD2_WSS525_ANALOG_ON;
+	else
+		temp_reg |= S5P_SDO_WORD2_WSS525_ANALOG_OFF;
+
+	switch (wss525.display_ratio) {
+	case SDO_525_COPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_WSS525_4_3_NORMAL;
+		break;
+
+	case SDO_525_ONECOPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_WSS525_16_9_ANAMORPIC;
+		break;
+
+	case SDO_525_NOCOPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_WSS525_4_3_LETTERBOX;
+		break;
+
+	default:
+		tvout_err("invalid display_ratio parameter(%d)\n",
+			wss525.display_ratio);
+		return -1;
+	}
+
+	writel(temp_reg |
+		S5P_SDO_CRC_WSS525(s5p_sdo_calc_wss_cgms_crc(temp_reg)),
+		sdo_base + S5P_SDO_WSS525);
+
+	return 0;
+}
+
+int s5p_sdo_set_wss625_data(struct s5p_sdo_625_data wss625)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d, %d, %d, %d, %d, %d\n",
+		wss625.surround_sound, wss625.copyright,
+		wss625.copy_protection, wss625.text_subtitles,
+		wss625.open_subtitles, wss625.camera_film,
+		wss625.color_encoding, wss625.helper_signal,
+		wss625.display_ratio);
+
+	if (wss625.surround_sound)
+		temp_reg = S5P_SDO_WSS625_SURROUND_SOUND_ENABLE;
+	else
+		temp_reg = S5P_SDO_WSS625_SURROUND_SOUND_DISABLE;
+
+	if (wss625.copyright)
+		temp_reg |= S5P_SDO_WSS625_COPYRIGHT;
+	else
+		temp_reg |= S5P_SDO_WSS625_NO_COPYRIGHT;
+
+	if (wss625.copy_protection)
+		temp_reg |= S5P_SDO_WSS625_COPY_RESTRICTED;
+	else
+		temp_reg |= S5P_SDO_WSS625_COPY_NOT_RESTRICTED;
+
+	if (wss625.text_subtitles)
+		temp_reg |= S5P_SDO_WSS625_TELETEXT_SUBTITLES;
+	else
+		temp_reg |= S5P_SDO_WSS625_TELETEXT_NO_SUBTITLES;
+
+	switch (wss625.open_subtitles) {
+	case SDO_625_NO_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_WSS625_NO_OPEN_SUBTITLES;
+		break;
+
+	case SDO_625_INACT_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_WSS625_INACT_OPEN_SUBTITLES;
+		break;
+
+	case SDO_625_OUTACT_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_WSS625_OUTACT_OPEN_SUBTITLES;
+		break;
+
+	default:
+		tvout_err("invalid open_subtitles parameter(%d)\n",
+			wss625.open_subtitles);
+		return -1;
+	}
+
+	switch (wss625.camera_film) {
+	case SDO_625_CAMERA:
+		temp_reg |= S5P_SDO_WSS625_CAMERA;
+		break;
+
+	case SDO_625_FILM:
+		temp_reg |= S5P_SDO_WSS625_FILM;
+		break;
+
+	default:
+		tvout_err("invalid camera_film parameter(%d)\n",
+			wss625.camera_film);
+		return -1;
+	}
+
+	switch (wss625.color_encoding) {
+	case SDO_625_NORMAL_PAL:
+		temp_reg |= S5P_SDO_WSS625_NORMAL_PAL;
+		break;
+
+	case SDO_625_MOTION_ADAPTIVE_COLORPLUS:
+		temp_reg |= S5P_SDO_WSS625_MOTION_ADAPTIVE_COLORPLUS;
+		break;
+
+	default:
+		tvout_err("invalid color_encoding parameter(%d)\n",
+			wss625.color_encoding);
+		return -1;
+	}
+
+	if (wss625.helper_signal)
+		temp_reg |= S5P_SDO_WSS625_HELPER_SIG;
+	else
+		temp_reg |= S5P_SDO_WSS625_HELPER_NO_SIG;
+
+	switch (wss625.display_ratio) {
+	case SDO_625_4_3_FULL_576:
+		temp_reg |= S5P_SDO_WSS625_4_3_FULL_576;
+		break;
+
+	case SDO_625_14_9_LETTERBOX_CENTER_504:
+		temp_reg |= S5P_SDO_WSS625_14_9_LETTERBOX_CENTER_504;
+		break;
+
+	case SDO_625_14_9_LETTERBOX_TOP_504:
+		temp_reg |= S5P_SDO_WSS625_14_9_LETTERBOX_TOP_504;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_CENTER_430:
+		temp_reg |= S5P_SDO_WSS625_16_9_LETTERBOX_CENTER_430;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_TOP_430:
+		temp_reg |= S5P_SDO_WSS625_16_9_LETTERBOX_TOP_430;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_CENTER:
+		temp_reg |= S5P_SDO_WSS625_16_9_LETTERBOX_CENTER;
+		break;
+
+	case SDO_625_14_9_FULL_CENTER_576:
+		temp_reg |= S5P_SDO_WSS625_14_9_FULL_CENTER_576;
+		break;
+
+	case SDO_625_16_9_ANAMORPIC_576:
+		temp_reg |= S5P_SDO_WSS625_16_9_ANAMORPIC_576;
+		break;
+
+	default:
+		tvout_err("invalid display_ratio parameter(%d)\n",
+			wss625.display_ratio);
+		return -1;
+	}
+
+	writel(temp_reg, sdo_base + S5P_SDO_WSS625);
+
+	return 0;
+}
+
+int s5p_sdo_set_cgmsa525_data(struct s5p_sdo_525_data cgmsa525)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d\n",
+		cgmsa525.copy_permit, cgmsa525.mv_psp,
+		cgmsa525.copy_info, cgmsa525.display_ratio);
+
+	switch (cgmsa525.copy_permit) {
+	case SDO_525_COPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_CGMS525_COPY_PERMIT;
+		break;
+
+	case SDO_525_ONECOPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_CGMS525_ONECOPY_PERMIT;
+		break;
+
+	case SDO_525_NOCOPY_PERMIT:
+		temp_reg = S5P_SDO_WORD2_CGMS525_NOCOPY_PERMIT;
+		break;
+
+	default:
+		tvout_err("invalid copy_permit parameter(%d)\n",
+			cgmsa525.copy_permit);
+		return -1;
+	}
+
+	switch (cgmsa525.mv_psp) {
+	case SDO_525_MV_PSP_OFF:
+		temp_reg |= S5P_SDO_WORD2_CGMS525_MV_PSP_OFF;
+		break;
+
+	case SDO_525_MV_PSP_ON_2LINE_BURST:
+		temp_reg |= S5P_SDO_WORD2_CGMS525_MV_PSP_ON_2LINE_BURST;
+		break;
+
+	case SDO_525_MV_PSP_ON_BURST_OFF:
+		temp_reg |= S5P_SDO_WORD2_CGMS525_MV_PSP_ON_BURST_OFF;
+		break;
+
+	case SDO_525_MV_PSP_ON_4LINE_BURST:
+		temp_reg |= S5P_SDO_WORD2_CGMS525_MV_PSP_ON_4LINE_BURST;
+		break;
+
+	default:
+		tvout_err("invalid mv_psp parameter(%d)\n", cgmsa525.mv_psp);
+		return -1;
+	}
+
+	switch (cgmsa525.copy_info) {
+	case SDO_525_COPY_INFO:
+		temp_reg |= S5P_SDO_WORD1_CGMS525_COPY_INFO;
+		break;
+
+	case SDO_525_DEFAULT:
+		temp_reg |= S5P_SDO_WORD1_CGMS525_DEFAULT;
+		break;
+
+	default:
+		tvout_err("invalid copy_info parameter(%d)\n",
+				cgmsa525.copy_info);
+		return -1;
+	}
+
+	if (cgmsa525.analog_on)
+		temp_reg |= S5P_SDO_WORD2_CGMS525_ANALOG_ON;
+	else
+		temp_reg |= S5P_SDO_WORD2_CGMS525_ANALOG_OFF;
+
+	switch (cgmsa525.display_ratio) {
+	case SDO_525_COPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_CGMS525_4_3_NORMAL;
+		break;
+
+	case SDO_525_ONECOPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_CGMS525_16_9_ANAMORPIC;
+		break;
+
+	case SDO_525_NOCOPY_PERMIT:
+		temp_reg |= S5P_SDO_WORD0_CGMS525_4_3_LETTERBOX;
+		break;
+
+	default:
+		tvout_err("invalid display_ratio parameter(%d)\n",
+			cgmsa525.display_ratio);
+		return -1;
+	}
+
+	writel(temp_reg | S5P_SDO_CRC_CGMS525(
+		s5p_sdo_calc_wss_cgms_crc(temp_reg)),
+		sdo_base + S5P_SDO_CGMS525);
+
+	return 0;
+}
+
+
+int s5p_sdo_set_cgmsa625_data(struct s5p_sdo_625_data cgmsa625)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d, %d, %d, %d, %d, %d, %d, %d\n",
+		cgmsa625.surround_sound, cgmsa625.copyright,
+		cgmsa625.copy_protection, cgmsa625.text_subtitles,
+		cgmsa625.open_subtitles, cgmsa625.camera_film,
+		cgmsa625.color_encoding, cgmsa625.helper_signal,
+		cgmsa625.display_ratio);
+
+	if (cgmsa625.surround_sound)
+		temp_reg = S5P_SDO_CGMS625_SURROUND_SOUND_ENABLE;
+	else
+		temp_reg = S5P_SDO_CGMS625_SURROUND_SOUND_DISABLE;
+
+	if (cgmsa625.copyright)
+		temp_reg |= S5P_SDO_CGMS625_COPYRIGHT;
+	else
+		temp_reg |= S5P_SDO_CGMS625_NO_COPYRIGHT;
+
+	if (cgmsa625.copy_protection)
+		temp_reg |= S5P_SDO_CGMS625_COPY_RESTRICTED;
+	else
+		temp_reg |= S5P_SDO_CGMS625_COPY_NOT_RESTRICTED;
+
+	if (cgmsa625.text_subtitles)
+		temp_reg |= S5P_SDO_CGMS625_TELETEXT_SUBTITLES;
+	else
+		temp_reg |= S5P_SDO_CGMS625_TELETEXT_NO_SUBTITLES;
+
+	switch (cgmsa625.open_subtitles) {
+	case SDO_625_NO_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_CGMS625_NO_OPEN_SUBTITLES;
+		break;
+
+	case SDO_625_INACT_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_CGMS625_INACT_OPEN_SUBTITLES;
+		break;
+
+	case SDO_625_OUTACT_OPEN_SUBTITLES:
+		temp_reg |= S5P_SDO_CGMS625_OUTACT_OPEN_SUBTITLES;
+		break;
+
+	default:
+		tvout_err("invalid open_subtitles parameter(%d)\n",
+			cgmsa625.open_subtitles);
+		return -1;
+	}
+
+	switch (cgmsa625.camera_film) {
+	case SDO_625_CAMERA:
+		temp_reg |= S5P_SDO_CGMS625_CAMERA;
+		break;
+
+	case SDO_625_FILM:
+		temp_reg |= S5P_SDO_CGMS625_FILM;
+		break;
+
+	default:
+		tvout_err("invalid camera_film parameter(%d)\n",
+			cgmsa625.camera_film);
+		return -1;
+	}
+
+	switch (cgmsa625.color_encoding) {
+	case SDO_625_NORMAL_PAL:
+		temp_reg |= S5P_SDO_CGMS625_NORMAL_PAL;
+		break;
+
+	case SDO_625_MOTION_ADAPTIVE_COLORPLUS:
+		temp_reg |= S5P_SDO_CGMS625_MOTION_ADAPTIVE_COLORPLUS;
+		break;
+
+	default:
+		tvout_err("invalid color_encoding parameter(%d)\n",
+			cgmsa625.color_encoding);
+		return -1;
+	}
+
+	if (cgmsa625.helper_signal)
+		temp_reg |= S5P_SDO_CGMS625_HELPER_SIG;
+	else
+		temp_reg |= S5P_SDO_CGMS625_HELPER_NO_SIG;
+
+	switch (cgmsa625.display_ratio) {
+	case SDO_625_4_3_FULL_576:
+		temp_reg |= S5P_SDO_CGMS625_4_3_FULL_576;
+		break;
+
+	case SDO_625_14_9_LETTERBOX_CENTER_504:
+		temp_reg |= S5P_SDO_CGMS625_14_9_LETTERBOX_CENTER_504;
+		break;
+
+	case SDO_625_14_9_LETTERBOX_TOP_504:
+		temp_reg |= S5P_SDO_CGMS625_14_9_LETTERBOX_TOP_504;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_CENTER_430:
+		temp_reg |= S5P_SDO_CGMS625_16_9_LETTERBOX_CENTER_430;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_TOP_430:
+		temp_reg |= S5P_SDO_CGMS625_16_9_LETTERBOX_TOP_430;
+		break;
+
+	case SDO_625_16_9_LETTERBOX_CENTER:
+		temp_reg |= S5P_SDO_CGMS625_16_9_LETTERBOX_CENTER;
+		break;
+
+	case SDO_625_14_9_FULL_CENTER_576:
+		temp_reg |= S5P_SDO_CGMS625_14_9_FULL_CENTER_576;
+		break;
+
+	case SDO_625_16_9_ANAMORPIC_576:
+		temp_reg |= S5P_SDO_CGMS625_16_9_ANAMORPIC_576;
+		break;
+
+	default:
+		tvout_err("invalid display_ratio parameter(%d)\n",
+			cgmsa625.display_ratio);
+		return -1;
+	}
+
+	writel(temp_reg, sdo_base + S5P_SDO_CGMS625);
+
+	return 0;
+}
+
+int s5p_sdo_set_display_mode(enum s5p_tvout_disp_mode disp_mode,
+			     enum s5p_sdo_order order)
+{
+	u32 temp_reg = 0;
+
+	tvout_dbg("%d, %d\n", disp_mode, order);
+
+	switch (disp_mode) {
+	case TVOUT_NTSC_M:
+		temp_reg |= S5P_SDO_NTSC_M;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_75IRE,
+			SDO_VTOS_RATIO_10_4);
+
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_75IRE,
+			SDO_VTOS_RATIO_10_4);
+		break;
+
+	case TVOUT_PAL_BDGHI:
+		temp_reg |= S5P_SDO_PAL_BGHID;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+		break;
+
+	case TVOUT_PAL_M:
+		temp_reg |= S5P_SDO_PAL_M;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+		break;
+
+	case TVOUT_PAL_N:
+		temp_reg |= S5P_SDO_PAL_N;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_75IRE,
+			SDO_VTOS_RATIO_10_4);
+		break;
+
+	case TVOUT_PAL_NC:
+		temp_reg |= S5P_SDO_PAL_NC;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+		break;
+
+	case TVOUT_PAL_60:
+		temp_reg |= S5P_SDO_PAL_60;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_0IRE,
+			SDO_VTOS_RATIO_7_3);
+		break;
+
+	case TVOUT_NTSC_443:
+		temp_reg |= S5P_SDO_NTSC_443;
+		s5p_sdo_set_video_scale_cfg(
+			SDO_LEVEL_75IRE,
+			SDO_VTOS_RATIO_10_4);
+		s5p_sdo_set_antialias_filter_coeff_default(
+			SDO_LEVEL_75IRE,
+			SDO_VTOS_RATIO_10_4);
+		break;
+
+	default:
+		tvout_err("invalid disp_mode parameter(%d)\n", disp_mode);
+		return -1;
+	}
+
+	temp_reg |= S5P_SDO_COMPOSITE | S5P_SDO_INTERLACED;
+
+	switch (order) {
+
+	case SDO_O_ORDER_COMPOSITE_CVBS_Y_C:
+		temp_reg |= S5P_SDO_DAC2_CVBS | S5P_SDO_DAC1_Y |
+				S5P_SDO_DAC0_C;
+		break;
+
+	case SDO_O_ORDER_COMPOSITE_CVBS_C_Y:
+		temp_reg |= S5P_SDO_DAC2_CVBS | S5P_SDO_DAC1_C |
+				S5P_SDO_DAC0_Y;
+		break;
+
+	case SDO_O_ORDER_COMPOSITE_Y_C_CVBS:
+		temp_reg |= S5P_SDO_DAC2_Y | S5P_SDO_DAC1_C |
+				S5P_SDO_DAC0_CVBS;
+		break;
+
+	case SDO_O_ORDER_COMPOSITE_Y_CVBS_C:
+		temp_reg |= S5P_SDO_DAC2_Y | S5P_SDO_DAC1_CVBS |
+				S5P_SDO_DAC0_C;
+		break;
+
+	case SDO_O_ORDER_COMPOSITE_C_CVBS_Y:
+		temp_reg |= S5P_SDO_DAC2_C | S5P_SDO_DAC1_CVBS |
+				S5P_SDO_DAC0_Y;
+		break;
+
+	case SDO_O_ORDER_COMPOSITE_C_Y_CVBS:
+		temp_reg |= S5P_SDO_DAC2_C | S5P_SDO_DAC1_Y |
+				S5P_SDO_DAC0_CVBS;
+		break;
+
+	default:
+		tvout_err("invalid order parameter(%d)\n", order);
+		return -1;
+	}
+
+	writel(temp_reg, sdo_base + S5P_SDO_CONFIG);
+
+	return 0;
+}
+
+void s5p_sdo_clock_on(bool on)
+{
+	tvout_dbg("%d\n", on);
+
+	if (on)
+		writel(S5P_SDO_TVOUT_CLOCK_ON, sdo_base + S5P_SDO_CLKCON);
+	else
+		writel(S5P_SDO_TVOUT_CLOCK_OFF, sdo_base + S5P_SDO_CLKCON);
+}
+
+void s5p_sdo_dac_on(bool on)
+{
+	tvout_dbg("%d\n", on);
+
+	if (on) {
+		writel(S5P_SDO_POWER_ON_DAC, sdo_base + S5P_SDO_DAC);
+		writel(S5P_DAC_ENABLE, S5P_DAC_CONTROL);
+	} else {
+		writel(S5P_DAC_DISABLE, S5P_DAC_CONTROL);
+		writel(S5P_SDO_POWER_DOWN_DAC, sdo_base + S5P_SDO_DAC);
+	}
+}
+
+void s5p_sdo_sw_reset(bool active)
+{
+	tvout_dbg("%d\n", active);
+
+	if (active)
+		writel(readl(sdo_base + S5P_SDO_CLKCON) |
+			S5P_SDO_TVOUT_SW_RESET, sdo_base + S5P_SDO_CLKCON);
+	else
+		writel(readl(sdo_base + S5P_SDO_CLKCON) &
+			~S5P_SDO_TVOUT_SW_RESET, sdo_base + S5P_SDO_CLKCON);
+}
+
+void s5p_sdo_set_interrupt_enable(bool vsync_intc_en)
+{
+	tvout_dbg("%d\n", vsync_intc_en);
+
+	if (vsync_intc_en)
+		writel(readl(sdo_base + S5P_SDO_IRQMASK) &
+			~S5P_SDO_VSYNC_IRQ_DISABLE, sdo_base + S5P_SDO_IRQMASK);
+	else
+		writel(readl(sdo_base + S5P_SDO_IRQMASK) |
+			S5P_SDO_VSYNC_IRQ_DISABLE, sdo_base + S5P_SDO_IRQMASK);
+}
+
+void s5p_sdo_clear_interrupt_pending(void)
+{
+	writel(readl(sdo_base + S5P_SDO_IRQ) | S5P_SDO_VSYNC_IRQ_PEND,
+			sdo_base + S5P_SDO_IRQ);
+}
+
+void s5p_sdo_init(void __iomem *addr)
+{
+	sdo_base = addr;
+}
diff --git a/drivers/media/video/s5p-tvout/s5p_tvif_ctrl.c b/drivers/media/video/s5p-tvout/s5p_tvif_ctrl.c
new file mode 100644
index 0000000..b00c4f5
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvif_ctrl.c
@@ -0,0 +1,1945 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Tvout ctrl class for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/**
+ * This file includes functions for ctrl classes of TVOUT driver.
+ * There are 3 ctrl classes. (tvif, hdmi, sdo)
+ *	- tvif ctrl class: controls hdmi and sdo ctrl class.
+ *      - hdmi ctrl class: contrls hdmi hardware by using hw_if/hdmi.c
+ *      - sdo  ctrl class: contrls sdo hardware by using hw_if/sdo.c
+ *
+ *                      +-----------------+
+ *                      | tvif ctrl class |
+ *                      +-----------------+
+ *                             |   |
+ *                  +----------+   +----------+		    ctrl class layer
+ *                  |                         |
+ *                  V                         V
+ *         +-----------------+       +-----------------+
+ *         | sdo ctrl class  |       | hdmi ctrl class |
+ *         +-----------------+       +-----------------+
+ *                  |                         |
+ *   ---------------+-------------------------+------------------------------
+ *                  V                         V
+ *         +-----------------+       +-----------------+
+ *         |   hw_if/sdo.c   |       |   hw_if/hdmi.c  |         hw_if layer
+ *         +-----------------+       +-----------------+
+ *                  |                         |
+ *   ---------------+-------------------------+------------------------------
+ *                  V                         V
+ *         +-----------------+       +-----------------+
+ *         |   sdo hardware  |       |   hdmi hardware |	  Hardware
+ *         +-----------------+       +-----------------+
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+
+#include "s5p_tvout_common_lib.h"
+#include "hw_if/hw_if.h"
+#include "s5p_tvout_ctrl.h"
+
+/*Definitions for sdo ctrl class */
+enum {
+	SDO_PCLK = 0,
+	SDO_MUX,
+	SDO_NO_OF_CLK
+};
+
+struct s5p_sdo_vscale_cfg {
+	enum s5p_sdo_level		composite_level;
+	enum s5p_sdo_vsync_ratio	composite_ratio;
+};
+
+struct s5p_sdo_vbi {
+	bool wss_cvbs;
+	enum s5p_sdo_closed_caption_type caption_cvbs;
+};
+
+struct s5p_sdo_offset_gain {
+	u32 offset;
+	u32 gain;
+};
+
+struct s5p_sdo_delay {
+	u32 delay_y;
+	u32 offset_video_start;
+	u32 offset_video_end;
+};
+
+struct s5p_sdo_component_porch {
+	u32 back_525;
+	u32 front_525;
+	u32 back_625;
+	u32 front_625;
+};
+
+struct s5p_sdo_ch_xtalk_cancellat_coeff {
+	u32 coeff1;
+	u32 coeff2;
+};
+
+struct s5p_sdo_closed_caption {
+	u32 display_cc;
+	u32 nondisplay_cc;
+};
+
+struct s5p_sdo_ctrl_private_data {
+	struct s5p_sdo_vscale_cfg		video_scale_cfg;
+	struct s5p_sdo_vbi			vbi;
+	struct s5p_sdo_offset_gain		offset_gain;
+	struct s5p_sdo_delay			delay;
+	struct s5p_sdo_bright_hue_saturation	bri_hue_sat;
+	struct s5p_sdo_cvbs_compensation	cvbs_compen;
+	struct s5p_sdo_component_porch		compo_porch;
+	struct s5p_sdo_ch_xtalk_cancellat_coeff	xtalk_cc;
+	struct s5p_sdo_closed_caption		closed_cap;
+	struct s5p_sdo_525_data			wss_525;
+	struct s5p_sdo_625_data			wss_625;
+	struct s5p_sdo_525_data			cgms_525;
+	struct s5p_sdo_625_data			cgms_625;
+
+	bool			color_sub_carrier_phase_adj;
+
+	bool			running;
+
+	struct s5p_tvout_clk_info	clk[SDO_NO_OF_CLK];
+	char			*pow_name;
+	struct reg_mem_info	reg_mem;
+};
+
+static struct s5p_sdo_ctrl_private_data s5p_sdo_ctrl_private = {
+	.clk[SDO_PCLK] = {
+		.name			= "tvenc",
+		.ptr			= NULL
+	},
+	.clk[SDO_MUX] = {
+		.name			= "sclk_dac",
+		.ptr			= NULL
+	},
+		.pow_name		= "tv_enc_pd",
+	.reg_mem = {
+		.name			= "s5p-sdo",
+		.res			= NULL,
+		.base			= NULL
+	},
+
+	.running			= false,
+
+	.color_sub_carrier_phase_adj	= false,
+
+	.vbi = {
+		.wss_cvbs		= true,
+		.caption_cvbs		= SDO_INS_OTHERS
+	},
+
+	.offset_gain = {
+		.offset			= 0,
+		.gain			= 0x800
+	},
+
+	.delay = {
+		.delay_y		= 0x00,
+		.offset_video_start	= 0xfa,
+		.offset_video_end	= 0x00
+	},
+
+	.bri_hue_sat = {
+		.bright_hue_sat_adj	= false,
+		.gain_brightness	= 0x80,
+		.offset_brightness	= 0x00,
+		.gain0_cb_hue_sat	= 0x00,
+		.gain1_cb_hue_sat	= 0x00,
+		.gain0_cr_hue_sat	= 0x00,
+		.gain1_cr_hue_sat	= 0x00,
+		.offset_cb_hue_sat	= 0x00,
+		.offset_cr_hue_sat	= 0x00
+	},
+
+	.cvbs_compen = {
+		.cvbs_color_compen	= false,
+		.y_lower_mid		= 0x200,
+		.y_bottom		= 0x000,
+		.y_top			= 0x3ff,
+		.y_upper_mid		= 0x200,
+		.radius			= 0x1ff
+	},
+
+	.compo_porch = {
+		.back_525		= 0x8a,
+		.front_525		= 0x359,
+		.back_625		= 0x96,
+		.front_625		= 0x35c
+	},
+
+	.xtalk_cc = {
+		.coeff2			= 0,
+		.coeff1			= 0
+	},
+
+	.closed_cap = {
+		.display_cc		= 0,
+		.nondisplay_cc		= 0
+	},
+
+	.wss_525 = {
+		.copy_permit		= SDO_525_COPY_PERMIT,
+		.mv_psp			= SDO_525_MV_PSP_OFF,
+		.copy_info		= SDO_525_COPY_INFO,
+		.analog_on		= false,
+		.display_ratio		= SDO_525_4_3_NORMAL
+	},
+
+	.wss_625 = {
+		.surround_sound		= false,
+		.copyright		= false,
+		.copy_protection	= false,
+		.text_subtitles		= false,
+		.open_subtitles		= SDO_625_NO_OPEN_SUBTITLES,
+		.camera_film		= SDO_625_CAMERA,
+		.color_encoding		= SDO_625_NORMAL_PAL,
+		.helper_signal		= false,
+		.display_ratio		= SDO_625_4_3_FULL_576
+	},
+
+	.cgms_525 = {
+		.copy_permit		= SDO_525_COPY_PERMIT,
+		.mv_psp			= SDO_525_MV_PSP_OFF,
+		.copy_info		= SDO_525_COPY_INFO,
+		.analog_on		= false,
+		.display_ratio		= SDO_525_4_3_NORMAL
+	},
+
+	.cgms_625 = {
+		.surround_sound		= false,
+		.copyright		= false,
+		.copy_protection	= false,
+		.text_subtitles		= false,
+		.open_subtitles		= SDO_625_NO_OPEN_SUBTITLES,
+		.camera_film		= SDO_625_CAMERA,
+		.color_encoding		= SDO_625_NORMAL_PAL,
+		.helper_signal		= false,
+		.display_ratio		= SDO_625_4_3_FULL_576
+	},
+};
+
+/* Definitions for hdmi ctrl class */
+
+#define AVI_SAME_WITH_PICTURE_AR	(0x1<<3)
+
+enum {
+	HDMI_PCLK = 0,
+	HDMI_MUX,
+	HDMI_NO_OF_CLK
+};
+
+enum {
+	HDMI = 0,
+	HDMI_PHY,
+	HDMI_NO_OF_MEM_RES
+};
+
+enum s5p_hdmi_pic_aspect {
+	HDMI_PIC_RATIO_4_3	= 1,
+	HDMI_PIC_RATIO_16_9	= 2
+};
+
+enum s5p_hdmi_colorimetry {
+	HDMI_CLRIMETRY_NO	= 0x00,
+	HDMI_CLRIMETRY_601	= 0x40,
+	HDMI_CLRIMETRY_709	= 0x80,
+	HDMI_CLRIMETRY_X_VAL	= 0xc0,
+};
+
+enum s5p_hdmi_audio_type {
+	HDMI_GENERIC_AUDIO,
+	HDMI_60958_AUDIO,
+	HDMI_DVD_AUDIO,
+	HDMI_SUPER_AUDIO,
+};
+
+enum s5p_hdmi_v_mode {
+	v640x480p_60Hz,
+	v720x480p_60Hz,
+	v1280x720p_60Hz,
+	v1920x1080i_60Hz,
+	v720x480i_60Hz,
+	v720x240p_60Hz,
+	v2880x480i_60Hz,
+	v2880x240p_60Hz,
+	v1440x480p_60Hz,
+	v1920x1080p_60Hz,
+	v720x576p_50Hz,
+	v1280x720p_50Hz,
+	v1920x1080i_50Hz,
+	v720x576i_50Hz,
+	v720x288p_50Hz,
+	v2880x576i_50Hz,
+	v2880x288p_50Hz,
+	v1440x576p_50Hz,
+	v1920x1080p_50Hz,
+	v1920x1080p_24Hz,
+	v1920x1080p_25Hz,
+	v1920x1080p_30Hz,
+	v2880x480p_60Hz,
+	v2880x576p_50Hz,
+	v1920x1080i_50Hz_1250,
+	v1920x1080i_100Hz,
+	v1280x720p_100Hz,
+	v720x576p_100Hz,
+	v720x576i_100Hz,
+	v1920x1080i_120Hz,
+	v1280x720p_120Hz,
+	v720x480p_120Hz,
+	v720x480i_120Hz,
+	v720x576p_200Hz,
+	v720x576i_200Hz,
+	v720x480p_240Hz,
+	v720x480i_240Hz,
+	v720x480p_59Hz,
+	v1280x720p_59Hz,
+	v1920x1080i_59Hz,
+	v1920x1080p_59Hz,
+};
+
+struct s5p_hdmi_bluescreen {
+	bool	enable;
+	u8	cb_b;
+	u8	y_g;
+	u8	cr_r;
+};
+
+struct s5p_hdmi_packet {
+	u8				acr[7];
+	u8				asp[7];
+	u8				gcp[7];
+	u8				acp[28];
+	u8				isrc1[16];
+	u8				isrc2[16];
+	u8				obas[7];
+	u8				dst[28];
+	u8				gmp[28];
+
+	u8				spd_vendor[8];
+	u8				spd_product[16];
+
+	u8				vsi[27];
+	u8				avi[27];
+	u8				spd[27];
+	u8				aui[27];
+	u8				mpg[27];
+
+	struct s5p_hdmi_infoframe	vsi_info;
+	struct s5p_hdmi_infoframe	avi_info;
+	struct s5p_hdmi_infoframe	spd_info;
+	struct s5p_hdmi_infoframe	aui_info;
+	struct s5p_hdmi_infoframe	mpg_info;
+
+	u8				h_asp[3];
+	u8				h_acp[3];
+	u8				h_isrc[3];
+};
+
+struct s5p_hdmi_color_range {
+	u8	y_min;
+	u8	y_max;
+	u8	c_min;
+	u8	c_max;
+};
+
+struct s5p_hdmi_tg {
+	bool correction_en;
+	bool bt656_en;
+};
+
+struct s5p_hdmi_audio {
+	enum s5p_hdmi_audio_type	type;
+	u32				freq;
+	u32				bit;
+	u32				channel;
+
+	u8				on;
+};
+
+struct s5p_hdmi_video {
+	struct s5p_hdmi_color_range	color_r;
+	enum s5p_hdmi_pic_aspect	aspect;
+	enum s5p_hdmi_colorimetry	colorimetry;
+	enum s5p_hdmi_color_depth	depth;
+};
+
+struct s5p_hdmi_o_params {
+	struct s5p_hdmi_o_trans	trans;
+	struct s5p_hdmi_o_reg	reg;
+};
+
+struct s5p_hdmi_ctrl_private_data {
+	u8				vendor[8];
+	u8				product[16];
+
+	enum s5p_tvout_o_mode		out;
+	enum s5p_hdmi_v_mode		mode;
+
+	struct s5p_hdmi_bluescreen	blue_screen;
+	struct s5p_hdmi_packet		packet;
+	struct s5p_hdmi_tg		tg;
+	struct s5p_hdmi_audio		audio;
+	struct s5p_hdmi_video		video;
+
+	bool				hpd_status;
+	bool				hdcp_en;
+
+	bool				av_mute;
+
+	bool				running;
+	char				*pow_name;
+	struct s5p_tvout_clk_info		clk[HDMI_NO_OF_CLK];
+	struct reg_mem_info		reg_mem[HDMI_NO_OF_MEM_RES];
+	struct irq_info			irq;
+};
+
+static struct s5p_hdmi_v_format s5p_hdmi_v_fmt[] = {
+	[v720x480p_60Hz] = {
+		.frame = {
+			.vic		= 2,
+			.vic_16_9	= 3,
+			.repetition	= 0,
+			.polarity	= 1,
+			.i_p		= 0,
+			.h_active	= 720,
+			.v_active	= 480,
+			.h_total	= 858,
+			.h_blank	= 138,
+			.v_total	= 525,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_27_027,
+		},
+		.h_sync = {
+			.begin		= 0xe,
+			.end		= 0x4c,
+		},
+		.v_sync_top = {
+			.begin		= 0x9,
+			.end		= 0xf,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1280x720p_60Hz] = {
+		.frame = {
+			.vic		= 4,
+			.vic_16_9	= 4,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1280,
+			.v_active	= 720,
+			.h_total	= 1650,
+			.h_blank	= 370,
+			.v_total	= 750,
+			.v_blank	= 30,
+			.pixel_clock	= ePHY_FREQ_74_250,
+		},
+		.h_sync = {
+			.begin		= 0x6c,
+			.end		= 0x94,
+		},
+		.v_sync_top = {
+			.begin		= 0x5,
+			.end		= 0xa,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080i_60Hz] = {
+		.frame = {
+			.vic		= 5,
+			.vic_16_9	= 5,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 1,
+			.h_active	= 1920,
+			.v_active	= 540,
+			.h_total	= 2200,
+			.h_blank	= 280,
+			.v_total	= 1125,
+			.v_blank	= 22,
+			.pixel_clock	= ePHY_FREQ_74_250,
+		},
+		.h_sync = {
+			.begin		= 0x56,
+			.end		= 0x82,
+		},
+		.v_sync_top = {
+			.begin		= 0x2,
+			.end		= 0x7,
+		},
+		.v_sync_bottom = {
+			.begin		= 0x234,
+			.end		= 0x239,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0x4a4,
+			.end		= 0x4a4,
+		},
+		.v_blank_f = {
+			.begin		= 0x249,
+			.end		= 0x465,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080p_60Hz] = {
+		.frame = {
+			.vic		= 16,
+			.vic_16_9	= 16,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1920,
+			.v_active	= 1080,
+			.h_total	= 2200,
+			.h_blank	= 280,
+			.v_total	= 1125,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_148_500,
+		},
+		.h_sync = {
+			.begin		= 0x56,
+			.end		= 0x82,
+		},
+		.v_sync_top = {
+			.begin		= 0x4,
+			.end		= 0x9,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v720x576p_50Hz] = {
+		.frame = {
+			.vic		= 17,
+			.vic_16_9	= 18,
+			.repetition	= 0,
+			.polarity	= 1,
+			.i_p		= 0,
+			.h_active	= 720,
+			.v_active	= 576,
+			.h_total	= 864,
+			.h_blank	= 144,
+			.v_total	= 625,
+			.v_blank	= 49,
+			.pixel_clock	= ePHY_FREQ_27,
+		},
+		.h_sync = {
+			.begin		= 0xa,
+			.end		= 0x4a,
+		},
+		.v_sync_top = {
+			.begin		= 0x5,
+			.end		= 0xa,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1280x720p_50Hz] = {
+		.frame = {
+			.vic		= 19,
+			.vic_16_9	= 19,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1280,
+			.v_active	= 720,
+			.h_total	= 1980,
+			.h_blank	= 700,
+			.v_total	= 750,
+			.v_blank	= 30,
+			.pixel_clock	= ePHY_FREQ_74_250,
+		},
+		.h_sync = {
+			.begin		= 0x1b6,
+			.end		= 0x1de,
+		},
+		.v_sync_top = {
+			.begin		= 0x5,
+			.end		= 0xa,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080i_50Hz] = {
+		.frame = {
+			.vic		= 20,
+			.vic_16_9	= 20,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 1,
+			.h_active	= 1920,
+			.v_active	= 540,
+			.h_total	= 2640,
+			.h_blank	= 720,
+			.v_total	= 1125,
+			.v_blank	= 22,
+			.pixel_clock	= ePHY_FREQ_74_250,
+		},
+		.h_sync = {
+			.begin		= 0x20e,
+			.end		= 0x23a,
+		},
+		.v_sync_top = {
+			.begin		= 0x2,
+			.end		= 0x7,
+		},
+		.v_sync_bottom = {
+			.begin		= 0x234,
+			.end		= 0x239,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0x738,
+			.end		= 0x738,
+		},
+		.v_blank_f = {
+			.begin		= 0x249,
+			.end		= 0x465,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080p_50Hz] = {
+		.frame = {
+			.vic		= 31,
+			.vic_16_9	= 31,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1920,
+			.v_active	= 1080,
+			.h_total	= 2640,
+			.h_blank	= 720,
+			.v_total	= 1125,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_148_500,
+		},
+		.h_sync = {
+			.begin		= 0x20e,
+			.end		= 0x23a,
+		},
+		.v_sync_top = {
+			.begin		= 0x4,
+			.end		= 0x9,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080p_30Hz] = {
+		.frame = {
+			.vic		= 34,
+			.vic_16_9	= 34,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1920,
+			.v_active	= 1080,
+			.h_total	= 2200,
+			.h_blank	= 280,
+			.v_total	= 1125,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_74_250,
+		},
+		.h_sync = {
+			.begin		= 0x56,
+			.end		= 0x82,
+		},
+		.v_sync_top = {
+			.begin		= 0x4,
+			.end		= 0x9,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v720x480p_59Hz] = {
+		.frame = {
+			.vic		= 2,
+			.vic_16_9	= 3,
+			.repetition	= 0,
+			.polarity	= 1,
+			.i_p		= 0,
+			.h_active	= 720,
+			.v_active	= 480,
+			.h_total	= 858,
+			.h_blank	= 138,
+			.v_total	= 525,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_27,
+		},
+		.h_sync = {
+			.begin		= 0xe,
+			.end		= 0x4c,
+		},
+		.v_sync_top = {
+			.begin		= 0x9,
+			.end		= 0xf,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1280x720p_59Hz] = {
+		.frame = {
+			.vic		= 4,
+			.vic_16_9	= 4,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1280,
+			.v_active	= 720,
+			.h_total	= 1650,
+			.h_blank	= 370,
+			.v_total	= 750,
+			.v_blank	= 30,
+			.pixel_clock	= ePHY_FREQ_74_176,
+		},
+		.h_sync = {
+			.begin		= 0x6c,
+			.end		= 0x94,
+		},
+		.v_sync_top = {
+			.begin		= 0x5,
+			.end		= 0xa,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080i_59Hz] = {
+		.frame = {
+			.vic		= 5,
+			.vic_16_9	= 5,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 1,
+			.h_active	= 1920,
+			.v_active	= 540,
+			.h_total	= 2200,
+			.h_blank	= 280,
+			.v_total	= 1125,
+			.v_blank	= 22,
+			.pixel_clock	= ePHY_FREQ_74_176,
+		},
+		.h_sync = {
+			.begin		= 0x56,
+			.end		= 0x82,
+		},
+		.v_sync_top = {
+			.begin		= 0x2,
+			.end		= 0x7,
+		},
+		.v_sync_bottom = {
+			.begin		= 0x234,
+			.end		= 0x239,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0x4a4,
+			.end		= 0x4a4,
+		},
+		.v_blank_f = {
+			.begin		= 0x249,
+			.end		= 0x465,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+
+	[v1920x1080p_59Hz] = {
+		.frame = {
+			.vic		= 16,
+			.vic_16_9	= 16,
+			.repetition	= 0,
+			.polarity	= 0,
+			.i_p		= 0,
+			.h_active	= 1920,
+			.v_active	= 1080,
+			.h_total	= 2200,
+			.h_blank	= 280,
+			.v_total	= 1125,
+			.v_blank	= 45,
+			.pixel_clock	= ePHY_FREQ_148_352,
+		},
+		.h_sync = {
+			.begin		= 0x56,
+			.end		= 0x82,
+		},
+		.v_sync_top = {
+			.begin		= 0x4,
+			.end		= 0x9,
+		},
+		.v_sync_bottom = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_sync_h_pos = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.v_blank_f = {
+			.begin		= 0,
+			.end		= 0,
+		},
+		.mhl_hsync = 0xf,
+		.mhl_vsync = 0x1,
+	},
+};
+
+static struct s5p_hdmi_o_params s5p_hdmi_output[] = {
+	{
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+		{0x00, 0x00, 0x00, 0x00, 0x00},
+	}, {
+		{0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x04},
+		{0x40, 0x00, 0x02, 0x00, 0x00},
+	}, {
+		{0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x04},
+		{0x00, 0x00, 0x02, 0x20, 0x00},
+	}, {
+		{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+		{0x00, 0x22, 0x01, 0x20, 0x01},
+	},
+};
+
+static struct s5p_hdmi_ctrl_private_data s5p_hdmi_ctrl_private = {
+	.vendor		= "SAMSUNG",
+	.product	= "S5PC210",
+
+	.blue_screen = {
+		.enable = false,
+		.cb_b	= 0,
+		.y_g	= 0,
+		.cr_r	= 0,
+	},
+
+	.video = {
+		.color_r = {
+			.y_min = 1,
+			.y_max = 254,
+			.c_min = 1,
+			.c_max = 254,
+		},
+		.depth	= HDMI_CD_24,
+	},
+
+	.packet = {
+		.vsi_info = {0x81, 0x1, 27},
+		.avi_info = {0x82, 0x2, 13},
+		.spd_info = {0x83, 0x1, 27},
+		.aui_info = {0x84, 0x1, 10},
+		.mpg_info = {0x85, 0x1, 5},
+	},
+
+	.tg = {
+		.correction_en	= false,
+		.bt656_en	= false,
+	},
+
+	.hdcp_en = false,
+
+	.audio = {
+		.type	= HDMI_60958_AUDIO,
+		.bit	= 16,
+		.freq	= 44100,
+	},
+
+	.av_mute	= false,
+	.running	= false,
+
+	.pow_name = "hdmi_pd",
+
+	.clk[HDMI_PCLK] = {
+		.name = "hdmi",
+		.ptr = NULL
+	},
+
+	.clk[HDMI_MUX] = {
+		.name = "sclk_hdmi",
+		.ptr = NULL
+	},
+
+	.reg_mem[HDMI] = {
+		.name = "s5p-hdmi",
+		.res = NULL,
+		.base = NULL
+	},
+
+	.reg_mem[HDMI_PHY] = {
+		.name = "s5p-i2c-hdmi-phy",
+		.res = NULL,
+		.base = NULL
+	},
+
+	.irq = {
+		.name = "s5p-hdmi",
+		.handler = s5p_hdmi_irq,
+		.no = -1
+	}
+
+};
+
+/* Definitions for tvif ctrl class */
+struct s5p_tvif_ctrl_private_data {
+	enum s5p_tvout_disp_mode	curr_std;
+	enum s5p_tvout_o_mode		curr_if;
+
+	bool				running;
+};
+
+static struct s5p_tvif_ctrl_private_data s5p_tvif_ctrl_private = {
+	.curr_std = TVOUT_INIT_DISP_VALUE,
+	.curr_if = TVOUT_INIT_O_VALUE,
+
+	.running = false
+};
+
+/* Functions for sdo ctrl class */
+
+static void s5p_sdo_ctrl_init_private(void)
+{
+	/* nothing here yet */
+}
+
+static int s5p_sdo_ctrl_set_reg(enum s5p_tvout_disp_mode disp_mode)
+{
+	struct s5p_sdo_ctrl_private_data *private = &s5p_sdo_ctrl_private;
+
+	s5p_sdo_sw_reset(1);
+
+	if (s5p_sdo_set_display_mode(disp_mode, SDO_O_ORDER_COMPOSITE_Y_C_CVBS))
+		return -1;
+
+	if (s5p_sdo_set_video_scale_cfg(private->video_scale_cfg.composite_level,
+					private->video_scale_cfg.composite_ratio))
+		return -1;
+
+	if (s5p_sdo_set_vbi(private->vbi.wss_cvbs, private->vbi.caption_cvbs))
+		return -1;
+
+	s5p_sdo_set_offset_gain(private->offset_gain.offset,
+				private->offset_gain.gain);
+
+	s5p_sdo_set_delay(private->delay.delay_y,
+			  private->delay.offset_video_start,
+			  private->delay.offset_video_end);
+
+	s5p_sdo_set_schlock(private->color_sub_carrier_phase_adj);
+
+	s5p_sdo_set_brightness_hue_saturation(private->bri_hue_sat);
+
+	s5p_sdo_set_cvbs_color_compensation(private->cvbs_compen);
+
+	s5p_sdo_set_component_porch(private->compo_porch.back_525,
+				    private->compo_porch.front_525,
+				    private->compo_porch.back_625,
+				    private->compo_porch.front_625);
+
+	s5p_sdo_set_ch_xtalk_cancel_coef(private->xtalk_cc.coeff2,
+					 private->xtalk_cc.coeff1);
+
+	s5p_sdo_set_closed_caption(private->closed_cap.display_cc,
+				   private->closed_cap.nondisplay_cc);
+
+	if (s5p_sdo_set_wss525_data(private->wss_525))
+		return -1;
+
+	if (s5p_sdo_set_wss625_data(private->wss_625))
+		return -1;
+
+	if (s5p_sdo_set_cgmsa525_data(private->cgms_525))
+		return -1;
+
+	if (s5p_sdo_set_cgmsa625_data(private->cgms_625))
+		return -1;
+
+	s5p_sdo_set_interrupt_enable(0);
+
+	s5p_sdo_clear_interrupt_pending();
+
+	s5p_sdo_clock_on(1);
+	s5p_sdo_dac_on(1);
+
+	return 0;
+}
+
+static void s5p_sdo_ctrl_internal_stop(void)
+{
+	s5p_sdo_clock_on(0);
+	s5p_sdo_dac_on(0);
+}
+
+static void s5p_sdo_ctrl_clock(bool on)
+{
+	if (on) {
+		clk_enable(s5p_sdo_ctrl_private.clk[SDO_MUX].ptr);
+		clk_enable(s5p_sdo_ctrl_private.clk[SDO_PCLK].ptr);
+	} else {
+		clk_disable(s5p_sdo_ctrl_private.clk[SDO_PCLK].ptr);
+		clk_disable(s5p_sdo_ctrl_private.clk[SDO_MUX].ptr);
+	}
+}
+
+void s5p_sdo_ctrl_stop(void)
+{
+	if (s5p_sdo_ctrl_private.running) {
+		s5p_sdo_ctrl_internal_stop();
+		s5p_sdo_ctrl_clock(0);
+
+		s5p_sdo_ctrl_private.running = false;
+	}
+}
+
+int s5p_sdo_ctrl_start(enum s5p_tvout_disp_mode disp_mode)
+{
+	struct s5p_sdo_ctrl_private_data *sdo_private = &s5p_sdo_ctrl_private;
+
+	switch (disp_mode) {
+	case TVOUT_NTSC_M:
+	case TVOUT_NTSC_443:
+		sdo_private->video_scale_cfg.composite_level = SDO_LEVEL_75IRE;
+		sdo_private->video_scale_cfg.composite_ratio = SDO_VTOS_RATIO_10_4;
+		break;
+
+	case TVOUT_PAL_BDGHI:
+	case TVOUT_PAL_M:
+	case TVOUT_PAL_N:
+	case TVOUT_PAL_NC:
+	case TVOUT_PAL_60:
+		sdo_private->video_scale_cfg.composite_level = SDO_LEVEL_0IRE;
+		sdo_private->video_scale_cfg.composite_ratio = SDO_VTOS_RATIO_7_3;
+		break;
+
+	default:
+		tvout_err("invalid disp_mode(%d) for SDO\n", disp_mode);
+		goto err_on_s5p_sdo_start;
+	}
+
+	if (sdo_private->running) {
+		s5p_sdo_ctrl_internal_stop();
+	} else {
+		s5p_sdo_ctrl_clock(1);
+
+		sdo_private->running = true;
+	}
+
+	if (s5p_sdo_ctrl_set_reg(disp_mode))
+		goto err_on_s5p_sdo_start;
+
+	return 0;
+
+err_on_s5p_sdo_start:
+	return -1;
+}
+
+int s5p_sdo_ctrl_constructor(struct platform_device *pdev)
+{
+	int ret;
+	int i, j;
+
+	ret = s5p_tvout_map_resource_mem(pdev, s5p_sdo_ctrl_private.reg_mem.name,
+					 &(s5p_sdo_ctrl_private.reg_mem.base),
+					 &(s5p_sdo_ctrl_private.reg_mem.res));
+
+	if (ret)
+		goto err_on_res;
+
+	for (i = SDO_PCLK; i < SDO_NO_OF_CLK; i++) {
+		s5p_sdo_ctrl_private.clk[i].ptr = clk_get(&pdev->dev, s5p_sdo_ctrl_private.clk[i].name);
+
+		if (IS_ERR(s5p_sdo_ctrl_private.clk[i].ptr)) {
+			tvout_err("Failed to find clock %s\n", s5p_sdo_ctrl_private.clk[i].name);
+			ret = -ENOENT;
+			goto err_on_clk;
+		}
+	}
+
+	s5p_sdo_ctrl_init_private();
+	s5p_sdo_init(s5p_sdo_ctrl_private.reg_mem.base);
+
+	return 0;
+
+err_on_clk:
+	for (j = 0; j < i; j++)
+		clk_put(s5p_sdo_ctrl_private.clk[j].ptr);
+
+	s5p_tvout_unmap_resource_mem(s5p_sdo_ctrl_private.reg_mem.base,
+				     s5p_sdo_ctrl_private.reg_mem.res);
+
+err_on_res:
+	return ret;
+}
+
+void s5p_sdo_ctrl_destructor(void)
+{
+	int i;
+
+	s5p_tvout_unmap_resource_mem(s5p_sdo_ctrl_private.reg_mem.base,
+				     s5p_sdo_ctrl_private.reg_mem.res);
+
+	for (i = SDO_PCLK; i < SDO_NO_OF_CLK; i++)
+		if (s5p_sdo_ctrl_private.clk[i].ptr) {
+			if (s5p_sdo_ctrl_private.running)
+				clk_disable(s5p_sdo_ctrl_private.clk[i].ptr);
+
+			clk_put(s5p_sdo_ctrl_private.clk[i].ptr);
+	}
+}
+
+/* Functions for hdmi ctrl class */
+
+static enum s5p_hdmi_v_mode s5p_hdmi_check_v_fmt(enum s5p_tvout_disp_mode disp)
+{
+	struct s5p_hdmi_ctrl_private_data	*ctrl = &s5p_hdmi_ctrl_private;
+	struct s5p_hdmi_video			*video = &ctrl->video;
+	enum s5p_hdmi_v_mode			mode;
+
+	video->aspect		= HDMI_PIC_RATIO_16_9;
+	video->colorimetry	= HDMI_CLRIMETRY_601;
+
+	switch (disp) {
+	case TVOUT_480P_60_16_9:
+		mode = v720x480p_60Hz;
+		break;
+
+	case TVOUT_480P_60_4_3:
+		mode = v720x480p_60Hz;
+		video->aspect = HDMI_PIC_RATIO_4_3;
+		break;
+
+	case TVOUT_480P_59:
+		mode = v720x480p_59Hz;
+		break;
+
+	case TVOUT_576P_50_16_9:
+		mode = v720x576p_50Hz;
+		break;
+
+	case TVOUT_576P_50_4_3:
+		mode = v720x576p_50Hz;
+		video->aspect = HDMI_PIC_RATIO_4_3;
+		break;
+
+	case TVOUT_720P_60:
+		mode = v1280x720p_60Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_720P_59:
+		mode = v1280x720p_59Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_720P_50:
+		mode = v1280x720p_50Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080P_30:
+		mode = v1920x1080p_30Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080P_60:
+		mode = v1920x1080p_60Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080P_59:
+		mode = v1920x1080p_59Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080P_50:
+		mode = v1920x1080p_50Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080I_60:
+		mode = v1920x1080i_60Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080I_59:
+		mode = v1920x1080i_59Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	case TVOUT_1080I_50:
+		mode = v1920x1080i_50Hz;
+		video->colorimetry = HDMI_CLRIMETRY_709;
+		break;
+
+	default:
+		mode = v720x480p_60Hz;
+		tvout_err("Not supported mode : %d\n", mode);
+	}
+
+	return mode;
+}
+
+static void s5p_hdmi_set_acr(struct s5p_hdmi_audio *audio, u8 *acr)
+{
+	u32 n = (audio->freq == 32000) ? 4096 :
+		(audio->freq == 44100) ? 6272 :
+		(audio->freq == 88200) ? 12544 :
+		(audio->freq == 176400) ? 25088 :
+		(audio->freq == 48000) ? 6144 :
+		(audio->freq == 96000) ? 12288 :
+		(audio->freq == 192000) ? 24576 : 0;
+
+	u32 cts = (audio->freq == 32000) ? 27000 :
+		(audio->freq == 44100) ? 30000 :
+		(audio->freq == 88200) ? 30000 :
+		(audio->freq == 176400) ? 30000 :
+		(audio->freq == 48000) ? 27000 :
+		(audio->freq == 96000) ? 27000 :
+		(audio->freq == 192000) ? 27000 : 0;
+
+	acr[1] = cts >> 16;
+	acr[2] = cts >> 8 & 0xff;
+	acr[3] = cts & 0xff;
+
+	acr[4] = n >> 16;
+	acr[5] = n >> 8 & 0xff;
+	acr[6] = n & 0xff;
+
+	tvout_dbg("n value = %d\n", n);
+	tvout_dbg("cts   = %d\n", cts);
+}
+
+static void s5p_hdmi_set_asp(u8 *header)
+{
+	header[1] = 0;
+	header[2] = 0;
+}
+
+static void s5p_hdmi_set_acp(struct s5p_hdmi_audio *audio, u8 *header)
+{
+	header[1] = audio->type;
+}
+
+static void s5p_hdmi_set_isrc(u8 *header)
+{
+	/* nothing here yet */
+}
+
+static void s5p_hdmi_set_gmp(u8 *gmp)
+{
+	/* nothing here yet */
+}
+
+static void s5p_hdmi_set_avi(enum s5p_hdmi_v_mode mode,
+			     enum s5p_tvout_o_mode out,
+			     struct s5p_hdmi_video *video, u8 *avi)
+{
+	struct s5p_hdmi_o_params param = s5p_hdmi_output[out];
+	struct s5p_hdmi_v_frame frame;
+
+	frame = s5p_hdmi_v_fmt[mode].frame;
+
+	avi[0] = param.reg.pxl_fmt;
+	avi[0] |= (0x1 << 4);
+
+	avi[1] = video->colorimetry;
+	avi[1] |= video->aspect << 4;
+	avi[1] |= AVI_SAME_WITH_PICTURE_AR;
+
+	avi[3] = (video->aspect == HDMI_PIC_RATIO_16_9) ?
+				frame.vic_16_9 : frame.vic;
+
+	avi[4] = frame.repetition;
+}
+
+static void s5p_hdmi_set_aui(struct s5p_hdmi_audio *audio, u8 *aui)
+{
+	aui[0] = (0 << 4) | audio->channel;
+	aui[1] = ((audio->type == HDMI_60958_AUDIO) ? 0 : audio->freq << 2) | 0;
+	aui[2] = 0;
+}
+
+static void s5p_hdmi_set_spd(u8 *spd)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	memcpy(spd, ctrl->vendor, 8);
+	memcpy(&spd[8], ctrl->product, 16);
+
+	spd[24] = 0x1; /* Digital STB */
+}
+
+static void s5p_hdmi_set_mpg(u8 *mpg)
+{
+	/* nothing here yet */
+}
+
+static int s5p_hdmi_ctrl_audio_enable(bool en)
+{
+	if (!s5p_hdmi_output[s5p_hdmi_ctrl_private.out].reg.dvi)
+		s5p_hdmi_reg_audio_enable(en);
+
+	return 0;
+}
+
+static void s5p_hdmi_ctrl_set_bluescreen(bool en)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	ctrl->blue_screen.enable = en ? true : false;
+
+	s5p_hdmi_reg_bluescreen(en);
+}
+
+static void s5p_hdmi_ctrl_set_audio(bool en)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	s5p_hdmi_ctrl_private.audio.on = en ? 1 : 0;
+
+	if (ctrl->running)
+		s5p_hdmi_ctrl_audio_enable(en);
+}
+
+static void s5p_hdmi_ctrl_set_av_mute(bool en)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	ctrl->av_mute = en ? 1 : 0;
+
+	if (ctrl->running) {
+		if (en) {
+			s5p_hdmi_ctrl_audio_enable(false);
+			s5p_hdmi_ctrl_set_bluescreen(true);
+		} else {
+			s5p_hdmi_ctrl_audio_enable(true);
+			s5p_hdmi_ctrl_set_bluescreen(false);
+		}
+	}
+
+}
+
+u8 s5p_hdmi_ctrl_get_mute(void)
+{
+	return s5p_hdmi_ctrl_private.av_mute ? 1 : 0;
+}
+
+void s5p_hdmi_ctrl_set_hdcp(bool en)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	ctrl->hdcp_en = en ? 1 : 0;
+}
+
+static void s5p_hdmi_ctrl_init_private(void)
+{
+}
+
+static bool s5p_hdmi_ctrl_set_reg(enum s5p_hdmi_v_mode mode,
+				  enum s5p_tvout_o_mode out)
+{
+	struct s5p_hdmi_ctrl_private_data	*ctrl = &s5p_hdmi_ctrl_private;
+	struct s5p_hdmi_packet			*packet = &ctrl->packet;
+
+	struct s5p_hdmi_bluescreen		*bl = &ctrl->blue_screen;
+	struct s5p_hdmi_color_range		*cr = &ctrl->video.color_r;
+	struct s5p_hdmi_tg			*tg = &ctrl->tg;
+
+	s5p_hdmi_reg_bluescreen_clr(bl->cb_b, bl->y_g, bl->cr_r);
+	s5p_hdmi_reg_bluescreen(bl->enable);
+
+	s5p_hdmi_reg_clr_range(cr->y_min, cr->y_max, cr->c_min, cr->c_max);
+
+	s5p_hdmi_reg_acr(packet->acr);
+	s5p_hdmi_reg_asp(packet->h_asp);
+	s5p_hdmi_reg_gcp(s5p_hdmi_v_fmt[mode].frame.i_p, packet->gcp);
+
+	s5p_hdmi_reg_acp(packet->h_acp, packet->acp);
+	s5p_hdmi_reg_isrc(packet->isrc1, packet->isrc2);
+	s5p_hdmi_reg_gmp(packet->gmp);
+
+	s5p_hdmi_reg_infoframe(&packet->avi_info, packet->avi);
+	s5p_hdmi_reg_infoframe(&packet->aui_info, packet->aui);
+	s5p_hdmi_reg_infoframe(&packet->spd_info, packet->spd);
+	s5p_hdmi_reg_infoframe(&packet->mpg_info, packet->mpg);
+
+	s5p_hdmi_reg_packet_trans(&s5p_hdmi_output[out].trans);
+	s5p_hdmi_reg_output(&s5p_hdmi_output[out].reg);
+
+	s5p_hdmi_reg_tg(&s5p_hdmi_v_fmt[mode].frame);
+	s5p_hdmi_reg_v_timing(&s5p_hdmi_v_fmt[mode]);
+	s5p_hdmi_reg_tg_cmd(tg->correction_en, tg->bt656_en, true);
+
+	switch (ctrl->audio.type) {
+	case HDMI_GENERIC_AUDIO:
+		break;
+
+	case HDMI_60958_AUDIO:
+		s5p_hdmi_audio_init(PCM, 44100, 16, 0);
+		break;
+
+	case HDMI_DVD_AUDIO:
+	case HDMI_SUPER_AUDIO:
+		break;
+
+	default:
+		tvout_err("Invalid audio type %d\n", ctrl->audio.type);
+		return -1;
+	}
+
+	s5p_hdmi_reg_audio_enable(true);
+
+	return 0;
+}
+
+static void s5p_hdmi_ctrl_internal_stop(void)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+	struct s5p_hdmi_tg *tg = &ctrl->tg;
+
+#ifdef CONFIG_S5P_HDMI_HPD
+	s5p_hpd_set_eint();
+#endif
+	if (ctrl->hdcp_en)
+		s5p_hdcp_stop();
+
+	s5p_hdmi_reg_enable(false);
+
+	s5p_hdmi_reg_tg_cmd(tg->correction_en, tg->bt656_en, false);
+}
+
+int s5p_hdmi_ctrl_phy_power(bool on)
+{
+	if (on) {
+		clk_enable(s5ptv_status.i2c_phy_clk);
+
+		s5p_hdmi_phy_power(true);
+	} else {
+		/*
+		 * for preventing hdmi hang up when restart
+		 * switch to internal clk - SCLK_DAC, SCLK_PIXEL
+		 */
+		s5p_mixer_ctrl_mux_clk(s5ptv_status.sclk_dac);
+		clk_set_parent(s5ptv_status.sclk_hdmi,
+					s5ptv_status.sclk_pixel);
+
+		s5p_hdmi_phy_power(false);
+
+		clk_disable(s5ptv_status.i2c_phy_clk);
+	}
+
+	return 0;
+}
+
+static void s5p_hdmi_ctrl_clock(bool on)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+	struct s5p_tvout_clk_info *clk = ctrl->clk;
+
+	if (on) {
+		clk_enable(clk[HDMI_MUX].ptr);
+		clk_enable(clk[HDMI_PCLK].ptr);
+	} else {
+		clk_disable(clk[HDMI_PCLK].ptr);
+		clk_disable(clk[HDMI_MUX].ptr);
+	}
+}
+
+void s5p_hdmi_ctrl_stop(void)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+
+	if (ctrl->running) {
+		s5p_hdmi_ctrl_internal_stop();
+		s5p_hdmi_ctrl_clock(0);
+
+		ctrl->running = false;
+	}
+}
+
+int s5p_hdmi_ctrl_start(enum s5p_tvout_disp_mode disp,
+			enum s5p_tvout_o_mode out)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+	struct s5p_hdmi_packet *packet = &ctrl->packet;
+	struct s5p_hdmi_v_frame	frame;
+
+	enum s5p_hdmi_v_mode mode;
+
+	ctrl->out = out;
+	mode = s5p_hdmi_check_v_fmt(disp);
+	ctrl->mode = mode;
+
+	if (ctrl->running)
+		s5p_hdmi_ctrl_internal_stop();
+	else {
+		s5p_hdmi_ctrl_clock(1);
+		ctrl->running = true;
+	}
+
+#ifdef CONFIG_S5P_HDMI_HPD
+	s5p_hpd_set_hdmiint();
+#endif
+
+	frame = s5p_hdmi_v_fmt[mode].frame;
+
+	if (s5p_hdmi_phy_config(frame.pixel_clock, ctrl->video.depth) < 0) {
+		tvout_err("hdmi phy configuration failed.\n");
+		goto err_on_s5p_hdmi_start;
+	}
+
+
+	s5p_hdmi_set_acr(&ctrl->audio, packet->acr);
+	s5p_hdmi_set_asp(packet->h_asp);
+	s5p_hdmi_set_gcp(ctrl->video.depth, packet->gcp);
+
+	s5p_hdmi_set_acp(&ctrl->audio, packet->h_acp);
+	s5p_hdmi_set_isrc(packet->h_isrc);
+	s5p_hdmi_set_gmp(packet->gmp);
+
+	s5p_hdmi_set_avi(mode, out, &ctrl->video, packet->avi);
+	s5p_hdmi_set_spd(packet->spd);
+	s5p_hdmi_set_aui(&ctrl->audio, packet->aui);
+	s5p_hdmi_set_mpg(packet->mpg);
+
+	s5p_hdmi_ctrl_set_reg(mode, out);
+
+	s5p_hdmi_reg_enable(true);
+
+	if (ctrl->hdcp_en)
+		s5p_hdcp_start();
+
+	return 0;
+
+err_on_s5p_hdmi_start:
+	return -1;
+}
+
+int s5p_hdmi_ctrl_constructor(struct platform_device *pdev)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+	struct reg_mem_info *reg_mem = ctrl->reg_mem;
+	struct s5p_tvout_clk_info *clk = ctrl->clk;
+	struct irq_info *irq = &ctrl->irq;
+	int ret, i, k, j;
+
+	for (i = 0; i < HDMI_NO_OF_MEM_RES; i++) {
+		ret = s5p_tvout_map_resource_mem(pdev, reg_mem[i].name,
+						 &(reg_mem[i].base),
+						 &(reg_mem[i].res));
+
+		if (ret)
+			goto err_on_res;
+	}
+
+	for (k = HDMI_PCLK; k < HDMI_NO_OF_CLK; k++) {
+		clk[k].ptr = clk_get(&pdev->dev, clk[k].name);
+
+		if (IS_ERR(clk[k].ptr)) {
+			printk(KERN_ERR	"%s clk is not found\n", clk[k].name);
+			ret = -ENOENT;
+			goto err_on_clk;
+		}
+	}
+
+	irq->no = platform_get_irq_byname(pdev, irq->name);
+
+	if (irq->no < 0) {
+		printk(KERN_ERR "can not get platform irq by name : %s\n", irq->name);
+		ret = irq->no;
+		goto err_on_irq;
+	}
+
+	ret = request_irq(irq->no, irq->handler, IRQF_DISABLED,
+			irq->name, NULL);
+	if (ret) {
+		printk(KERN_ERR "can not request irq : %s\n", irq->name);
+		goto err_on_irq;
+	}
+
+	s5p_hdmi_ctrl_init_private();
+	s5p_hdmi_init(reg_mem[HDMI].base, reg_mem[HDMI_PHY].base);
+
+	/* set initial state of HDMI PHY power to off */
+	s5p_hdmi_ctrl_phy_power(1);
+	s5p_hdmi_ctrl_phy_power(0);
+
+	s5p_hdcp_init();
+
+	return 0;
+
+err_on_irq:
+err_on_clk:
+	for (j = 0; j < k; j++)
+		clk_put(clk[j].ptr);
+
+err_on_res:
+	for (j = 0; j < i; j++)
+		s5p_tvout_unmap_resource_mem(reg_mem[j].base, reg_mem[j].res);
+
+	return ret;
+}
+
+void s5p_hdmi_ctrl_destructor(void)
+{
+	struct s5p_hdmi_ctrl_private_data *ctrl = &s5p_hdmi_ctrl_private;
+	struct reg_mem_info *reg_mem = ctrl->reg_mem;
+	struct s5p_tvout_clk_info *clk = ctrl->clk;
+	struct irq_info *irq = &ctrl->irq;
+
+	int i;
+
+	if (irq->no >= 0)
+		free_irq(irq->no, NULL);
+
+	for (i = 0; i < HDMI_NO_OF_MEM_RES; i++)
+		s5p_tvout_unmap_resource_mem(reg_mem[i].base, reg_mem[i].res);
+
+	for (i = HDMI_PCLK; i < HDMI_NO_OF_CLK; i++)
+		if (clk[i].ptr) {
+			if (ctrl->running)
+				clk_disable(clk[i].ptr);
+			clk_put(clk[i].ptr);
+		}
+}
+
+void s5p_hdmi_ctrl_suspend(void)
+{
+	/* nothing here yet */
+}
+
+void s5p_hdmi_ctrl_resume(void)
+{
+	/* nothing here yet */
+}
+
+/* Functions for tvif ctrl class */
+static void s5p_tvif_ctrl_init_private(void)
+{
+	/* nothing here yet */
+}
+
+/*
+ * TV cut off sequence
+ * VP stop -> Mixer stop -> HDMI stop -> HDMI TG stop
+ * Above sequence should be satisfied.
+ */
+static int s5p_tvif_ctrl_internal_stop(void)
+{
+	s5p_mixer_ctrl_stop();
+
+	switch (s5p_tvif_ctrl_private.curr_if) {
+	case TVOUT_COMPOSITE:
+		s5p_sdo_ctrl_stop();
+		break;
+
+	case TVOUT_DVI:
+	case TVOUT_HDMI:
+	case TVOUT_HDMI_RGB:
+		s5p_hdmi_ctrl_stop();
+		s5p_hdmi_ctrl_phy_power(0);
+		break;
+
+	default:
+		tvout_err("invalid out parameter(%d)\n", s5p_tvif_ctrl_private.curr_if);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void s5p_tvif_ctrl_internal_start(enum s5p_tvout_disp_mode std,
+					 enum s5p_tvout_o_mode inf)
+{
+	s5p_mixer_ctrl_set_int_enable(false);
+
+	/* Clear All Interrupt Pending */
+	s5p_mixer_ctrl_clear_pend_all();
+
+	switch (inf) {
+	case TVOUT_COMPOSITE:
+		if (s5p_mixer_ctrl_start(std, inf) < 0)
+			goto ret_on_err;
+
+		if (0 != s5p_sdo_ctrl_start(std))
+			goto ret_on_err;
+
+		break;
+
+	case TVOUT_HDMI:
+	case TVOUT_HDMI_RGB:
+	case TVOUT_DVI:
+		s5p_hdmi_ctrl_phy_power(1);
+
+		if (s5p_mixer_ctrl_start(std, inf) < 0)
+			goto ret_on_err;
+
+		if (0 != s5p_hdmi_ctrl_start(std, inf))
+			goto ret_on_err;
+		break;
+
+	default:
+		break;
+	}
+
+ret_on_err:
+	s5p_mixer_ctrl_set_int_enable(true);
+
+	/* Clear All Interrupt Pending */
+	s5p_mixer_ctrl_clear_pend_all();
+}
+
+int s5p_tvif_ctrl_set_audio(bool en)
+{
+	switch (s5p_tvif_ctrl_private.curr_if) {
+	case TVOUT_HDMI:
+	case TVOUT_HDMI_RGB:
+	case TVOUT_DVI:
+		s5p_hdmi_ctrl_set_audio(en);
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int s5p_tvif_ctrl_set_av_mute(bool en)
+{
+	switch (s5p_tvif_ctrl_private.curr_if) {
+	case TVOUT_HDMI:
+	case TVOUT_HDMI_RGB:
+	case TVOUT_DVI:
+		s5p_hdmi_ctrl_set_av_mute(en);
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int s5p_tvif_ctrl_get_std_if(enum s5p_tvout_disp_mode *std,
+			     enum s5p_tvout_o_mode *inf)
+{
+	*std = s5p_tvif_ctrl_private.curr_std;
+	*inf = s5p_tvif_ctrl_private.curr_if;
+
+	return 0;
+}
+
+bool s5p_tvif_ctrl_get_run_state()
+{
+	return s5p_tvif_ctrl_private.running;
+}
+
+int s5p_tvif_ctrl_start(enum s5p_tvout_disp_mode std,
+			enum s5p_tvout_o_mode inf)
+{
+	if (s5p_tvif_ctrl_private.running &&
+		(std == s5p_tvif_ctrl_private.curr_std) &&
+		(inf == s5p_tvif_ctrl_private.curr_if))
+		goto cannot_change;
+
+	switch (inf) {
+	case TVOUT_COMPOSITE:
+	case TVOUT_HDMI:
+	case TVOUT_HDMI_RGB:
+	case TVOUT_DVI:
+		break;
+	default:
+		tvout_err("invalid out parameter(%d)\n", inf);
+		goto cannot_change;
+	}
+
+	/* how to control the clock path on stop time ??? */
+	if (s5p_tvif_ctrl_private.running)
+		s5p_tvif_ctrl_internal_stop();
+
+	s5p_tvif_ctrl_internal_start(std, inf);
+
+	s5p_tvif_ctrl_private.running = true;
+	s5p_tvif_ctrl_private.curr_std = std;
+	s5p_tvif_ctrl_private.curr_if = inf;
+
+	return 0;
+
+cannot_change:
+	return -1;
+}
+
+void s5p_tvif_ctrl_stop(void)
+{
+	if (s5p_tvif_ctrl_private.running) {
+		s5p_tvif_ctrl_internal_stop();
+
+		s5p_tvif_ctrl_private.running = false;
+	}
+}
+
+int s5p_tvif_ctrl_constructor(struct platform_device *pdev)
+{
+	if (s5p_sdo_ctrl_constructor(pdev))
+		goto err;
+
+	if (s5p_hdmi_ctrl_constructor(pdev))
+		goto err;
+
+	s5p_tvif_ctrl_init_private();
+
+	return 0;
+
+err:
+	return -1;
+}
+
+void s5p_tvif_ctrl_destructor(void)
+{
+	s5p_sdo_ctrl_destructor();
+	s5p_hdmi_ctrl_destructor();
+}
+
+void s5p_tvif_ctrl_suspend(void)
+{
+	if (s5p_tvif_ctrl_private.running)
+		s5p_tvif_ctrl_internal_stop();
+}
+
+void s5p_tvif_ctrl_resume(void)
+{
+	if (s5p_tvif_ctrl_private.running)
+		s5p_tvif_ctrl_internal_start(s5p_tvif_ctrl_private.curr_std,
+					     s5p_tvif_ctrl_private.curr_if);
+}
-- 
1.7.1

