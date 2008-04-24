Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3O2a1qK005705
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 22:36:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3O2ZooP021560
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 22:35:50 -0400
Date: Wed, 23 Apr 2008 22:35:49 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080423234322.GB20819@plankton.ifup.org>
Message-ID: <Pine.LNX.4.64.0804232231250.31358@bombadil.infradead.org>
References: <200804230137.12502.laurent.pinchart@skynet.be>
	<20080423142705.62b6e444@gaivota>
	<20080423234322.GB20819@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

On Wed, 23 Apr 2008, Brandon Philips wrote:

> On 14:27 Wed 23 Apr 2008, Mauro Carvalho Chehab wrote:
>>> + * ...  It implements the
>>> + * mmap capture method only ...
>>
>> You should consider moving to videobuf on a later version. videobuf also
>> implements read() method, and will likely implement also USERPTR and maybe
>> OVERLAY on future versions.
>
> Lets shoot for doing this after 2.6.26 if Laurent signs-off.  Until then
> lets not get into this argument again :D

Hmm... I didn't notice the lack of Laurent SOB :)

As I said, this is a comment about possible improvements for later 
versions. Seems ok to me to use uvc-queue for 2.6.26.

>>> +static int uvc_v4l2_do_ioctl(struct inode *inode, struct file *file,
>>> +		     unsigned int cmd, void *arg)
>>> +{
>>> +	struct video_device *vdev = video_devdata(file);
>>> +	struct uvc_video_device *video = video_get_drvdata(vdev);
>>> +	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
>>> +	int ret = 0;
>>> +
>>> +	if (uvc_trace_param & UVC_TRACE_IOCTL)
>>> +		v4l_printk_ioctl(cmd);
>>
>> The better is to remove the do_ioctl, in favor of video_ioctl2. Also, this will
>> provide a much better debug than what's provided by v4l_printk_ioctl().
>
> We discussed this months ago and everyone agreed that video_ioctl2 is
> nice but it is not a requirement to be in the tree.

No, it is not a requirement for merging uvc. This is a suggestion for 
future improvements.

>> Driver looks sane. Just a few comments.
>
> Thanks for finding the other issues in your review Mauro; you picked up
> on some good details that should be fixed up before the merge.

Anytime.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
