Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34007 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3DRVW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:22:57 -0400
Received: by mail-ee0-f48.google.com with SMTP id b15so1534334eek.21
        for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 14:22:55 -0700 (PDT)
Message-ID: <5170642C.9070701@gmail.com>
Date: Thu, 18 Apr 2013 23:22:52 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com> <1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com> <51688A85.8080206@gmail.com> <CAHG8p1Dc4erTTQRD5mzZQDsS=Zp_1L7yGkxspAT_T4gPUnBptg@mail.gmail.com>
In-Reply-To: <CAHG8p1Dc4erTTQRD5mzZQDsS=Zp_1L7yGkxspAT_T4gPUnBptg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On 04/17/2013 08:57 AM, Scott Jiang wrote:
> Hi Sylwester ,
>
>>> @@ -9,7 +9,18 @@ config VIDEO_BLACKFIN_CAPTURE
>>>            To compile this driver as a module, choose M here: the
>>>            module will be called bfin_capture.
>>>
>>> +config VIDEO_BLACKFIN_DISPLAY
>>> +       tristate "Blackfin Video Display Driver"
>>> +       depends on VIDEO_V4L2&&   BLACKFIN&&   I2C
>>> +       select VIDEOBUF2_DMA_CONTIG
>>> +       help
>>> +         V4L2 bridge driver for Blackfin video display device.
>>
>>
>> Shouldn't it just be "V4L2 output driver", why are you calling it "bridge" ?
>>
> Hmm, capture<->display, input<->output, right?

Yes, input/output from user space POV.

> The kernel docs called it bridge, may "host" sounds better.

I suggested "output" as referring to the "V4L2 output interface" [1].
I guess bridge/host could just be skipped and we could simply put it as:

"V4L2 driver for Blackfin video display (E)PPI interface."

>>> +/*
>>> + * Analog Devices video display driver
>>
>>
>> Sounds a bit too generic.
>>
>>> + *
>>> + * Copyright (c) 2011 Analog Devices Inc.
>>
>>
>> 2011 - 2013 ?
>>
> Written in 2011.

Since you're still actively working on it I would say it makes sense
to put it as 2011 - 2013. At least this is what most people do AFAICS.
But I don't really mind, it's up to you!

>>> +struct disp_fh {
>>> +       struct v4l2_fh fh;
>>> +       /* indicates whether this file handle is doing IO */
>>> +       bool io_allowed;
>>> +};
>>
>>
>> This structure should not be needed when you use the vb2 helpers. Please see
>> below for more details.
>>
> The only question is how the core deal with the permission that which
> file handle can
> stream off the output. I want to impose a rule that only IO handle can stop IO.
> I refer to priority, but current kernel driver export this to user
> space and let user decide it.

As far as I can see there would be no change in behaviour if you used the
helpers. For instance, vidioc_streamon/streamoff ioctls

/* From videobuf2-core.c */

/* The queue is busy if there is a owner and you are not that owner. */
static inline bool vb2_queue_is_busy(struct video_device *vdev, struct 
file *file)
{
	return vdev->queue->owner && vdev->queue->owner != file->private_data;
}

/* vb2 ioctl helpers */

int vb2_ioctl_reqbufs(struct file *file, void *priv,
			  struct v4l2_requestbuffers *p)
{
	struct video_device *vdev = video_devdata(file);
	int res = __verify_memory_type(vdev->queue, p->memory, p->type);

	if (res)
		return res;
	if (vb2_queue_is_busy(vdev, file))
		return -EBUSY;
	res = __reqbufs(vdev->queue, p);
	/* If count == 0, then the owner has released all buffers and he
	   is no longer owner of the queue. Otherwise we have a new owner. */
	if (res == 0)
		vdev->queue->owner = p->count ? file->private_data : NULL;
	return res;
}

int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
{
	struct video_device *vdev = video_devdata(file);

	if (vb2_queue_is_busy(vdev, file))
		return -EBUSY;
	return vb2_streamon(vdev->queue, i);
}

int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
{
	struct video_device *vdev = video_devdata(file);

	if (vb2_queue_is_busy(vdev, file))
		return -EBUSY;
	return vb2_streamoff(vdev->queue, i);
}

And in your code:


+static int disp_reqbufs(struct file *file, void *priv,
+			struct v4l2_requestbuffers *req_buf)
+{
+	struct disp_device *disp = video_drvdata(file);
+	struct vb2_queue *vq = &disp->buffer_queue;
+	struct v4l2_fh *fh = file->private_data;
+	struct disp_fh *disp_fh = container_of(fh, struct disp_fh, fh);
+
+	if (vb2_is_busy(vq))
+		return -EBUSY;
+
+	disp_fh->io_allowed = true;
+
+	return vb2_reqbufs(vq, req_buf);
+}

+static int disp_streamon(struct file *file, void *priv,
+				enum v4l2_buf_type buf_type)
+{
+	struct disp_device *disp = video_drvdata(file);
+	struct disp_fh *fh = file->private_data;
+	struct ppi_if *ppi = disp->ppi;
+	dma_addr_t addr;
+	int ret;
+
+	if (!fh->io_allowed)
+		return -EBUSY;
+
+	/* call streamon to start streaming in videobuf */
+	ret = vb2_streamon(&disp->buffer_queue, buf_type);
+	if (ret)
+		return ret;
+
	...
+}

+static int disp_streamoff(struct file *file, void *priv,
+				enum v4l2_buf_type buf_type)
+{
+	struct disp_device *disp = video_drvdata(file);
+	struct disp_fh *fh = file->private_data;
+
+	if (!fh->io_allowed)
+		return -EBUSY;
+
+	return vb2_streamoff(&disp->buffer_queue, buf_type);
+}

Please note that you really should be setting io_allowed to true only if
vb2_reqbufs() succeeds.

Hence I wouldn't hesitate to use the core implementation. This way we get
more consistent behaviour across all drivers, which is in line with
what you have currently implemented AFAICT.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/devices.html#output


Thanks,
Sylwester
