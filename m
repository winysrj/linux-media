Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:53704 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbbFIBl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 21:41:59 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NPN0169FM1WPVC0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jun 2015 10:41:56 +0900 (KST)
Message-id: <55764463.7080908@samsung.com>
Date: Tue, 09 Jun 2015 10:41:55 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sangbae90.lee@samsung.com,
	inki.dae@samsung.com, nenggun.kim@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [RFC PATCH 0/3] Refactoring Videobuf2 for common use
References: <1433770535-21143-1-git-send-email-jh1009.sung@samsung.com>
 <5575A9E8.3020902@xs4all.nl> <20150608143952.41f92946@recife.lan>
In-reply-to: <20150608143952.41f92946@recife.lan>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/09/2015 02:39 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 08 Jun 2015 16:42:48 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> On 06/08/2015 03:35 PM, Junghak Sung wrote:
>>> Hello everybody,
>>>
>>> This patch series refactories exsiting Videobuf2, so that not only V4L2
>>> but also other frameworks can use it to manage buffer and utilize
>>> queue.
>>>
>>> I would separate existing Videobuf2-core framework into two parts - common
>>> and v4l2-specific part. This work is as follows :
>>>
>>> 1. Separate existing vb2_buffer structure into common buffer and
>>>     v4l2-specific parts by removing v4l2-specific members and
>>>     embedding it into vb2_v4l2_buffer structure like this:
>>>
>>>      struct vb2_v4l2_buffer {
>>>          struct vb2_buffer    vb2;
>>>          struct v4l2_buffer   v4l2_buf;
>>>          struct v4l2_plane    v4l2_planes[VIDEO_MAX_PLANES];
>>>      };
>>>
>>> 2. Abstract the v4l2-specific elements, and specify them when the device
>>>     drives use them. For example, vb2_v4l2_buffer structure can be abstracted
>>>     by vb2_buffer structure, and device drivers can get framework-specific
>>>     object such as vb2_v4l2_buffer by using container_of().
>>>
>>> 3. Separate VB2-core framework into real VB2-core and v4l2-specific part.
>>>     This means that it moves V4L2-specific parts of VB2-core to v4l2-specific
>>>     part because current VB2-core framework has some codes dependent of V4L2.
>>>     As a result, we will have two VB2 files - videobuf2-core.c and
>>>     videobuf2-v4l2.c.
>>>
>>> Why do we try to make the VB2 framework to be common?
>>>
>>> As you may know, current DVB framework uses ringbuffer mechanism to demux
>>> MPEG-2 TS data and pass it to userspace. However, this mechanism requires
>>> extra memory copy because DVB framework provides only read() system call for
>>> application - read() system call copies the kernel data to user-space buffer.
>>>
>>> So if we can use VB2 framework which supports streaming I/O and buffer
>>> sharing mechanism, then we could enhance existing DVB framework by removing
>>> the extra memory copy - with VB2 framework, application can access the kernel
>>> data directly through mmap system call.
>>>
>>> This patch series is the first step for it.
>>>
>>> We have a plan for this work as follows:
>>>
>>> 1. Separate existing VB2 framework into three parts - VB2 common, VB2-v4l2,
>>>     and VB2-dvb. Of course, this change should not affect other v4l2-based
>>>     device drivers. This patch series includes some parts of this step.
>>>
>>> 2. Add new APIs for DVB streaming I/O. These APIs will be implemented
>>>     in VB2-dvb framework. So, we can remove unnecessary memory copy between
>>>     kernel-space and user-space by using these new APIs.
>>>     However, we leaves legacy interfaces as-is for backward compatibility.
>>>
>>> We are working on this project with Mauro and have a discussion with him
>>> on IRC channel weekly. Nowaday, we are discussing more detailed DVB user
>>> scenario for streaming I/O.
>>>
>>> The final goal of this project is to enhance current DVB framework.
>>> The first mission is to achieve zero-copy functionality between kernel-space
>>> and user-space with mmap system call. More missions are under consideration:
>>> i.e., we could share the buffer not only between kernel-space and user-space
>>> but also between devices - demux, hw video codec - by exporting a buffer
>>> to dmabuf fd with VB2 framework.
>>>
>>> Any suggestions and comments are welcome.
>>>
>>> Best regards,
>>> Junghak
>>>
>>> Junghak Sung (3):
>>>    modify the vb2_buffer structure for common video buffer     and make
>>>      struct vb2_v4l2_buffer
>>>    move struct vb2_queue to common and apply the changes related with
>>>      that     Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>>>    make vb2-core part with not v4l2-specific elements
>> Patch 2/3 didn't arrive at linux-media for some reason. Can you post it again?
> Probably, the patch is too big. Vger doesn't accept patches bigger than
> a few hundreds of KB. Not sure what's the current limit.
>
> Junghak added the patches on his tree too:
> 	http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/log/?h=dvb-vb2
>
> Junghak,
>
> You may try to play with the git options that improve rename/copy files,
> like:
> 	--find-copies-harder
> 	-M
> 	-C
>
> The last two options accepts a percentage parameter, like:
>    -C60	for detect changes that keep up to 60% of the original content.
>
> and:
> 	--diff-algorithm=minimal
> 	--diff-algorithm=patience
>
> Maybe with those options, the email produced by git format-patch will
> be small enough to fit at the VGER mailing list limits.
>
> If none of those work, please let us know.
I tried to reduce the size of patch 2/3 with the combinations of git 
options you recommended like :
     --minimal, --patience, -M[n], -C[n], --find-copies-harder
I found the patch 3/3 can be optimized with those options.
But, failed to optimize patch 2/3.
Is there any other solutions?

Regards,
Junghak
> Regards,
> Mauro
>   
>
>> Thanks!
>>
>> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

