Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33729 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbaLSP1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 10:27:11 -0500
Message-ID: <549443C9.6090900@xs4all.nl>
Date: Fri, 19 Dec 2014 16:27:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] [Patch] implement video driver for sur40
References: <5492D7E8.504@butterbrot.org> <5492E091.1060404@xs4all.nl> <54943680.3020007@butterbrot.org> <549437DA.6090601@xs4all.nl> <54943CC2.6040803@butterbrot.org>
In-Reply-To: <54943CC2.6040803@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/19/2014 03:57 PM, Florian Echtler wrote:
> On 19.12.2014 15:36, Hans Verkuil wrote:
>> On 12/19/2014 03:30 PM, Florian Echtler wrote:
>>> Ran the most recent version from git master, got a total of 6 fails, 4
>>> of which are probably easy fixes:
>>>
>>>> fail: v4l2-compliance.cpp(306): missing bus_info prefix ('USB:1')
>>>> test VIDIOC_QUERYCAP: FAIL
>>> Changed the relevant code to:
>>>   usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
>>> 	
>>>> fail: v4l2-test-input-output.cpp(455): could set input to invalid input 1
>>>> test VIDIOC_G/S/ENUMINPUT: FAIL
>>> Now returning -EINVAL when S_INPUT called with input != 0.
>>>
>>>> fail: v4l2-test-formats.cpp(322): !colorspace
>>>> fail: v4l2-test-formats.cpp(429): testColorspace(pix.pixelformat,
>>> pix.colorspace, pix.ycbcr_enc, pix.quantization)
>>>> test VIDIOC_G_FMT: FAIL
>>> Setting colorspace in v4l2_pix_format to V4L2_COLORSPACE_SRGB.	
>>>
>>>> fail: v4l2-compliance.cpp(365): doioctl(node, VIDIOC_G_PRIORITY, &prio)
>>>> test VIDIOC_G/S_PRIORITY: FAIL
>>> Don't know how to fix this - does this mean VIDIOC_G/S_PRIORITY _must_
>>> be implemented?
>>>
>>>> fail: v4l2-test-buffers.cpp(500): q.has_expbuf(node)
>>>> test VIDIOC_EXPBUF: FAIL
>>> Also not clear how to fix this one.

This is most likely fallout from the G_FMT failure above. If you fix that,
then this should be OK.

>>>
>>> Could you give some hints on the last two?
>>
>> Can you post the driver code you used to run these tests? And which kernel version
>> and git tree did you base your patch on?
> Driver code is attached (should be identical to the one from initial
> mail). Kernel version used for the tests is 3.16.0-25 from Ubuntu

OK, 3.16 explains the PRIO failure. For that kernel you need to set this
flag in struct video_device:

	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);

This flag went away in 3.17 or 3.18 since it has now become standard behavior.

> Utopic, git tree for patches is currently
> https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> 
> I'm building the module standalone on the target machine, since it's not
> powerful enough that you would want to do a full kernel build. However,
> since the driver was merged into mainline, no other changes have been
> made, so I think it shouldn't be a problem to patch against the original
> git tree?

drivers/media remains under heavy development, so for video capture drivers
like yours you should always patch against either the mainline linux tree
or (preferred) the media_tree.git repo (git://linuxtv.org/media_tree.git,
master branch).

Regards,

	Hans
