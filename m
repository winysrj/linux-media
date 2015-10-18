Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36658 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbbJRX21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2015 19:28:27 -0400
Date: Sun, 18 Oct 2015 16:28:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Florian Echtler <floe@butterbrot.org>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: ERROR: "vb2_ops_wait_finish"
 [drivers/input/touchscreen/sur40.ko] undefined!
Message-ID: <20151018232824.GB12041@dtor-ws>
References: <201510180859.AAKuUlU9%fengguang.wu@intel.com>
 <5622F3A3.4010407@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5622F3A3.4010407@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 17, 2015 at 06:19:31PM -0700, Randy Dunlap wrote:
> On 10/17/15 17:38, kbuild test robot wrote:
> > Hi Florian,
> > 
> > FYI, the error/warning still remains.
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   81429a6dbcbf3a01830de42dbdf0d9acbe68e1c1
> > commit: e831cd251fb91d6c25352d322743db0d17ea11dd [media] add raw video stream support for Samsung SUR40
> > date:   7 months ago
> > config: x86_64-randconfig-s5-10180707 (attached as .config)
> > reproduce:
> >         git checkout e831cd251fb91d6c25352d322743db0d17ea11dd
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > All errors (new ones prefixed by >>):
> > 
> >>> ERROR: "vb2_ops_wait_finish" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ops_wait_prepare" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_fop_release" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "v4l2_fh_open" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_fop_mmap" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "video_ioctl2" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_fop_poll" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_fop_read" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_streamoff" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_streamon" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_create_bufs" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_dqbuf" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_expbuf" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_qbuf" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_querybuf" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_ioctl_reqbufs" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "__video_register_device" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "video_device_release_empty" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_dma_sg_init_ctx" [drivers/input/touchscreen/sur40.ko] undefined!
> >>> ERROR: "vb2_queue_init" [drivers/input/touchscreen/sur40.ko] undefined!
> > 
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> > 
> 
> patch is here:  https://lkml.org/lkml/2015/7/10/507

I picked it up.

Thanks.

-- 
Dmitry
