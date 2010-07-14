Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50460 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab0GNQpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 12:45:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OZ54x-0005UI-L6
	for linux-media@vger.kernel.org; Wed, 14 Jul 2010 18:45:03 +0200
Received: from 217067201162.u.itsa.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 14 Jul 2010 18:45:03 +0200
Received: from p.osciak by 217067201162.u.itsa.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 14 Jul 2010 18:45:03 +0200
To: linux-media@vger.kernel.org
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH] Fix VIDIOC_QBUF compat ioctl32
Date: Wed, 14 Jul 2010 16:41:20 +0000 (UTC)
Message-ID: <i1kpbf$7h4$1@dough.gmane.org>
References: <m3bpgi448o.fsf@anduin.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 25 Jan 2010 16:02:31 +0100, Arnaud Patard wrote:

> When using VIDIOC_QBUF with memory type set to V4L2_MEMORY_MMAP, the
> v4l2_buffer buffer gets unmodified on drivers like uvc (well, only
> bytesused field is modified). Then some apps like gstreamer are reusing
> the same buffer later to call munmap (eg passing the buffer "length"
> field as 2nd parameter of munmap).
> 
> It's working fine on full 32bits but on 32bits systems with 64bit
> kernel, the get_v4l2_buffer32() doesn't copy length/m.offset values and
> then copy garbage to userspace in put_v4l2_buffer32().
> 
> This has for consequence things like that in the libv4l2 logs:
> 
> libv4l2: v4l2 unknown munmap 0x2e2b0000, -2145144908 libv4l2: v4l2
> unknown munmap 0x2e530000, -2145144908
> 
> The buffer are not unmap'ed and then if the application close and open
> again the device, it won't work and logs will show something like:
> 
> libv4l2: error setting pixformat: Device or resource busy
> 
> The easy solution is to read length and m.offset in get_v4l2_buffer32().
> 
> 
> Signed-off-by: Arnaud Patard <apatard@mandriva.com> ---
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    5 	5 +	0 -	0 ! 1 file
>  changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/media/video/v4l2-compat-ioctl32.c
> =================================================================== ---
> linux-2.6.orig/drivers/media/video/v4l2-compat-ioctl32.c +++
> linux-2.6/drivers/media/video/v4l2-compat-ioctl32.c @@ -475,6 +475,9 @@
> static int get_v4l2_buffer32(struct v4l2
>  			return -EFAULT;
>  	switch (kp->memory) {
>  	case V4L2_MEMORY_MMAP:
> +		if (get_user(kp->length, &up->length) ||
> +			get_user(kp->m.offset, &up->m.offset))
> +			return -EFAULT;
>  		break;
>  	case V4L2_MEMORY_USERPTR:
>  		{

Could you give more details on how this helps your application? Especially, why
is length needed? Length should be returned by driver, but this is the get_*
function, so userspace->kernel...

Could you explain this with a bit more context please? Thanks!

Best regards,
-- 
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

