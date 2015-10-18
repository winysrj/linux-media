Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbJRBTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2015 21:19:42 -0400
Subject: Re: ERROR: "vb2_ops_wait_finish" [drivers/input/touchscreen/sur40.ko]
 undefined!
To: kbuild test robot <fengguang.wu@intel.com>,
	Florian Echtler <floe@butterbrot.org>
References: <201510180859.AAKuUlU9%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5622F3A3.4010407@infradead.org>
Date: Sat, 17 Oct 2015 18:19:31 -0700
MIME-Version: 1.0
In-Reply-To: <201510180859.AAKuUlU9%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/17/15 17:38, kbuild test robot wrote:
> Hi Florian,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   81429a6dbcbf3a01830de42dbdf0d9acbe68e1c1
> commit: e831cd251fb91d6c25352d322743db0d17ea11dd [media] add raw video stream support for Samsung SUR40
> date:   7 months ago
> config: x86_64-randconfig-s5-10180707 (attached as .config)
> reproduce:
>         git checkout e831cd251fb91d6c25352d322743db0d17ea11dd
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>>> ERROR: "vb2_ops_wait_finish" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ops_wait_prepare" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_fop_release" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "v4l2_fh_open" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_fop_mmap" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "video_ioctl2" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_fop_poll" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_fop_read" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_streamoff" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_streamon" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_create_bufs" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_dqbuf" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_expbuf" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_qbuf" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_querybuf" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_ioctl_reqbufs" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "__video_register_device" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "video_device_release_empty" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_dma_sg_init_ctx" [drivers/input/touchscreen/sur40.ko] undefined!
>>> ERROR: "vb2_queue_init" [drivers/input/touchscreen/sur40.ko] undefined!
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

patch is here:  https://lkml.org/lkml/2015/7/10/507


-- 
~Randy Dunlab

