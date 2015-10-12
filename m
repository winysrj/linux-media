Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48001 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbbJLMss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 08:48:48 -0400
Message-ID: <561BABB9.4010804@xs4all.nl>
Date: Mon, 12 Oct 2015 14:46:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v6 0/4] Refactoring Videobuf2 for common use
References: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
In-Reply-To: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

I've accepted this v6 series and made a pull request for Mauro.

I am still not happy about the queue_setup patch, but that can be changed
later.

Regards,

	Hans

On 10/06/2015 11:37 AM, Junghak Sung wrote:
> Hello everybody,
> 
> This is the 6th round for refactoring Videobuf2(a.k.a VB2).
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
> 
> Changes since v5
> 1. v5 is merged partially to media_tree
> 4 of 8 patches - restructuring vb2_buffer for common use - are merged to
> media_tree. So, v6 is rebased on later version than that.
> 
> 2. vb2_format is reverted to void *
> vb2_format - which is newly defined for queue_setup() in v5 to deliver
> the format information from user-space to device driver - is reverted to
> void pointer. This change requires more discussion about the way to do
> the format validation and decide the image size.
> So, in this version, I would like to revert it to original version.
> 
> 3. The change related with v4l2_buf_ops is moved
> The change related with v4l2_buf_ops seems to be a sort of functional change.
> So, it was moved to patch 3/4 - which includes the most of functional changes.
> 
> 
> Changes since v4
> 1. Rebase on 4.3-rc1
> Kernel 4.3-rc1 was released. So, this patch set is made based on
> that version.
> 
> 2. Modify queue_setup() argument
> In previous patch set, struct v4l2_format, which is a parameter of
> queue_setup(), is abstracted by using void pointer. But, it is better way to
> pass the parameter with presise meaning than abstracting it.
> So, replace void * with struct vb2_format which is newly defined to contain
> the format information for common use.
> 
> 3. Add a code to check if VB2_MAX_* match with VIDEO_MAX_*
> Add a check code to videobuf2-v4l2.c where the compiler compares VIDEO_MAX_FRAME
> and VB2_MAX_FRAME (and ditto for MAX_PLANES) and throws an #error if they
> do not match.
> 
> 4. Change the commit order
> For easier review, the patch that just move things around without doing any
> functional change is moved to the last.
> 
> All ideas above are from Hans and it seems to be better and right way.
> 
> 
> Changes since v3
> 
> 1. Resolve build errors
> In previous patch set, the build errors prevented reviewers from applying
> the patch. So, in this patch, I tryed to fix the build errors but I hadn't
> the build test on all architectures except for x86 and ARM.
> 
> 2. Modify descriptions for DocBook
> Descriptions not complying with the DocBook rule are modified,
> which was pointed out by Mauro.
> 
> 3. Initialize reserved fields explicitly
> The reserved fields of v4l2_buffer are initialized by 0 explicitly
> when the vb2_buffer information is returned to userspace,
> which was pointed out by Hans.
> 
> 4. Remove unnecessary type-cast
> According to Mauro's advice, the unnecessary type-cast are removed
> because it's better for the compiler - rather than human - to check those
> things.
> 
> 5. Sperate the patch - not easy to review - into two patches
> In previous patch set, patch 5 was too difficult to review. So accoring to
> Hans' opinion, it separated the patch without any functional changes.
> 
> 
> Changes since v2
> 
> 1. Remove v4l2 stuffs completely from vb2_buffer
> The v4l2 stuffs - v4l2_buf and v4l2_planes - are removed completely from
> struct vb2_buffer. New member variables - index, type, memory - are added
> to struct vb2_buffer, all of which can be used commonly. And bytesused,
> length, offset, userptr, fd, data_offset are added to struct vb2_plane
> for the same reason. So, we can manage video buffer by only using
> struct vb2_buffer.
> And, v4l2 stuffs - flags, field, timestamp, timecode, sequence - are defined
> as member variables of struct vb2_v4l2_buffer.
> 
> 2. Create new header file for VB2 internal use
> videobuf2-internal.h is created, which is referred by videobuf2-core
> and videobuf2-v4l2. The header file contains dprintk() for debug,
> macro functions to invoke various callbacks, and vb2_core_* function prototypes
> referred by inside of videobuf2.
> 
> 3. Remove buffer-specific callbacks as much as possible
> There were many callback functions to handle video buffer information
> in previous patch series. In this patch series, I try to remove these callbacks
> as much as possible without breaking the existing function flow.
> As a result, only four callbacks are remained - fill_user_buffer(),
> fill_vb2_buffer(), fill_vb2_timestamp() and is_last().
> 
> All ideas above are from Hans and it seems to be better and right way.
> 
> 
> Changes since v1
> 
> 1. Divide patch set into more pieces
> v1 was not reviewed normally because the 2/3 patch is failed to send to mailing
> list with size problem - over 300kb. So I have divided the patch set into five
> pieces and refined them neatly, which was pointed by Hans.
> 
> 2. Add shell scripts for renaming patch
> In case of renaming patch, shell scripts are included inside the body of the
> patches by Mauro's advice. 1/5 and 5/5 patches include these scripts, which can
> be used by reviewers or maintainers to regenerate big patch file if something
> goes wrong during patch apply.
> 
> 3. Remove dependency on v4l2 from videobuf2
> In previous patch set, videobuf2-core uses v4l2-specific stuff as it is.
> e.g. enum v4l2_buf_type and enum v4l2_memory. That prevented other frameworks
> from using videobuf2 independently and made them forced to include
> v4l2-specific stuff.
> In this version, these dependent stuffs are replaced with VB2 own stuffs.
> e.g. enum vb2_buf_type and enum vb2_memory. So, v4l2-specific header file isn't
> required to use videobuf2 in other modules. Please, note that videobuf2 stuffs
> will be translated to v4l2-specific stuffs in videobuf2-v4l2.c file for
> backward compatibility.
> 
> 4. Unify duplicated definitions
> VB2_DEBUG() is newly defined in videobuf2-core header file in order to unify
> duplicated macro functions that invoke callback functions implemented in vb2
> backends - i.e., videobuf2-vmalloc and videobuf2-dma-sg - and queue relevant
> callbacks of device drivers.
> In previous patch set, these macro functions were defined
> in both videobuf2-core.c and videobuf2-v4l2.c.
> 
> 
> This patch series is based on media_tree.git [6]. I have applied this patches
> to my own git [7] for review, and tested this patch series on ubuntu
> PC(Intel i7-3770) for x86 system and odroid-xu3(exynos5422) for ARM.
> 
> [6] media_tree.git - http://git.linuxtv.org/cgit.cgi/media_tree.git/
> [7] jsung/dvb-vb2.git - http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/
>     (branch: vb2-refactoring)
> 
> Any suggestions and comments are welcome.
> 
> Regards,
> Junghak

