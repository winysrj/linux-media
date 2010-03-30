Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1593 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0C3Vgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 17:36:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: dean <dean@sensoray.com>
Subject: Re: [PATCH] s2255drv: cleanup of driver disconnect code
Date: Tue, 30 Mar 2010 23:36:30 +0200
Cc: David Ellingsworth <david@identd.dyndns.org>,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	isely@pobox.com, andre.goddard@gmail.com,
	linux-media@vger.kernel.org
References: <tkrat.7f9b79c0eafb6d4f@sensoray.com> <4BB263C4.4040900@sensoray.com> <201003302309.49188.hverkuil@xs4all.nl>
In-Reply-To: <201003302309.49188.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003302336.30959.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 March 2010 23:09:49 Hans Verkuil wrote:
> On Tuesday 30 March 2010 22:49:08 dean wrote:
> > Thanks for this and the other feedback.
> > 
> > The concern, without knowing the full history, is if video_device_alloc 
> > changes to do more than just allocate the whole structure with a single 
> > call to kzalloc?  Otherwise, why have this extra indirection and 
> > overhead in most V4L drivers?
> 
> It is unlikely that video_device_alloc() will change. I think it is just
> historical. I have a preference for not allocating it at all, but embedding
> it in a larger struct. This type of embedding is very common in the kernel.
> 
> But if you do allocate it, then use video_device_alloc() rather than kzalloc,
> if only because that makes it consistent and easier to grep on should we
> need to replace it in the future.

Just a quick follow-up: if someone is going to do some work on this driver,
then it would be nice if the BKL (lock_kernel) can be removed as well.

And also add struct v4l2_device. Admittedly, that doesn't do much (yet), but
it will become more important in the near future. Eventually this struct will
be required by all drivers.

There are more things that can be simplified as well. Let me know if someone
is interested in cleaning up/improving this driver.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> > The majority of V4L drivers are using video_device_alloc.  Very few 
> > (bw-qcam.h, c-qcam.c, cpia.h, pvrusb2, usbvideo) are using "struct 
> > video_device" statically similar to solution 1.  Three drivers(zoran, 
> > radio-gemtek, saa5249) are allocating their own video_device structure 
> > directly with kzalloc similar to solution #2.
> > 
> > The call definitely needs checked, but I'd like some more feedback on this.
> > 
> > Thanks and best regards,
> > 
> > Dean
> > 
> > 
> > 
> > 
> > David Ellingsworth wrote:
> > > This patch looks good, but there was one other thing that caught my eye.
> > >
> > > In s2255_probe_v4l, video_device_alloc is called for each video
> > > device, which is nothing more than a call to kzalloc, but the result
> > > of the call is never verified.
> > >
> > > Given that this driver has a fixed number of video device nodes, the
> > > array of video_device structs could be allocated within the s2255_dev
> > > struct. This would remove the extra calls to video_device_alloc,
> > > video_device_release, and the additional error checks that should have
> > > been there. If you'd prefer to keep the array of video_device structs
> > > independent of the s2255_dev struct, an alternative would be to
> > > dynamically allocate the entire array at once using kcalloc and store
> > > only the pointer to the array in the s2255_dev struct. In my opinion,
> > > either of these methods would be better than calling
> > > video_device_alloc for each video device that needs to be registered.
> > >
> > > Regards,
> > >
> > > David Ellingsworth
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
