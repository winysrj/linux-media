Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46349 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057Ab2IKAkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 20:40:06 -0400
Subject: Re: [RFC API] Capture Overlay API ambiguities
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 10 Sep 2012 20:39:47 -0400
In-Reply-To: <201209101714.54365.hverkuil@xs4all.nl>
References: <201209101714.54365.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1347323994.2499.23.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-09-10 at 17:14 +0200, Hans Verkuil wrote:
> Hi all,
> 
> While working on making bttv compliant with the V4L2 API I managed to resolve
> all v4l2-compliance errors except for two:
> 
>                 fail: v4l2-test-formats.cpp(339): !fmt.width || !fmt.height
>         test VIDIOC_G_FBUF: FAIL
>                 fail: v4l2-test-formats.cpp(607): Video Overlay is valid, but no S_FMT was implemented
>         test VIDIOC_S_FMT: FAIL
> 
> After some analysis it turns out to be an ambiguity in VIDIOC_G_FBUF and
> VIDIOC_G_FMT for overlays.
> 
> The first relates to what VIDIOC_G_FBUF should return if there is no framebuffer
> set? I.e. if VIDIOC_S_FBUF was never called?
> 
> Should G_FBUF return an error, or provide non-zero but dummy struct v4l2_pix_format
> values and only leave base to NULL, or should the whole v4l2_framebuffer structure
> be zeroed (except for the capability field)?
> 
> bttv just zeroes everything.
> 
> Currently v4l2-compliance assumes that there is at least a dummy fmt setup. But
> I think that is unreasonably for destructive capture overlays.
> 
> I would prefer to zero everything except for the capability field.
> 
> Returning an error is not an option IMHO: even if there is no framebuffer defined,
> the capability field is still useful information to have.
> 
> The second error is related to the first: what should happen if you try to set
> a capture overlay format with S_FMT and no framebuffer is defined? The driver
> cannot really validate the given format without knowing what the framebuffer
> is like.
> 
> Currently I am returning some dummy values for G_FMT and TRY_FMT in that case,
> but for S_FMT I cannot do even that.
> 
> While normally the G/S/TRY_FMT ioctls should never return an error, I think
> that in this particular case we should allow an error code. I am proposing
> ENODATA because, well, there is no data w.r.t. the framebuffer.

I agree that something better and more distinct than EINVAL is needed.

Not that the exact error return code really matters, but ENODATA is one
of those little used things in POSIX that looks like it was really only
meant for read-data-releated POSIX STREAMS ioctl()s:

http://pubs.opengroup.org/onlinepubs/009695399/functions/ioctl.html

Maybe one of ENXIO, ENOTTY, or EPROTO would be better?
http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_03.html#tag_02_03

Regards,
Andy

> The current bttv driver returns EINVAL for these cases, but that's too generic
> I think.


> So in the case of destructive capture overlays the G/S/TRY_FMT ioctls should
> return ENODATA if no framebuffer was configured.
> 
> Comments?
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


