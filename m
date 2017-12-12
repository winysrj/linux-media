Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.136]:48028 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdLLG3U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 01:29:20 -0500
From: Leo Wen <leo.wen@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        rdunlap@infradead.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        eddie.cai@rock-chips.com, Leo Wen <leo.wen@rock-chips.com>
Subject: [PATCH 1/2] [media] Add Rockchip RK1608 driver
Date: Tue, 12 Dec 2017 14:28:14 +0800
Message-Id: <1513060095-29588-2-git-send-email-leo.wen@rock-chips.com>
In-Reply-To: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
References: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rk1608 is used as a PreISP to link on Soc, which mainly has two functions.
One is to download the firmware of RK1608, and the other is to match the
extra sensor such as camera and enable sensor by calling sensor's s_power.

use below v4l2-ctl command to capture frames.

    v4l2-ctl --verbose -d /dev/video1 --stream-mmap=2
    --stream-to=/tmp/stream.out --stream-count=60 --stream-poll

use below command to playback the video on your PC.

    mplayer ./stream.out -loop 0 -demuxer rawvideo -rawvideo
    w=640:h=480:size=$((640*480*3/2)):format=NV12

Signed-off-by: Leo Wen <leo.wen@rock-chips.com>
---
 MAINTAINERS                |    6 +
 drivers/media/spi/Makefile |    1 +
 drivers/media/spi/rk1608.c | 1165 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/spi/rk1608.h |  366 ++++++++++++++
 4 files changed, 1538 insertions(+)
 create mode 100644 drivers/media/spi/rk1608.c
 create mode 100644 drivers/media/spi/rk1608.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 82ad0ea..48235d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -128,6 +128,12 @@ Maintainers List (try to look for most precise areas first)
 
 		-----------------------------------
 
+ROCKCHIP RK1608 DRIVER
+M:	Leo Wen <leo.wen@rock-chips.com>
+S:	Maintained
+F:	drivers/media/platform/spi/rk1608.c
+F:	drivers/media/platform/spi/rk1608.h
+
 3C59X NETWORK DRIVER
 M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
 L:	netdev@vger.kernel.org
diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
index ea64013..9d9d9ec 100644
--- a/drivers/media/spi/Makefile
+++ b/drivers/media/spi/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_GS1662) += gs1662.o
+obj-$(CONFIG_ROCKCHIP_RK1608) += rk1608.o
diff --git a/drivers/media/spi/rk1608.c b/drivers/media/spi/rk1608.c
new file mode 100644
index 0000000..e646204
--- /dev/null
+++ b/drivers/media/spi/rk1608.c
@@ -0,0 +1,1165 @@
+/**
+ * Rockchip rk1608 driver
+ *
+ * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-image-sizes.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-of.h>
+#include "rk1608.h"
+
+/**
+ * Rk1608 is used as the Pre-ISP to link on Soc, which mainly has two
+ * functions. One is to download the firmware of RK1608, and the other
+ * is to match the extra sensor such as camera and enable sensor by
+ * calling sensor's s_power.
+ *	|-----------------------|
+ *	|     Sensor Camera     |
+ *	|-----------------------|
+ *	|-----------||----------|
+ *	|-----------||----------|
+ *	|-----------\/----------|
+ *	|     Pre-ISP RK1608	|
+ *	|-----------------------|
+ *	|-----------||----------|
+ *	|-----------||----------|
+ *	|-----------\/----------|
+ *	|      Rockchip Soc     |
+ *	|-----------------------|
+ * Data Transfer As shown above. In RK1608, the data received from the
+ * extra sensor,and it is passed to the Soc through ISP.
+ */
+struct rk1608_state {
+	struct v4l2_subdev	sd;
+	struct v4l2_subdev	*sensor_sd;
+	struct device		*dev;
+	struct spi_device	*spi;
+	struct media_pad	pad;
+	struct clk			*mclk;
+	struct mutex		lock;		/* protect resource */
+	struct mutex		sensor_lock;	/* protect sensor */
+	struct mutex		send_msg_lock;	/* protect msg */
+	int power_count;
+	int reset_gpio;
+	int reset_active;
+	int irq_gpio;
+	int irq;
+	int sleepst_gpio;
+	int sleepst_irq;
+	int wakeup_gpio;
+	int wakeup_active;
+	int powerdown_gpio;
+	int powerdown_active;
+	int msg_num;
+	u32 sensor_cnt;
+	u32 sensor_nums;
+	u32 max_speed_hz;
+	u32 min_speed_hz;
+	atomic_t			msg_done[8];
+	wait_queue_head_t	msg_wait;
+	struct v4l2_ctrl	*link_freq;
+	struct v4l2_ctrl_handler ctrl_handler;
+};
+
+static const s64 link_freq_menu_items[] = {
+	1000000000
+};
+
+static inline struct rk1608_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct rk1608_state, sd);
+}
+
+/**
+ * rk1608_operation_query - RK1608 last operation state query
+ *
+ * @spi: device from which data will be read
+ * @state: last operation state [out]
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_operation_query(struct spi_device *spi, s32 *state)
+{
+	s32 query_cmd = RK1608_CMD_QUERY;
+	struct spi_transfer query_cmd_packet = {
+		.tx_buf = &query_cmd,
+		.len    = sizeof(query_cmd),
+	};
+	struct spi_transfer state_packet = {
+		.rx_buf = state,
+		.len    = sizeof(*state),
+	};
+	struct spi_message  m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&query_cmd_packet, &m);
+	spi_message_add_tail(&state_packet, &m);
+	spi_sync(spi, &m);
+
+	return ((*state & RK1608_STATE_ID_MASK) == RK1608_STATE_ID) ? 0 : -1;
+}
+
+int rk1608_write(struct spi_device *spi,
+		 s32 addr, const s32 *data, size_t data_len)
+{
+	s32 write_cmd = RK1608_CMD_WRITE;
+	struct spi_transfer write_cmd_packet = {
+		.tx_buf = &write_cmd,
+		.len    = sizeof(write_cmd),
+	};
+	struct spi_transfer addr_packet = {
+		.tx_buf = &addr,
+		.len    = sizeof(addr),
+	};
+	struct spi_transfer data_packet = {
+		.tx_buf = data,
+		.len    = data_len,
+	};
+	struct spi_message  m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&write_cmd_packet, &m);
+	spi_message_add_tail(&addr_packet, &m);
+	spi_message_add_tail(&data_packet, &m);
+	return spi_sync(spi, &m);
+}
+
+/**
+ * rk1608_safe_write - RK1608 synchronous write with state check
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else operation state code.
+ */
+int rk1608_safe_write(struct spi_device *spi,
+		      s32 addr, const s32 *data, size_t data_len)
+{
+	int ret = 0;
+	s32 state, retry = 0;
+
+	while (data_len > 0) {
+		size_t slen = MIN(data_len, RK1608_MAX_OP_BYTES);
+
+		do {
+			rk1608_write(spi, addr, data, data_len);
+			if (rk1608_operation_query(spi, &state) != 0)
+				return -1;
+			if ((state & RK1608_STATE_MASK) == 0)
+				break;
+
+			udelay(RK1608_OP_TRY_DELAY);
+		} while (retry++ != RK1608_OP_TRY_MAX);
+
+		data_len = data_len - slen;
+		data = (s32 *)((s8 *)data + slen);
+		addr += slen;
+	}
+	return ret;
+}
+
+void rk1608_hw_init(struct spi_device *spi)
+{
+	s32 write_data = SPI0_PLL_SEL_APLL;
+
+	/* modify rk1608 spi slave clk to 300M */
+	rk1608_safe_write(spi, CRUPMU_CLKSEL14_CON, &write_data, 4);
+
+	/* modify rk1608 spi io driver strength to 8mA */
+	write_data = BIT7_6_SEL_8MA;
+	rk1608_safe_write(spi, PMUGRF_GPIO1A_E, &write_data, 4);
+	write_data = BIT1_0_SEL_8MA;
+	rk1608_safe_write(spi, PMUGRF_GPIO1B_E, &write_data, 4);
+}
+
+/**
+ * rk1608_read - RK1608 synchronous read
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer [out]
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_read(struct spi_device *spi,
+		s32 addr, s32 *data, size_t data_len)
+{
+	s32 real_len = MIN(data_len, RK1608_MAX_OP_BYTES);
+	s32 read_cmd = RK1608_CMD_READ | (real_len << 14 &
+					   RK1608_STATE_ID_MASK);
+	s32 read_begin_cmd = RK1608_CMD_READ_BEGIN;
+	s32 dummy = 0;
+	struct spi_transfer read_cmd_packet = {
+		.tx_buf = &read_cmd,
+		.len    = sizeof(read_cmd),
+	};
+	struct spi_transfer addr_packet = {
+		.tx_buf = &addr,
+		.len    = sizeof(addr),
+	};
+	struct spi_transfer read_dummy_packet = {
+		.tx_buf = &dummy,
+		.len    = sizeof(dummy),
+	};
+	struct spi_transfer read_begin_cmd_packet = {
+		.tx_buf = &read_begin_cmd,
+		.len    = sizeof(read_begin_cmd),
+	};
+	struct spi_transfer data_packet = {
+		.rx_buf = data,
+		.len    = data_len,
+	};
+	struct spi_message  m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&read_cmd_packet, &m);
+	spi_message_add_tail(&addr_packet, &m);
+	spi_message_add_tail(&read_dummy_packet, &m);
+	spi_message_add_tail(&read_begin_cmd_packet, &m);
+	spi_message_add_tail(&data_packet, &m);
+	return spi_sync(spi, &m);
+}
+
+/**
+ * rk1608_safe_read - RK1608 synchronous read with state check
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer [out]
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else operation state code.
+ */
+int rk1608_safe_read(struct spi_device *spi,
+		     s32 addr, s32 *data, size_t data_len)
+{
+	s32 state = 0;
+	s32 retry = 0;
+
+	do {
+		rk1608_read(spi, addr, data, data_len);
+		if (rk1608_operation_query(spi, &state) != 0)
+			return -1;
+		if ((state & RK1608_STATE_MASK) == 0)
+			break;
+		udelay(RK1608_OP_TRY_DELAY);
+	} while (retry++ != RK1608_OP_TRY_MAX);
+
+	return (state & RK1608_STATE_MASK);
+}
+
+static int rk1608_read_wait(struct spi_device *spi,
+			    const struct rk1608_section *sec)
+{
+	s32 value = 0;
+	int retry = 0;
+	int ret = 0;
+
+	do {
+		ret = rk1608_safe_read(spi, sec->wait_addr, &value, 4);
+		if (!ret && value == sec->wait_value)
+			break;
+
+		if (retry++ == sec->timeout) {
+			ret = -1;
+			dev_err(&spi->dev, "read 0x%x is %x != %x timeout\n",
+				sec->wait_addr, value, sec->wait_value);
+			break;
+		}
+		mdelay(sec->wait_time);
+	} while (1);
+
+	return ret;
+}
+
+static int rk1608_boot_request(struct spi_device *spi,
+			       const struct rk1608_section *sec)
+{
+	struct rk1608_boot_req boot_req;
+	int retry = 0;
+	int ret = 0;
+
+	/*send boot request to rk1608 for ddr init*/
+	boot_req.flag = sec->flag;
+	boot_req.load_addr = sec->load_addr;
+	boot_req.boot_len = sec->size;
+	boot_req.status = 1;
+	boot_req.cmd = 2;
+
+	ret = rk1608_safe_write(spi, BOOT_REQUEST_ADDR,
+				(s32 *)&boot_req, sizeof(boot_req));
+	if (ret)
+		return ret;
+
+	if (sec->flag & BOOT_FLAG_READ_WAIT) {
+	/*waitting for rk1608 init ddr done*/
+		do {
+			ret = rk1608_safe_read(spi, BOOT_REQUEST_ADDR,
+					       (s32 *)&boot_req,
+					       sizeof(boot_req));
+
+			if (!ret && boot_req.status == 0)
+				break;
+
+			if (retry++ == sec->timeout) {
+				ret = -1;
+				dev_err(&spi->dev, "boot_request timeout\n");
+				break;
+			}
+			mdelay(sec->wait_time);
+		} while (1);
+	}
+
+	return ret;
+}
+
+static int rk1608_download_section(struct spi_device *spi, const u8 *data,
+				   const struct rk1608_section *sec)
+{
+	int ret = 0;
+
+	dev_info(&spi->dev, "offset:%x,size:%x,addr:%x,wait_time:%x",
+		 sec->offset, sec->size, sec->load_addr, sec->wait_time);
+	dev_info(&spi->dev, "timeout:%x,crc:%x,flag:%x,type:%x",
+		 sec->timeout, sec->crc_16, sec->flag, sec->type);
+
+	if (sec->size > 0) {
+		ret = rk1608_safe_write(spi, sec->load_addr,
+					(s32 *)(data + sec->offset),
+					sec->size);
+		if (ret) {
+			dev_err(&spi->dev, "rk1608_safe_write err =%d\n", ret);
+			return ret;
+		}
+	}
+
+	if (sec->flag & BOOT_FLAG_BOOT_REQUEST)
+		ret = rk1608_boot_request(spi, sec);
+	else if (sec->flag & BOOT_FLAG_READ_WAIT)
+		ret = rk1608_read_wait(spi, sec);
+
+	return ret;
+}
+
+/**
+ * rk1608_download_fw: - rk1608 firmware download through spi
+ *
+ * @spi: spi device
+ * @fw_name: name of firmware file, NULL for default firmware name
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ **/
+int rk1608_download_fw(struct spi_device *spi, const char *fw_name)
+{
+	const struct rk1608_header *head;
+	const struct firmware *fw;
+	int i = 0;
+	int ret = 0;
+
+	if (!fw_name)
+		fw_name = RK1608_FW_NAME;
+
+	dev_info(&spi->dev, "before request firmware");
+	ret = request_firmware(&fw, fw_name, &spi->dev);
+	if (ret) {
+		dev_err(&spi->dev, "request firmware %s failed!", fw_name);
+		return ret;
+	}
+
+	head = (const struct rk1608_header *)fw->data;
+
+	dev_info(&spi->dev, "request firmware %s (version:%s) success!",
+		 fw_name, head->version);
+
+	for (i = 0; i < head->section_count; i++) {
+		ret = rk1608_download_section(spi, fw->data,
+					      &head->sections[i]);
+		if (ret)
+			break;
+	}
+
+	release_firmware(fw);
+	return ret;
+}
+
+int rk1608_lsb_w32(struct spi_device *spi, s32 addr, s32 data)
+{
+	s32 write_cmd = RK1608_CMD_WRITE;
+	struct spi_transfer write_cmd_packet = {
+		.tx_buf = &write_cmd,
+		.len    = sizeof(write_cmd),
+	};
+	struct spi_transfer addr_packet = {
+		.tx_buf = &addr,
+		.len    = sizeof(addr),
+	};
+	struct spi_transfer data_packet = {
+		.tx_buf = &data,
+		.len    = sizeof(data),
+	};
+	struct spi_message  m;
+
+	write_cmd = MSB2LSB32(write_cmd);
+	addr = MSB2LSB32(addr);
+	data = MSB2LSB32(data);
+	spi_message_init(&m);
+	spi_message_add_tail(&write_cmd_packet, &m);
+	spi_message_add_tail(&addr_packet, &m);
+	spi_message_add_tail(&data_packet, &m);
+	return spi_sync(spi, &m);
+}
+
+void rk1608_cs_set_value(struct rk1608_state *pdata, int value)
+{
+	s8 null_cmd = 0;
+	struct spi_transfer null_cmd_packet = {
+		.tx_buf = &null_cmd,
+		.len    = sizeof(null_cmd),
+		.cs_change = !value,
+	};
+	struct spi_message  m;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&null_cmd_packet, &m);
+	spi_sync(pdata->spi, &m);
+}
+
+void rk1608_set_spi_speed(struct rk1608_state *pdata, u32 hz)
+{
+	pdata->spi->max_speed_hz = hz;
+}
+
+static int rk1608_sensor_power(struct v4l2_subdev *sd, int on)
+{
+	int ret = 0;
+	struct rk1608_state *pdata = to_state(sd);
+	struct spi_device *spi = pdata->spi;
+
+	mutex_lock(&pdata->lock);
+	/*start Sensor power on/off*/
+	if (pdata->sensor_sd)
+		pdata->sensor_sd->ops->core->s_power(pdata->sensor_sd, on);
+	if (on && !pdata->power_count)	{
+		clk_prepare_enable(pdata->mclk);
+		clk_set_rate(pdata->mclk, RK1608_MCLK_RATE);
+		/*request rk1608 enter slave mode*/
+		rk1608_cs_set_value(pdata, 0);
+		if (pdata->powerdown_gpio > 0) {
+			gpio_set_value(pdata->powerdown_gpio,
+				       pdata->powerdown_active);
+		}
+		if (pdata->wakeup_gpio > 0) {
+			gpio_set_value(pdata->wakeup_gpio,
+				       pdata->wakeup_active);
+		}
+		mdelay(3);
+		if (pdata->reset_gpio > 0)
+			gpio_set_value(pdata->reset_gpio, pdata->reset_active);
+		mdelay(5);
+		rk1608_cs_set_value(pdata, 1);
+		rk1608_set_spi_speed(pdata, pdata->min_speed_hz);
+		rk1608_lsb_w32(spi, SPI_ENR, 0);
+		rk1608_lsb_w32(spi, SPI_CTRL0,
+			       OPM_SLAVE_MODE | RSD_SEL_2CYC | DFS_SEL_16BIT);
+		rk1608_hw_init(pdata->spi);
+		rk1608_set_spi_speed(pdata, pdata->max_speed_hz);
+		/*download system firmware*/
+		ret = rk1608_download_fw(pdata->spi, NULL);
+		if (ret)
+			dev_err(pdata->dev, "Download firmware failed!");
+		else
+			dev_info(pdata->dev, "Download firmware success!");
+		enable_irq(pdata->irq);
+		if (pdata->sleepst_irq > 0)
+			enable_irq(pdata->sleepst_irq);
+
+	} else if (!on && pdata->power_count == 1) {
+		disable_irq(pdata->irq);
+		if (pdata->sleepst_irq > 0)
+			disable_irq(pdata->sleepst_irq);
+		if (pdata->powerdown_gpio > 0)
+			gpio_set_value(pdata->powerdown_gpio,
+				       !pdata->powerdown_active);
+
+		if (pdata->wakeup_gpio > 0)
+			gpio_set_value(pdata->wakeup_gpio,
+				       !pdata->wakeup_active);
+
+		if (pdata->reset_gpio > 0)
+			gpio_set_value(pdata->reset_gpio, !pdata->reset_active);
+
+		rk1608_cs_set_value(pdata, 0);
+		clk_disable_unprepare(pdata->mclk);
+	}
+	/* Update the power count. */
+	pdata->power_count += on ? 1 : -1;
+	WARN_ON(pdata->power_count < 0);
+	mutex_unlock(&pdata->lock);
+
+	return ret;
+}
+
+static int rk1608_stream_on(struct rk1608_state *pdata)
+{
+	int  cnt = 0;
+
+	/*Waiting for the sensor to be ready*/
+	while (pdata->sensor_cnt < pdata->sensor_nums) {
+		/* TIMEOUT 10s break*/
+		if (cnt++ > SENSOR_TIMEOUT) {
+			dev_err(pdata->dev, "Sensor%d is ready to timeout!",
+				pdata->sensor_cnt);
+			break;
+		}
+	mdelay(10);
+	}
+
+	if (pdata->sensor_nums) {
+		if (pdata->sensor_cnt == pdata->sensor_nums)
+			dev_info(pdata->dev, "Sensor(num %d) is ready!",
+				 pdata->sensor_cnt);
+	} else {
+		dev_warn(pdata->dev, "No sensor is found!");
+	}
+
+	return 0;
+}
+
+static int rk1608_stream_off(struct rk1608_state *pdata)
+{
+	mutex_lock(&pdata->sensor_lock);
+	pdata->sensor_cnt = 0;
+	mutex_unlock(&pdata->sensor_lock);
+	return 0;
+}
+
+static int rk1608_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct rk1608_state *pdata = to_state(sd);
+
+	if (enable)
+		return rk1608_stream_on(pdata);
+	else
+		return rk1608_stream_off(pdata);
+}
+
+static int rk1608_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index > 0)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_SGRBG8_1X8;
+
+	return 0;
+}
+
+static int rk1608_get_fmt(struct v4l2_subdev *sd,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+
+	mf->code = MEDIA_BUS_FMT_SGRBG8_1X8;
+	mf->width = RK1608_WINDOW_WIDTH_DEF;
+	mf->height = RK1608_WINDOW_HEIGHT_DEF;
+	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops rk1608_subdev_internal_ops = {
+	.open	= NULL,
+};
+
+static const struct v4l2_subdev_video_ops rk1608_subdev_video_ops = {
+	.s_stream	= rk1608_s_stream,
+};
+
+static const struct v4l2_subdev_pad_ops rk1608_subdev_pad_ops = {
+	.enum_mbus_code	= rk1608_enum_mbus_code,
+	.get_fmt	= rk1608_get_fmt,
+};
+
+static const struct v4l2_subdev_core_ops rk1608_core_ops = {
+	.s_power	= rk1608_sensor_power,
+};
+
+static const struct v4l2_subdev_ops rk1608_subdev_ops = {
+	.core	= &rk1608_core_ops,
+	.video	= &rk1608_subdev_video_ops,
+	.pad	= &rk1608_subdev_pad_ops,
+};
+
+/**
+ * rk1608_msq_read_head - read rk1608 msg queue head
+ *
+ * @spi: spi device
+ * @addr: msg queue head addr
+ * @m: msg queue pointer
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_msq_read_head(struct spi_device *spi,
+			 u32 addr, struct rk1608_msg_queue *q)
+{
+	int err = 0;
+	s32 reg;
+
+	err = rk1608_safe_read(spi, RK1608_PMU_SYS_REG0, &reg, 4);
+
+	if (err || ((reg & RK1608_MSG_QUEUE_OK_MASK) !=
+			 RK1608_MSG_QUEUE_OK_TAG))
+		return -1;
+
+	err = rk1608_safe_read(spi, addr, (s32 *)q, sizeof(*q));
+
+	return err;
+}
+
+/**
+ * rk1608_msq_recv_msg - receive a msg from RK1608 -> AP msg queue
+ *
+ * @q: msg queue
+ * @m: a msg pointer buf [out]
+ *
+ * need call rk1608_msq_recv_msg_free to free msg after msg use done
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_msq_recv_msg(struct spi_device *spi, struct msg **m)
+{
+	struct rk1608_msg_queue queue;
+	struct rk1608_msg_queue *q = &queue;
+	u32 size = 0, msg_size = 0;
+	u32 recv_addr = 0;
+	u32 next_recv_addr = 0;
+	int err = 0;
+
+	*m = NULL;
+	err = rk1608_msq_read_head(spi, RK1608_S_MSG_QUEUE_ADDR, q);
+	if (err)
+		return err;
+
+	if (q->cur_send == q->cur_recv)
+		return -1;
+	/*skip to head when size is 0*/
+	err = rk1608_safe_read(spi, (s32)q->cur_recv, (s32 *)&size, 4);
+	if (err)
+		return err;
+	if (size == 0) {
+		err = rk1608_safe_read(spi, (s32)q->buf_head, (s32 *)&size, 4);
+		if (err)
+			return err;
+
+		msg_size = size * sizeof(u32);
+		recv_addr = q->buf_head;
+		next_recv_addr = q->buf_head + msg_size;
+	} else {
+		msg_size = size * sizeof(u32);
+		recv_addr = q->cur_recv;
+		next_recv_addr = q->cur_recv + msg_size;
+		if (next_recv_addr == q->buf_tail)
+			next_recv_addr = q->buf_head;
+	}
+
+	if (msg_size > (q->buf_tail - q->buf_head))
+		return -2;
+
+	*m = kmalloc(msg_size, GFP_KERNEL);
+	err = rk1608_safe_read(spi, recv_addr, (s32 *)*m, msg_size);
+	if (err == 0) {
+		err = rk1608_safe_write(spi, RK1608_S_MSG_QUEUE_ADDR +
+				       (u8 *)&q->cur_recv - (u8 *)q,
+				       &next_recv_addr, 4);
+	}
+	if (err)
+		kfree(*m);
+
+	return err;
+}
+
+static void print_rk1608_log(struct rk1608_state *pdata,
+			     struct msg_rk1608_log_t *log)
+{
+	char *str = (char *)(log);
+
+	str[log->size * sizeof(s32) - 1] = 0;
+	str += sizeof(struct msg_rk1608_log_t);
+	dev_info(pdata->dev, "RK1608%d: %s", log->core_id, str);
+}
+
+void int32_hexdump(const char *prefix, int32_t *data, int len)
+{
+	pr_err("%s\n", prefix);
+	print_hex_dump(KERN_ERR, "offset ", DUMP_PREFIX_OFFSET,
+		       16, 4, data, len, false);
+	pr_err("\n");
+}
+
+static void dispatch_received_msg(struct rk1608_state *pdata,
+				  struct msg *msg)
+{
+	#if DEBUG_DUMP_ALL_SEND_RECV_MSG == 1
+	int32_hexdump("recv msg:", (s32 *)msg, msg->size * 4);
+	#endif
+
+	if (msg->type == id_msg_set_stream_out_on_ret_t) {
+		mutex_lock(&pdata->sensor_lock);
+		pdata->sensor_cnt++;
+		mutex_unlock(&pdata->sensor_lock);
+	}
+
+	if (msg->type == id_msg_rk1608_log_t)
+		print_rk1608_log(pdata, (struct msg_rk1608_log_t *)msg);
+}
+
+static irqreturn_t rk1608_threaded_isr(int irq, void *dev_id)
+{
+	struct rk1608_state *pdata = dev_id;
+	struct msg *msg;
+
+	WARN_ON(irq != pdata->irq);
+	while (!rk1608_msq_recv_msg(pdata->spi, &msg) && NULL != msg) {
+		dispatch_received_msg(pdata, msg);
+		/* for kernel msg sync */
+		if (pdata->msg_num != 0 && msg->sync) {
+			dev_info(pdata->dev, "rk1608 kernel sync\n");
+			mutex_lock(&pdata->send_msg_lock);
+			pdata->msg_num--;
+			atomic_set(&pdata->msg_done[pdata->msg_num], 1);
+			mutex_unlock(&pdata->send_msg_lock);
+			wake_up(&pdata->msg_wait);
+		}
+		kfree(msg);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rk1608_sleep_isr(int irq, void *dev_id)
+{
+	struct rk1608_state *pdata = dev_id;
+
+	WARN_ON(irq != pdata->sleepst_irq);
+	if (pdata->powerdown_gpio > 0)
+		gpio_set_value(pdata->powerdown_gpio, !pdata->powerdown_active);
+
+	return IRQ_HANDLED;
+}
+
+static int rk1608_parse_dt_property(struct rk1608_state *pdata)
+{
+	int ret = 0;
+	int i;
+	struct device *dev = pdata->dev;
+	struct device_node *node = dev->of_node;
+	enum of_gpio_flags flags;
+
+	if (!node)
+		return 1;
+
+	ret = of_property_read_u32(node, "spi-max-frequency",
+				   &pdata->max_speed_hz);
+	if (ret <= 0) {
+		dev_warn(dev, "can not get spi-max-frequency!");
+		pdata->max_speed_hz = RK1608_MCLK_RATE;
+	}
+
+	ret = of_property_read_u32(node, "spi-min-frequency",
+				   &pdata->min_speed_hz);
+	if (ret <= 0) {
+		dev_warn(dev, "can not get spi-min-frequency!");
+		pdata->min_speed_hz = pdata->max_speed_hz / 2;
+	}
+
+	pdata->mclk = devm_clk_get(dev, "mclk");
+	if (IS_ERR(pdata->mclk)) {
+		dev_err(dev, "can not get mclk, error %ld\n",
+			PTR_ERR(pdata->mclk));
+		pdata->mclk = NULL;
+		return -1;
+	}
+
+	ret = of_get_named_gpio_flags(node, "reset-gpio", 0, &flags);
+	if (ret <= 0) {
+		dev_warn(dev, "can not find reset-gpio, error %d\n", ret);
+		return ret;
+	}
+	pdata->reset_gpio = ret;
+	pdata->reset_active = 1;
+	if (flags == OF_GPIO_ACTIVE_LOW)
+		pdata->reset_active = 0;
+
+	if (pdata->reset_gpio > 0) {
+		ret = devm_gpio_request(dev, pdata->reset_gpio, "rk1608-reset");
+		if (ret) {
+			dev_err(dev, "gpio %d request error %d\n",
+				pdata->reset_gpio, ret);
+			return ret;
+		}
+
+		ret = gpio_direction_output(pdata->reset_gpio,
+					    !pdata->reset_active);
+		if (ret) {
+			dev_err(dev, "gpio %d direction output error %d\n",
+				pdata->reset_gpio, ret);
+			return ret;
+		}
+	}
+
+	ret = of_get_named_gpio_flags(node, "irq-gpio", 0, NULL);
+	if (ret <= 0) {
+		dev_warn(dev, "can not find irq-gpio, error %d\n", ret);
+		return ret;
+	}
+
+	pdata->irq_gpio = ret;
+
+	ret = devm_gpio_request(dev, pdata->irq_gpio, "rk1608-irq");
+	if (ret) {
+		dev_err(dev, "gpio %d request error %d\n", pdata->irq_gpio,
+			ret);
+		return ret;
+	}
+
+	ret = gpio_direction_input(pdata->irq_gpio);
+	if (ret) {
+		dev_err(dev, "gpio %d direction input error %d\n",
+			pdata->irq_gpio, ret);
+		return ret;
+	}
+
+	ret = gpio_to_irq(pdata->irq_gpio);
+	if (ret < 0) {
+		dev_err(dev, "Unable to get irq number for GPIO %d, error %d\n",
+			pdata->irq_gpio, ret);
+		return ret;
+	}
+	pdata->irq = ret;
+	ret = request_threaded_irq(pdata->irq, NULL, rk1608_threaded_isr,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				   "rk1608-irq", pdata);
+	if (ret) {
+		dev_err(dev, "cannot request thread irq: %d\n", ret);
+		return ret;
+	}
+
+	disable_irq(pdata->irq);
+
+	ret = of_get_named_gpio_flags(node, "powerdown-gpio", 0, &flags);
+	if (ret <= 0)
+		dev_warn(dev, "can not find  powerdown-gpio, error %d\n", ret);
+
+	pdata->powerdown_gpio = ret;
+	pdata->powerdown_active = 1;
+	if (flags == OF_GPIO_ACTIVE_LOW)
+		pdata->powerdown_active = 0;
+
+	if (pdata->powerdown_gpio > 0) {
+		ret = devm_gpio_request(dev, pdata->powerdown_gpio,
+					"rk1608-powerdown");
+		if (ret) {
+			dev_err(dev, "gpio %d request error %d\n",
+				pdata->powerdown_gpio, ret);
+			return ret;
+		}
+
+		ret = gpio_direction_output(pdata->powerdown_gpio,
+					    !pdata->powerdown_active);
+		if (ret) {
+			dev_err(dev, "gpio %d direction output error %d\n",
+				pdata->powerdown_gpio, ret);
+			return ret;
+		}
+	}
+
+	pdata->sleepst_gpio = -1;
+	pdata->sleepst_irq = -1;
+	pdata->wakeup_gpio = -1;
+
+	ret = of_get_named_gpio_flags(node, "sleepst-gpio", 0, NULL);
+	if (ret <= 0) {
+		dev_warn(dev, "can not find property sleepst-gpio, error %d\n",
+			 ret);
+		return ret;
+	}
+
+	pdata->sleepst_gpio = ret;
+
+	ret = devm_gpio_request(dev, pdata->sleepst_gpio, "rk1608-sleep-irq");
+	if (ret) {
+		dev_err(dev, "gpio %d request error %d\n",
+			pdata->sleepst_gpio, ret);
+		return ret;
+	}
+
+	ret = gpio_direction_input(pdata->sleepst_gpio);
+	if (ret) {
+		dev_err(dev, "gpio %d direction input error %d\n",
+			pdata->sleepst_gpio, ret);
+		return ret;
+	}
+
+	ret = gpio_to_irq(pdata->sleepst_gpio);
+	if (ret < 0) {
+		dev_err(dev, "Unable to get irq number for GPIO %d, error %d\n",
+			pdata->sleepst_gpio, ret);
+		return ret;
+	}
+	pdata->sleepst_irq = ret;
+	ret = request_any_context_irq(pdata->sleepst_irq,
+				      rk1608_sleep_isr,
+				      IRQF_TRIGGER_RISING,
+				      "rk1608-sleepst", pdata);
+	disable_irq(pdata->sleepst_irq);
+
+	ret = of_get_named_gpio_flags(node, "wakeup-gpio", 0, &flags);
+	if (ret <= 0)
+		dev_warn(dev, "can not find wakeup-gpio error %d\n", ret);
+
+	pdata->wakeup_gpio = ret;
+	pdata->wakeup_active = 1;
+	if (flags == OF_GPIO_ACTIVE_LOW)
+		pdata->wakeup_active = 0;
+
+	if (pdata->wakeup_gpio > 0) {
+		ret = devm_gpio_request(dev, pdata->wakeup_gpio,
+					"rk1608-wakeup");
+		if (ret) {
+			dev_err(dev, "gpio %d request error %d\n",
+				pdata->wakeup_gpio, ret);
+			return ret;
+		}
+
+		ret = gpio_direction_output(pdata->wakeup_gpio,
+					    !pdata->wakeup_active);
+		if (ret) {
+			dev_err(dev, "gpio %d direction output error %d\n",
+				pdata->wakeup_gpio, ret);
+			return ret;
+		}
+	}
+	pdata->msg_num = 0;
+	init_waitqueue_head(&pdata->msg_wait);
+	for (i = 0; i < 8; i++)
+		atomic_set(&pdata->msg_done[i], 0);
+
+	return ret;
+}
+
+static int get_remote_node_dev(struct rk1608_state *pdev)
+{
+	struct platform_device *sensor_pdev = NULL;
+	struct device *dev = pdev->dev;
+	struct device_node *parent = dev->of_node;
+	struct device_node *node, *pre_node = NULL;
+	struct device_node  *remote = NULL;
+	int ret, sensor_nums = 0;
+
+	node = of_graph_get_next_endpoint(parent, pre_node);
+	if (node) {
+		of_node_put(pre_node);
+		pre_node = node;
+	} else {
+		dev_err(dev, "fieled to get endpoint\n");
+		return -EINVAL;
+	}
+	while ((node = of_graph_get_next_endpoint(parent, pre_node)) != NULL) {
+		of_node_put(pre_node);
+		pre_node = node;
+		remote = of_graph_get_remote_port_parent(node);
+		if (!remote) {
+			dev_err(dev, "%s: no valid device\n", __func__);
+			of_node_put(remote);
+			ret = -EINVAL;
+		}
+
+		sensor_pdev = of_find_device_by_node(remote);
+		of_node_put(remote);
+
+		if (!sensor_pdev) {
+			dev_err(dev, "fieled to get Sensor device\n");
+			ret = -EINVAL;
+		} else {
+			pdev->sensor_sd = platform_get_drvdata(sensor_pdev);
+			if (pdev->sensor_sd)
+				sensor_nums++;
+			else
+				dev_err(dev, "fieled to get Sensor drvdata\n");
+			ret = 0;
+		}
+	}
+	pdev->sensor_nums = sensor_nums;
+	if (pdev->sensor_nums)
+		dev_info(dev, "get Sensor (nums=%d) dev is OK!\n",
+			 pdev->sensor_nums);
+
+	return ret;
+}
+
+static int rk1608_probe(struct spi_device *spi)
+{
+	struct rk1608_state		*rk1608;
+	struct v4l2_subdev		*sd;
+	struct v4l2_ctrl_handler	*handler;
+	int ret;
+
+	rk1608 = devm_kzalloc(&spi->dev, sizeof(*rk1608), GFP_KERNEL);
+	if (!rk1608)
+		return -ENOMEM;
+	rk1608->dev = &spi->dev;
+	rk1608->spi = spi;
+	spi_set_drvdata(spi, rk1608);
+	ret = rk1608_parse_dt_property(rk1608);
+	if (ret) {
+		dev_err(rk1608->dev, "rk1608 parse dt property err(%x)\n", ret);
+		goto parse_err;
+	}
+	ret = get_remote_node_dev(rk1608);
+	if (ret)
+		dev_warn(rk1608->dev, "get remote node dev err(%x)\n", ret);
+	rk1608->sensor_cnt = 0;
+	mutex_init(&rk1608->sensor_lock);
+	mutex_init(&rk1608->send_msg_lock);
+	mutex_init(&rk1608->lock);
+	sd = &rk1608->sd;
+	v4l2_spi_subdev_init(sd, spi, &rk1608_subdev_ops);
+
+	handler = &rk1608->ctrl_handler;
+	ret = v4l2_ctrl_handler_init(handler, 1);
+	if (ret)
+		goto handler_init_err;
+
+	rk1608->link_freq = v4l2_ctrl_new_int_menu(handler, NULL,
+						   V4L2_CID_LINK_FREQ,
+						   0, 0, link_freq_menu_items);
+	if (rk1608->link_freq)
+		rk1608->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	if (handler->error)
+		goto handler_err;
+
+	sd->ctrl_handler = handler;
+	sd->internal_ops = &rk1608_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	rk1608->pad.flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+
+	ret = media_entity_init(&sd->entity, 1, &rk1608->pad, 0);
+	if (ret < 0)
+		goto handler_err;
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto register_err;
+	dev_info(rk1608->dev, "DSP rk1608 Driver probe is OK!\n");
+
+	return 0;
+register_err:
+	media_entity_cleanup(&sd->entity);
+handler_err:
+	v4l2_ctrl_handler_free(handler);
+handler_init_err:
+	v4l2_device_unregister_subdev(&rk1608->sd);
+	mutex_destroy(&rk1608->lock);
+	mutex_destroy(&rk1608->send_msg_lock);
+	mutex_destroy(&rk1608->sensor_lock);
+parse_err:
+	kfree(rk1608);
+	return ret;
+}
+
+static int rk1608_remove(struct spi_device *spi)
+{
+	struct rk1608_state *rk1608 = spi_get_drvdata(spi);
+
+	v4l2_async_unregister_subdev(&rk1608->sd);
+	media_entity_cleanup(&rk1608->sd.entity);
+	v4l2_ctrl_handler_free(&rk1608->ctrl_handler);
+	v4l2_device_unregister_subdev(&rk1608->sd);
+	mutex_destroy(&rk1608->lock);
+	mutex_destroy(&rk1608->send_msg_lock);
+	mutex_destroy(&rk1608->sensor_lock);
+	kfree(rk1608);
+
+	return 0;
+}
+
+static const struct spi_device_id rk1608_id[] = {
+	{ "RK1608", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, rk1608_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id rk1608_of_match[] = {
+	{ .compatible = "rockchip,rk1608" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, rk1608_of_match);
+#endif
+
+static struct spi_driver rk1608_driver = {
+	.driver = {
+		.of_match_table = of_match_ptr(rk1608_of_match),
+		.name	= "RK1608",
+	},
+	.probe		= rk1608_probe,
+	.remove		= rk1608_remove,
+	.id_table	= rk1608_id,
+};
+
+module_spi_driver(rk1608_driver);
+
+MODULE_AUTHOR("Rockchip Camera/ISP team");
+MODULE_DESCRIPTION("A DSP driver for rk1608 chip");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/media/spi/rk1608.h b/drivers/media/spi/rk1608.h
new file mode 100644
index 0000000..bf0c5ec
--- /dev/null
+++ b/drivers/media/spi/rk1608.h
@@ -0,0 +1,366 @@
+/**
+ * Rockchip rk1608 driver
+ *
+ * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef __RK1608_H__
+#define __RK1608_H__
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/spi/spi.h>
+#include "linux/i2c.h"
+
+#define RK1608_OP_TRY_MAX			3
+#define RK1608_OP_TRY_DELAY			10
+#define RK1608_CMD_WRITE			0x00000011
+#define RK1608_CMD_WRITE_REG0		0X00010011
+#define RK1608_CMD_WRITE_REG1		0X00020011
+#define RK1608_CMD_READ				0x00000077
+#define RK1608_CMD_READ_BEGIN		0x000000aa
+#define RK1608_CMD_QUERY			0x000000ff
+#define RK1608_CMD_QUERY_REG2		0x000001ff
+#define RK1608_STATE_ID_MASK		(0xffff0000)
+#define RK1608_STATE_ID				(0X16080000)
+#define RK1608_STATE_MASK			(0x0000ffff)
+
+#define BOOT_REQUEST_ADDR			0x18000010
+#define RK1608_HEAD_ADDR			0x60000000
+#define RK1608_FW_NAME				"rk1608.rkl"
+#define RK1608_S_MSG_QUEUE_ADDR		0x60050010
+#define RK1608_PMU_SYS_REG0			0x120000f0
+#define RK1608_MSG_QUEUE_OK_MASK	0xffff0001
+#define RK1608_MSG_QUEUE_OK_TAG		0x16080001
+#define RK1608_MAX_OP_BYTES			60000
+
+#define RK1608_WINDOW_HEIGHT_DEF	480
+#define RK1608_WINDOW_WIDTH_DEF		640
+
+#define BOOT_FLAG_CRC				(0x01 << 0)
+#define BOOT_FLAG_EXE				(0x01 << 1)
+#define BOOT_FLAG_LOAD_PMEM			(0x01 << 2)
+#define BOOT_FLAG_ACK				(0x01 << 3)
+#define BOOT_FLAG_READ_WAIT			(0x01 << 4)
+#define BOOT_FLAG_BOOT_REQUEST		(0x01 << 5)
+
+#define DEBUG_DUMP_ALL_SEND_RECV_MSG	0
+#define RK1608_MCLK_RATE			(24 * 1000 * 1000ul)
+#define SENSOR_TIMEOUT				1000
+#define GRF_BASE_ADDR				0xff770000
+#define GRF_GPIO2B_IOMUX			0x0014
+#define GRF_IO_VSEL					0x0380
+#define	OPM_SLAVE_MODE				0X100000
+#define	RSD_SEL_2CYC				0X008000
+#define	DFS_SEL_16BIT				0X000002
+#define SPI_CTRL0					0x11060000
+#define SPI_ENR						0x11060008
+#define CRUPMU_CLKSEL14_CON			0x12008098
+#define PMUGRF_GPIO1A_E				0x12030040
+#define PMUGRF_GPIO1B_E				0x12030044
+#define BIT7_6_SEL_8MA				0xf000a000
+#define BIT1_0_SEL_8MA				0x000f000a
+#define SPI0_PLL_SEL_APLL			0xff004000
+#define INVALID_ID					-1
+#define RK1608_MAX_SEC_NUM			10
+
+#ifndef MIN
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
+
+#ifndef MSB2LSB32
+#define MSB2LSB32(x)	((((u32)x & 0x80808080) >> 7) | \
+			(((u32)x & 0x40404040) >> 5) | \
+			(((u32)x & 0x20202020) >> 3) | \
+			(((u32)x & 0x10101010) >> 1) | \
+			(((u32)x & 0x08080808) << 1) | \
+			(((u32)x & 0x04040404) << 3) | \
+			(((u32)x & 0x02020202) << 5) | \
+			(((u32)x & 0x01010101) << 7))
+#endif
+
+struct rk1608_section {
+	union {
+		u32	offset;
+		u32	wait_value;
+	};
+	u32 size;
+	union {
+		u32	load_addr;
+		u32	wait_addr;
+	};
+	u16	wait_time;
+	u16	timeout;
+	u16	crc_16;
+	u8	flag;
+	u8	type;
+};
+
+struct rk1608_header {
+	char version[32];
+	u32 header_size;
+	u32 section_count;
+	struct rk1608_section sections[RK1608_MAX_SEC_NUM];
+};
+
+struct rk1608_boot_req {
+	u32 flag;
+	u32 load_addr;
+	u32 boot_len;
+	u8 status;
+	u8 dummy[2];
+	u8 cmd;
+};
+
+struct rk1608_msg_queue {
+	u32 buf_head; /* msg buffer head */
+	u32 buf_tail; /* msg buffer tail */
+	u32 cur_send; /* current msg send postition */
+	u32 cur_recv; /* current msg receive position */
+};
+
+struct msg {
+	u32 size; /* unit 4 bytes */
+	u16 type; /* msg identification */
+	s8  camera_id;
+	s8  sync;
+};
+
+enum {
+	/** AP -> RK1608
+	 *   1 msg of sensor
+	 */
+	id_msg_init_sensor_t =			0x0001,
+	id_msg_set_input_size_t,
+	id_msg_set_output_size_t,
+	id_msg_set_stream_in_on_t,
+	id_msg_set_stream_in_off_t,
+	id_msg_set_stream_out_on_t,
+	id_msg_set_stream_out_off_t,
+
+	/** AP -> RK1608
+	 *   2 msg of take picture
+	 */
+	id_msg_take_picture_t =			0x0021,
+	id_msg_take_picture_done_t,
+
+	/** AP -> RK1608
+	 *   3 msg of realtime parameter
+	 */
+	id_msg_rt_args_t =				0x0031,
+
+	/** AP -> RK1608
+	 *   4 msg of power manager
+	 */
+	id_msg_set_sys_mode_bypass_t =	0x0200,
+	id_msg_set_sys_mode_standby_t,
+	id_msg_set_sys_mode_idle_enable_t,
+	id_msg_set_sys_mode_idle_disable_t,
+	id_msg_set_sys_mode_slave_rk1608_on_t,
+	id_msg_set_sys_mode_slave_rk1608_off_t,
+
+	/** AP -> RK1608
+	 *   5 msg of debug config
+	 */
+	id_msg_set_log_level_t =		0x0250,
+
+	/** RK1608 -> AP
+	 *   6 response of sensor msg
+	 */
+	id_msg_init_sensor_ret_t =		0x0301,
+	id_msg_set_input_size_ret_t,
+	id_msg_set_output_size_ret_t,
+	id_msg_set_stream_in_on_ret_t,
+	id_msg_set_stream_in_off_ret_t,
+	id_msg_set_stream_out_on_ret_t,
+	id_msg_set_stream_out_off_ret_t,
+
+	/** RK1608 -> AP
+	 *   7 response of take picture msg
+	 */
+	id_msg_take_picture_ret_t =		0x0320,
+	id_msg_take_picture_done_ret_t,
+
+	/** RK1608 -> AP
+	 *   8 response of realtime parameter msg
+	 */
+	id_msg_rt_args_ret_t =			0x0330,
+
+	/*rk1608 -> ap*/
+	id_msg_do_i2c_t =				0x0390,
+	/*ap -> rk1608*/
+	id_msg_do_i2c_ret_t,
+
+	/** RK1608 -> AP
+	 *   9 msg of print log
+	 */
+	id_msg_rk1608_log_t =			0x0400,
+
+	/* dsi2csi dump */
+	id_msg_dsi2sci_rgb_dump_t =		0x6000,
+	id_msg_dsi2sci_nv12_dump_t =	0x6001,
+
+	/** RK1608 -> AP
+	 *	10  msg of xfile
+	 */
+	id_msg_xfile_import_t =		0x8000 + 0x0600,
+	id_msg_xfile_export_t,
+	id_msg_xfile_mkdir_t
+};
+
+struct msg_rk1608_log_t {
+	u32	size;
+	u16	type;
+	s8	core_id;
+	s8	log_level;
+};
+
+/**
+ * rk1608_write - RK1608 synchronous write
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_write(struct spi_device *spi, s32 addr,
+		 const s32 *data, size_t data_len);
+
+/**
+ * rk1608_safe_write - RK1608 synchronous write with state check
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else operation state code.
+ */
+int rk1608_safe_write(struct spi_device *spi,
+		      s32 addr, const s32 *data, size_t data_len);
+
+/**
+ * rk1608_read - RK1608 synchronous read
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer [out]
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_read(struct spi_device *spi, s32 addr,
+		s32 *data, size_t data_len);
+
+/**
+ * rk1608_safe_read - RK1608 synchronous read with state check
+ *
+ * @spi: spi device
+ * @addr: resource address
+ * @data: data buffer [out]
+ * @data_len: data buffer size, in bytes
+ * Context: can sleep
+ *
+ * It returns zero on success, else operation state code.
+ */
+int rk1608_safe_read(struct spi_device *spi,
+		     s32 addr, s32 *data, size_t data_len);
+
+/**
+ * rk1608_operation_query - RK1608 last operation state query
+ *
+ * @spi: spi device
+ * @state: last operation state [out]
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_operation_query(struct spi_device *spi, s32 *state);
+
+/**
+ * rk1608_interrupt_request - RK1608 request a rk1608 interrupt
+ *
+ * @spi: spi device
+ * @interrupt_num: interrupt identification
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_interrupt_request(struct spi_device *spi,
+			     s32 interrupt_num);
+
+static int rk1608_read_wait(struct spi_device *spi,
+			    const struct rk1608_section *sec);
+
+static int rk1608_boot_request(struct spi_device *spi,
+			       const struct rk1608_section *sec);
+
+static int rk1608_download_section(struct spi_device *spi, const u8 *data,
+				   const struct rk1608_section *sec);
+/**
+ * rk1608_download_fw: - rk1608 firmware download through spi
+ *
+ * @spi: spi device
+ * @fw_name: name of firmware file, NULL for default firmware name
+ * Context: can sleep
+ *
+ * It returns zero on success, else a negative error code.
+ **/
+int rk1608_download_fw(struct spi_device *spi, const char *fw_name);
+
+/**
+ * rk1608_msq_read_head - read rk1608 msg queue head
+ *
+ * @spi: spi device
+ * @addr: msg queue head addr
+ * @m: msg queue pointer
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_msq_read_head(struct spi_device *spi,
+			 u32 addr, struct rk1608_msg_queue *q);
+
+/**
+ * rk1608_msq_recv_msg - receive a msg from RK1608 -> AP msg queue
+ *
+ * @q: msg queue
+ * @m: a msg pointer buf [out]
+ *
+ * need call rk1608_msq_free_received_msg to free msg after msg use done
+ *
+ * It returns zero on success, else a negative error code.
+ */
+int rk1608_msq_recv_msg(struct spi_device *spi, struct msg **m);
+#endif
-- 
2.7.4
