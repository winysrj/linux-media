Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:33544 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbeGJVtX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 17:49:23 -0400
Subject: Re: [PATCH v7 6/6] [media] cxusb: add analog mode support for Medion
 MD95700
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <cover.1530565770.git.mail@maciej.szmigiero.name>
 <13d9690f35724b82f874a76105340ce44821a2c0.1530565770.git.mail@maciej.szmigiero.name>
 <6db5faa9-18a9-386d-56cc-909adac8f47d@xs4all.nl>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <5f33d915-f26c-97d0-95e4-7f3e2c6884e0@maciej.szmigiero.name>
Date: Tue, 10 Jul 2018 23:48:15 +0200
MIME-Version: 1.0
In-Reply-To: <6db5faa9-18a9-386d-56cc-909adac8f47d@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04.07.2018 11:33, Hans Verkuil wrote:
> Hi Maciej,
> 
> On 02/07/18 23:23, Maciej S. Szmigiero wrote:
(..)
>> +static int cxusb_medion_v_queue_setup(struct vb2_queue *q,
>> +				      unsigned int *num_buffers,
>> +				      unsigned int *num_planes,
>> +				      unsigned int sizes[],
>> +				      struct device *alloc_devs[])
>> +{
>> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +	unsigned int size = cxdev->raw_mode ?
>> +		CXUSB_VIDEO_MAX_FRAME_SIZE :
>> +		cxdev->width * cxdev->height * 2;
>> +
>> +	if (*num_planes > 0) {
>> +		if (*num_planes != 1)
>> +			return -EINVAL;
>> +
>> +		if (sizes[0] < size)
>> +			return -EINVAL;
>> +	} else {
>> +		*num_planes = 1;
>> +		sizes[0] = size;
>> +	}
>> +
>> +	if (q->num_buffers + *num_buffers < 6)
>> +		*num_buffers = 6 - q->num_buffers;
> 
> Huh? These two lines should be removed. I'm not sure what the purpose is.

This is to request that the vb2 framework keeps at least 6 buffers in the
queue.

There is a similar code in usb/usbtv/usbtv-video.c:
> if (vq->num_buffers + *nbuffers < 2)
>                 *nbuffers = 2 - vq->num_buffers;

And in usb/hackrf/hackrf.c and usb/airspy/airspy.c:
> /* Need at least 8 buffers */
> if (vq->num_buffers + *nbuffers < 8)
> 	*nbuffers = 8 - vq->num_buffers;

In addition to this, many drivers (like stk1160, s2255, pwc, msi2500,
go7007, ...) always enforce some minimum *num_buffers count, regardless
of the number of buffers currently in the queue.

>> +static void cxusb_auxbuf_init(struct cxusb_medion_auxbuf *auxbuf,
>> +			      u8 *buf, unsigned int len)
>> +{
>> +	auxbuf->buf = buf;
>> +	auxbuf->len = len;
>> +	auxbuf->paylen = 0;
>> +}
>> +
>> +static void cxusb_auxbuf_head_trim(struct dvb_usb_device *dvbdev,
>> +				   struct cxusb_medion_auxbuf *auxbuf,
>> +				   unsigned int pos)
>> +{
>> +	if (pos == 0)
>> +		return;
>> +
>> +	if (WARN_ON(pos > auxbuf->paylen))
>> +		return;
>> +
>> +	cxusb_vprintk(dvbdev, AUXB,
>> +		      "trimming auxbuf len by %u to %u\n",
>> +		      pos, auxbuf->paylen - pos);
>> +
>> +	memmove(auxbuf->buf, auxbuf->buf + pos, auxbuf->paylen - pos);
>> +	auxbuf->paylen -= pos;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_paylen(struct cxusb_medion_auxbuf *auxbuf)
>> +{
>> +	return auxbuf->paylen;
>> +}
>> +
>> +static bool cxusb_auxbuf_make_space(struct dvb_usb_device *dvbdev,
>> +				    struct cxusb_medion_auxbuf *auxbuf,
>> +				    unsigned int howmuch)
>> +{
>> +	unsigned int freespace;
>> +
>> +	if (WARN_ON(howmuch >= auxbuf->len))
>> +		howmuch = auxbuf->len - 1;
>> +
>> +	freespace = auxbuf->len - cxusb_auxbuf_paylen(auxbuf);
>> +
>> +	cxusb_vprintk(dvbdev, AUXB, "freespace is %u\n", freespace);
>> +
>> +	if (freespace >= howmuch)
>> +		return true;
>> +
>> +	howmuch -= freespace;
>> +
>> +	cxusb_vprintk(dvbdev, AUXB, "will overwrite %u bytes of buffer\n",
>> +		      howmuch);
>> +
>> +	cxusb_auxbuf_head_trim(dvbdev, auxbuf, howmuch);
>> +
>> +	return false;
>> +}
>> +
>> +/* returns false if some data was overwritten */
>> +static bool cxusb_auxbuf_append_urb(struct dvb_usb_device *dvbdev,
>> +				    struct cxusb_medion_auxbuf *auxbuf,
>> +				    struct urb *urb)
>> +{
>> +	unsigned long len = 0;
>> +	int i;
>> +	bool ret;
>> +
>> +	for (i = 0; i < urb->number_of_packets; i++)
>> +		len += urb->iso_frame_desc[i].actual_length;
>> +
>> +	ret = cxusb_auxbuf_make_space(dvbdev, auxbuf, len);
>> +
>> +	for (i = 0; i < urb->number_of_packets; i++) {
>> +		unsigned int to_copy;
>> +
>> +		to_copy = urb->iso_frame_desc[i].actual_length;
>> +
>> +		memcpy(auxbuf->buf + auxbuf->paylen, urb->transfer_buffer +
>> +		       urb->iso_frame_desc[i].offset, to_copy);
>> +
>> +		auxbuf->paylen += to_copy;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static bool cxusb_auxbuf_copy(struct cxusb_medion_auxbuf *auxbuf,
>> +			      unsigned int pos, unsigned char *dest,
>> +			      unsigned int len)
>> +{
>> +	if (pos + len > auxbuf->paylen)
>> +		return false;
>> +
>> +	memcpy(dest, auxbuf->buf + pos, len);
>> +
>> +	return true;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_advance(struct cxusb_medion_auxbuf *auxbuf,
>> +					 unsigned int pos,
>> +					 unsigned int increment)
>> +{
>> +	return pos + increment;
>> +}
>> +
>> +static unsigned int cxusb_auxbuf_begin(struct cxusb_medion_auxbuf *auxbuf)
>> +{
>> +	return 0;
>> +}
>> +
>> +static bool cxusb_auxbuf_isend(struct cxusb_medion_auxbuf *auxbuf,
>> +			       unsigned int pos)
>> +{
>> +	return pos >= auxbuf->paylen;
>> +}
> 
> These three functions seem pointless to me.

I will remove cxusb_auxbuf_begin().

cxusb_auxbuf_advance() is called 6 times in the code while
cxusb_auxbuf_isend() keeps the buffer implementation opaque for users so
I think they make the code a bit nicer.

>> +static void cxusb_medion_v_process_urb_raw_mode(struct cxusb_medion_dev *cxdev,
>> +						struct urb *urb)
>> +{
>> +	struct dvb_usb_device *dvbdev = cxdev->dvbdev;
>> +	u8 *buf;
>> +	struct cxusb_medion_vbuffer *vbuf;
>> +	int i;
>> +	unsigned long len = 0;
>> +
>> +	if (list_empty(&cxdev->buflist)) {
>> +		dev_warn(&dvbdev->udev->dev, "no free buffers\n");
>> +		return;
>> +	}
>> +
>> +	vbuf = list_first_entry(&cxdev->buflist, struct cxusb_medion_vbuffer,
>> +				list);
>> +	list_del(&vbuf->list);
>> +
>> +	vbuf->vb2.timestamp = ktime_get_ns();
>> +
>> +	buf = vb2_plane_vaddr(&vbuf->vb2, 0);
>> +
>> +	for (i = 0; i < urb->number_of_packets; i++) {
>> +		memcpy(buf, urb->transfer_buffer +
>> +		       urb->iso_frame_desc[i].offset,
>> +		       urb->iso_frame_desc[i].actual_length);
>> +
>> +		buf += urb->iso_frame_desc[i].actual_length;
>> +		len += urb->iso_frame_desc[i].actual_length;
>> +	}
>> +
>> +	vb2_set_plane_payload(&vbuf->vb2, 0, len);
>> +
>> +	vb2_buffer_done(&vbuf->vb2, VB2_BUF_STATE_DONE);
> 
> The frame sequence counter in vb2_v4l2_buffer does not seem to be incremented.
> 
> Did you test this driver with v4l2-compliance? It will detect such errors.

Hmm, I did test this driver with v4l2-compliance last year and don't
remember seeing any error about the frame sequence counter.

When I'll be doing a respin I will check this again and see whether
v4l2-compliance reports anything (it seems it should).

>> +static int cxusb_medion_v_start_streaming(struct vb2_queue *q,
>> +					  unsigned int count)
>> +{
>> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +	u8 streamon_params[2] = { 0x03, 0x00 };
>> +	int npackets, i;
>> +	int ret;
>> +
>> +	cxusb_vprintk(dvbdev, OPS, "should start streaming\n");
>> +
>> +	/* already streaming */
>> +	if (cxdev->streaming)
>> +		return 0;
> 
> Unnecessary check, this can't happen.
> 
>> +
>> +	if (cxusb_medion_stream_busy(cxdev)) {
>> +		ret = -EBUSY;
>> +		goto ret_retbufs;
>> +	}
>> +
>> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 1);
>> +	if (ret != 0) {
>> +		dev_err(&dvbdev->udev->dev,
>> +			"unable to start stream (%d)\n", ret);
>> +		goto ret_retbufs;
>> +	}
>> +
>> +	ret = cxusb_ctrl_msg(dvbdev, CMD_STREAMING_ON, streamon_params, 2,
>> +			     NULL, 0);
>> +	if (ret != 0) {
>> +		dev_err(&dvbdev->udev->dev,
>> +			"unable to start streaming (%d)\n", ret);
>> +		goto ret_unstream_cx;
>> +	}
>> +
>> +	if (cxdev->raw_mode)
>> +		npackets = CXUSB_VIDEO_MAX_FRAME_PKTS;
>> +	else {
>> +		u8 *buf;
>> +		unsigned int urblen, auxbuflen;
>> +
>> +		/* has to be less than full frame size */
>> +		urblen = (cxdev->width * 2 + 4 + 4) * cxdev->height;
>> +		npackets = urblen / CXUSB_VIDEO_PKT_SIZE;
>> +		urblen = npackets * CXUSB_VIDEO_PKT_SIZE;
>> +
>> +		auxbuflen = (cxdev->width * 2 + 4 + 4) *
>> +			(cxdev->height + 50 /* VBI lines */) + urblen;
>> +
>> +		buf = vmalloc(auxbuflen);
>> +		if (buf == NULL) {
>> +			ret = -ENOMEM;
>> +			goto ret_unstream_md;
>> +		}
>> +
>> +		cxusb_auxbuf_init(&cxdev->auxbuf, buf, auxbuflen);
>> +	}
>> +
>> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++) {
>> +		int framen;
>> +		u8 *streambuf;
>> +		struct urb *surb;
>> +
>> +		streambuf = kmalloc(npackets * CXUSB_VIDEO_PKT_SIZE,
>> +				    GFP_KERNEL);
>> +		if (streambuf == NULL) {
>> +			if (i == 0) {
>> +				ret = -ENOMEM;
>> +				goto ret_freeab;
>> +			} else
>> +				break;
>> +		}
>> +
>> +		surb = usb_alloc_urb(npackets, GFP_KERNEL);
>> +		if (surb == NULL) {
>> +			kfree(streambuf);
>> +			ret = -ENOMEM;
>> +			goto ret_freeu;
>> +		}
>> +
>> +		cxdev->streamurbs[i] = surb;
>> +		surb->dev = dvbdev->udev;
>> +		surb->context = dvbdev;
>> +		surb->pipe = usb_rcvisocpipe(dvbdev->udev, 2);
>> +
>> +		surb->interval = 1;
>> +		surb->transfer_flags = URB_ISO_ASAP;
>> +
>> +		surb->transfer_buffer = streambuf;
>> +
>> +		surb->complete = cxusb_medion_v_complete;
>> +		surb->number_of_packets = npackets;
>> +		surb->transfer_buffer_length = npackets * CXUSB_VIDEO_PKT_SIZE;
>> +
>> +		for (framen = 0; framen < npackets; framen++) {
>> +			surb->iso_frame_desc[framen].offset =
>> +				CXUSB_VIDEO_PKT_SIZE * framen;
>> +
>> +			surb->iso_frame_desc[framen].length =
>> +				CXUSB_VIDEO_PKT_SIZE;
>> +		}
>> +	}
>> +
>> +	cxdev->urbcomplete = 0;
>> +	cxdev->nexturb = 0;
>> +	cxdev->vbuf = NULL;
>> +	cxdev->bt656.mode = NEW_FRAME;
>> +	cxdev->bt656.buf = NULL;
>> +
>> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +		if (cxdev->streamurbs[i] != NULL) {
>> +			ret = usb_submit_urb(cxdev->streamurbs[i],
>> +					GFP_KERNEL);
>> +			if (ret != 0)
>> +				dev_err(&dvbdev->udev->dev,
>> +					"URB %d submission failed (%d)\n", i,
>> +					ret);
>> +		}
>> +
>> +	cxdev->streaming = true;
> 
> No need to keep track of the streaming state. You can use vb2_start_streaming_called()
> instead since vb2 already keeps track of this.

The driver still needs some flag to tell its workqueue task to not
process and resubmit URBs when the stream is being stopped.

Otherwise, as the device lock gets released to flush the workqueue task
there will be a time window where this task could still resubmit URBs
(not knowing that we are stopping the stream).
And we need to have the URBs killed before we flush the workqueue since
their completion routine can schedule the workqueue task.

There seems to be no vb2 specific flag for this:
q->start_streaming_called is zeroed only after stop_streaming callback
has already returned.
And we need to have URBs killed and the workqueue task flushed before
we return from stop_streaming callback so we can clean up their
resources in this callback.

>> +
>> +	return 0;
>> +
>> +ret_freeu:
>> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +		if (cxdev->streamurbs[i] != NULL) {
>> +			kfree(cxdev->streamurbs[i]->transfer_buffer);
>> +			usb_free_urb(cxdev->streamurbs[i]);
>> +			cxdev->streamurbs[i] = NULL;
>> +		}
>> +
>> +ret_freeab:
>> +	if (!cxdev->raw_mode)
>> +		vfree(cxdev->auxbuf.buf);
>> +
>> +ret_unstream_md:
>> +	cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
>> +
>> +ret_unstream_cx:
>> +	v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
>> +
>> +ret_retbufs:
>> +	cxusb_medion_return_buffers(cxdev, true);
>> +
>> +	return ret;
>> +}
>> +
>> +static void cxusb_medion_v_stop_streaming(struct vb2_queue *q)
>> +{
>> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +	int i, ret;
>> +
>> +	cxusb_vprintk(dvbdev, OPS, "should stop streaming\n");
>> +
>> +	if (!cxdev->streaming)
>> +		return;
>> +
>> +	cxdev->streaming = false;
>> +
>> +	cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
>> +
>> +	ret = v4l2_subdev_call(cxdev->cx25840, video, s_stream, 0);
>> +	if (ret != 0)
>> +		dev_err(&dvbdev->udev->dev, "unable to stop stream (%d)\n",
>> +			ret);
>> +
>> +	/* let URB completion run */
>> +	mutex_unlock(cxdev->videodev->lock);
>> +
>> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +		if (cxdev->streamurbs[i] != NULL)
>> +			usb_kill_urb(cxdev->streamurbs[i]);
>> +
>> +	flush_work(&cxdev->urbwork);
>> +
>> +	mutex_lock(cxdev->videodev->lock);
>> +
>> +	/* free transfer buffer and URB */
>> +	if (!cxdev->raw_mode)
>> +		vfree(cxdev->auxbuf.buf);
>> +
>> +	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
>> +		if (cxdev->streamurbs[i] != NULL) {
>> +			kfree(cxdev->streamurbs[i]->transfer_buffer);
>> +			usb_free_urb(cxdev->streamurbs[i]);
>> +			cxdev->streamurbs[i] = NULL;
>> +		}
>> +
>> +	cxusb_medion_return_buffers(cxdev, false);
>> +}
>> +
>> +static void cxusub_medion_v_buf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct cxusb_medion_vbuffer *vbuf =
>> +		container_of(vb, struct cxusb_medion_vbuffer, vb2);
>> +	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +	/* cxusb_vprintk(dvbdev, OPS, "mmmm.. fresh buffer...\n"); */
>> +
>> +	list_add_tail(&vbuf->list, &cxdev->buflist);
> 
> I would expect a spinlock here to protect the list.

All buffer list accesses are done either while holding main 
lock or in vb2 callbacks (which accoring to
https://lwn.net/Articles/447435/ can assume that the lock has been
taken).
 
>> +static int cxusb_medion_g_fmt_vid_cap(struct file *file, void *fh,
>> +				      struct v4l2_format *f)
>> +{
>> +	struct dvb_usb_device *dvbdev = video_drvdata(file);
>> +	struct cxusb_medion_dev *cxdev = dvbdev->priv;
>> +
>> +	f->fmt.pix.width = cxdev->width;
>> +	f->fmt.pix.height = cxdev->height;
>> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
>> +	f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
>> +	f->fmt.pix.bytesperline = cxdev->raw_mode ? 0 : cxdev->width * 2;
> 
> Dunno what raw_mode is, but it looks suspicous.

It is simply an ability to capture a raw BT.656 stream as received by
the driver from the device.
This functionality is very useful for debugging.
> I stopped reviewing halfway because I was wondering whether this is the right approach.
> 
> Most of the analog support is not actually tied to the medion but is fairly generic.
> This is how other drivers do that as well: the implementation is generic and the board
> specific bits are implemented via card structures.
> 
> They also make use of v4l2_device_call_all() instead of calling each subdev directly,
> this means that the board-specific code loads the correct subdevs, but the generic
> code doesn't need to know (in general) what those are, it just calls all of them.

There are only three subdevices here: a RF tuner, TDA9887 demod and
cx25840 chip.
Most of the subdev calls are for c25840 only, some (like g_tuner) should
be done in a proper order so returned details aren't overwritten by less
specific data being returned from the next subdevice.
The RF tuner and the demod are target of just a few of the subdev calls.

v4l2_device_call_all() ignores any errors, which makes for example trying
a video format hard (and which format will be accepted by the cx25840
depends on the currently set broadcast standard and parameters of the
last signal that was received), while V4L2 docs say that
VIDIOC_{S,TRY}_FMT ioctls "should not return an error code unless the
type field is invalid", that is, they should not return an error for
invalid or unsupported image widths or heights.
They should instead return something sensible for these image parameters
which requires a feedback from the cx25840 subdev which one it will
finally accept.

With respect to making the code more generic: considering this is a
13-year old hardware I think it is fairly unlikely that there are going
to be devices with similar internal design released in the future.
And in the unlikely case that this indeed happens then the code can
always be refactored into some more generic framework.

This driver has been alredy nearly merged back in 2012 (even without last
year cleanups), just I wasn't able to find time to rebase it then:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg50449.html
so it isn't something completely new.

> Regards,
> 
> 	Hans
> 

Thanks and best regards,
Maciej
