Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54004 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1KZMVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 07:21:08 -0500
Received: by bke11 with SMTP id 11so5589631bke.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 04:21:06 -0800 (PST)
Message-ID: <4ED0D9AD.90603@gmail.com>
Date: Sat, 26 Nov 2011 13:21:01 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4][media] Exynos4 JPEG codec v4l2 driver
References: <1322213893-5462-1-git-send-email-andrzej.p@samsung.com> <20111126095625.GA29805@valkosipuli.localdomain>
In-Reply-To: <20111126095625.GA29805@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/26/2011 10:56 AM, Sakari Ailus wrote:
> On Fri, Nov 25, 2011 at 10:38:13AM +0100, Andrzej Pietrasiewicz wrote:
> ...
>> +static int s5p_jpeg_s_jpegcomp(struct file *file, void *priv,
>> +			       struct v4l2_jpegcompression *compr)
>> +{
>> +	struct s5p_jpeg_ctx *ctx = priv;
>> +
>> +	if (ctx->mode == S5P_JPEG_DECODE)
>> +		return -ENOTTY;
>> +
>> +	compr->quality = clamp(compr->quality, S5P_JPEG_COMPR_QUAL_BEST,
>> +			       S5P_JPEG_COMPR_QUAL_WORST);
>> +
>> +	ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - compr->quality;
>> +
>> +	return 0;
> 
> The quality paramaeter of VIDIOC_S_JPEGCOMP is badly documented and its
> value range is unspecified. To make the matter worse, VIDIOC_S_JPEGCOMP is a
> write-only IOCTL, so the user won't be able to know the value the driver
> uses. This forces the user space to know the value range for quality. I
> think we have a good change to resolve the matter properly now.
> 
> I can think of two alternatives, both of which are very simple.
> 
> 1) Define the value range for v4l2_jpegcompression. The driver implements
> four, so they essentially would be 0, 33, 66 and 100, if 0--100 is chosen as
> the standard range. This is what I have seen is often used by jpeg
> compression programs.

This is improving a situation a bit but it's not really solving anything, using
Muaro's words, let's not waste time investing in a dead horse. ;)

I'm in favour of creating a new control for jpeg quality and leave the range 
driver-specific, with only requirement that ascending values should indicate
better quality, i.e. lower compression ratio. 

Did you have a chance to look at this RFC [1] ? I have reviewed usage 
of VIDIOC_[S/G]_JPEGCOMP ioctls and there are also some links to previous 
discussion there. 

> 
> 2) Define a new control for jpeg quality. Its value range can be what the
> hardware supports and the user space gets much better information on the
> capabilities of the hardware and the granularity of the quality setting.

This was my conclusion as well. That sounds like a most effective and flexible 
solution. IIRC, Hans also suggested those things might be a perfect candidate
for a control class.

> 
> I might even favour the second one. I also wonder how many user space
> applications use this IOCTL, so if we're breaking anything by not supporting
> it.

I imagine we could deprecate 'quality' and 'jpeg_markers' fields of v4l2_jpegcompression
and during deprecation period add support for the controls for these parameters,
so the application can adapt and fall back to a control based interface once the
ioctl is removed in the kernel.
This should be possible for almost all drivers as they virtually use G/S_JPEGCOMP 
ioctls for image quality only.  

> 
> Or we could decide to do option 1 right now and implement 2) later on. I can
> write a patch to change the documentation.

The documentation could always be improved. But I personally would like to see these
ioctls die, as they're really hopeless as a part of public API. I though about
something like

/* The ioctls to configure/query selected data segment in a jpeg encoder */  
#define VIDIOC_G_JPEGCOMP        _IOR('V', 61, struct v4l2_jpegcomp)
#define VIDIOC_S_JPEGCOMP        _IOW('V', 62, struct v4l2_jpegcomp)

/**
 * struct v4l2_jpegcomp - JPEG segment data structure
 *
 * @id: field indicating what standard JPEG data segment @data contains
 * @data: points the segment data
 * @length: length of the segment
 */
struct v4l2_jpegcomp {
	__u32 id;		 

        int  length;
        void  *data;
};


As a side note, our plan was to get merged the S5P JPEG codec in v3.3, with 
the old jpeg ioctls and then switch to the controls when they're ready, possibly
in subsequent kernel release. That's why the driver is marked as experimental.


--
Regards,
Sylwester


[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg39012.html

