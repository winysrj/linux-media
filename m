Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m347BwTj011296
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 03:11:58 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m347Bb1G004778
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 03:11:37 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1Jhg5I-00014o-J6
	for video4linux-list@redhat.com; Fri, 04 Apr 2008 09:11:36 +0200
Received: from [145.52.8.13] (port=43384 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1Jhg5I-00014i-Bj
	for video4linux-list@redhat.com; Fri, 04 Apr 2008 09:11:36 +0200
Message-ID: <47F5D1F6.2020906@hhs.nl>
Date: Fri, 04 Apr 2008 09:00:06 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
References: <47ED68E3.7040400@hhs.nl>
	<20080403212728.GE14369@plankton.ifup.org>
In-Reply-To: <20080403212728.GE14369@plankton.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, spca50x-devs@lists.sourceforge.net
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

Brandon Philips wrote:
> On 22:53 Fri 28 Mar 2008, Hans de Goede wrote:
>>  I'm currently posting these as .c files for easy reading and
>>  compilation / testing, but I still hope to get a lot of feedback / a
>>  thorough review, esp of the core <-> pac207 split version as I hope
>>  to submit that as a patch for mainline inclusion soon.
> 
> The driver look pretty good.  Comments inline.
> 

Thanks for the review!

>> struct pac207_decompress_table_t {
>> 	u8 is_abs;
>> 	u8 len;
>> 	s8 val;
>> };
> 
> Why add the _t?
> 

So that I can write "struct pac207_decompress_table_t 
pac207_decompress_table[256];" further on.

>> int pac207_read_reg(struct usbvideo2_device* cam, u16 index)
>> {
>> 	struct usb_device* udev = cam->usbdev;
>> 	u8* buff = cam->control_buffer;
>> 	int res;
>>
>> 	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
>> 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
>> 			0x00, index, buff, 1, USBVIDEO2_CTRL_TIMEOUT);
>> 	if (res < 0)
>> 		DBG(1, "Failed to read a register (index 0x%04X, error %d)",
>> 			index, res);
>>
>> 	return (res >= 0) ? (int)(*buff) : res;
> 
> Why not do the obvious thing and return from the if (res < 0) statement?
> 

Good point.

>> /*****************************************************************************/
>>
>> /* auto gain and exposure algorithm based on the knee algorithm described here:
>>    http://ytse.tricolour.net/docs/LowLightOptimization.html */
> 
> URL is dead.
> 

Huh, you're right it was still alive when I wrote my mail, lets give it some 
time to come back (I hope it does).

>> #define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))
> 
> Add a comment about what this is doing?  Could you just do it as a
> static function instead?
> 

What it does it obvious isn't it? Sure I could make this into a funciton that 
indeed would be somewhat more readable.

>> static int
>> pac207_vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
>> {
>> 	struct usbvideo2_device* cam = fh;
>> 	struct pac207_data *data = cam->cam_data;
>> 	int new_value = a->value;
>> 	int err;
>>
>> 	if ((err = pac207_vidioc_g_ctrl(file, fh, a)))
>> 		return err;
>>
>> 	if (a->value == new_value)
>> 		return 0;
> 
> This all needs some locking to protect from multi-threaded applications.
> Otherwise the hardware and data structures could be in two different
> states.
> 

They are all called with the usbvideo2 "core" fileop_mutex lock held, as is 
documented in usbvideo2.h

<snip>

> 
>> static void usbvideo2_urb_complete(struct urb *urb)
>> {
>> 	struct usbvideo2_device* cam = urb->context;
>> 	struct usbvideo2_frame_t** f;
>> 	int i, ret;
>>
>> 	switch (urb->status) {
>> 		case 0:
>> 			break;
>> 		case -ENOENT:		/* usb_kill_urb() called. */
>> 		case -ECONNRESET:	/* usb_unlink_urb() called. */
>> 		case -ESHUTDOWN:	/* The endpoint is being disabled. */
>> 			return;
>> 		default:
>> 			goto resubmit_urb;
>> 	}
>>
>> 	f = &cam->frame_current;
>>
>> 	if (!(*f)) {
>> 		if (list_empty(&cam->inqueue))
>> 			goto resubmit_urb;
>>
>> 		(*f) = list_entry(cam->inqueue.next, struct usbvideo2_frame_t,
>> 					frame);
>> 	} 
> 
> Don't you want to take a spinlock here?  Most accesses of inqueue seem
> to take a spinlock.
> 

Good catch! Note that this bug is present in the current in mainline zc0301, 
et61x251, and sn9c102 drivers too!!

(I modelled my driver after these).

<snip>

>> static void usbvideo2_vm_close(struct vm_area_struct* vma)
>> {
>> 	/* NOTE: buffers are not freed here */
> 
> Why is that worth noting?
> 

I guess it isn't this was copied verbatim from the zc0301 driver.

>> 	struct usbvideo2_frame_t* f = vma->vm_private_data;
>> 	f->vma_use_count--;
>> }
>>
>>
>> static int
>> usbvideo2_vidioc_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *b)
>> {
>> 	u32 i;
>> 	struct usbvideo2_device* cam = fh;
>>
>> 	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
>> 			b->memory != V4L2_MEMORY_MMAP)
>> 		return -EINVAL;
>>
>> 	if (cam->io == IO_READ) {
>> 		DBG(2, "Close and open the device again to choose the "
>> 			"mmap I/O method");
>> 		return -EBUSY;
>> 	}
> 
> Again, why is close then open required?
> 

This whole check is just there to give a hint to the applicaiton writer, that 
mixing mmap and read won't work. If a read() call is made, then it will request 
a number of buffers, and effectively do a transfer_on ioctl, starting the 
stream. If this check is removed, the usbvideo2_vidioc_reqbufs() ioctl will 
still fail if done after a read call is made, because the next check will fail:

         if (cam->stream == STREAM_ON) {
                 return -EBUSY;
         }

Thic check is mandatory as freeing the buffers will the usb isoc stream is 
active is a bad idea! So I can remove the if (cam->io == IO_READ) { check 
without any ill effects, its just there to give a hint to application writers 
why switching between mmap <-> read will fial most of the time.


>> static int
>> usbvideo2_vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
>> {
>> 	struct usbvideo2_device* cam = fh;
>> 	struct usbvideo2_frame_t *f;
>> 	unsigned long lock_flags;
>> 	long timeout;
>>
>> 	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE || cam->io != IO_MMAP ||
>> 			cam->stream == STREAM_OFF)
>> 		return -EINVAL;
>>
>> 	if (list_empty(&cam->outqueue)) {
>> 		if (file->f_flags & O_NONBLOCK)
>> 			return -EAGAIN;
>>
>> 		timeout = wait_event_interruptible_timeout(cam->wait_frame,
>> 				!list_empty(&cam->outqueue) ||
>> 				cam->disconnected,
>> 				msecs_to_jiffies(USBVIDEO2_FRAME_TIMEOUT) );
>> 		if (cam->disconnected)
>> 			return -ENODEV;
>>
>> 		if (timeout <= 0)
>> 			return (timeout < 0)? timeout : -EIO;
>> 	}
> 
> Where is the locking?  What happens if two threads call dqbuf on this
> device at the same time?  
> 

All ioctl handlers gets called through usbvideo2_ioctl(), which takes the 
fileop_mutex, then checks if the device hasn't been disconnected from 
underneath us, and then calls video_ioctl2(...). This video_ioctl2() wrapping 
is needed to check for disconnected devices, and as it was needed anyway also 
was a good central place to add locking, simplifying all the ioctl handlers, 
esp. there error exit paths.

> 
>> struct usbvideo2_frame_t {
>> 	void* bufmem;
>> 	struct v4l2_buffer buf;
>> 	enum usbvideo2_frame_state state;
>> 	struct list_head frame;
>> 	unsigned long vma_use_count;
>> };
> 
> Why the _t on the end?
> 

No special reason in this case.

Thanks & Regards,

Hans


p.s.

I'm currently trying to merge my work and the work to port gspca as a whole to 
v4l2 of Jean-François Moine, so don't expect a new iteration of this soon, as I 
first want to have a clear path for merging these 2 works.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
