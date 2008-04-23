Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NNiVEw004830
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 19:44:31 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.251])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NNhwl4024509
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 19:44:10 -0400
Received: by rv-out-0506.google.com with SMTP id b17so1610499rvf.51
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 16:43:52 -0700 (PDT)
Date: Wed, 23 Apr 2008 16:43:22 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080423234322.GB20819@plankton.ifup.org>
References: <200804230137.12502.laurent.pinchart@skynet.be>
	<20080423142705.62b6e444@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423142705.62b6e444@gaivota>
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

On 14:27 Wed 23 Apr 2008, Mauro Carvalho Chehab wrote:
> > + * ...  It implements the
> > + * mmap capture method only ...
> 
> You should consider moving to videobuf on a later version. videobuf also
> implements read() method, and will likely implement also USERPTR and maybe
> OVERLAY on future versions.

Lets shoot for doing this after 2.6.26 if Laurent signs-off.  Until then
lets not get into this argument again :D

> > +static int uvc_v4l2_do_ioctl(struct inode *inode, struct file *file,
> > +		     unsigned int cmd, void *arg)
> > +{
> > +	struct video_device *vdev = video_devdata(file);
> > +	struct uvc_video_device *video = video_get_drvdata(vdev);
> > +	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
> > +	int ret = 0;
> > +
> > +	if (uvc_trace_param & UVC_TRACE_IOCTL)
> > +		v4l_printk_ioctl(cmd);
> 
> The better is to remove the do_ioctl, in favor of video_ioctl2. Also, this will
> provide a much better debug than what's provided by v4l_printk_ioctl().

We discussed this months ago and everyone agreed that video_ioctl2 is
nice but it is not a requirement to be in the tree.

> Driver looks sane. Just a few comments.

Thanks for finding the other issues in your review Mauro; you picked up
on some good details that should be fixed up before the merge.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
