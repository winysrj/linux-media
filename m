Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4863 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaAGNWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:22:10 -0500
Message-ID: <52CBFF70.6010604@xs4all.nl>
Date: Tue, 07 Jan 2014 14:21:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Question about videobuf2 with 0 buffers
References: <CAPybu_0fyzj45rhia71Qq+5QOps0EeuRNqcXDDo+D0HW7Exwdw@mail.gmail.com>
In-Reply-To: <CAPybu_0fyzj45rhia71Qq+5QOps0EeuRNqcXDDo+D0HW7Exwdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2014 02:09 PM, Ricardo Ribalda Delgado wrote:
> Hello
> 
>   White testing a driver I have stepped into some strange behaviour
> and I want to know if it is a feature or a bug.
> 
>    I am using yavta to test the system and I run this command:
> 
> yavta /dev/video0 -c -n 0
> 
> to start a capture with 0 buffers (Even if I dont know where this can be useful)
> 
> And I have found out that:
> 
> 1) If the user does a streamon() and then  close() the descriptor,
> streamoff is not called, this is because he has never been set as
> owner of the queue. (on vb2_fop_release, queue_release is only called
> if the owns the queue)
> 
> Is this expected? Shouldn't we leave the stream stopped?

No, this is a bug. vb2_internal_streamon() misses a check if q->num_buffers > 0.
If no buffers have been requested, then STREAMON should return -EINVAL.

So streamon() should never be able to start.

Note that calling REQBUFS with count == 0 will work: it will free any allocated
buffers and just return 0.

> 
> I propose to set vdev->queue->owner to the current vdev on streamon if
> it does not have an owner.
> 
> Or in vb2_fop_release set check for :
> if (!vdev->queue->owner || file->private_data == vdev->queue->owner)
> instead of
> if (file->private_data == vdev->queue->owner)
> 
> Shall I post a patch?

Yes, please, but for the real bug :-) Make sure to do a git pull, a bunch
of vb2 patches have just been merged.

> 
> 2) the queue_setup handler of the driver is not called, this could be
> expected, since it is commented on the code.
> /*
> * In case of REQBUFS(0) return immediately without calling
> * driver's queue_setup() callback and allocating resources.
> */
> But I find it strange, the driver could be doing some initialization there...

No, reqbufs(0) is used to free buffers. And it actually can also be used
to check with memory models are supported by the driver.

So reqbufs(0) doesn't setup anything, instead it frees things and releases
the current filehandle from being the owner.

Hope this helps,

	Hans
