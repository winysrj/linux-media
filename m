Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55062 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752305AbcHZJet (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 05:34:49 -0400
Subject: Re: Plan to support Rockchip VPU in DRM, is it a good idea
To: Randy Li <randy.li@rock-chips.com>, dri-devel@lists.freedesktop.org
References: <a56a7da9-154b-c889-67f6-81bd7e4c7a7d@rock-chips.com>
Cc: airlied@linux.ie,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <526b56fc-004b-a25d-e370-3e5c03d8e2f0@xs4all.nl>
Date: Fri, 26 Aug 2016 11:34:38 +0200
MIME-Version: 1.0
In-Reply-To: <a56a7da9-154b-c889-67f6-81bd7e4c7a7d@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randi,

On 08/26/2016 04:13 AM, Randy Li wrote:
> Hello,
>    We always use some kind of hack work to make our Video Process 
> Unit(Multi-format Video Encoder/Decoder) work in kernel. From a 
> customize driver(vpu service) to the customize V4L2 driver. The V4L2 
> subsystem is really not suitable for the stateless Video process or it 
> could make driver too fat.
>    After talking to some kindness Intel guys and moving our userspace 
> library to VA-API driver, I find the DRM may the good choice for us.
> But I don't know whether it is welcome to to submit a video driver in 
> DRM subsystem?
>    Also our VPU(Video process unit) is not just like the Intel's, we 
> don't have VCS, we based on registers to set the encoder/decoder. I 
> think we may need a lots of IOCTL then. Also we do have a IOMMU in VPU 
> but also not a isolated memory for VPU, I don't know I should use TT 
> memory or GEM memory.
>    I am actually not a member of the department in charge of VPU, and I 
> am just beginning to learning DRM(thank the help from Intel again), I am 
> not so good at memory part as well(I am more familiar with CMA not the 
> IOMMU way), I may need know guide about the implementations when I am 
> going to submit driver, I hope I could get help from someone.
> 

It makes no sense to do this in the DRM subsystem IMHO. There are already
quite a few HW codecs implemented in the V4L2 subsystem and more are in the
pipeline. Putting codec support in different subsystems will just make
userspace software much harder to write.

One of the codecs that was posted to linux-media was actually from Rockchip:

https://lkml.org/lkml/2016/2/29/861

There is also a libVA driver (I think) that sits on top of it:

https://github.com/rockchip-linux/rockchip-va-driver/tree/v4l2-libvpu

For the Allwinner a patch series was posted yesterday:

https://lkml.org/lkml/2016/8/25/246

They created a pretty generic libVA userspace that looks very promising at
first glance.

What these have in common is that they depend on the Request API and Frame API,
neither of which has been merged. The problem is that the Request API requires
more work since not only controls have to be part of a request, but also formats,
selection rectangles, and even dynamic routing changes. While that is not relevant
for codecs, it is relevant for Android CameraHAL in general and complex devices
like Google's Project Ara.

This is being worked on, but it is simply not yet ready. The core V4L2 developers
involved in this plan to discuss this on the Monday before the ELCE in Berlin,
to see if we can fast track this work somehow so this support can be merged.

If there are missing features in V4L2 (other that the two APIs discussed above)
that prevent you from creating a good driver, then please discuss that with us.
We are always open to suggestions and improvements and want to work with you on
that.

Regards,

	Hans
