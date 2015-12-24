Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54170 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbLXKyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 05:54:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: karthik poduval <karthik.poduval@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
Date: Thu, 24 Dec 2015 12:54:51 +0200
Message-ID: <3419549.kxZAihUTho@avalon>
In-Reply-To: <CAFP0Ok9t53p6zAJBBu=ov7O8nfrwvn=RxJUCkOPgFmJ3xuzbEQ@mail.gmail.com>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange> <Pine.LNX.4.64.1512221122420.31855@axis700.grange> <CAFP0Ok9t53p6zAJBBu=ov7O8nfrwvn=RxJUCkOPgFmJ3xuzbEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Karthik,

On Tuesday 22 December 2015 05:30:52 karthik poduval wrote:
> I have been wanting to share these thoughts for the group but was
> waiting for the right time which I think is now since Guennadi brought
> up this discussion.
> 
> For the Amazon Fire phone 4 corner camera, here is how we passed
> metadata from driver to application (which was a CV client requiring
> per frame metadata).
> 
> We took an unused field in struct v4l2_buffer (__u32 reserved in this
> case) and used it to pass in a pointer to a user space metadata object
> (i.e. struct app_metadata) to the driver via the VIDIOC_DQBUF ioctl
> call.
> 
> struct v4l2_buffer for reference.
> http://lxr.free-electrons.com/source/include/uapi/linux/videodev2.h#L836
> 
> The driver copied its local copy of the metadata object to the
> userspace metadata object using the copy_to_user primitive offered by
> the kernel.
> 
> Here is how we handled the metadata in the driver code.
> https://github.com/Fire-Phone/android_kernel_amazon_kodiak/blob/master/drive
> rs/media/platform/msm/camera_v2/camera/camera.c#L235
> 
> This was done before HAL V3 was available. With HAL V3, the metadata
> object can be the HAL v3 metadata buffer. Non Android devices can use
> custom metadata format (like the one we used).
> 
> With this approach, the metadata always accompanies the frame data as
> it's available along with the frame buffer inside struct v4l2_buffer
> from the VIDIOC_DQBUF ioctl call.
> 
> If the community likes this idea, the v4l2_buffer can now be
> officially modified to contain a pointer to user space metadata object
> v4l2_buffer.metadata and then metadata format and size can be agreed
> upon between application and driver.
> Thoughts ?

I see several issues with that approach. The first one is that the meta-data 
buffer is only passed at DQBUF time. Drivers thus need to copy data using the 
CPU instead of capturing meta-data directly to the buffer through DMA. If the 
meta-data size is small the performance impact can be negligible, but that 
might not be true in the general case.

A second issue is that the approach isn't generic enough in my opinion. If we 
want to attach additional data buffers to a v4l2_buffer I agree with Sakari 
that we should design a multi-part buffer API in order to not limit the 
implementation to meta-data, but support other kind of information such as 
statistics for instance.

Finally, it might be beneficial in some use cases to pass meta-data to 
userspace before the end of the frame (assuming meta-data is available earlier 
of course). That's certainly true for statistics, use cases for meta-data are 
less clear to me though.

-- 
Regards,

Laurent Pinchart

