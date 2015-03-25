Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:65029 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbbCYLcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 07:32:51 -0400
Date: Wed, 25 Mar 2015 12:32:39 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: kbuild test robot <fengguang.wu@intel.com>, shuahkh@osg.samsung.com
cc: kbuild@01.org, m.chehab@samsung.com, linux-media@vger.kernel.org,
	hans.verkuil@cisco.com, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: drivers/media/usb/au0828/au0828-video.c:1741:1-3: WARNING: end
 returns can be simpified if negative or 0 value
In-Reply-To: <201503251704.WKqk4QuR%fengguang.wu@intel.com>
Message-ID: <alpine.DEB.2.10.1503251231420.2395@hadrien>
References: <201503251704.WKqk4QuR%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function does only return 0 or a negative constant, but it seems like
a matter of personal prefernce - shorter vs more explicit.

julia

On Wed, 25 Mar 2015, kbuild test robot wrote:

> TO: Shuah Khan <shuahkh@osg.samsung.com>
> CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
> CC: linux-media@vger.kernel.org
> CC: Hans Verkuil <hans.verkuil@cisco.com>
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   c875f421097a55d9126159957a2d812b91c9ce8c
> commit: 05439b1a36935992785c4f28f6693e73820321cb [media] media: au0828 - convert to use videobuf2
> date:   7 weeks ago
> :::::: branch date: 9 hours ago
> :::::: commit date: 7 weeks ago
>
> >> drivers/media/usb/au0828/au0828-video.c:1741:1-3: WARNING: end returns can be simpified if negative or 0 value
>
> git remote add linus git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> git remote update linus
> git checkout 05439b1a36935992785c4f28f6693e73820321cb
> vim +1741 drivers/media/usb/au0828/au0828-video.c
>
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1725  	q->mem_ops = &vb2_vmalloc_memops;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1726
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1727  	rc = vb2_queue_init(q);
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1728  	if (rc < 0)
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1729  		return rc;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1730
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1731  	/* Setup Videobuf2 for VBI capture */
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1732  	q = &dev->vb_vbiq;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1733  	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1734  	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1735  	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1736  	q->drv_priv = dev;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1737  	q->buf_struct_size = sizeof(struct au0828_buffer);
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1738  	q->ops = &au0828_vbi_qops;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1739  	q->mem_ops = &vb2_vmalloc_memops;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1740
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29 @1741  	rc = vb2_queue_init(q);
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1742  	if (rc < 0)
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1743  		return rc;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1744
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1745  	return 0;
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1746  }
> 05439b1a drivers/media/usb/au0828/au0828-video.c   Shuah Khan        2015-01-29  1747
> 8b2f0795 drivers/media/video/au0828/au0828-video.c Devin Heitmueller 2009-03-11  1748  /**************************************************************************/
> 8b2f0795 drivers/media/video/au0828/au0828-video.c Devin Heitmueller 2009-03-11  1749
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>
