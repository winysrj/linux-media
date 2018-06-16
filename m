Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37051 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbeFPEax (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 00:30:53 -0400
From: "JoonHwan.Kim" <spilit464@gmail.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        aishpant@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] media: staging: atomisp: add a blank line after declarations
Date: Sat, 16 Jun 2018 13:30:48 +0900
Message-ID: <2750553.3y1WJKmnP5@joonhwan-virtualbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fix checkpatch.pl warning:
  * Missing a blank line after declarations

Signed-off-by: Joonhwan Kim <spilit464@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 61bd550dafb9..4c8ff1c90f63 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -1194,6 +1194,7 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	 */
 	if (buf->memory == V4L2_MEMORY_USERPTR) {
 		struct hrt_userbuffer_attr attributes;
+
 		vb = pipe->capq.bufs[buf->index];
 		vm_mem = vb->priv;
 		if (!vm_mem) {
@@ -1557,6 +1558,7 @@ int atomisp_stream_on_master_slave_sensor(struct atomisp_device *isp,
 	 */
 	for (i = 0; i < isp->num_of_streams; i++) {
 		int sensor_index = isp->asd[i].input_curr;
+
 		if (isp->inputs[sensor_index].camera_caps->
 				sensor[isp->asd[i].sensor_curr].is_slave)
 			slave = sensor_index;
@@ -1643,6 +1645,7 @@ static void atomisp_pause_buffer_event(struct atomisp_device *isp)
 
 	for (i = 0; i < isp->num_of_streams; i++) {
 		int sensor_index = isp->asd[i].input_curr;
+
 		if (isp->inputs[sensor_index].camera_caps->
 				sensor[isp->asd[i].sensor_curr].is_slave) {
 			v4l2_event_queue(isp->asd[i].subdev.devnode, &event);
@@ -1656,6 +1659,7 @@ static void atomisp_pause_buffer_event(struct atomisp_device *isp)
 /* invalidate. SW workaround for this is to set burst length */
 /* manually to 128 in case of 13MPx snapshot and to 1 otherwise. */
 static void atomisp_dma_burst_len_cfg(struct atomisp_sub_device *asd)
+
 {
 
 	struct v4l2_mbus_framefmt *sink;
@@ -2138,6 +2142,7 @@ int __atomisp_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (isp->sw_contex.power_state == ATOM_ISP_POWER_UP) {
 		unsigned int i;
 		bool recreate_streams[MAX_STREAM_NUM] = {0};
+
 		if (isp->isp_timeout)
 			dev_err(isp->dev, "%s: Resetting with WA activated",
 				__func__);
-- 
2.17.1
