Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35546 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbcLGQGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 11:06:40 -0500
Received: by mail-pg0-f51.google.com with SMTP id p66so163431350pga.2
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 08:06:38 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] [media] davinci: vpif_capture: don't lock over s_stream
References: <20161129235712.29846-1-khilman@baylibre.com>
        <4747860.QGGHSuFRpz@avalon> <m237i1gfz1.fsf@baylibre.com>
        <4999781.kd7ueUSsQd@avalon>
Date: Wed, 07 Dec 2016 08:06:36 -0800
In-Reply-To: <4999781.kd7ueUSsQd@avalon> (Laurent Pinchart's message of "Wed,
        07 Dec 2016 17:47:59 +0200")
Message-ID: <m21sxjg1v7.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

 > Hi Kevin,
>
> On Tuesday 06 Dec 2016 08:49:38 Kevin Hilman wrote:
>> Laurent Pinchart writes:
>> > On Tuesday 29 Nov 2016 15:57:09 Kevin Hilman wrote:
>> >> Video capture subdevs may be over I2C and may sleep during xfer, so we
>> >> cannot do IRQ-disabled locking when calling the subdev.
>> >> 
>> >> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> >> ---
>> >>  drivers/media/platform/davinci/vpif_capture.c | 3 +++
>> >>  1 file changed, 3 insertions(+)
>> >> 
>> >> diff --git a/drivers/media/platform/davinci/vpif_capture.c
>> >> b/drivers/media/platform/davinci/vpif_capture.c index
>> >> 5104cc0ee40e..9f8f41c0f251 100644
>> >> --- a/drivers/media/platform/davinci/vpif_capture.c
>> >> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> >> @@ -193,7 +193,10 @@ static int vpif_start_streaming(struct vb2_queue
>> >> *vq, unsigned int count)
>> >>  		}
>> >>  	}
>> >> 
>> >> +	spin_unlock_irqrestore(&common->irqlock, flags);
>> >>  	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
>> >> +	spin_lock_irqsave(&common->irqlock, flags);
>> > 
>> > I always get anxious when I see a spinlock being released randomly with an
>> > operation in the middle of a protected section. Looking at the code it
>> > looks like the spinlock is abused here. irqlock should only protect the
>> > dma_queue and should thus only be taken around the following code:
>> > 
>> > spin_lock_irqsave(&common->irqlock, flags);
>> > /* Get the next frame from the buffer queue */
>> > common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
>> >                             struct vpif_cap_buffer, list);
>> > 
>> > /* Remove buffer from the buffer queue */
>> > list_del(&common->cur_frm->list);
>> > spin_unlock_irqrestore(&common->irqlock, flags);
>> 
>> Yes, that looks correct.  Will update.
>> 
>> > The code that is currently protected by the lock in the start and stop
>> > streaming functions should be protected by a mutex instead.
>> 
>> I tried taking the mutex here, but lockdep pointed out a deadlock.  I
>> may not be fully understanding the V4L2 internals here, but it seems
>> that the ioctl is already taking a mutex, so taking it again in
>> start/stop streaming is a deadlock.  Unless you think the locking should
>> be nested here, it seems to me that the mutex isn't needed.
>
> The V4L2 core can lock all ioctls using struct video_device::lock. For buffer-
> related ioctls, it can optionally use a separate lock from struct 
> vb2_queue::lock. See v4l2_ioctl_get_lock() in drivers/media/v4l2-core/v4l2-
> ioctl.c.
>
> The vpif-capture driver sets both the video_device and vb2_queue locks to the 
> same lock (which would have the same effect as leaving the vb2_queue lock 
> NULL). All ioctls are thus serialized. You would only need to handle locking 
> in start_streaming and stop_streaming manually if you didn't rely on the core 
> serializing the ioctls.

OK, thanks for clarifying how that works.

Kevin
