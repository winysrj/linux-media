Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway07.websitewelcome.com ([67.18.36.29]:44344 "EHLO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaBLQsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 11:48:13 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway07.websitewelcome.com (Postfix) with ESMTP id 6CDC3A41D27F3
	for <linux-media@vger.kernel.org>; Wed, 12 Feb 2014 10:01:32 -0600 (CST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Feb 2014 10:01:29 -0600
From: Dean Anderson <linux-dev@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] s2255drv: upgrade to videobuf2
In-Reply-To: <52FAAD23.2010606@xs4all.nl>
References: <1392159384-30088-1-git-send-email-linux-dev@sensoray.com>
 <cd5a631056e9d46cea6f70e6231c0c33@sensoray.com> <52FAAD23.2010606@xs4all.nl>
Message-ID: <3b3175b374d23eafaf8ea226e9312d68@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"./utils/v4l2-compliance/v4l2-compliance -s"

Driver Info:
	Driver name   : s2255
	Card type     : s2255
	Bus info      : usb-0000:00:1a.7-3.6
	Driver version: 3.13.0
	Capabilities  : 0x84000001
		Video Capture
		Streaming
		Device Capabilities
	Device Caps   : 0x04000001
		Video Capture
		Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		warn: v4l2-test-controls.cpp(753): The VIDIOC_G_JPEGCOMP ioctl is 
deprecated!
		warn: v4l2-test-controls.cpp(770): The VIDIOC_S_JPEGCOMP ioctl is 
deprecated!
	test VIDIOC_G/S_JPEGCOMP: OK
	Standard Controls: 7 Private Controls: 1

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(599): TRY_FMT cannot handle an invalid 
pixelformat.
		warn: v4l2-test-formats.cpp(600): This may or may not be a problem. 
For more information see:
		warn: v4l2-test-formats.cpp(601): 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
	test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(786): S_FMT cannot handle an invalid 
pixelformat.
		warn: v4l2-test-formats.cpp(787): This may or may not be a problem. 
For more information see:
		warn: v4l2-test-formats.cpp(788): 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		warn: v4l2-test-buffers.cpp(343): VIDIOC_CREATE_BUFS not supported
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		fail: v4l2-test-buffers.cpp(379): ret < 0 && errno != EINVAL
	test read/write: FAIL
		fail: v4l2-test-buffers.cpp(537): can_stream
	test MMAP: FAIL
		fail: v4l2-test-buffers.cpp(641): can_stream
	test USERPTR: FAIL

Total: 39, Succeeded: 36, Failed: 3, Warnings: 9



On 2014-02-11 17:07, Hans Verkuil wrote:
> Hi Dean,
> 
> On 02/12/2014 12:05 AM, Dean Anderson wrote:
>> The output of v4l2-compliance looks fine.  The warnings can be 
>> ignored
>> for this patch.
> 
> Can you update to the latest v4l2-compliance that I just pushed this 
> morning?
> 
> I added support for the streaming I/O ioctls (use the -s option and 
> make sure
> that you have a valid video signal).
> 
> That will be very useful.
> 
> Regards,
> 
> 	Hans
> 
>> 
>> 
>> "./v4l2-compliance ":
>> 
>> Driver Info:
>> 	Driver name   : s2255
>> 	Card type     : s2255
>> 	Bus info      : usb-0000:00:1a.7-3.6
>> 	Driver version: 3.13.0
>> 	Capabilities  : 0x84000001
>> 		Video Capture
>> 		Streaming
>> 		Device Capabilities
>> 	Device Caps   : 0x04000001
>> 		Video Capture
>> 		Streaming
>> 
>> Compliance test for device /dev/video0 (not using libv4l2):
>> 
>> Required ioctls:
>> 	test VIDIOC_QUERYCAP: OK
>> 
>> Allow for multiple opens:
>> 	test second video open: OK
>> 	test VIDIOC_QUERYCAP: OK
>> 	test VIDIOC_G/S_PRIORITY: OK
>> 
>> Debug ioctls:
>> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>> 	test VIDIOC_LOG_STATUS: OK
>> 
>> Input ioctls:
>> 	test VIDIOC_G/S_TUNER: OK (Not Supported)
>> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
>> 	test VIDIOC_G/S/ENUMINPUT: OK
>> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
>> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
>> 
>> Output ioctls:
>> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
>> 
>> Control ioctls:
>> 	test VIDIOC_QUERYCTRL/MENU: OK
>> 	test VIDIOC_G/S_CTRL: OK
>> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>> 		warn: v4l2-test-controls.cpp(753): The VIDIOC_G_JPEGCOMP ioctl is
>> deprecated!
>> 		warn: v4l2-test-controls.cpp(770): The VIDIOC_S_JPEGCOMP ioctl is
>> deprecated!
>> 	test VIDIOC_G/S_JPEGCOMP: OK
>> 	Standard Controls: 7 Private Controls: 1
>> 
>> Input/Output configuration ioctls:
>> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK
>> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>> 
>> Format ioctls:
>> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>> 	test VIDIOC_G/S_PARM: OK
>> 	test VIDIOC_G_FBUF: OK (Not Supported)
>> 	test VIDIOC_G_FMT: OK
>> 		warn: v4l2-test-formats.cpp(598): TRY_FMT cannot handle an invalid
>> pixelformat.
>> 		warn: v4l2-test-formats.cpp(599): This may or may not be a problem.
>> For more information see:
>> 		warn: v4l2-test-formats.cpp(600):
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>> 	test VIDIOC_TRY_FMT: OK
>> 		warn: v4l2-test-formats.cpp(785): S_FMT cannot handle an invalid
>> pixelformat.
>> 		warn: v4l2-test-formats.cpp(786): This may or may not be a problem.
>> For more information see:
>> 		warn: v4l2-test-formats.cpp(787):
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>> 	test VIDIOC_S_FMT: OK
>> 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>> 
>> Codec ioctls:
>> 	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>> 	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>> 	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>> 
>> Buffer ioctls:
>> 		warn: v4l2-test-buffers.cpp(335): VIDIOC_CREATE_BUFS not supported
>> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>> 
>> Total: 36, Succeeded: 36, Failed: 0, Warnings: 9
>> 
>> 
>> 
>> On 2014-02-11 16:56, Dean Anderson wrote:
>>> Upgrade to videobuf2 libraries.
>>> 
>>> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
>>> 
>>> ---
>>>  drivers/media/usb/s2255/s2255drv.c |  507
>>> +++++++++++-------------------------
>>>  1 file changed, 148 insertions(+), 359 deletions(-)
>>> 
>>> diff --git a/drivers/media/usb/s2255/s2255drv.c
>>> b/drivers/media/usb/s2255/s2255drv.c
>>> index e0663ce..3f0d1a6 100644
>>> --- a/drivers/media/usb/s2255/s2255drv.c
>>> +++ b/drivers/media/usb/s2255/s2255drv.c
>>> @@ -45,14 +45,14 @@
>>>  #include <linux/mm.h>
>>>  #include <linux/vmalloc.h>
>>>  #include <linux/usb.h>
>>> -#include <media/videobuf-vmalloc.h>
>>> +#include <media/videobuf2-vmalloc.h>
>>>  #include <media/v4l2-common.h>
>>>  #include <media/v4l2-device.h>
>>>  #include <media/v4l2-ioctl.h>
>>>  #include <media/v4l2-ctrls.h>
>>>  #include <media/v4l2-event.h>
>>> 
>>> -#define S2255_VERSION		"1.24.1"
>>> +#define S2255_VERSION		"1.25.1"
>>>  #define FIRMWARE_FILE_NAME "f2255usb.bin"
>>> 
>>>  /* default JPEG quality */
>>> @@ -229,8 +229,6 @@ struct s2255_vc {
>>>  	struct v4l2_captureparm cap_parm;
>>>  	int			cur_frame;
>>>  	int			last_frame;
>>> -
>>> -	int			b_acquire;
>>>  	/* allocated image size */
>>>  	unsigned long		req_image_size;
>>>  	/* received packet size */
>>> @@ -249,8 +247,12 @@ struct s2255_vc {
>>>  	int                     vidstatus_ready;
>>>  	unsigned int		width;
>>>  	unsigned int		height;
>>> +	enum v4l2_field         field;
>>>  	const struct s2255_fmt	*fmt;
>>>  	int idx; /* channel number on device, 0-3 */
>>> +	struct vb2_queue vb_vidq;
>>> +	struct mutex vb_lock; /* streaming lock */
>>> +	spinlock_t qlock;
>>>  };
>>> 
>>> 
>>> @@ -270,7 +272,6 @@ struct s2255_dev {
>>>  	u32			cc;	/* current channel */
>>>  	int			frame_ready;
>>>  	int                     chn_ready;
>>> -	spinlock_t              slock;
>>>  	/* dsp firmware version (f2255usb.bin) */
>>>  	int                     dsp_fw_ver;
>>>  	u16                     pid; /* product id */
>>> @@ -292,16 +293,10 @@ struct s2255_fmt {
>>>  /* buffer for one video frame */
>>>  struct s2255_buffer {
>>>  	/* common v4l buffer stuff -- must be first */
>>> -	struct videobuf_buffer vb;
>>> +	struct vb2_buffer vb;
>>> +	struct list_head list;
>>>  };
>>> 
>>> -struct s2255_fh {
>>> -	/* this must be the first field in this struct */
>>> -	struct v4l2_fh		fh;
>>> -	struct videobuf_queue	vb_vidq;
>>> -	struct s2255_vc	*vc;
>>> -	int			resources;
>>> -};
>>> 
>>>  /* current cypress EEPROM firmware version */
>>>  #define S2255_CUR_USB_FWVER	((3 << 8) | 12)
>>> @@ -569,21 +564,20 @@ static int s2255_got_frame(struct s2255_vc 
>>> *vc,
>>> int jpgsize)
>>>  	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
>>>  	unsigned long flags = 0;
>>>  	int rc = 0;
>>> -	spin_lock_irqsave(&dev->slock, flags);
>>> +	spin_lock_irqsave(&vc->qlock, flags);
>>>  	if (list_empty(&vc->buf_list)) {
>>>  		dprintk(dev, 1, "No active queue to serve\n");
>>>  		rc = -1;
>>>  		goto unlock;
>>>  	}
>>>  	buf = list_entry(vc->buf_list.next,
>>> -			 struct s2255_buffer, vb.queue);
>>> -	list_del(&buf->vb.queue);
>>> -	v4l2_get_timestamp(&buf->vb.ts);
>>> +			 struct s2255_buffer, list);
>>> +	list_del(&buf->list);
>>> +	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
>>>  	s2255_fillbuff(vc, buf, jpgsize);
>>> -	wake_up(&buf->vb.done);
>>> -	dprintk(dev, 2, "%s: [buf/i] [%p/%d]\n", __func__, buf, 
>>> buf->vb.i);
>>> +	dprintk(dev, 2, "%s: [buf] [%p]\n", __func__, buf);
>>>  unlock:
>>> -	spin_unlock_irqrestore(&dev->slock, flags);
>>> +	spin_unlock_irqrestore(&vc->qlock, flags);
>>>  	return rc;
>>>  }
>>> 
>>> @@ -615,7 +609,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
>>>  {
>>>  	int pos = 0;
>>>  	const char *tmpbuf;
>>> -	char *vbuf = videobuf_to_vmalloc(&buf->vb);
>>> +	char *vbuf = vb2_plane_vaddr(&buf->vb, 0);
>>>  	unsigned long last_frame;
>>>  	struct s2255_dev *dev = vc->dev;
>>> 
>>> @@ -629,21 +623,21 @@ static void s2255_fillbuff(struct s2255_vc 
>>> *vc,
>>>  		case V4L2_PIX_FMT_YUYV:
>>>  		case V4L2_PIX_FMT_UYVY:
>>>  			planar422p_to_yuv_packed((const unsigned char *)tmpbuf,
>>> -						 vbuf, buf->vb.width,
>>> -						 buf->vb.height,
>>> +						 vbuf, vc->width,
>>> +						 vc->height,
>>>  						 vc->fmt->fourcc);
>>>  			break;
>>>  		case V4L2_PIX_FMT_GREY:
>>> -			memcpy(vbuf, tmpbuf, buf->vb.width * buf->vb.height);
>>> +			memcpy(vbuf, tmpbuf, vc->width * vc->height);
>>>  			break;
>>>  		case V4L2_PIX_FMT_JPEG:
>>>  		case V4L2_PIX_FMT_MJPEG:
>>> -			buf->vb.size = jpgsize;
>>> -			memcpy(vbuf, tmpbuf, buf->vb.size);
>>> +			buf->vb.v4l2_buf.length = jpgsize;
>>> +			memcpy(vbuf, tmpbuf, jpgsize);
>>>  			break;
>>>  		case V4L2_PIX_FMT_YUV422P:
>>>  			memcpy(vbuf, tmpbuf,
>>> -			       buf->vb.width * buf->vb.height * 2);
>>> +			       vc->width * vc->height * 2);
>>>  			break;
>>>  		default:
>>>  			pr_info("s2255: unknown format?\n");
>>> @@ -656,9 +650,10 @@ static void s2255_fillbuff(struct s2255_vc *vc,
>>>  	dprintk(dev, 2, "s2255fill at : Buffer 0x%08lx size= %d\n",
>>>  		(unsigned long)vbuf, pos);
>>>  	/* tell v4l buffer was filled */
>>> -	buf->vb.field_count = vc->frame_count * 2;
>>> -	v4l2_get_timestamp(&buf->vb.ts);
>>> -	buf->vb.state = VIDEOBUF_DONE;
>>> +	buf->vb.v4l2_buf.field = vc->field;
>>> +	buf->vb.v4l2_buf.sequence = vc->frame_count;
>>> +	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
>>> +	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>>>  }
>>> 
>>> 
>>> @@ -666,36 +661,27 @@ static void s2255_fillbuff(struct s2255_vc 
>>> *vc,
>>>     Videobuf operations
>>> 
>>> ------------------------------------------------------------------*/
>>> 
>>> -static int buffer_setup(struct videobuf_queue *vq, unsigned int
>>> *nbuffers,
>>> -			unsigned int *size)
>>> +static int queue_setup(struct vb2_queue *vq, const struct 
>>> v4l2_format
>>> *fmt,
>>> +		       unsigned int *nbuffers, unsigned int *nplanes,
>>> +		       unsigned int sizes[], void *alloc_ctxs[])
>>>  {
>>> -	struct s2255_fh *fh = vq->priv_data;
>>> -	struct s2255_vc *vc = fh->vc;
>>> -
>>> -	*size = vc->width * vc->height * (vc->fmt->depth >> 3);
>>> -
>>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>>>  	if (*nbuffers < S2255_MIN_BUFS)
>>>  		*nbuffers = S2255_MIN_BUFS;
>>> -
>>> +	*nplanes = 1;
>>> +	sizes[0] = vc->width * vc->height * (vc->fmt->depth >> 3);
>>>  	return 0;
>>>  }
>>> 
>>> -static void free_buffer(struct videobuf_queue *vq, struct
>>> s2255_buffer *buf)
>>> -{
>>> -	videobuf_vmalloc_free(&buf->vb);
>>> -	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>>> -}
>>> -
>>> -static int buffer_prepare(struct videobuf_queue *vq, struct
>>> videobuf_buffer *vb,
>>> -			  enum v4l2_field field)
>>> +static int buffer_prepare(struct vb2_buffer *vb)
>>>  {
>>> -	struct s2255_fh *fh = vq->priv_data;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
>>>  	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer,
>>> vb);
>>> -	int rc;
>>>  	int w = vc->width;
>>>  	int h = vc->height;
>>> -	dprintk(vc->dev, 4, "%s, field=%d\n", __func__, field);
>>> +	unsigned long size;
>>> +
>>> +	dprintk(vc->dev, 4, "%s\n", __func__);
>>>  	if (vc->fmt == NULL)
>>>  		return -EINVAL;
>>> 
>>> @@ -706,93 +692,45 @@ static int buffer_prepare(struct 
>>> videobuf_queue
>>> *vq, struct videobuf_buffer *vb,
>>>  		dprintk(vc->dev, 4, "invalid buffer prepare\n");
>>>  		return -EINVAL;
>>>  	}
>>> -	buf->vb.size = w * h * (vc->fmt->depth >> 3);
>>> -	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
>>> +	size = w * h * (vc->fmt->depth >> 3);
>>> +	if (vb2_plane_size(vb, 0) < size) {
>>>  		dprintk(vc->dev, 4, "invalid buffer prepare\n");
>>>  		return -EINVAL;
>>>  	}
>>> 
>>> -	buf->vb.width = w;
>>> -	buf->vb.height = h;
>>> -	buf->vb.field = field;
>>> -
>>> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
>>> -		rc = videobuf_iolock(vq, &buf->vb, NULL);
>>> -		if (rc < 0)
>>> -			goto fail;
>>> -	}
>>> -
>>> -	buf->vb.state = VIDEOBUF_PREPARED;
>>> +	vb2_set_plane_payload(&buf->vb, 0, size);
>>>  	return 0;
>>> -fail:
>>> -	free_buffer(vq, buf);
>>> -	return rc;
>>>  }
>>> 
>>> -static void buffer_queue(struct videobuf_queue *vq, struct
>>> videobuf_buffer *vb)
>>> +static void buffer_queue(struct vb2_buffer *vb)
>>>  {
>>>  	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer,
>>> vb);
>>> -	struct s2255_fh *fh = vq->priv_data;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = vb2_get_drv_priv(vb->vb2_queue);
>>> +	unsigned long flags = 0;
>>>  	dprintk(vc->dev, 1, "%s\n", __func__);
>>> -	buf->vb.state = VIDEOBUF_QUEUED;
>>> -	list_add_tail(&buf->vb.queue, &vc->buf_list);
>>> +	spin_lock_irqsave(&vc->qlock, flags);
>>> +	list_add_tail(&buf->list, &vc->buf_list);
>>> +	spin_unlock_irqrestore(&vc->qlock, flags);
>>>  }
>>> 
>>> -static void buffer_release(struct videobuf_queue *vq,
>>> -			   struct videobuf_buffer *vb)
>>> -{
>>> -	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer,
>>> vb);
>>> -	struct s2255_fh *fh = vq->priv_data;
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	dprintk(vc->dev, 4, "%s %d\n", __func__, vc->idx);
>>> -	free_buffer(vq, buf);
>>> -}
>>> +static int start_streaming(struct vb2_queue *vq, unsigned int 
>>> count);
>>> +static int stop_streaming(struct vb2_queue *vq);
>>> 
>>> -static struct videobuf_queue_ops s2255_video_qops = {
>>> -	.buf_setup = buffer_setup,
>>> +static struct vb2_ops s2255_video_qops = {
>>> +	.queue_setup = queue_setup,
>>>  	.buf_prepare = buffer_prepare,
>>>  	.buf_queue = buffer_queue,
>>> -	.buf_release = buffer_release,
>>> +	.start_streaming = start_streaming,
>>> +	.stop_streaming = stop_streaming,
>>> +	.wait_prepare = vb2_ops_wait_prepare,
>>> +	.wait_finish = vb2_ops_wait_finish,
>>>  };
>>> 
>>> -
>>> -static int res_get(struct s2255_fh *fh)
>>> -{
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	/* is it free? */
>>> -	if (vc->resources)
>>> -		return 0; /* no, someone else uses it */
>>> -	/* it's free, grab it */
>>> -	vc->resources = 1;
>>> -	fh->resources = 1;
>>> -	dprintk(vc->dev, 1, "s2255: res: get\n");
>>> -	return 1;
>>> -}
>>> -
>>> -static int res_locked(struct s2255_fh *fh)
>>> -{
>>> -	return fh->vc->resources;
>>> -}
>>> -
>>> -static int res_check(struct s2255_fh *fh)
>>> -{
>>> -	return fh->resources;
>>> -}
>>> -
>>> -
>>> -static void res_free(struct s2255_fh *fh)
>>> -{
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	vc->resources = 0;
>>> -	fh->resources = 0;
>>> -}
>>> -
>>>  static int vidioc_querycap(struct file *file, void *priv,
>>>  			   struct v4l2_capability *cap)
>>>  {
>>> -	struct s2255_fh *fh = file->private_data;
>>> -	struct s2255_dev *dev = fh->vc->dev;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>> +	struct s2255_dev *dev = vc->dev;
>>> 
>>>  	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
>>>  	strlcpy(cap->card, "s2255", sizeof(cap->card));
>>> @@ -820,8 +758,7 @@ static int vidioc_enum_fmt_vid_cap(struct file
>>> *file, void *priv,
>>>  static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>>  			    struct v4l2_format *f)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	int is_ntsc = vc->std & V4L2_STD_525_60;
>>> 
>>>  	f->fmt.pix.width = vc->width;
>>> @@ -844,8 +781,7 @@ static int vidioc_try_fmt_vid_cap(struct file
>>> *file, void *priv,
>>>  {
>>>  	const struct s2255_fmt *fmt;
>>>  	enum v4l2_field field;
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	int is_ntsc = vc->std & V4L2_STD_525_60;
>>> 
>>>  	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
>>> @@ -905,14 +841,13 @@ static int vidioc_try_fmt_vid_cap(struct file
>>> *file, void *priv,
>>>  static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>>>  			    struct v4l2_format *f)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	const struct s2255_fmt *fmt;
>>> -	struct videobuf_queue *q = &fh->vb_vidq;
>>> +	struct vb2_queue *q = &vc->vb_vidq;
>>>  	struct s2255_mode mode;
>>>  	int ret;
>>> 
>>> -	ret = vidioc_try_fmt_vid_cap(file, fh, f);
>>> +	ret = vidioc_try_fmt_vid_cap(file, vc, f);
>>> 
>>>  	if (ret < 0)
>>>  		return ret;
>>> @@ -922,24 +857,16 @@ static int vidioc_s_fmt_vid_cap(struct file
>>> *file, void *priv,
>>>  	if (fmt == NULL)
>>>  		return -EINVAL;
>>> 
>>> -	mutex_lock(&q->vb_lock);
>>> -
>>> -	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
>>> +	if (vb2_is_busy(q)) {
>>>  		dprintk(vc->dev, 1, "queue busy\n");
>>> -		ret = -EBUSY;
>>> -		goto out_s_fmt;
>>> +		return -EBUSY;
>>>  	}
>>> 
>>> -	if (res_locked(fh)) {
>>> -		dprintk(vc->dev, 1, "%s: channel busy\n", __func__);
>>> -		ret = -EBUSY;
>>> -		goto out_s_fmt;
>>> -	}
>>>  	mode = vc->mode;
>>>  	vc->fmt = fmt;
>>>  	vc->width = f->fmt.pix.width;
>>>  	vc->height = f->fmt.pix.height;
>>> -	fh->vb_vidq.field = f->fmt.pix.field;
>>> +	vc->field = f->fmt.pix.field;
>>>  	if (vc->width > norm_minw(vc)) {
>>>  		if (vc->height > norm_minh(vc)) {
>>>  			if (vc->cap_parm.capturemode &
>>> @@ -984,44 +911,9 @@ static int vidioc_s_fmt_vid_cap(struct file
>>> *file, void *priv,
>>>  		mode.restart = 1;
>>>  	vc->mode = mode;
>>>  	(void) s2255_set_mode(vc, &mode);
>>> -	ret = 0;
>>> -out_s_fmt:
>>> -	mutex_unlock(&q->vb_lock);
>>> -	return ret;
>>> -}
>>> -
>>> -static int vidioc_reqbufs(struct file *file, void *priv,
>>> -			  struct v4l2_requestbuffers *p)
>>> -{
>>> -	int rc;
>>> -	struct s2255_fh *fh = priv;
>>> -	rc = videobuf_reqbufs(&fh->vb_vidq, p);
>>> -	return rc;
>>> -}
>>> -
>>> -static int vidioc_querybuf(struct file *file, void *priv, struct
>>> v4l2_buffer *p)
>>> -{
>>> -	int rc;
>>> -	struct s2255_fh *fh = priv;
>>> -	rc = videobuf_querybuf(&fh->vb_vidq, p);
>>> -	return rc;
>>> -}
>>> -
>>> -static int vidioc_qbuf(struct file *file, void *priv, struct
>>> v4l2_buffer *p)
>>> -{
>>> -	int rc;
>>> -	struct s2255_fh *fh = priv;
>>> -	rc = videobuf_qbuf(&fh->vb_vidq, p);
>>> -	return rc;
>>> +	return 0;
>>>  }
>>> 
>>> -static int vidioc_dqbuf(struct file *file, void *priv, struct
>>> v4l2_buffer *p)
>>> -{
>>> -	int rc;
>>> -	struct s2255_fh *fh = priv;
>>> -	rc = videobuf_dqbuf(&fh->vb_vidq, p, file->f_flags & O_NONBLOCK);
>>> -	return rc;
>>> -}
>>> 
>>>  /* write to the configuration pipe, synchronously */
>>>  static int s2255_write_config(struct usb_device *udev, unsigned 
>>> char
>>> *pbuf,
>>> @@ -1199,24 +1091,11 @@ static int s2255_cmd_status(struct s2255_vc
>>> *vc, u32 *pstatus)
>>>  	return res;
>>>  }
>>> 
>>> -static int vidioc_streamon(struct file *file, void *priv, enum
>>> v4l2_buf_type i)
>>> +static int start_streaming(struct vb2_queue *vq, unsigned int 
>>> count)
>>>  {
>>> -	int res;
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	struct s2255_dev *dev = vc->dev;
>>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>>>  	int j;
>>> 
>>> -	dprintk(dev, 4, "%s\n", __func__);
>>> -	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
>>> -		dev_err(&dev->udev->dev, "invalid fh type1\n");
>>> -		return -EINVAL;
>>> -	}
>>> -
>>> -	if (!res_get(fh)) {
>>> -		s2255_dev_err(&dev->udev->dev, "stream busy\n");
>>> -		return -EBUSY;
>>> -	}
>>>  	vc->last_frame = -1;
>>>  	vc->bad_payload = 0;
>>>  	vc->cur_frame = 0;
>>> @@ -1225,48 +1104,40 @@ static int vidioc_streamon(struct file 
>>> *file,
>>> void *priv, enum v4l2_buf_type i)
>>>  		vc->buffer.frame[j].ulState = S2255_READ_IDLE;
>>>  		vc->buffer.frame[j].cur_size = 0;
>>>  	}
>>> -	res = videobuf_streamon(&fh->vb_vidq);
>>> -	if (res != 0) {
>>> -		res_free(fh);
>>> -		return res;
>>> -	}
>>> -	res = s2255_start_acquire(vc);
>>> -	if (res != 0) {
>>> -		res_free(fh);
>>> -		return res;
>>> -	}
>>> -	vc->b_acquire = 1;
>>> -	return res;
>>> +	return s2255_start_acquire(vc);
>>>  }
>>> 
>>> -static int vidioc_streamoff(struct file *file, void *priv, enum
>>> v4l2_buf_type i)
>>> +/* abort streaming and wait for last buffer */
>>> +static int stop_streaming(struct vb2_queue *vq)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	dprintk(vc->dev, 4, "%s\n, channel: %d", __func__, vc->idx);
>>> -
>>> -	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>> -		return -EINVAL;
>>> -	s2255_stop_acquire(vc);
>>> -	videobuf_streamoff(&fh->vb_vidq);
>>> -	res_free(fh);
>>> +	struct s2255_vc *vc = vb2_get_drv_priv(vq);
>>> +	struct s2255_buffer *buf, *node;
>>> +	unsigned long flags;
>>> +	(void) s2255_stop_acquire(vc);
>>> +	spin_lock_irqsave(&vc->qlock, flags);
>>> +	list_for_each_entry_safe(buf, node, &vc->buf_list, list) {
>>> +		list_del(&buf->list);
>>> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>> +		dprintk(vc->dev, 2, "[%p/%d] done\n",
>>> +			buf, buf->vb.v4l2_buf.index);
>>> +	}
>>> +	spin_unlock_irqrestore(&vc->qlock, flags);
>>>  	return 0;
>>>  }
>>> 
>>>  static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id 
>>> i)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	struct s2255_mode mode;
>>> -	struct videobuf_queue *q = &fh->vb_vidq;
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	int ret = 0;
>>> +	struct vb2_queue *q = &vc->vb_vidq;
>>> +
>>> +	/*
>>> +	 * Changing the standard implies a format change, which is not
>>> allowed
>>> +	 * while buffers for use with streaming have already been 
>>> allocated.
>>> +	 */
>>> +	if (vb2_is_busy(q))
>>> +		return -EBUSY;
>>> 
>>> -	mutex_lock(&q->vb_lock);
>>> -	if (res_locked(fh)) {
>>> -		dprintk(vc->dev, 1, "can't change standard after started\n");
>>> -		ret = -EBUSY;
>>> -		goto out_s_std;
>>> -	}
>>>  	mode = vc->mode;
>>>  	if (i & V4L2_STD_525_60) {
>>>  		dprintk(vc->dev, 4, "%s 60 Hz\n", __func__);
>>> @@ -1287,22 +1158,17 @@ static int vidioc_s_std(struct file *file,
>>> void *priv, v4l2_std_id i)
>>>  			vc->width = LINE_SZ_4CIFS_PAL;
>>>  			vc->height = NUM_LINES_4CIFS_PAL * 2;
>>>  		}
>>> -	} else {
>>> -		ret = -EINVAL;
>>> -		goto out_s_std;
>>> -	}
>>> +	} else
>>> +		return -EINVAL;
>>>  	vc->std = i;
>>>  	if (mode.restart)
>>>  		s2255_set_mode(vc, &mode);
>>> -out_s_std:
>>> -	mutex_unlock(&q->vb_lock);
>>> -	return ret;
>>> +	return 0;
>>>  }
>>> 
>>>  static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id
>>> *i)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>> 
>>>  	*i = vc->std;
>>>  	return 0;
>>> @@ -1318,8 +1184,7 @@ static int vidioc_g_std(struct file *file, 
>>> void
>>> *priv, v4l2_std_id *i)
>>>  static int vidioc_enum_input(struct file *file, void *priv,
>>>  			     struct v4l2_input *inp)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	struct s2255_dev *dev = vc->dev;
>>>  	u32 status = 0;
>>> 
>>> @@ -1404,8 +1269,7 @@ static int s2255_s_ctrl(struct v4l2_ctrl 
>>> *ctrl)
>>>  static int vidioc_g_jpegcomp(struct file *file, void *priv,
>>>  			 struct v4l2_jpegcompression *jc)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>> 
>>>  	memset(jc, 0, sizeof(*jc));
>>>  	jc->quality = vc->jpegqual;
>>> @@ -1416,8 +1280,8 @@ static int vidioc_g_jpegcomp(struct file 
>>> *file,
>>> void *priv,
>>>  static int vidioc_s_jpegcomp(struct file *file, void *priv,
>>>  			 const struct v4l2_jpegcompression *jc)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>> +
>>>  	if (jc->quality < 0 || jc->quality > 100)
>>>  		return -EINVAL;
>>>  	v4l2_ctrl_s_ctrl(vc->jpegqual_ctrl, jc->quality);
>>> @@ -1428,9 +1292,9 @@ static int vidioc_s_jpegcomp(struct file 
>>> *file,
>>> void *priv,
>>>  static int vidioc_g_parm(struct file *file, void *priv,
>>>  			 struct v4l2_streamparm *sp)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>>  	__u32 def_num, def_dem;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>> +
>>>  	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>  		return -EINVAL;
>>>  	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> @@ -1464,8 +1328,7 @@ static int vidioc_g_parm(struct file *file, 
>>> void
>>> *priv,
>>>  static int vidioc_s_parm(struct file *file, void *priv,
>>>  			 struct v4l2_streamparm *sp)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	struct s2255_mode mode;
>>>  	int fdec = FDEC_1;
>>>  	__u32 def_num, def_dem;
>>> @@ -1473,8 +1336,8 @@ static int vidioc_s_parm(struct file *file, 
>>> void
>>> *priv,
>>>  		return -EINVAL;
>>>  	mode = vc->mode;
>>>  	/* high quality capture mode requires a stream restart */
>>> -	if (vc->cap_parm.capturemode
>>> -	    != sp->parm.capture.capturemode && res_locked(fh))
>>> +	if ((vc->cap_parm.capturemode != sp->parm.capture.capturemode)
>>> +	    && vb2_is_streaming(&vc->vb_vidq))
>>>  		return -EBUSY;
>>>  	def_num = (mode.format == FORMAT_NTSC) ? 1001 : 1000;
>>>  	def_dem = (mode.format == FORMAT_NTSC) ? 30000 : 25000;
>>> @@ -1518,8 +1381,7 @@ static const struct v4l2_frmsize_discrete
>>> pal_sizes[] = {
>>>  static int vidioc_enum_framesizes(struct file *file, void *priv,
>>>  			    struct v4l2_frmsizeenum *fe)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	int is_ntsc = vc->std & V4L2_STD_525_60;
>>>  	const struct s2255_fmt *fmt;
>>> 
>>> @@ -1537,8 +1399,7 @@ static int vidioc_enum_framesizes(struct file
>>> *file, void *priv,
>>>  static int vidioc_enum_frameintervals(struct file *file, void 
>>> *priv,
>>>  			    struct v4l2_frmivalenum *fe)
>>>  {
>>> -	struct s2255_fh *fh = priv;
>>> -	struct s2255_vc *vc = fh->vc;
>>> +	struct s2255_vc *vc = video_drvdata(file);
>>>  	const struct s2255_fmt *fmt;
>>>  	const struct v4l2_frmsize_discrete *sizes;
>>>  	int is_ntsc = vc->std & V4L2_STD_525_60;
>>> @@ -1570,16 +1431,18 @@ static int vidioc_enum_frameintervals(struct
>>> file *file, void *priv,
>>>  	return 0;
>>>  }
>>> 
>>> -static int __s2255_open(struct file *file)
>>> +static int s2255_open(struct file *file)
>>>  {
>>> -	struct video_device *vdev = video_devdata(file);
>>>  	struct s2255_vc *vc = video_drvdata(file);
>>> -	struct s2255_dev *dev = to_s2255_dev(vdev->v4l2_dev);
>>> -	struct s2255_fh *fh;
>>> -	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +	struct s2255_dev *dev = vc->dev;
>>>  	int state;
>>> -	dprintk(dev, 1, "s2255: open called (dev=%s)\n",
>>> -		video_device_node_name(vdev));
>>> +	int rc = 0;
>>> +
>>> +	rc = v4l2_fh_open(file);
>>> +	if (rc != 0)
>>> +		return rc;
>>> +
>>> +	dprintk(dev, 1, "s2255: %s\n", __func__);
>>>  	state = atomic_read(&dev->fw_data->fw_state);
>>>  	switch (state) {
>>>  	case S2255_FW_DISCONNECTING:
>>> @@ -1641,61 +1504,15 @@ static int __s2255_open(struct file *file)
>>>  		pr_info("%s: unknown state\n", __func__);
>>>  		return -EFAULT;
>>>  	}
>>> -	/* allocate + initialize per filehandle data */
>>> -	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
>>> -	if (NULL == fh)
>>> -		return -ENOMEM;
>>> -	v4l2_fh_init(&fh->fh, vdev);
>>> -	v4l2_fh_add(&fh->fh);
>>> -	file->private_data = &fh->fh;
>>> -	fh->vc = vc;
>>>  	if (!vc->configured) {
>>>  		/* configure channel to default state */
>>>  		vc->fmt = &formats[0];
>>>  		s2255_set_mode(vc, &vc->mode);
>>>  		vc->configured = 1;
>>>  	}
>>> -	dprintk(dev, 1, "%s: dev=%s type=%s\n", __func__,
>>> -		video_device_node_name(vdev), v4l2_type_names[type]);
>>> -	dprintk(dev, 2, "%s: fh=0x%08lx, dev=0x%08lx\n", __func__,
>>> -		(unsigned long)fh, (unsigned long)dev);
>>> -	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
>>> -		list_empty(&vc->buf_list));
>>> -	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
>>> -				    NULL, &dev->slock,
>>> -				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
>>> -				    V4L2_FIELD_INTERLACED,
>>> -				    sizeof(struct s2255_buffer),
>>> -				    fh, vdev->lock);
>>>  	return 0;
>>>  }
>>> 
>>> -static int s2255_open(struct file *file)
>>> -{
>>> -	struct video_device *vdev = video_devdata(file);
>>> -	int ret;
>>> -
>>> -	if (mutex_lock_interruptible(vdev->lock))
>>> -		return -ERESTARTSYS;
>>> -	ret = __s2255_open(file);
>>> -	mutex_unlock(vdev->lock);
>>> -	return ret;
>>> -}
>>> -
>>> -static unsigned int s2255_poll(struct file *file,
>>> -			       struct poll_table_struct *wait)
>>> -{
>>> -	struct s2255_fh *fh = file->private_data;
>>> -	struct s2255_dev *dev = fh->vc->dev;
>>> -	int rc = v4l2_ctrl_poll(file, wait);
>>> -
>>> -	dprintk(dev, 100, "%s\n", __func__);
>>> -	mutex_lock(&dev->lock);
>>> -	rc |= videobuf_poll_stream(file, &fh->vb_vidq, wait);
>>> -	mutex_unlock(&dev->lock);
>>> -	return rc;
>>> -}
>>> -
>>>  static void s2255_destroy(struct s2255_dev *dev)
>>>  {
>>>  	dprintk(dev, 1, "%s", __func__);
>>> @@ -1720,59 +1537,14 @@ static void s2255_destroy(struct s2255_dev
>>> *dev)
>>>  	kfree(dev);
>>>  }
>>> 
>>> -static int s2255_release(struct file *file)
>>> -{
>>> -	struct s2255_fh *fh = file->private_data;
>>> -	struct video_device *vdev = video_devdata(file);
>>> -	struct s2255_vc *vc = fh->vc;
>>> -	struct s2255_dev *dev = vc->dev;
>>> -
>>> -	if (!dev)
>>> -		return -ENODEV;
>>> -	mutex_lock(&dev->lock);
>>> -	/* turn off stream */
>>> -	if (res_check(fh)) {
>>> -		if (vc->b_acquire)
>>> -			s2255_stop_acquire(vc);
>>> -		videobuf_streamoff(&fh->vb_vidq);
>>> -		res_free(fh);
>>> -	}
>>> -	videobuf_mmap_free(&fh->vb_vidq);
>>> -	mutex_unlock(&dev->lock);
>>> -	dprintk(dev, 1, "%s[%s]\n", __func__, 
>>> video_device_node_name(vdev));
>>> -	v4l2_fh_del(&fh->fh);
>>> -	v4l2_fh_exit(&fh->fh);
>>> -	kfree(fh);
>>> -	return 0;
>>> -}
>>> -
>>> -static int s2255_mmap_v4l(struct file *file, struct vm_area_struct
>>> *vma)
>>> -{
>>> -	struct s2255_fh *fh = file->private_data;
>>> -	struct s2255_dev *dev;
>>> -	int ret;
>>> -
>>> -	if (!fh)
>>> -		return -ENODEV;
>>> -	dev = fh->vc->dev;
>>> -	dprintk(dev, 4, "%s, vma=0x%08lx\n", __func__, (unsigned 
>>> long)vma);
>>> -	if (mutex_lock_interruptible(&dev->lock))
>>> -		return -ERESTARTSYS;
>>> -	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
>>> -	mutex_unlock(&dev->lock);
>>> -	dprintk(dev, 4, "%s vma start=0x%08lx, size=%ld, ret=%d\n",
>>> __func__,
>>> -		(unsigned long)vma->vm_start,
>>> -		(unsigned long)vma->vm_end - (unsigned long)vma->vm_start, ret);
>>> -	return ret;
>>> -}
>>> -
>>>  static const struct v4l2_file_operations s2255_fops_v4l = {
>>>  	.owner = THIS_MODULE,
>>>  	.open = s2255_open,
>>> -	.release = s2255_release,
>>> -	.poll = s2255_poll,
>>> +	.release = vb2_fop_release,
>>> +	.poll = vb2_fop_poll,
>>>  	.unlocked_ioctl = video_ioctl2,	/* V4L2 ioctl handler */
>>> -	.mmap = s2255_mmap_v4l,
>>> +	.mmap = vb2_fop_mmap,
>>> +	.read = vb2_fop_read,
>>>  };
>>> 
>>>  static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
>>> @@ -1781,17 +1553,17 @@ static const struct v4l2_ioctl_ops
>>> s2255_ioctl_ops = {
>>>  	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
>>>  	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
>>>  	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
>>> -	.vidioc_reqbufs = vidioc_reqbufs,
>>> -	.vidioc_querybuf = vidioc_querybuf,
>>> -	.vidioc_qbuf = vidioc_qbuf,
>>> -	.vidioc_dqbuf = vidioc_dqbuf,
>>> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>>>  	.vidioc_s_std = vidioc_s_std,
>>>  	.vidioc_g_std = vidioc_g_std,
>>>  	.vidioc_enum_input = vidioc_enum_input,
>>>  	.vidioc_g_input = vidioc_g_input,
>>>  	.vidioc_s_input = vidioc_s_input,
>>> -	.vidioc_streamon = vidioc_streamon,
>>> -	.vidioc_streamoff = vidioc_streamoff,
>>> +	.vidioc_streamon = vb2_ioctl_streamon,
>>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>>>  	.vidioc_s_jpegcomp = vidioc_s_jpegcomp,
>>>  	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
>>>  	.vidioc_s_parm = vidioc_s_parm,
>>> @@ -1847,6 +1619,8 @@ static int s2255_probe_v4l(struct s2255_dev
>>> *dev)
>>>  	int i;
>>>  	int cur_nr = video_nr;
>>>  	struct s2255_vc *vc;
>>> +	struct vb2_queue *q;
>>> +
>>>  	ret = v4l2_device_register(&dev->interface->dev, &dev->v4l2_dev);
>>>  	if (ret)
>>>  		return ret;
>>> @@ -1879,8 +1653,24 @@ static int s2255_probe_v4l(struct s2255_dev
>>> *dev)
>>>  			dev_err(&dev->udev->dev, "couldn't register control\n");
>>>  			break;
>>>  		}
>>> -		/* register 4 video devices */
>>> +		q = &vc->vb_vidq;
>>> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +		q->io_modes = VB2_MMAP | VB2_READ | VB2_USERPTR;
>>> +		q->drv_priv = vc;
>>> +		q->lock = &vc->vb_lock;
>>> +		q->buf_struct_size = sizeof(struct s2255_buffer);
>>> +		q->mem_ops = &vb2_vmalloc_memops;
>>> +		q->ops = &s2255_video_qops;
>>> +		q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>>> +		ret = vb2_queue_init(q);
>>> +		if (ret != 0) {
>>> +			dev_err(&dev->udev->dev,
>>> +				"%s vb2_queue_init 0x%x\n", __func__, ret);
>>> +			break;
>>> +		}
>>> +		/* register video devices */
>>>  		vc->vdev = template;
>>> +		vc->vdev.queue = q;
>>>  		vc->vdev.ctrl_handler = &vc->hdl;
>>>  		vc->vdev.lock = &dev->lock;
>>>  		vc->vdev.v4l2_dev = &dev->v4l2_dev;
>>> @@ -2029,7 +1819,7 @@ static int save_frame(struct s2255_dev *dev,
>>> struct s2255_pipeinfo *pipe_info)
>>>  	idx = vc->cur_frame;
>>>  	frm = &vc->buffer.frame[idx];
>>>  	/* search done.  now find out if should be acquiring on this 
>>> channel
>>> */
>>> -	if (!vc->b_acquire) {
>>> +	if (!vb2_is_streaming(&vc->vb_vidq)) {
>>>  		/* we found a frame, but this channel is turned off */
>>>  		frm->ulState = S2255_READ_IDLE;
>>>  		return -EINVAL;
>>> @@ -2073,7 +1863,7 @@ static int save_frame(struct s2255_dev *dev,
>>> struct s2255_pipeinfo *pipe_info)
>>>  		    (vc->cur_frame == vc->buffer.dwFrames))
>>>  			vc->cur_frame = 0;
>>>  		/* frame ready */
>>> -		if (vc->b_acquire)
>>> +		if (vb2_is_streaming(&vc->vb_vidq))
>>>  			s2255_got_frame(vc, vc->jpg_size);
>>>  		vc->frame_count++;
>>>  		frm->ulState = S2255_READ_IDLE;
>>> @@ -2222,7 +2012,6 @@ static int s2255_board_init(struct s2255_dev
>>> *dev)
>>> 
>>>  	for (j = 0; j < MAX_CHANNELS; j++) {
>>>  		struct s2255_vc *vc = &dev->vc[j];
>>> -		vc->b_acquire = 0;
>>>  		vc->mode = mode_def;
>>>  		if (dev->pid == 0x2257 && j > 1)
>>>  			vc->mode.color |= (1 << 16);
>>> @@ -2249,7 +2038,7 @@ static int s2255_board_shutdown(struct 
>>> s2255_dev
>>> *dev)
>>>  	dprintk(dev, 1, "%s: dev: %p", __func__,  dev);
>>> 
>>>  	for (i = 0; i < MAX_CHANNELS; i++) {
>>> -		if (dev->vc[i].b_acquire)
>>> +		if (vb2_is_streaming(&dev->vc[i].vb_vidq))
>>>  			s2255_stop_acquire(&dev->vc[i]);
>>>  	}
>>>  	s2255_stop_readpipe(dev);
>>> @@ -2397,7 +2186,6 @@ static int s2255_stop_acquire(struct s2255_vc
>>> *vc)
>>>  	if (res != 0)
>>>  		dev_err(&dev->udev->dev, "CMD_STOP error\n");
>>> 
>>> -	vc->b_acquire = 0;
>>>  	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, vc->idx, res);
>>>  	mutex_unlock(&dev->cmdlock);
>>>  	return res;
>>> @@ -2503,6 +2291,8 @@ static int s2255_probe(struct usb_interface
>>> *interface,
>>>  		vc->dev = dev;
>>>  		init_waitqueue_head(&vc->wait_setmode);
>>>  		init_waitqueue_head(&vc->wait_vidstatus);
>>> +		spin_lock_init(&vc->qlock);
>>> +		mutex_init(&vc->vb_lock);
>>>  	}
>>> 
>>>  	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
>>> @@ -2548,7 +2338,6 @@ static int s2255_probe(struct usb_interface
>>> *interface,
>>>  	retval = s2255_board_init(dev);
>>>  	if (retval)
>>>  		goto errorBOARDINIT;
>>> -	spin_lock_init(&dev->slock);
>>>  	s2255_fwload_start(dev, 0);
>>>  	/* loads v4l specific */
>>>  	retval = s2255_probe_v4l(dev);
>>> --
>>> 1.7.9.5
