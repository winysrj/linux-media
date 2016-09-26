Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48492
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759963AbcIZJ3D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 05:29:03 -0400
Date: Mon, 26 Sep 2016 06:28:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ajith Raj <ajith.raj@broadcom.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
        mchehab@kernel.org
Subject: Re: [Camera Driver] Building as Static v/s Dynamic module
Message-ID: <20160926062855.634f8628@vento.lan>
In-Reply-To: <3461d4fdf32e5b3a645419f0f3b1eb5b@mail.gmail.com>
References: <0afd07b4dc410140902808df6b909507@mail.gmail.com>
        <3461d4fdf32e5b3a645419f0f3b1eb5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Sep 2016 14:39:06 +0530
Ajith Raj <ajith.raj@broadcom.com> escreveu:

> Hi Maintainers,
> 
> I was working on a CPI based camera driver based on soc_camera framework
> which is compiled as a static module in kernel, due to the non-availability
> of modprobe framework.

Don't rely on soc_camera. We're in the process of rework such drivers
to use directly the V4L2 core or to remove them.

> While I was pushing the changes, I got a question from the internel  code
> review that why the driver is being compiled as static while all other
> drivers available in the open source are compiled as dynamic .ko modules.
> 
> I understand that camera as a component need not have to be built static and
> can be added later on the need basis. Is there any reason apart from this?
> Since the modprobe framework is not available, if I build it as dynamic .ko
> module, I need to insert all dependent modules independently and in the
> right order. There are many;
> 
> videobuf2-dma-contig.ko, videobuf2-v4l2.ko, videobuf2-memops.ko,
> videobuf2-vmalloc.ko, …..etc
> v4l2-common.ko, v4l2-mem2mem.ko, v4l2-dv-timings.ko
> soc_mediabus.ko,soc_camera.ko ,……etc
> media.ko, videodev.ko

You don't need to take care of the order, as modprobe inserts them
with the right dependencies automatically. You may need to use the
async probe inside V4L, though, in order to ensure that the main
driver will be initializing the sub-drivers in the right order, as
OF doesn't ensure that.

> Do you see any issues in submitting camera as a static module?
> Or it has to be dynamic? If so, could you please help me understand the
> reasons.

All media drivers should build with modprobe. The more important
reason (at least for my PoV) is that it should be built with
allmodconfig/allyesconfig, and on all architectures, if COMPILE_TEST
Kconfig define is defined.

The rationale is that building the driver this way is required
for us to avoid building problems. Also, some static code analyzers
we have (Coverity) only runs on x86.

Another thing is that drivers that don't accept dynamic module load 
very likely have hidden bugs (usually, race bugs, PM support issues,
dynamic bind/unbind issues).

> 
> Thanks in advance.
> 
> Regards,
> Ajith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Thanks,
Mauro
