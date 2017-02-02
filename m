Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:29058 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751143AbdBBPAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:00:23 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v7 07/10] [media] st-delta: rpmsg ipc support
Date: Thu, 2 Feb 2017 15:59:50 +0100
Message-ID: <1486047593-18581-8-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IPC (Inter Process Communication) support for communication with
DELTA coprocessor firmware using rpmsg kernel framework.
Based on 4 services open/set_stream/decode/close and their associated
rpmsg messages.
The messages structures are duplicated on both host and firmware
side and are packed (use only of 32 bits size fields in messages
structures to ensure packing).
Each service is synchronous; service returns only when firmware
acknowledges the associated command message.
Due to significant parameters size exchanged from host to copro,
parameters are not inserted in rpmsg messages. Instead, parameters are
stored in physical memory shared between host and coprocessor.
Memory is non-cacheable, so no special operation is required
to ensure memory coherency on host and on coprocessor side.
Multi-instance support and re-entrance are ensured using host_hdl and
copro_hdl in message header exchanged between both host and coprocessor.
This avoids to manage tables on both sides to get back the running context
of each instance.

Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/Kconfig                |   1 +
 drivers/media/platform/sti/delta/Makefile     |   2 +-
 drivers/media/platform/sti/delta/delta-ipc.c  | 594 ++++++++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-ipc.h  |  76 ++++
 drivers/media/platform/sti/delta/delta-v4l2.c |  11 +
 drivers/media/platform/sti/delta/delta.h      |  21 +
 6 files changed, 704 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.c
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2247d9d..2e82ec6 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -323,6 +323,7 @@ config VIDEO_STI_DELTA_DRIVER
 	default n
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select RPMSG
 
 endif # VIDEO_STI_DELTA
 
diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index 93a3037..b791ba0 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_VIDEO_STI_DELTA_DRIVER) := st-delta.o
-st-delta-y := delta-v4l2.o delta-mem.o
+st-delta-y := delta-v4l2.o delta-mem.o delta-ipc.o
diff --git a/drivers/media/platform/sti/delta/delta-ipc.c b/drivers/media/platform/sti/delta/delta-ipc.c
new file mode 100644
index 0000000..41e4a4c
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-ipc.c
@@ -0,0 +1,594 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/rpmsg.h>
+
+#include "delta.h"
+#include "delta-ipc.h"
+#include "delta-mem.h"
+
+#define IPC_TIMEOUT 100
+#define IPC_SANITY_TAG 0xDEADBEEF
+
+enum delta_ipc_fw_command {
+	DELTA_IPC_OPEN,
+	DELTA_IPC_SET_STREAM,
+	DELTA_IPC_DECODE,
+	DELTA_IPC_CLOSE
+};
+
+#define to_rpmsg_driver(__drv) container_of(__drv, struct rpmsg_driver, drv)
+#define to_delta(__d) container_of(__d, struct delta_dev, rpmsg_driver)
+
+#define to_ctx(hdl) ((struct delta_ipc_ctx *)hdl)
+#define to_pctx(ctx) container_of(ctx, struct delta_ctx, ipc_ctx)
+
+struct delta_ipc_header_msg {
+	u32 tag;
+	void *host_hdl;
+	u32 copro_hdl;
+	u32 command;
+};
+
+#define to_host_hdl(ctx) ((void *)ctx)
+
+#define msg_to_ctx(msg) ((struct delta_ipc_ctx *)(msg)->header.host_hdl)
+#define msg_to_copro_hdl(msg) ((msg)->header.copro_hdl)
+
+static inline dma_addr_t to_paddr(struct delta_ipc_ctx *ctx, void *vaddr)
+{
+	return (ctx->ipc_buf->paddr + (vaddr - ctx->ipc_buf->vaddr));
+}
+
+static inline bool is_valid_data(struct delta_ipc_ctx *ctx,
+				 void *data, u32 size)
+{
+	return ((data >= ctx->ipc_buf->vaddr) &&
+		((data + size) <= (ctx->ipc_buf->vaddr + ctx->ipc_buf->size)));
+}
+
+/*
+ * IPC shared memory (@ipc_buf_size, @ipc_buf_paddr) is sent to copro
+ * at each instance opening. This memory is allocated by IPC client
+ * and given through delta_ipc_open(). All messages parameters
+ * (open, set_stream, decode) will have their phy address within
+ * this IPC shared memory, avoiding de-facto recopies inside delta-ipc.
+ * All the below messages structures are used on both host and firmware
+ * side and are packed (use only of 32 bits size fields in messages
+ * structures to ensure packing):
+ * - struct delta_ipc_open_msg
+ * - struct delta_ipc_set_stream_msg
+ * - struct delta_ipc_decode_msg
+ * - struct delta_ipc_close_msg
+ * - struct delta_ipc_cb_msg
+ */
+struct delta_ipc_open_msg {
+	struct delta_ipc_header_msg header;
+	u32 ipc_buf_size;
+	dma_addr_t ipc_buf_paddr;
+	char name[32];
+	u32 param_size;
+	dma_addr_t param_paddr;
+};
+
+struct delta_ipc_set_stream_msg {
+	struct delta_ipc_header_msg header;
+	u32 param_size;
+	dma_addr_t param_paddr;
+};
+
+struct delta_ipc_decode_msg {
+	struct delta_ipc_header_msg header;
+	u32 param_size;
+	dma_addr_t param_paddr;
+	u32 status_size;
+	dma_addr_t status_paddr;
+};
+
+struct delta_ipc_close_msg {
+	struct delta_ipc_header_msg header;
+};
+
+struct delta_ipc_cb_msg {
+	struct delta_ipc_header_msg header;
+	int err;
+};
+
+static void build_msg_header(struct delta_ipc_ctx *ctx,
+			     enum delta_ipc_fw_command command,
+			     struct delta_ipc_header_msg *header)
+{
+	header->tag = IPC_SANITY_TAG;
+	header->host_hdl = to_host_hdl(ctx);
+	header->copro_hdl = ctx->copro_hdl;
+	header->command = command;
+}
+
+int delta_ipc_open(struct delta_ctx *pctx, const char *name,
+		   struct delta_ipc_param *param, u32 ipc_buf_size,
+		   struct delta_buf **ipc_buf, void **hdl)
+{
+	struct delta_dev *delta = pctx->dev;
+	struct rpmsg_device *rpmsg_device = delta->rpmsg_device;
+	struct delta_ipc_ctx *ctx = &pctx->ipc_ctx;
+	struct delta_ipc_open_msg msg;
+	struct delta_buf *buf = &ctx->ipc_buf_struct;
+	int ret;
+
+	if (!rpmsg_device) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, rpmsg is not initialized\n",
+			pctx->name);
+		pctx->sys_errors++;
+		return -EINVAL;
+	}
+
+	if (!name) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, no name given\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!param || !param->data || !param->size) {
+		dev_err(delta->dev,
+			"%s  ipc: failed to open, empty parameter\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!ipc_buf_size) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, no size given for ipc buffer\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (param->size > ipc_buf_size) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, too large ipc parameter (%d bytes while max %d expected)\n",
+			pctx->name,
+			param->size, ctx->ipc_buf->size);
+		return -EINVAL;
+	}
+
+	/* init */
+	init_completion(&ctx->done);
+
+	/*
+	 * allocation of contiguous buffer for
+	 * data of commands exchanged between
+	 * host and firmware coprocessor
+	 */
+	ret = hw_alloc(pctx, ipc_buf_size,
+		       "ipc data buffer", buf);
+	if (ret)
+		return ret;
+	ctx->ipc_buf = buf;
+
+	/* build rpmsg message */
+	build_msg_header(ctx, DELTA_IPC_OPEN, &msg.header);
+
+	msg.ipc_buf_size = ipc_buf_size;
+	msg.ipc_buf_paddr = ctx->ipc_buf->paddr;
+
+	memcpy(msg.name, name, sizeof(msg.name));
+	msg.name[sizeof(msg.name) - 1] = 0;
+
+	msg.param_size = param->size;
+	memcpy(ctx->ipc_buf->vaddr, param->data, msg.param_size);
+	msg.param_paddr = ctx->ipc_buf->paddr;
+
+	/* send it */
+	ret = rpmsg_send(rpmsg_device->ept, &msg, sizeof(msg));
+	if (ret) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, rpmsg_send failed (%d) for DELTA_IPC_OPEN (name=%s, size=%d, data=%p)\n",
+			pctx->name,
+			ret, name, param->size, param->data);
+		goto err;
+	}
+
+	/* wait for acknowledge */
+	if (!wait_for_completion_timeout
+	    (&ctx->done, msecs_to_jiffies(IPC_TIMEOUT))) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, timeout waiting for DELTA_IPC_OPEN callback (name=%s, size=%d, data=%p)\n",
+			pctx->name,
+			name, param->size, param->data);
+		ret = -ETIMEDOUT;
+		goto err;
+	}
+
+	/* command completed, check error */
+	if (ctx->cb_err) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to open, DELTA_IPC_OPEN completed but with error (%d) (name=%s, size=%d, data=%p)\n",
+			pctx->name,
+			ctx->cb_err, name, param->size, param->data);
+		ret = -EIO;
+		goto err;
+	}
+
+	*ipc_buf = ctx->ipc_buf;
+	*hdl = (void *)ctx;
+
+	return 0;
+
+err:
+	pctx->sys_errors++;
+	if (ctx->ipc_buf) {
+		hw_free(pctx, ctx->ipc_buf);
+		ctx->ipc_buf = NULL;
+	}
+
+	return ret;
+};
+
+int delta_ipc_set_stream(void *hdl, struct delta_ipc_param *param)
+{
+	struct delta_ipc_ctx *ctx = to_ctx(hdl);
+	struct delta_ctx *pctx = to_pctx(ctx);
+	struct delta_dev *delta = pctx->dev;
+	struct rpmsg_device *rpmsg_device = delta->rpmsg_device;
+	struct delta_ipc_set_stream_msg msg;
+	int ret;
+
+	if (!hdl) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, invalid ipc handle\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!rpmsg_device) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, rpmsg is not initialized\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!param || !param->data || !param->size) {
+		dev_err(delta->dev,
+			"%s  ipc: failed to set stream, empty parameter\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (param->size > ctx->ipc_buf->size) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, too large ipc parameter(%d bytes while max %d expected)\n",
+			pctx->name,
+			param->size, ctx->ipc_buf->size);
+		return -EINVAL;
+	}
+
+	if (!is_valid_data(ctx, param->data, param->size)) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, parameter is not in expected address range (size=%d, data=%p not in %p..%p)\n",
+			pctx->name,
+			param->size,
+			param->data,
+			ctx->ipc_buf->vaddr,
+			ctx->ipc_buf->vaddr + ctx->ipc_buf->size - 1);
+		return -EINVAL;
+	}
+
+	/* build rpmsg message */
+	build_msg_header(ctx, DELTA_IPC_SET_STREAM, &msg.header);
+
+	msg.param_size = param->size;
+	msg.param_paddr = to_paddr(ctx, param->data);
+
+	/* send it */
+	ret = rpmsg_send(rpmsg_device->ept, &msg, sizeof(msg));
+	if (ret) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, rpmsg_send failed (%d) for DELTA_IPC_SET_STREAM (size=%d, data=%p)\n",
+			pctx->name,
+			ret, param->size, param->data);
+		pctx->sys_errors++;
+		return ret;
+	}
+
+	/* wait for acknowledge */
+	if (!wait_for_completion_timeout
+	    (&ctx->done, msecs_to_jiffies(IPC_TIMEOUT))) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, timeout waiting for DELTA_IPC_SET_STREAM callback (size=%d, data=%p)\n",
+			pctx->name,
+			param->size, param->data);
+		pctx->sys_errors++;
+		return -ETIMEDOUT;
+	}
+
+	/* command completed, check status */
+	if (ctx->cb_err) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to set stream, DELTA_IPC_SET_STREAM completed but with error (%d) (size=%d, data=%p)\n",
+			pctx->name,
+			ctx->cb_err, param->size, param->data);
+		pctx->sys_errors++;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int delta_ipc_decode(void *hdl, struct delta_ipc_param *param,
+		     struct delta_ipc_param *status)
+{
+	struct delta_ipc_ctx *ctx = to_ctx(hdl);
+	struct delta_ctx *pctx = to_pctx(ctx);
+	struct delta_dev *delta = pctx->dev;
+	struct rpmsg_device *rpmsg_device = delta->rpmsg_device;
+	struct delta_ipc_decode_msg msg;
+	int ret;
+
+	if (!hdl) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, invalid ipc handle\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!rpmsg_device) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, rpmsg is not initialized\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!param || !param->data || !param->size) {
+		dev_err(delta->dev,
+			"%s  ipc: failed to decode, empty parameter\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (!status || !status->data || !status->size) {
+		dev_err(delta->dev,
+			"%s  ipc: failed to decode, empty status\n",
+			pctx->name);
+		return -EINVAL;
+	}
+
+	if (param->size + status->size > ctx->ipc_buf->size) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, too large ipc parameter (%d bytes (param) + %d bytes (status) while max %d expected)\n",
+			pctx->name,
+			param->size,
+			status->size,
+			ctx->ipc_buf->size);
+		return -EINVAL;
+	}
+
+	if (!is_valid_data(ctx, param->data, param->size)) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, parameter is not in expected address range (size=%d, data=%p not in %p..%p)\n",
+			pctx->name,
+			param->size,
+			param->data,
+			ctx->ipc_buf->vaddr,
+			ctx->ipc_buf->vaddr + ctx->ipc_buf->size - 1);
+		return -EINVAL;
+	}
+
+	if (!is_valid_data(ctx, status->data, status->size)) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, status is not in expected address range (size=%d, data=%p not in %p..%p)\n",
+			pctx->name,
+			status->size,
+			status->data,
+			ctx->ipc_buf->vaddr,
+			ctx->ipc_buf->vaddr + ctx->ipc_buf->size - 1);
+		return -EINVAL;
+	}
+
+	/* build rpmsg message */
+	build_msg_header(ctx, DELTA_IPC_DECODE, &msg.header);
+
+	msg.param_size = param->size;
+	msg.param_paddr = to_paddr(ctx, param->data);
+
+	msg.status_size = status->size;
+	msg.status_paddr = to_paddr(ctx, status->data);
+
+	/* send it */
+	ret = rpmsg_send(rpmsg_device->ept, &msg, sizeof(msg));
+	if (ret) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, rpmsg_send failed (%d) for DELTA_IPC_DECODE (size=%d, data=%p)\n",
+			pctx->name,
+			ret, param->size, param->data);
+		pctx->sys_errors++;
+		return ret;
+	}
+
+	/* wait for acknowledge */
+	if (!wait_for_completion_timeout
+	    (&ctx->done, msecs_to_jiffies(IPC_TIMEOUT))) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, timeout waiting for DELTA_IPC_DECODE callback (size=%d, data=%p)\n",
+			pctx->name,
+			param->size, param->data);
+		pctx->sys_errors++;
+		return -ETIMEDOUT;
+	}
+
+	/* command completed, check status */
+	if (ctx->cb_err) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to decode, DELTA_IPC_DECODE completed but with error (%d) (size=%d, data=%p)\n",
+			pctx->name,
+			ctx->cb_err, param->size, param->data);
+		pctx->sys_errors++;
+		return -EIO;
+	}
+
+	return 0;
+};
+
+void delta_ipc_close(void *hdl)
+{
+	struct delta_ipc_ctx *ctx = to_ctx(hdl);
+	struct delta_ctx *pctx = to_pctx(ctx);
+	struct delta_dev *delta = pctx->dev;
+	struct rpmsg_device *rpmsg_device = delta->rpmsg_device;
+	struct delta_ipc_close_msg msg;
+	int ret;
+
+	if (!hdl) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to close, invalid ipc handle\n",
+			pctx->name);
+		return;
+	}
+
+	if (ctx->ipc_buf) {
+		hw_free(pctx, ctx->ipc_buf);
+		ctx->ipc_buf = NULL;
+	}
+
+	if (!rpmsg_device) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to close, rpmsg is not initialized\n",
+			pctx->name);
+		return;
+	}
+
+	/* build rpmsg message */
+	build_msg_header(ctx, DELTA_IPC_CLOSE, &msg.header);
+
+	/* send it */
+	ret = rpmsg_send(rpmsg_device->ept, &msg, sizeof(msg));
+	if (ret) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to close, rpmsg_send failed (%d) for DELTA_IPC_CLOSE\n",
+			pctx->name, ret);
+		pctx->sys_errors++;
+		return;
+	}
+
+	/* wait for acknowledge */
+	if (!wait_for_completion_timeout
+	    (&ctx->done, msecs_to_jiffies(IPC_TIMEOUT))) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to close, timeout waiting for DELTA_IPC_CLOSE callback\n",
+			pctx->name);
+		pctx->sys_errors++;
+		return;
+	}
+
+	/* command completed, check status */
+	if (ctx->cb_err) {
+		dev_err(delta->dev,
+			"%s   ipc: failed to close, DELTA_IPC_CLOSE completed but with error (%d)\n",
+			pctx->name, ctx->cb_err);
+		pctx->sys_errors++;
+	}
+};
+
+static int delta_ipc_cb(struct rpmsg_device *rpdev, void *data,
+			int len, void *priv, u32 src)
+{
+	struct delta_ipc_ctx *ctx;
+	struct delta_ipc_cb_msg *msg;
+
+	/* sanity check */
+	if (!rpdev) {
+		dev_err(NULL, "rpdev is NULL\n");
+		return -EINVAL;
+	}
+
+	if (!data || !len) {
+		dev_err(&rpdev->dev,
+			"unexpected empty message received from src=%d\n", src);
+		return -EINVAL;
+	}
+
+	if (len != sizeof(*msg)) {
+		dev_err(&rpdev->dev,
+			"unexpected message length received from src=%d (received %d bytes while %zu bytes expected)\n",
+			len, src, sizeof(*msg));
+		return -EINVAL;
+	}
+
+	msg = (struct delta_ipc_cb_msg *)data;
+	if (msg->header.tag != IPC_SANITY_TAG) {
+		dev_err(&rpdev->dev,
+			"unexpected message tag received from src=%d (received %x tag while %x expected)\n",
+			src, msg->header.tag, IPC_SANITY_TAG);
+		return -EINVAL;
+	}
+
+	ctx = msg_to_ctx(msg);
+	if (!ctx) {
+		dev_err(&rpdev->dev,
+			"unexpected message with NULL host_hdl received from src=%d\n",
+			src);
+		return -EINVAL;
+	}
+
+	/*
+	 * if not already known, save copro instance context
+	 * to ensure re-entrance on copro side
+	 */
+	if (!ctx->copro_hdl)
+		ctx->copro_hdl = msg_to_copro_hdl(msg);
+
+	/*
+	 * all is fine,
+	 * update status & complete command
+	 */
+	ctx->cb_err = msg->err;
+	complete(&ctx->done);
+
+	return 0;
+}
+
+static int delta_ipc_probe(struct rpmsg_device *rpmsg_device)
+{
+	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpmsg_device->dev.driver);
+	struct delta_dev *delta = to_delta(rpdrv);
+
+	delta->rpmsg_device = rpmsg_device;
+
+	return 0;
+}
+
+static void delta_ipc_remove(struct rpmsg_device *rpmsg_device)
+{
+	struct rpmsg_driver *rpdrv = to_rpmsg_driver(rpmsg_device->dev.driver);
+	struct delta_dev *delta = to_delta(rpdrv);
+
+	delta->rpmsg_device = NULL;
+}
+
+static struct rpmsg_device_id delta_ipc_device_id_table[] = {
+	{.name = "rpmsg-delta"},
+	{},
+};
+
+static struct rpmsg_driver delta_rpmsg_driver = {
+	.drv = {.name = KBUILD_MODNAME},
+	.id_table = delta_ipc_device_id_table,
+	.probe = delta_ipc_probe,
+	.callback = delta_ipc_cb,
+	.remove = delta_ipc_remove,
+};
+
+int delta_ipc_init(struct delta_dev *delta)
+{
+	delta->rpmsg_driver = delta_rpmsg_driver;
+
+	return register_rpmsg_driver(&delta->rpmsg_driver);
+}
+
+void delta_ipc_exit(struct delta_dev *delta)
+{
+	unregister_rpmsg_driver(&delta->rpmsg_driver);
+}
diff --git a/drivers/media/platform/sti/delta/delta-ipc.h b/drivers/media/platform/sti/delta/delta-ipc.h
new file mode 100644
index 0000000..cef2019
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-ipc.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_IPC_H
+#define DELTA_IPC_H
+
+int delta_ipc_init(struct delta_dev *delta);
+void delta_ipc_exit(struct delta_dev *delta);
+
+/*
+ * delta_ipc_open - open a decoding instance on firmware side
+ * @ctx:		(in) delta context
+ * @name:		(in) name of decoder to be used
+ * @param:		(in) open command parameters specific to decoder
+ *  @param.size:		(in) size of parameter
+ *  @param.data:		(in) virtual address of parameter
+ * @ipc_buf_size:	(in) size of IPC shared buffer between host
+ *			     and copro used to share command data.
+ *			     Client have to set here the size of the biggest
+ *			     command parameters (+ status if any).
+ *			     Allocation will be done in this function which
+ *			     will give back to client in @ipc_buf the virtual
+ *			     & physical addresses & size of shared IPC buffer.
+ *			     All the further command data (parameters + status)
+ *			     have to be written in this shared IPC buffer
+ *			     virtual memory. This is done to avoid
+ *			     unnecessary copies of command data.
+ * @ipc_buf:		(out) allocated IPC shared buffer
+ *  @ipc_buf.size:		(out) allocated size
+ *  @ipc_buf.vaddr:		(out) virtual address where to copy
+ *				      further command data
+ * @hdl:		(out) handle of decoding instance.
+ */
+
+int delta_ipc_open(struct delta_ctx *ctx, const char *name,
+		   struct delta_ipc_param *param, u32 ipc_buf_size,
+		   struct delta_buf **ipc_buf, void **hdl);
+
+/*
+ * delta_ipc_set_stream - set information about stream to decoder
+ * @hdl:		(in) handle of decoding instance.
+ * @param:		(in) set stream command parameters specific to decoder
+ *  @param.size:		(in) size of parameter
+ *  @param.data:		(in) virtual address of parameter. Must be
+ *				     within IPC shared buffer range
+ */
+int delta_ipc_set_stream(void *hdl, struct delta_ipc_param *param);
+
+/*
+ * delta_ipc_decode - frame decoding synchronous request, returns only
+ *		      after decoding completion on firmware side.
+ * @hdl:		(in) handle of decoding instance.
+ * @param:		(in) decode command parameters specific to decoder
+ *  @param.size:		(in) size of parameter
+ *  @param.data:		(in) virtual address of parameter. Must be
+ *				     within IPC shared buffer range
+ * @status:		(in/out) decode command status specific to decoder
+ *  @status.size:		(in) size of status
+ *  @status.data:		(in/out) virtual address of status. Must be
+ *					 within IPC shared buffer range.
+ *					 Status is filled by decoding instance
+ *					 after decoding completion.
+ */
+int delta_ipc_decode(void *hdl, struct delta_ipc_param *param,
+		     struct delta_ipc_param *status);
+
+/*
+ * delta_ipc_close - close decoding instance
+ * @hdl:		(in) handle of decoding instance to close.
+ */
+void delta_ipc_close(void *hdl);
+
+#endif /* DELTA_IPC_H */
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index e65a3a3..237a938 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -17,6 +17,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "delta.h"
+#include "delta-ipc.h"
 
 #define DELTA_NAME	"st-delta"
 
@@ -1703,6 +1704,14 @@ static int delta_probe(struct platform_device *pdev)
 	pm_runtime_set_suspended(dev);
 	pm_runtime_enable(dev);
 
+	/* init firmware ipc channel */
+	ret = delta_ipc_init(delta);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to initialize firmware ipc channel\n",
+			DELTA_PREFIX);
+		goto err;
+	}
+
 	/* register all available decoders */
 	register_decoders(delta);
 
@@ -1747,6 +1756,8 @@ static int delta_remove(struct platform_device *pdev)
 {
 	struct delta_dev *delta = platform_get_drvdata(pdev);
 
+	delta_ipc_exit(delta);
+
 	delta_unregister_device(delta);
 
 	destroy_workqueue(delta->work_queue);
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
index 9e26525..d4a401b 100644
--- a/drivers/media/platform/sti/delta/delta.h
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -7,6 +7,7 @@
 #ifndef DELTA_H
 #define DELTA_H
 
+#include <linux/rpmsg.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 
@@ -199,6 +200,19 @@ struct delta_buf {
 	unsigned long attrs;
 };
 
+struct delta_ipc_ctx {
+	int cb_err;
+	u32 copro_hdl;
+	struct completion done;
+	struct delta_buf ipc_buf_struct;
+	struct delta_buf *ipc_buf;
+};
+
+struct delta_ipc_param {
+	u32 size;
+	void *data;
+};
+
 struct delta_ctx;
 
 /*
@@ -368,6 +382,7 @@ struct delta_dec {
  * @fh:			V4L2 file handle
  * @dev:		device context
  * @dec:		selected decoder context for this instance
+ * @ipc_ctx:		context of IPC communication with firmware
  * @state:		instance state
  * @frame_num:		frame number
  * @au_num:		access unit number
@@ -399,6 +414,8 @@ struct delta_ctx {
 	struct v4l2_fh fh;
 	struct delta_dev *dev;
 	const struct delta_dec *dec;
+	struct delta_ipc_ctx ipc_ctx;
+
 	enum delta_state state;
 	u32 frame_num;
 	u32 au_num;
@@ -447,6 +464,8 @@ struct delta_ctx {
  * @nb_of_streamformats:number of supported compressed video formats
  * @instance_id:	rolling counter identifying an instance (debug purpose)
  * @work_queue:		decoding job work queue
+ * @rpmsg_driver:	rpmsg IPC driver
+ * @rpmsg_device:	rpmsg IPC device
  */
 struct delta_dev {
 	struct v4l2_device v4l2_dev;
@@ -466,6 +485,8 @@ struct delta_dev {
 	u32 nb_of_streamformats;
 	u8 instance_id;
 	struct workqueue_struct *work_queue;
+	struct rpmsg_driver rpmsg_driver;
+	struct rpmsg_device *rpmsg_device;
 };
 
 static inline char *frame_type_str(u32 flags)
-- 
1.9.1

