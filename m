Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46274
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934808AbdBVU1j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 15:27:39 -0500
Date: Wed, 22 Feb 2017 17:25:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>,
        James Morse <james.morse@arm.com>, linux-media@vger.kernel.org,
        shijie.huang@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        mark.rutland@arm.com, akpm@linux-foundation.org,
        sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, tiffany.lin@mediatek.com,
        nick@shmanahar.org, shuah@kernel.org, ricardo.ribalda@gmail.com
Subject: Re: <Query> Looking more details and reasons for using
 orig_add_limit.
Message-ID: <20170222172541.49b7cbb1@vento.lan>
In-Reply-To: <2944633.ljab0sy3Dg@avalon>
References: <def87360266193184dc013a055ec3869@codeaurora.org>
        <58A58162.2020101@arm.com>
        <568205ddc2e7af6a57a71b8c5cd47d68@codeaurora.org>
        <2944633.ljab0sy3Dg@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 22 Feb 2017 21:53:08 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Prasad,
> 
> On Tuesday 21 Feb 2017 06:20:58 Sodagudi Prasad wrote:
> > Hi mchehab/linux-media,
> > 
> > It is not clear why KERNEL_DS was set explicitly here. In this path
> > video_usercopy() gets  called  and it
> > copies the “struct v4l2_buffer” struct to user space stack memory.
> > 
> > Can you please share reasons for setting to KERNEL_DS here?  
> 
> It's a bit of historical hack. To implement compat ioctl handling, we copy the 
> ioctl 32-bit argument from userspace, turn it into a native 64-bit ioctl 
> argument, and call the native ioctl code. That code expects the argument to be 
> stored in userspace memory and uses get_user() and put_user() to access it. As 
> the 64-bit argument now lives in kernel memory, my understanding is that we 
> fake things up with KERNEL_DS.

Precisely. Actually, if I remember well, this was needed to pass pointer
arguments from 32 bits userspace to 64 bits kernelspace. There are a lot of
V4L2 ioctls that pass structures with pointers on it. Setting DS cause
those pointers to do the right thing, but yeah, it is hackish.

This used to work fine on x86_64 (when such code was written e. g. Kernel
2.6.1x). I never tested myself on ARM64, but I guess it used to work, as we
received some patches fixing support for some ioctl compat code due to
x86_64/arm64 differences in the past.

On what Kernel version it started to cause troubles? 4.9? If so, then
maybe the breakage is a side effect of VM stack changes.

> The ioctl code should be refactored to get rid of this hack.

Agreed.

Thanks,
Mauro
