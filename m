Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49576 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758752AbdLRPcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 10:32:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 08/17] media: v4l2-ioctl.h: convert debug macros into enum and document
Date: Mon, 18 Dec 2017 17:32:11 +0200
Message-ID: <2353823.dVyOV93MJo@avalon>
In-Reply-To: <20171218131326.20f8241c@vento.lan>
References: <cover.1506548682.git.mchehab@s-opensource.com> <75398545.O2kI4imJ1e@avalon> <20171218131326.20f8241c@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday, 18 December 2017 17:13:26 EET Mauro Carvalho Chehab wrote:
> Em Fri, 13 Oct 2017 15:38:11 +0300 Laurent Pinchart escreveu:
> > On Thursday, 28 September 2017 00:46:51 EEST Mauro Carvalho Chehab wrote:
> >> Currently, there's no way to document #define foo <value>
> >> with kernel-doc. So, convert it to an enum, and document.
> > 
> > The documentation seems fine to me (except for one comment below).
> > However, converting macros to an enum just to work around a defect of the
> > documentation system doesn't seem like a good idea to me. I'd rather find
> > a way to document macros.
> 
> I agree that this limitation should be fixed.
> 
> Yet, in this specific case where we have an "array" of defines, all
> associated to the same field (even being a bitmask), and assuming that
> we would add a way for kernel-doc to parse this kind of defines
> (not sure how easy/doable would be), then, in order to respect the
> way kernel-doc markup is, the documentation for those macros would be:
> 
> 
> /**
>  * define: Just log the ioctl name + error code
>  */
> #define V4L2_DEV_DEBUG_IOCTL		0x01
> /**
>  * define: Log the ioctl name arguments + error code
>  */
> #define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
> /**
>  * define: Log the file operations open, release, mmap and get_unmapped_area
> */
> #define V4L2_DEV_DEBUG_FOP		0x04
> /**
>  * define: Log the read and write file operations and the VIDIOC_(D)QBUF
> ioctls */
> #define V4L2_DEV_DEBUG_STREAMING	0x08
> 
> IMHO, this is a way easier to read/understand by humans, and a way more
> coincise:
> 
> /**
>  * enum v4l2_debug_flags - Device debug flags to be used with the video
>  *	device debug attribute
>  *
>  * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
>  * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
>  * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
>  *				mmap and get_unmapped_area syscalls.
>  * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
>  *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
>  */
> 
> It also underlines the aspect that those names are grouped altogether.
> 
> So, IMHO, the main reason to place them inside an enum and document
> as such is that it looks a way better for humans to read.

As we're talking about extending kerneldoc to document macros, we're free to 
decide on a format that would make it easy and clear. Based on your above 
example, we could write it

/**
 * define v4l2_debug_flags - Device debug flags to be used with the video
 *	device debug attribute
 *
 * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
 * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
 * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
 *				mmap and get_unmapped_area syscalls.
 * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
 *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
 */

That would be simple, clear, and wouldn't require a code change to workaround 
a limitation of the documentation system.

-- 
Regards,

Laurent Pinchart
