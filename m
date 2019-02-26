Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAC7C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E3AF217F9
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551182001;
	bh=Q3PMcPZyYk7lXpXVRSw73aPhfioMF5rJZy36t6w1tjs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HBD3Cr7nOnkdhF/D38iSeeXRE0fg2VWULbZ3N5bLRf5n/TYociGC5pMhLQqruOZGK
	 /OVq/F7DjmoSHrT0uJcvf05QwRotLSkCATbehotLFft/k5+WEU2PE31onRJICC41S5
	 mtY6Yc/qlf0aDhQSDCk9MejXoSmPQtEtw4oU1pQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfBZLxP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfBZLxP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 06:53:15 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27183217F9;
        Tue, 26 Feb 2019 11:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551181993;
        bh=Q3PMcPZyYk7lXpXVRSw73aPhfioMF5rJZy36t6w1tjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AszxAvyBBEg6OQWICDLthuF/+OmY14lAe+oil6tPiYJsDHyMXRwLNOnGYXiRpGupi
         p8IFppdfGT8N/CHAZ//mc+UQsPwFvow7s+UCb66lsKqutV8x8vDJTXnxIXBlx0WvGt
         g6XCnSfSBnM/BKS7i/93ifj5/fC6K33PuuAYnRUY=
Date:   Tue, 26 Feb 2019 12:53:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hyun Kwon <hyun.kwon@xilinx.com>
Cc:     linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Stefano Stabellini <stefanos@xilinx.com>,
        linaro-mm-sig@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
Message-ID: <20190226115311.GA4094@kroah.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> Add the dmabuf map / unmap interfaces. This allows the user driver
> to be able to import the external dmabuf and use it from user space.
> 
> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> ---
>  drivers/uio/Makefile         |   2 +-
>  drivers/uio/uio.c            |  43 +++++++++
>  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/uio/uio_dmabuf.h     |  26 ++++++
>  include/uapi/linux/uio/uio.h |  33 +++++++
>  5 files changed, 313 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/uio/uio_dmabuf.c
>  create mode 100644 drivers/uio/uio_dmabuf.h
>  create mode 100644 include/uapi/linux/uio/uio.h
> 
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index c285dd2..5da16c7 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -obj-$(CONFIG_UIO)	+= uio.o
> +obj-$(CONFIG_UIO)	+= uio.o uio_dmabuf.o
>  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
>  obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
>  obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 1313422..6841f98 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -24,6 +24,12 @@
>  #include <linux/kobject.h>
>  #include <linux/cdev.h>
>  #include <linux/uio_driver.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +
> +#include <uapi/linux/uio/uio.h>
> +
> +#include "uio_dmabuf.h"
>  
>  #define UIO_MAX_DEVICES		(1U << MINORBITS)
>  
> @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
>  struct uio_listener {
>  	struct uio_device *dev;
>  	s32 event_count;
> +	struct list_head dbufs;
> +	struct mutex dbufs_lock; /* protect @dbufs */
>  };
>  
>  static int uio_open(struct inode *inode, struct file *filep)
> @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
>  	if (ret)
>  		goto err_infoopen;
>  
> +	INIT_LIST_HEAD(&listener->dbufs);
> +	mutex_init(&listener->dbufs_lock);
> +
>  	return 0;
>  
>  err_infoopen:
> @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
>  	struct uio_listener *listener = filep->private_data;
>  	struct uio_device *idev = listener->dev;
>  
> +	ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> +	if (ret)
> +		dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> +
>  	mutex_lock(&idev->info_lock);
>  	if (idev->info && idev->info->release)
>  		ret = idev->info->release(idev->info, inode);
> @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
>  	return retval ? retval : sizeof(s32);
>  }
>  
> +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)

We have resisted adding a uio ioctl for a long time, can't you do this
through sysfs somehow?

A meta-comment about your ioctl structure:

> +#define UIO_DMABUF_DIR_BIDIR	1
> +#define UIO_DMABUF_DIR_TO_DEV	2
> +#define UIO_DMABUF_DIR_FROM_DEV	3
> +#define UIO_DMABUF_DIR_NONE	4

enumerated type?

> +
> +struct uio_dmabuf_args {
> +	__s32	dbuf_fd;
> +	__u64	dma_addr;
> +	__u64	size;
> +	__u32	dir;

Why the odd alignment?  Are you sure this is the best packing for such a
structure?

Why is dbuf_fd __s32?  dir can be __u8, right?

I don't know that dma layer very well, it would be good to get some
review from others to see if this really is even a viable thing to do.
The fd handling seems a bit "odd" here, but maybe I just do not
understand it.

thanks,

greg k-h
