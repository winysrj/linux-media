Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33LSP20004515
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 17:28:25 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33LSC9F020576
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 17:28:12 -0400
Received: by rn-out-0910.google.com with SMTP id i50so2433569rne.11
	for <video4linux-list@redhat.com>; Thu, 03 Apr 2008 14:28:12 -0700 (PDT)
Date: Thu, 3 Apr 2008 14:27:28 -0700
From: Brandon Philips <brandon@ifup.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080403212728.GE14369@plankton.ifup.org>
References: <47ED68E3.7040400@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED68E3.7040400@hhs.nl>
Cc: fedora-kernel-list@redhat.com, video4linux-list@redhat.com,
	spca50x-devs@lists.sourceforge.net
Subject: Re: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 22:53 Fri 28 Mar 2008, Hans de Goede wrote:
>  I'm currently posting these as .c files for easy reading and
>  compilation / testing, but I still hope to get a lot of feedback / a
>  thorough review, esp of the core <-> pac207 split version as I hope
>  to submit that as a patch for mainline inclusion soon.

The driver look pretty good.  Comments inline.

> struct pac207_decompress_table_t {
> 	u8 is_abs;
> 	u8 len;
> 	s8 val;
> };

Why add the _t?

> int pac207_read_reg(struct usbvideo2_device* cam, u16 index)
> {
> 	struct usb_device* udev = cam->usbdev;
> 	u8* buff = cam->control_buffer;
> 	int res;
> 
> 	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
> 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
> 			0x00, index, buff, 1, USBVIDEO2_CTRL_TIMEOUT);
> 	if (res < 0)
> 		DBG(1, "Failed to read a register (index 0x%04X, error %d)",
> 			index, res);
> 
> 	return (res >= 0) ? (int)(*buff) : res;

Why not do the obvious thing and return from the if (res < 0) statement?

> /*****************************************************************************/
> 
> /* auto gain and exposure algorithm based on the knee algorithm described here:
>    http://ytse.tricolour.net/docs/LowLightOptimization.html */

URL is dead.

> #define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))

Add a comment about what this is doing?  Could you just do it as a
static function instead?

> static int
> pac207_vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
> {
> 	struct usbvideo2_device* cam = fh;
> 	struct pac207_data *data = cam->cam_data;
> 	int new_value = a->value;
> 	int err;
> 
> 	if ((err = pac207_vidioc_g_ctrl(file, fh, a)))
> 		return err;
> 
> 	if (a->value == new_value)
> 		return 0;

This all needs some locking to protect from multi-threaded applications.
Otherwise the hardware and data structures could be in two different
states.

> 	/* don't allow mucking with gain / exposure when using autogain */
> 	if (data->autogain && (a->id == V4L2_CID_GAIN ||
> 			a->id == V4L2_CID_EXPOSURE))
> 		return -EINVAL;
> 
> 	switch (a->id) {
> 		case V4L2_CID_BRIGHTNESS:
> 			data->brightness = new_value;
> 			pac207_write_reg(cam, 0x0008, data->brightness);
> 			/* give brightness change time to take effect before
> 			   doing autogain based on the new brightness */
> 			data->autogain_ignore_frames =
> 						PAC207_AUTOGAIN_IGNORE_FRAMES;
> 			break;
> 
> 		case V4L2_CID_EXPOSURE:
> 			data->exposure = new_value;
> 			pac207_write_reg(cam, 0x0002, data->exposure);
> 			break;
> 
> 		case V4L2_CID_AUTOGAIN:
> 			data->autogain = new_value;
> 			/* when switching to autogain set defaults to make sure
> 			   we are on a valid point of the autogain gain /
> 			   exposure knee graph, and give this change time to
> 			   take effect before doing autogain. */
> 			if (data->autogain) {
> 				data->exposure = PAC207_EXPOSURE_DEFAULT;
> 				data->gain = PAC207_GAIN_DEFAULT;
> 				data->autogain_ignore_frames =
> 						PAC207_AUTOGAIN_IGNORE_FRAMES;
> 				pac207_write_reg(cam, 0x0002, data->exposure);
> 				pac207_write_reg(cam, 0x000e, data->gain);
> 			}
> 			break;
> 
> 		case V4L2_CID_GAIN:
> 			data->gain = new_value;
> 			pac207_write_reg(cam, 0x000e, data->gain);
> 			break;
> 	
> 		/* no default needed already checked in pac207_vidioc_g_ctrl */
> 	}
> 
> 	pac207_write_reg(cam, 0x13, 0x01); /* load registers to sensor */
> 	pac207_write_reg(cam, 0x1c, 0x01); /* not documented */
> 
> 	return 0;
> }

> static void usbvideo2_urb_complete(struct urb *urb)
> {
> 	struct usbvideo2_device* cam = urb->context;
> 	struct usbvideo2_frame_t** f;
> 	int i, ret;
> 
> 	switch (urb->status) {
> 		case 0:
> 			break;
> 		case -ENOENT:		/* usb_kill_urb() called. */
> 		case -ECONNRESET:	/* usb_unlink_urb() called. */
> 		case -ESHUTDOWN:	/* The endpoint is being disabled. */
> 			return;
> 		default:
> 			goto resubmit_urb;
> 	}
> 
> 	f = &cam->frame_current;
> 
> 	if (!(*f)) {
> 		if (list_empty(&cam->inqueue))
> 			goto resubmit_urb;
> 
> 		(*f) = list_entry(cam->inqueue.next, struct usbvideo2_frame_t,
> 					frame);
> 	} 

Don't you want to take a spinlock here?  Most accesses of inqueue seem
to take a spinlock.

> static ssize_t
> usbvideo2_read(struct file* filp, char __user * buf, size_t count, loff_t* f_pos)
> {
> 	struct usbvideo2_device *cam = filp->private_data;
> 	struct usbvideo2_frame_t *f;
> 	unsigned long lock_flags;
> 	long timeout;
> 	int err = 0;
> 
> 
> 	if (cam->disconnected) {
> 		err = -ENODEV;
> 		goto out;
> 	}
> 
> 	if (cam->io == IO_MMAP) {
> 		DBG(2, "Close and open the device again to choose the read "
> 			"method");
> 		err = -EBUSY;
> 		goto out;
> 	}
> 
> static void usbvideo2_vm_close(struct vm_area_struct* vma)
> {
> 	/* NOTE: buffers are not freed here */

Why is that worth noting?

> 	struct usbvideo2_frame_t* f = vma->vm_private_data;
> 	f->vma_use_count--;
> }
> 
> 
> static int
> usbvideo2_vidioc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
> {
> 	u32 i;
> 	struct usbvideo2_device* cam = fh;
> 
> 	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> 			b->memory != V4L2_MEMORY_MMAP)
> 		return -EINVAL;
> 
> 	if (cam->io == IO_READ) {
> 		DBG(2, "Close and open the device again to choose the "
> 			"mmap I/O method");
> 		return -EBUSY;
> 	}

Again, why is close then open required?

> static int
> usbvideo2_vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> {
> 	struct usbvideo2_device* cam = fh;
> 	struct usbvideo2_frame_t *f;
> 	unsigned long lock_flags;
> 	long timeout;
> 
> 	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP ||
> 			cam->stream == STREAM_OFF)
> 		return -EINVAL;
> 
> 	if (list_empty(&cam->outqueue)) {
> 		if (file->f_flags & O_NONBLOCK)
> 			return -EAGAIN;
> 
> 		timeout = wait_event_interruptible_timeout(cam->wait_frame,
> 				!list_empty(&cam->outqueue) ||
> 				cam->disconnected,
> 				msecs_to_jiffies(USBVIDEO2_FRAME_TIMEOUT) );
> 		if (cam->disconnected)
> 			return -ENODEV;
> 
> 		if (timeout <= 0)
> 			return (timeout < 0)? timeout : -EIO;
> 	}

Where is the locking?  What happens if two threads call dqbuf on this
device at the same time?  

> 	if (cam->funcs->frame_dequeued)
> 		cam->funcs->frame_dequeued(cam);
> 
> 	spin_lock_irqsave(&cam->queue_lock, lock_flags);

You will probably hit LIST_POISON on a second thread because of the list
being empty when it comes through.

> 	f = list_entry(cam->outqueue.next, struct usbvideo2_frame_t, frame);
> 	list_del(cam->outqueue.next);
> 	spin_unlock_irqrestore(&cam->queue_lock, lock_flags);
> 
> 	f->state = F_UNUSED;
> 
> 	memcpy(b, &f->buf, sizeof(*b));
> 	if (f->vma_use_count)
> 		b->flags |= V4L2_BUF_FLAG_MAPPED;
> 
> 	return 0;
> }

> struct usbvideo2_frame_t {
> 	void* bufmem;
> 	struct v4l2_buffer buf;
> 	enum usbvideo2_frame_state state;
> 	struct list_head frame;
> 	unsigned long vma_use_count;
> };

Why the _t on the end?

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
