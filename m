Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcGQOaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 10:30:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 5/7] [media] doc-rst: Fix conversion for v4l2 core functions
Date: Sun, 17 Jul 2016 11:30:02 -0300
Message-Id: <5833391dc4d0d28c5c629a86708e349c75fdcc64.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from DocBook lead into some conversion issues,
basically due to the lack of proper support at kernel-doc.

So, address them:

- Now, the C files with the exported symbols also need to be
  added. So, all headers need to be included twice: one to
  get the structs/enums/.. and another one for the functions;

- Notes should use the ReST tag, as kernel-doc doesn't
  recognizes it anymore;

- Identation needs to be fixed, as ReST uses it to identify
  when a format "tag" ends.

- kernel-doc doesn't escape things like *pointer, so we
  need to manually add a escape char before it.

- On some cases, kernel-doc conversion requires violating
  the 80-cols, as otherwise it won't properly parse the
  source code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-core.rst | 21 +++++++++++++++++++++
 include/media/tuner-types.h            |  8 ++++++--
 include/media/tveeprom.h               | 18 +++++++++++++++---
 include/media/v4l2-mc.h                | 13 ++++++++-----
 include/media/v4l2-subdev.h            |  4 ++--
 include/media/videobuf2-core.h         | 30 ++++++++++++++++++------------
 6 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index a1b73e8d6795..4e2aa721d9c8 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -34,3 +34,24 @@ Video2Linux devices
 .. kernel-doc:: include/media/videobuf2-v4l2.h
 
 .. kernel-doc:: include/media/videobuf2-memops.h
+
+
+
+
+.. kernel-doc:: include/media/tveeprom.h
+   :export: drivers/media/common/tveeprom.c
+
+.. kernel-doc:: include/media/v4l2-ctrls.h
+   :export: drivers/media/v4l2-core/v4l2-ctrls.c
+
+.. kernel-doc:: include/media/v4l2-dv-timings.h
+   :export: drivers/media/v4l2-core/v4l2-dv-timings.c
+
+.. kernel-doc:: include/media/v4l2-flash-led-class.h
+   :export: drivers/media/v4l2-core/v4l2-flash-led-class.c
+
+.. kernel-doc:: include/media/v4l2-mc.h
+   :export: drivers/media/v4l2-core/v4l2-mc.c
+
+.. kernel-doc:: include/media/videobuf2-core.h
+   :export: drivers/media/v4l2-core/videobuf2-core.c
diff --git a/include/media/tuner-types.h b/include/media/tuner-types.h
index 094e112cc325..aed539068d2d 100644
--- a/include/media/tuner-types.h
+++ b/include/media/tuner-types.h
@@ -35,8 +35,12 @@ enum param_type {
  * those ranges, as they're defined inside the driver. This is used by
  * analog tuners that are compatible with the "Philips way" to setup the
  * tuners. On those devices, the tuner set is done via 4 bytes:
- *	divider byte1 (DB1), divider byte 2 (DB2), Control byte (CB) and
- *	band switch byte (BB).
+ *
+ *	#) divider byte1 (DB1)
+ *	#) divider byte 2 (DB2)
+ *	#) Control byte (CB)
+ *	#) band switch byte (BB)
+ *
  * Some tuners also have an additional optional Auxiliary byte (AB).
  */
 struct tuner_range {
diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index 8be898739e0c..c56501ee0484 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -27,31 +27,43 @@ enum tveeprom_audio_processor {
  * struct tveeprom - Contains the fields parsed from Hauppauge eeproms
  *
  * @has_radio:			1 if the device has radio; 0 otherwise.
+ *
  * @has_ir:			If has_ir == 0, then it is unknown what the IR
  *				capabilities are. Otherwise:
- *					bit 0) 1 (= IR capabilities are known);
- *					bit 1) IR receiver present;
- *					bit 2) IR transmitter (blaster) present.
+ *				bit 0) 1 (= IR capabilities are known);
+ *				bit 1) IR receiver present;
+ *				bit 2) IR transmitter (blaster) present.
+ *
  * @has_MAC_address:		0: no MAC, 1: MAC present, 2: unknown.
  * @tuner_type:			type of the tuner (TUNER_*, as defined at
  *				include/media/tuner.h).
+ *
  * @tuner_formats:		Supported analog TV standards (V4L2_STD_*).
  * @tuner_hauppauge_model:	Hauppauge's code for the device model number.
  * @tuner2_type:		type of the second tuner (TUNER_*, as defined
  *				at include/media/tuner.h).
+ *
  * @tuner2_formats:		Tuner 2 supported analog TV standards
  *				(V4L2_STD_*).
+ *
  * @tuner2_hauppauge_model:	tuner 2 Hauppauge's code for the device model
  *				number.
+ *
  * @audio_processor:		analog audio decoder, as defined by enum
  *				tveeprom_audio_processor.
+ *
  * @decoder_processor:		Hauppauge's code for the decoder chipset.
  *				Unused by the drivers, as they probe the
  *				decoder based on the PCI or USB ID.
+ *
  * @model:			Hauppauge's model number
+ *
  * @revision:			Card revision number
+ *
  * @serial_number:		Card's serial number
+ *
  * @rev_str:			Card revision converted to number
+ *
  * @MAC_address:		MAC address for the network interface
  */
 struct tveeprom {
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 7a8d6037a4bb..28c3f9d9c209 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -114,11 +114,14 @@ struct usb_device;
  * Add links between the entities commonly found on PC customer's hardware at
  * the V4L2 side: camera sensors, audio and video PLL-IF decoders, tuners,
  * analog TV decoder and I/O entities (video, VBI and Software Defined Radio).
- * NOTE: webcams are modelled on a very simple way: the sensor is
- * connected directly to the I/O entity. All dirty details, like
- * scaler and crop HW are hidden. While such mapping is enough for v4l2
- * interface centric PC-consumer's hardware, V4L2 subdev centric camera
- * hardware should not use this routine, as it will not build the right graph.
+ *
+ * .. note::
+ *
+ *    Webcams are modelled on a very simple way: the sensor is
+ *    connected directly to the I/O entity. All dirty details, like
+ *    scaler and crop HW are hidden. While such mapping is enough for v4l2
+ *    interface centric PC-consumer's hardware, V4L2 subdev centric camera
+ *    hardware should not use this routine, as it will not build the right graph.
  */
 int v4l2_mc_create_media_graph(struct media_device *mdev);
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 32fc7a4beb5e..4c880e86a1aa 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -225,7 +225,7 @@ struct v4l2_subdev_core_ops {
  *
  * @g_frequency: callback for VIDIOC_G_FREQUENCY ioctl handler code.
  *		 freq->type must be filled in. Normally done by video_ioctl2
- *		or the bridge driver.
+ *		 or the bridge driver.
  *
  * @enum_freq_bands: callback for VIDIOC_ENUM_FREQ_BANDS ioctl handler code.
  *
@@ -233,7 +233,7 @@ struct v4l2_subdev_core_ops {
  *
  * @s_tuner: callback for VIDIOC_S_TUNER ioctl handler code. vt->type must be
  *	     filled in. Normally done by video_ioctl2 or the
- *	bridge driver.
+ *	     bridge driver.
  *
  * @g_modulator: callback for VIDIOC_G_MODULATOR ioctl handler code.
  *
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 88e3ab496e8f..01cdd5bf90c8 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -86,11 +86,17 @@ struct vb2_threadio_data;
  * @mmap:	setup a userspace mapping for a given memory buffer under
  *		the provided virtual memory region.
  *
- * Required ops for USERPTR types: get_userptr, put_userptr.
- * Required ops for MMAP types: alloc, put, num_users, mmap.
- * Required ops for read/write access types: alloc, put, num_users, vaddr.
- * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
- *				  unmap_dmabuf.
+ * Those operations are used by the videobuf2 core to implement the memory
+ * handling/memory allocators for each type of supported streaming I/O method.
+ *
+ * .. note::
+ *    #) Required ops for USERPTR types: get_userptr, put_userptr.
+ *
+ *    #) Required ops for MMAP types: alloc, put, num_users, mmap.
+ *
+ *    #) Required ops for read/write access types: alloc, put, num_users, vaddr.
+ *
+ *    #) Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf, unmap_dmabuf.
  */
 struct vb2_mem_ops {
 	void		*(*alloc)(void *alloc_ctx, unsigned long size,
@@ -279,19 +285,19 @@ struct vb2_buffer {
  *			second time with the actually allocated number of
  *			buffers to verify if that is OK.
  *			The driver should return the required number of buffers
- *			in *num_buffers, the required number of planes per
- *			buffer in *num_planes, the size of each plane should be
+ *			in \*num_buffers, the required number of planes per
+ *			buffer in \*num_planes, the size of each plane should be
  *			set in the sizes[] array and optional per-plane
  *			allocator specific context in the alloc_ctxs[] array.
- *			When called from VIDIOC_REQBUFS, *num_planes == 0, the
+ *			When called from VIDIOC_REQBUFS, \*num_planes == 0, the
  *			driver has to use the currently configured format to
- *			determine the plane sizes and *num_buffers is the total
+ *			determine the plane sizes and \*num_buffers is the total
  *			number of buffers that are being allocated. When called
- *			from VIDIOC_CREATE_BUFS, *num_planes != 0 and it
+ *			from VIDIOC_CREATE_BUFS, \*num_planes != 0 and it
  *			describes the requested number of planes and sizes[]
  *			contains the requested plane sizes. If either
- *			*num_planes or the requested sizes are invalid callback
- *			must return -EINVAL. In this case *num_buffers are
+ *			\*num_planes or the requested sizes are invalid callback
+ *			must return -EINVAL. In this case \*num_buffers are
  *			being allocated additionally to q->num_buffers.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
-- 
2.7.4

