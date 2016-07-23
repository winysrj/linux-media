Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbcGWLcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 07:32:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/4] [media] doc-rst: add some needed escape codes
Date: Sat, 23 Jul 2016 08:31:53 -0300
Message-Id: <564aaf69208d6f9e37cd82c06b889e5d9c59bfb6.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some extra escape codes are needed to avoid Sphinx to not
identify the tags.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/demux.h        |  4 +--
 drivers/media/dvb-core/dvb_frontend.h | 26 +++++++++---------
 include/media/media-entity.h          |  2 +-
 include/media/v4l2-dev.h              |  4 +--
 include/media/videobuf2-core.h        | 50 +++++++++++++++++------------------
 5 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index 99379c09aa7f..4b4c1da20f4b 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -65,7 +65,7 @@
  */
 
 /**
- * enum ts_filter_type - filter type bitmap for dmx_ts_feed.set()
+ * enum ts_filter_type - filter type bitmap for dmx_ts_feed.set\(\)
  *
  * @TS_PACKET:		Send TS packets (188 bytes) to callback (default).
  * @TS_PAYLOAD_ONLY:	In case TS_PACKET is set, only send the TS payload
@@ -339,7 +339,7 @@ struct dmx_frontend {
  * @DMX_SECTION_FILTERING:	set if section filtering is supported;
  * @DMX_MEMORY_BASED_FILTERING:	set if write() available.
  *
- * Those flags are OR'ed in the &dmx_demux.&capabilities field
+ * Those flags are OR'ed in the &dmx_demux.capabilities field
  */
 enum dmx_demux_caps {
 	DMX_TS_FILTERING = 1,
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 8c551174537a..fb6e84811504 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -387,7 +387,7 @@ struct dtv_frontend_properties;
  *			FE_DISHNETWORK_SEND_LEGACY_CMD ioctl (only Satellite).
  *			Drivers should not use this, except when the DVB
  *			core emulation fails to provide proper support (e.g.
- *			if set_voltage() takes more than 8ms to work), and
+ *			if @set_voltage takes more than 8ms to work), and
  *			when backward compatibility with this legacy API is
  *			required.
  * @i2c_gate_ctrl:	controls the I2C gate. Newer drivers should use I2C
@@ -722,13 +722,13 @@ void dvb_frontend_detach(struct dvb_frontend *fe);
  * This function prepares a Digital TV frontend to suspend.
  *
  * In order to prepare the tuner to suspend, if
- * &dvb_frontend_ops.tuner_ops.suspend() is available, it calls it. Otherwise,
- * it will call &dvb_frontend_ops.tuner_ops.sleep(), if available.
+ * &dvb_frontend_ops.tuner_ops.suspend\(\) is available, it calls it. Otherwise,
+ * it will call &dvb_frontend_ops.tuner_ops.sleep\(\), if available.
  *
- * It will also call &dvb_frontend_ops.sleep() to put the demod to suspend.
+ * It will also call &dvb_frontend_ops.sleep\(\) to put the demod to suspend.
  *
- * The drivers should also call dvb_frontend_suspend() as part of their
- * handler for the &device_driver.suspend().
+ * The drivers should also call dvb_frontend_suspend\(\) as part of their
+ * handler for the &device_driver.suspend\(\).
  */
 int dvb_frontend_suspend(struct dvb_frontend *fe);
 
@@ -739,17 +739,17 @@ int dvb_frontend_suspend(struct dvb_frontend *fe);
  *
  * This function resumes the usual operation of the tuner after resume.
  *
- * In order to resume the frontend, it calls the demod &dvb_frontend_ops.init().
+ * In order to resume the frontend, it calls the demod &dvb_frontend_ops.init\(\).
  *
- * If &dvb_frontend_ops.tuner_ops.resume() is available, It, it calls it.
- * Otherwise,t will call &dvb_frontend_ops.tuner_ops.init(), if available.
+ * If &dvb_frontend_ops.tuner_ops.resume\(\) is available, It, it calls it.
+ * Otherwise,t will call &dvb_frontend_ops.tuner_ops.init\(\), if available.
  *
  * Once tuner and demods are resumed, it will enforce that the SEC voltage and
  * tone are restored to their previous values and wake up the frontend's
  * kthread in order to retune the frontend.
  *
  * The drivers should also call dvb_frontend_resume() as part of their
- * handler for the &device_driver.resume().
+ * handler for the &device_driver.resume\(\).
  */
 int dvb_frontend_resume(struct dvb_frontend *fe);
 
@@ -758,7 +758,7 @@ int dvb_frontend_resume(struct dvb_frontend *fe);
  *
  * @fe: pointer to the frontend struct
  *
- * Calls &dvb_frontend_ops.init() and &dvb_frontend_ops.tuner_ops.init(),
+ * Calls &dvb_frontend_ops.init\(\) and &dvb_frontend_ops.tuner_ops.init\(\),
  * and resets SEC tone and voltage (for Satellite systems).
  *
  * NOTE: Currently, this function is used only by one driver (budget-av).
@@ -780,14 +780,14 @@ void dvb_frontend_reinitialise(struct dvb_frontend *fe);
  * satellite subsystem.
  *
  * Its used internally by the DVB frontend core, in order to emulate
- * %FE_DISHNETWORK_SEND_LEGACY_CMD using the &dvb_frontend_ops.set_voltage()
+ * %FE_DISHNETWORK_SEND_LEGACY_CMD using the &dvb_frontend_ops.set_voltage\(\)
  * callback.
  *
  * NOTE: it should not be used at the drivers, as the emulation for the
  * legacy callback is provided by the Kernel. The only situation where this
  * should be at the drivers is when there are some bugs at the hardware that
  * would prevent the core emulation to work. On such cases, the driver would
- * be writing a &dvb_frontend_ops.dishnetwork_send_legacy_command() and
+ * be writing a &dvb_frontend_ops.dishnetwork_send_legacy_command\(\) and
  * calling this function directly.
  */
 void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 17390cc7b538..09b03c17784d 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -540,7 +540,7 @@ static inline bool media_entity_enum_intersects(
  * @gobj:	Pointer to the graph object
  *
  * This routine initializes the embedded struct media_gobj inside a
- * media graph object. It is called automatically if media_*_create()
+ * media graph object. It is called automatically if media_*_create\(\)
  * calls are used. However, if the object (entity, link, pad, interface)
  * is embedded on some other object, this function should be called before
  * registering the object at the media controller.
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 5921c24565cf..a122b1bd40f9 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -374,13 +374,13 @@ struct video_device * __must_check video_device_alloc(void);
  *
  * @vdev: pointer to &struct video_device
  *
- * Can also be used for video_device->release().
+ * Can also be used for video_device->release\(\).
  */
 void video_device_release(struct video_device *vdev);
 
 /**
  * video_device_release_empty - helper function to implement the
- * 	video_device->release() callback.
+ * 	video_device->release\(\) callback.
  *
  * @vdev: pointer to &struct video_device
  *
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index c346beaaeae6..946340ce7701 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -277,7 +277,7 @@ struct vb2_buffer {
 /**
  * struct vb2_ops - driver-specific callbacks
  *
- * @queue_setup:	called from VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
+ * @queue_setup:	called from %VIDIOC_REQBUFS and %VIDIOC_CREATE_BUFS
  *			handlers before memory allocation. It can be called
  *			twice: if the original number of requested buffers
  *			could not be allocated, then it will be called a
@@ -286,17 +286,17 @@ struct vb2_buffer {
  *			The driver should return the required number of buffers
  *			in \*num_buffers, the required number of planes per
  *			buffer in \*num_planes, the size of each plane should be
- *			set in the sizes[] array and optional per-plane
- *			allocator specific device in the alloc_devs[] array.
- *			When called from VIDIOC_REQBUFS, *num_planes == 0, the
+ *			set in the sizes\[\] array and optional per-plane
+ *			allocator specific device in the alloc_devs\[\] array.
+ *			When called from %VIDIOC_REQBUFS, \*num_planes == 0, the
  *			driver has to use the currently configured format to
  *			determine the plane sizes and \*num_buffers is the total
  *			number of buffers that are being allocated. When called
- *			from VIDIOC_CREATE_BUFS, \*num_planes != 0 and it
- *			describes the requested number of planes and sizes[]
+ *			from %VIDIOC_CREATE_BUFS, \*num_planes != 0 and it
+ *			describes the requested number of planes and sizes\[\]
  *			contains the requested plane sizes. If either
  *			\*num_planes or the requested sizes are invalid callback
- *			must return -EINVAL. In this case \*num_buffers are
+ *			must return %-EINVAL. In this case \*num_buffers are
  *			being allocated additionally to q->num_buffers.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
@@ -311,11 +311,11 @@ struct vb2_buffer {
  *			initialization failure (return != 0) will prevent
  *			queue setup from completing successfully; optional.
  * @buf_prepare:	called every time the buffer is queued from userspace
- *			and from the VIDIOC_PREPARE_BUF ioctl; drivers may
+ *			and from the %VIDIOC_PREPARE_BUF ioctl; drivers may
  *			perform any initialization required before each
  *			hardware operation in this callback; drivers can
  *			access/modify the buffer here as it is still synced for
- *			the CPU; drivers that support VIDIOC_CREATE_BUFS must
+ *			the CPU; drivers that support %VIDIOC_CREATE_BUFS must
  *			also validate the buffer size; if an error is returned,
  *			the buffer will not be queued in driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
@@ -323,23 +323,23 @@ struct vb2_buffer {
  *			can access/modify the buffer contents; drivers may
  *			perform any operations required before userspace
  *			accesses the buffer; optional. The buffer state can be
- *			one of the following: DONE and ERROR occur while
- *			streaming is in progress, and the PREPARED state occurs
+ *			one of the following: %DONE and %ERROR occur while
+ *			streaming is in progress, and the %PREPARED state occurs
  *			when the queue has been canceled and all pending
- *			buffers are being returned to their default DEQUEUED
+ *			buffers are being returned to their default %DEQUEUED
  *			state. Typically you only have to do something if the
- *			state is VB2_BUF_STATE_DONE, since in all other cases
+ *			state is %VB2_BUF_STATE_DONE, since in all other cases
  *			the buffer contents will be ignored anyway.
  * @buf_cleanup:	called once before the buffer is freed; drivers may
  *			perform any additional cleanup; optional.
  * @start_streaming:	called once to enter 'streaming' state; the driver may
- *			receive buffers with @buf_queue callback before
- *			@start_streaming is called; the driver gets the number
- *			of already queued buffers in count parameter; driver
- *			can return an error if hardware fails, in that case all
- *			buffers that have been already given by the @buf_queue
- *			callback are to be returned by the driver by calling
- *			@vb2_buffer_done(VB2_BUF_STATE_QUEUED).
+ *			receive buffers with @buf_queue callback
+ *			before @start_streaming is called; the driver gets the
+ *			number of already queued buffers in count parameter;
+ *			driver can return an error if hardware fails, in that
+ *			case all buffers that have been already given by
+ *			the @buf_queue callback are to be returned by the driver
+ *			by calling @vb2_buffer_done\(%VB2_BUF_STATE_QUEUED\).
  *			If you need a minimum number of buffers before you can
  *			start streaming, then set @min_buffers_needed in the
  *			vb2_queue structure. If that is non-zero then
@@ -347,16 +347,16 @@ struct vb2_buffer {
  *			many buffers have been queued up by userspace.
  * @stop_streaming:	called when 'streaming' state must be disabled; driver
  *			should stop any DMA transactions or wait until they
- *			finish and give back all buffers it got from buf_queue()
- *			callback by calling @vb2_buffer_done() with either
- *			VB2_BUF_STATE_DONE or VB2_BUF_STATE_ERROR; may use
+ *			finish and give back all buffers it got from &buf_queue
+ *			callback by calling @vb2_buffer_done\(\) with either
+ *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
- *			it is allways called after calling STREAMON ioctl;
+ *			it is allways called after calling %VIDIOC_STREAMON ioctl;
  *			might be called before start_streaming callback if user
- *			pre-queued buffers before calling STREAMON.
+ *			pre-queued buffers before calling %VIDIOC_STREAMON.
  */
 struct vb2_ops {
 	int (*queue_setup)(struct vb2_queue *q,
-- 
2.7.4

