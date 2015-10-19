Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39548 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbbJSH7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 03:59:04 -0400
Message-ID: <5624A248.9050809@xs4all.nl>
Date: Mon, 19 Oct 2015 09:56:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v7] Refactoring Videobuf2 for common use
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/16/2015 08:27 AM, Junghak Sung wrote:
> Hello everybody,
> 
> This is the 7th round for refactoring Videobuf2(a.k.a VB2).
> The purpose of this patch series is to separate existing VB2 framework
> into core part and V4L2 specific part. So that not only V4L2 but also other
> frameworks can use them to manage buffer and utilize queue.
> 
> Why do we try to make the VB2 framework to be common?
> 
> As you may know, current DVB framework uses ringbuffer mechanism to demux
> MPEG-2 TS data and pass it to userspace. However, this mechanism requires
> extra memory copy because DVB framework provides only read() system call for
> application - read() system call copies the kernel data to user-space buffer.
> So if we can use VB2 framework which supports streaming I/O and buffer
> sharing mechanism, then we could enhance existing DVB framework by removing
> the extra memory copy - with VB2 framework, application can access the kernel
> data directly through mmap system call.
> 
> We have a plan for this work as follows:
> 1. Separate existing VB2 framework into three parts - VB2 core, VB2 v4l2.
>    Of course, this change will not affect other v4l2-based
>    device drivers. This patch series corresponds to this step.
> 
> 2. Add and implement new APIs for DVB streaming I/O.
>    We can remove unnecessary memory copy between kernel-space and user-space
>    by using these new APIs. However, we leaves legacy interfaces as-is
>    for backward compatibility.
> 
> This patch series is the first step for it.
> The previous version of this patch series can be found at belows.
> 
> [1] RFC PATCH v1 - http://www.spinics.net/lists/linux-media/msg90688.html
> [2] RFC PATCH v2 - http://www.spinics.net/lists/linux-media/msg92130.html
> [3] RFC PATCH v3 - http://www.spinics.net/lists/linux-media/msg92953.html
> [4] RFC PATCH v4 - http://www.spinics.net/lists/linux-media/msg93421.html
> [5] RFC PATCH v5 - http://www.spinics.net/lists/linux-media/msg93810.html
> [6] RFC PATCH v6 - http://www.spinics.net/lists/linux-media/msg94112.html
> 
> 
> Changes since v6
> 1. Based on v6
> Patch series v6 was accepted (but, not merged yet). So, this series v7 is
> based on v6.
> 
> 2. Fix a warning on fimc-lite.c
> In patch series v6, a warning is reported by kbuild robot. So, this warning
> is fixed.

Fixed already in my pull request.

> 3. Move things related with vb2_thread to core part
> In order to move vb2_thread to vb2-core, these changes below would precede it.
>  - timestamp of vb2_v4l2_buffer is moved to vb2_buffer for common use.
>  - A flag - which is for checking if vb2-core should set timestamps or not - is
>   added as a member of vb2_queue.
>  - Replace v4l2-stuffs with common things in vb2_fileio_data and vb2_thread.

This looks good. However, I'm postponing merging this until after the upcoming
media workshop. The reasons for that have to do with timestamp handling and y2038
(so we probably want to use a u64 timestamp in vb2 core and use ktime_get_ns() to
fill it in), and they have to do with the poll() function which has some problems
in the output case.

I do not expect any major changes to this patch series, but I'm not quite ready
to merge it at this moment.

Regards,

	Hans
