Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RJBN4j030773
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 15:11:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RJAvwu024588
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 15:10:57 -0400
Date: Tue, 27 May 2008 16:10:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080527161038.71d55b3f@gaivota>
In-Reply-To: <200804242219.23906.laurent.pinchart@skynet.be>
References: <200804230137.12502.laurent.pinchart@skynet.be>
	<20080423142705.62b6e444@gaivota>
	<200804242219.23906.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB Video Class driver
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

Hi Laurent,

Any news about the UVC patches for kernel inclusion? We urge to send it,
otherwise it may be too late for 2.5.27 addition.

Cheers,
Mauro.

On Thu, 24 Apr 2008 22:19:23 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> On Wednesday 23 April 2008, Mauro Carvalho Chehab wrote:
> > Driver looks sane. Just a few comments.
> >
> > On Wed, 23 Apr 2008 01:37:11 +0200
> >
> > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > +USB VIDEO CLASS
> > > +P:	Laurent Pinchart
> > > +M:	laurent.pinchart@skynet.be
> > > +L:      linux-uvc-devel@berlios.de
> >
> > I think you should also add V4L ML here - and maybe USB.
> 
> I don't think the linux-usb ML wants to be spammed with the uvcvideo driver 
> bugreports. I can add V4L ML, although it's already mentioned in the 
> maintainer's file V4L entry.
> 
> > > +static __s32 uvc_get_le_value(const __u8 *data,
> > > +	struct uvc_control_mapping *mapping)
> > > +{
> > > +	int bits = mapping->size;
> > > +	int offset = mapping->offset;
> > > +	__s32 value = 0;
> > > +	__u8 mask;
> > > +
> > > +	data += offset / 8;
> > > +	offset &= 7;
> > > +	mask = ((1LL << bits) - 1) << offset;
> > > +
> > > +	for (; bits > 0; data++) {
> > > +		__u8 byte = *data & mask;
> > > +		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
> > > +		bits -= 8 - (offset > 0 ? offset : 0);
> > > +		offset -= 8;
> > > +		mask = (1 << bits) - 1;
> > > +	}
> >
> > Instead of using your own le conversion, IMO, it would be better to use the
> > standard _le_ functions here.
> >
> > > +static void uvc_set_le_value(__s32 value, __u8 *data,
> > > +	struct uvc_control_mapping *mapping)
> > > +{
> >
> > Instead of using your own le conversion, IMO, it would be better to use the
> > standard _le_ functions here.
> 
> Have a closer look at the two functions. They extract/insert variable-size 
> fields from/to a 32 bit number. The existing _le_ functions can't do that.
> 
> > > + * ...  It implements the
> > > + * mmap capture method only ...
> >
> > You should consider moving to videobuf on a later version. videobuf also
> > implements read() method, and will likely implement also USERPTR and maybe
> > OVERLAY on future versions.
> 
> I've considered using videobuf when I started the driver, but it wasn't ready 
> for USB devices. There has been several nasty videobuf issues reported to the 
> V4L mailing list recently, so I'd rather wait until videobuf stabilises. I 
> will have to test it properly anyway, as I don't want to loose any 
> functionality/introduce any bug.
> 
> There's also another issue. The UVC standard defines ways to capture still 
> images, and the V4L2 API doesn't support that. I thought about using the 
> read() interface for still images.
> 
> My current feeling is that videobuf is quite bloated. Sharing a buffer 
> management library similar to the uvcvideo code between USB drivers might be 
> an interesting option.
> 
> > > +static int uvc_v4l2_do_ioctl(struct inode *inode, struct file *file,
> > > +		     unsigned int cmd, void *arg)
> > > +{
> > > +	struct video_device *vdev = video_devdata(file);
> > > +	struct uvc_video_device *video = video_get_drvdata(vdev);
> > > +	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
> > > +	int ret = 0;
> > > +
> > > +	if (uvc_trace_param & UVC_TRACE_IOCTL)
> > > +		v4l_printk_ioctl(cmd);
> >
> > The better is to remove the do_ioctl, in favor of video_ioctl2. Also, this
> > will provide a much better debug than what's provided by
> > v4l_printk_ioctl().
> >
> > > +	case VIDIOC_QUERYCAP:
> > > +	{
> > > +		struct v4l2_capability *cap = arg;
> > > +
> > > +		memset(cap, 0, sizeof *cap);
> > > +		strncpy(cap->driver, "uvcvideo", sizeof cap->driver);
> > > +		strncpy(cap->card, vdev->name, 32);
> > > +		strncpy(cap->bus_info, video->dev->udev->bus->bus_name,
> > > +			sizeof cap->bus_info);
> > > +		cap->version = DRIVER_VERSION_NUMBER;
> > > +		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
> > > +				  | V4L2_CAP_STREAMING;
> > > +	}
> > > +		break;
> >
> > The break seems to be wrongly aligned. The proper way should be to move it
> > to be before the '}'.
> 
> Ok.
> 
> > Again, converting to video_ioctl2() will provide a clearer code, and will
> > save stack space.
> 
> We've discussed video_ioctl2 in the past and I'm still not convinced. I don't 
> plan/want to convert the uvcvideo driver to use video_ioctl2.
> 
> > > +struct uvc_xu_control_mapping {
> > > +	__u32 id;
> > > +	__u8 name[32];
> > > +	__u8 entity[16];
> > > +	__u8 selector;
> > > +
> > > +	__u8 size;
> > > +	__u8 offset;
> > > +	enum v4l2_ctrl_type v4l2_type;
> > > +	enum uvc_control_data_type data_type;
> > > +};
> >
> > Don't use enum at userspace interface, since enum size is not portable.
> > (yes, unfortunately, V4L API did this mistake on his design)
> 
> Good point.
> 
> > > +struct uvc_xu_control {
> > > +	__u8 unit;
> > > +	__u8 selector;
> > > +	__u16 size;
> > > +	__u8 __user *data;
> > > +};
> > > +
> > > +#define UVCIOC_CTRL_ADD		_IOW('U', 1, struct uvc_xu_control_info)
> > > +#define UVCIOC_CTRL_MAP		_IOWR('U', 2, struct uvc_xu_control_mapping)
> > > +#define UVCIOC_CTRL_GET		_IOWR('U', 3, struct uvc_xu_control)
> > > +#define UVCIOC_CTRL_SET		_IOW('U', 4, struct uvc_xu_control)
> > > +
> > > +#ifdef __KERNEL__
> >
> > Don't mix userspace API with kernelspace one. Please, split this into two
> > separate files. The userspace one should be at linux/include/media. The
> > kernelspace one, together with usb* stuff.
> 
> Ok.
> 
> Best regards,
> 
> Laurent Pinchart
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
