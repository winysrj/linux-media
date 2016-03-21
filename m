Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:58671 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbcCUW0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 18:26:30 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] pxa_camera transition to v4l2 standalone device
References: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
	<56EFAD47.8010403@xs4all.nl>
Date: Mon, 21 Mar 2016 23:26:19 +0100
Message-ID: <87lh5bmpro.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 03/19/2016 10:01 PM, Robert Jarzmik wrote:
>> Hi Hans and Guennadi,
>> 
>> As Hans is converting sh_mobile_ceu_camera.c,
>
> That's not going as fast as I hoped. This driver is quite complex and extracting
> it from soc-camera isn't easy. I also can't spend as much time as I'd like on this.
>
>> let's see how close our ports are
>> to see if there are things we could either reuse of change.
>> 
>> The port is assuming :
>>  - the formation translation is transferred into soc_mediabus, so that it can be
>>    reused across all v4l2 devices
>
> At best this will be a temporary helper source. I never liked soc_mediabus, I don't
> believe it is the right approach.
As long as you provide a better approach, especially for the dynamic formats
translation, it should be fine.

> But I have no problem if it is used for now to simplify the soc-camera
> dependency removal.
Ok.

>>  - pxa_camera is ported
>> 
>> This sets a ground of discussion for soc_camera adherence removal from
>> pxa_camera. I'd like to have a comment from Hans if this is what he has in mind,
>> and Guennadi if he agrees to transfer the soc xlate stuff to soc_mediabus.
>
> Can you provide the output of 'v4l2-compliance -s' with your new pxa driver?
> I would be curious to see the result of that.
Of course, with [1] added (initial format init and querycap strings), I have
the following results. I have no idea where VIDIOC_EXPBUF failure comes from,
while the colorspace issues are a consequence from the MT9M111 sensor which
provides the couple ("VYUY", V4L2_COLORSPACE_JPEG) format (which I also don't
understand why it is a failure) :

Driver Info:
	Driver name   : pxa27x-camera
	Card type     : PXA_Camera
	Bus info      : platform:pxa-camera
	Driver version: 4.5.0
	Capabilities  : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(418): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
		test VIDIOC_QUERYCTRL: OK (Not Supported)
		test VIDIOC_G/S_CTRL: OK (Not Supported)
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 0 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		fail: v4l2-test-formats.cpp(329): pixelformat != V4L2_PIX_FMT_JPEG && colorspace == V4L2_COLORSPACE_JPEG
		fail: v4l2-test-formats.cpp(432): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)
		test VIDIOC_G_FMT: FAIL
		test VIDIOC_TRY_FMT: OK (Not Supported)
		test VIDIOC_S_FMT: OK (Not Supported)
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)
		test VIDIOC_EXPBUF: FAIL

Test input 0:

Streaming ioctls:
	test read/write: OK (Not Supported)
	test MMAP: OK (Not Supported)
	test USERPTR: OK (Not Supported)
	test DMABUF: OK (Not Supported)


Total: 46, Succeeded: 43, Failed: 3, Warnings: 0

-- 
Robert

[1] Patch on pxa_camera
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index cebab16897ce..f371260b5b7f 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -52,6 +52,9 @@
 #define PXA_CAM_VERSION "0.0.6"
 #define PXA_CAM_DRV_NAME "pxa27x-camera"
 
+#define DEFAULT_WIDTH	640
+#define DEFAULT_HEIGHT	480
+
 /* Camera Interface */
 #define CICR0		0x0000
 #define CICR1		0x0004
@@ -792,7 +795,7 @@ static int pxa_camera_init_videobuf2(struct pxa_camera_dev *pcdev)
 
 	memset(vq, 0, sizeof(*vq));
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+	vq->io_modes = VB2_MMAP | VB2_DMABUF;
 	vq->drv_priv = pcdev;
 	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	vq->buf_struct_size = sizeof(struct pxa_buffer);
@@ -1429,6 +1432,8 @@ static int pxa_camera_querycap(struct file *file, void *priv,
 			       struct v4l2_capability *cap)
 {
 	/* cap->name is set by the firendly caller:-> */
+	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
+	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -1630,6 +1635,11 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
 	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
 	struct video_device *vdev = &pcdev->vdev;
+	struct v4l2_pix_format *pix = &pcdev->current_pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &format.format;
 
 	dev_info(pcdev_to_dev(pcdev), "%s(): trying to bind a device\n",
 		 __func__);
@@ -1653,6 +1663,24 @@ static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
 		goto out;
 	}
 
+	pcdev->current_fmt = pcdev->user_formats;
+	pix->field = V4L2_FIELD_NONE;
+	pix->width = DEFAULT_WIDTH;
+	pix->height = DEFAULT_HEIGHT;
+	pix->bytesperline =
+		soc_mbus_bytes_per_line(pix->width,
+					pcdev->current_fmt->host_fmt);
+	pix->sizeimage =
+		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
+				    pix->bytesperline, pix->height);
+	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
+	v4l2_fill_mbus_format(&format.format, pix, pcdev->current_fmt->code);
+	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
+	if (err)
+		goto out;
+
+	v4l2_fill_pix_format(pix, mf);
+
 	err = pxa_camera_init_videobuf2(pcdev);
 	if (err)
 		goto out;
