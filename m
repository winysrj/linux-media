Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34842 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdCNUNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 16:13:08 -0400
Received: by mail-wr0-f193.google.com with SMTP id u108so25262617wrb.2
        for <linux-media@vger.kernel.org>; Tue, 14 Mar 2017 13:13:07 -0700 (PDT)
Date: Tue, 14 Mar 2017 21:13:03 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laura Abbott <labbott@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC][PATCH] dma-buf: Introduce dma-buf test module
Message-ID: <20170314201303.2o6bhyn5yudjx4m6@phenom.ffwll.local>
References: <1489521859-20701-1-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489521859-20701-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 14, 2017 at 01:04:19PM -0700, Laura Abbott wrote:
> 
> dma-buf is designed to share buffers. Sharing means that there needs to
> be another subsystem to accept those buffers. Introduce a simple test
> module to act as a dummy system to accept dma_bufs from elsewhere. The
> goal is to provide a very simple interface to validate exported buffers
> do something reasonable. This is based on ion_test.c that existed for
> the Ion framework.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> This is basically a drop in of what was available as
> drivers/staging/android/ion/ion_test.c. Given it has no Ion specific
> parts it might be useful as a more general test module. RFC mostly
> to see if this is generally useful or not.

We already have a test dma-buf driver, which also handles reservation
objects and can create fences to provoke signalling races an all kinds of
other fun. It's drivers/gpu/drm/vgem.

If there's anything missing in there, patches very much welcome.
-Daniel

> ---
>  drivers/dma-buf/Kconfig           |   9 ++
>  drivers/dma-buf/Makefile          |   1 +
>  drivers/dma-buf/dma-buf-test.c    | 309 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/dma_buf_test.h |  67 +++++++++
>  4 files changed, 386 insertions(+)
>  create mode 100644 drivers/dma-buf/dma-buf-test.c
>  create mode 100644 include/uapi/linux/dma_buf_test.h
> 
> diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
> index ed3b785..8b3fdb1 100644
> --- a/drivers/dma-buf/Kconfig
> +++ b/drivers/dma-buf/Kconfig
> @@ -30,4 +30,13 @@ config SW_SYNC
>  	  WARNING: improper use of this can result in deadlocking kernel
>  	  drivers from userspace. Intended for test and debug only.
>  
> +config DMA_BUF_TEST
> +	bool "Test module for dma-buf"
> +	default n
> +	---help---
> +	  A test module to validate dma_buf APIs. This should not be
> +	  enabled for general use.
> +
> +	  Say N here unless you know you want this.
> +
>  endmenu
> diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> index c33bf88..5029608 100644
> --- a/drivers/dma-buf/Makefile
> +++ b/drivers/dma-buf/Makefile
> @@ -1,3 +1,4 @@
>  obj-y := dma-buf.o dma-fence.o dma-fence-array.o reservation.o seqno-fence.o
>  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
>  obj-$(CONFIG_SW_SYNC)		+= sw_sync.o sync_debug.o
> +obj-$(CONFIG_DMA_BUF_TEST)	+= dma-buf-test.o
> diff --git a/drivers/dma-buf/dma-buf-test.c b/drivers/dma-buf/dma-buf-test.c
> new file mode 100644
> index 0000000..3af131c
> --- /dev/null
> +++ b/drivers/dma-buf/dma-buf-test.c
> @@ -0,0 +1,309 @@
> +/*
> + * Copyright (C) 2013 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License versdma_buf 2, as published by the Free Software Foundatdma_buf, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#define pr_fmt(fmt) "dma-buf-test: " fmt
> +
> +#include <linux/dma-buf.h>
> +#include <linux/dma-direction.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/vmalloc.h>
> +
> +#include <uapi/linux/dma_buf_test.h>
> +
> +struct dma_buf_test_device {
> +	struct miscdevice misc;
> +};
> +
> +struct dma_buf_test_data {
> +	struct dma_buf *dma_buf;
> +	struct device *dev;
> +};
> +
> +static int dma_buf_handle_test_dma(struct device *dev, struct dma_buf *dma_buf,
> +			       void __user *ptr, size_t offset, size_t size,
> +			       bool write)
> +{
> +	int ret = 0;
> +	struct dma_buf_attachment *attach;
> +	struct sg_table *table;
> +	pgprot_t pgprot = pgprot_writecombine(PAGE_KERNEL);
> +	enum dma_data_direction dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	struct sg_page_iter sg_iter;
> +	unsigned long offset_page;
> +
> +	attach = dma_buf_attach(dma_buf, dev);
> +	if (IS_ERR(attach))
> +		return PTR_ERR(attach);
> +
> +	table = dma_buf_map_attachment(attach, dir);
> +	if (IS_ERR(table))
> +		return PTR_ERR(table);
> +
> +	offset_page = offset >> PAGE_SHIFT;
> +	offset %= PAGE_SIZE;
> +
> +	for_each_sg_page(table->sgl, &sg_iter, table->nents, offset_page) {
> +		struct page *page = sg_page_iter_page(&sg_iter);
> +		void *vaddr = vmap(&page, 1, VM_MAP, pgprot);
> +		size_t to_copy = PAGE_SIZE - offset;
> +
> +		to_copy = min(to_copy, size);
> +		if (!vaddr) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		if (write)
> +			ret = copy_from_user(vaddr + offset, ptr, to_copy);
> +		else
> +			ret = copy_to_user(ptr, vaddr + offset, to_copy);
> +
> +		vunmap(vaddr);
> +		if (ret) {
> +			ret = -EFAULT;
> +			goto err;
> +		}
> +		size -= to_copy;
> +		if (!size)
> +			break;
> +		ptr += to_copy;
> +		offset = 0;
> +	}
> +
> +err:
> +	dma_buf_unmap_attachment(attach, table, dir);
> +	dma_buf_detach(dma_buf, attach);
> +	return ret;
> +}
> +
> +static int dma_buf_handle_test_kernel(struct dma_buf *dma_buf, void __user *ptr,
> +				  size_t offset, size_t size, bool write)
> +{
> +	int ret;
> +	unsigned long page_offset = offset >> PAGE_SHIFT;
> +	size_t copy_offset = offset % PAGE_SIZE;
> +	size_t copy_size = size;
> +	enum dma_data_direction dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +
> +	if (offset > dma_buf->size || size > dma_buf->size - offset)
> +		return -EINVAL;
> +
> +	ret = dma_buf_begin_cpu_access(dma_buf, dir);
> +	if (ret)
> +		return ret;
> +
> +	while (copy_size > 0) {
> +		size_t to_copy;
> +		void *vaddr = dma_buf_kmap(dma_buf, page_offset);
> +
> +		if (!vaddr)
> +			goto err;
> +
> +		to_copy = min_t(size_t, PAGE_SIZE - copy_offset, copy_size);
> +
> +		if (write)
> +			ret = copy_from_user(vaddr + copy_offset, ptr, to_copy);
> +		else
> +			ret = copy_to_user(ptr, vaddr + copy_offset, to_copy);
> +
> +		dma_buf_kunmap(dma_buf, page_offset, vaddr);
> +		if (ret) {
> +			ret = -EFAULT;
> +			goto err;
> +		}
> +
> +		copy_size -= to_copy;
> +		ptr += to_copy;
> +		page_offset++;
> +		copy_offset = 0;
> +	}
> +err:
> +	dma_buf_end_cpu_access(dma_buf, dir);
> +	return ret;
> +}
> +
> +static long dma_buf_test_ioctl(struct file *filp, unsigned int cmd,
> +			   unsigned long arg)
> +{
> +	struct dma_buf_test_data *test_data = filp->private_data;
> +	int ret = 0;
> +
> +	union {
> +		struct dma_buf_test_rw_data test_rw;
> +	} data;
> +
> +	if (_IOC_SIZE(cmd) > sizeof(data))
> +		return -EINVAL;
> +
> +	if (_IOC_DIR(cmd) & _IOC_WRITE)
> +		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +			return -EFAULT;
> +
> +	switch (cmd) {
> +	case DMA_BUF_IOC_TEST_SET_FD:
> +	{
> +		struct dma_buf *dma_buf = NULL;
> +		int fd = arg;
> +
> +		if (fd >= 0) {
> +			dma_buf = dma_buf_get((int)arg);
> +			if (IS_ERR(dma_buf))
> +				return PTR_ERR(dma_buf);
> +		}
> +		if (test_data->dma_buf)
> +			dma_buf_put(test_data->dma_buf);
> +		test_data->dma_buf = dma_buf;
> +		break;
> +	}
> +	case DMA_BUF_IOC_TEST_DMA_MAPPING:
> +	{
> +		ret = dma_buf_handle_test_dma(test_data->dev,
> +					  test_data->dma_buf,
> +					  u64_to_user_ptr(data.test_rw.ptr),
> +					  data.test_rw.offset,
> +					  data.test_rw.size,
> +					  data.test_rw.write);
> +		break;
> +	}
> +	case DMA_BUF_IOC_TEST_KERNEL_MAPPING:
> +	{
> +		ret = dma_buf_handle_test_kernel(test_data->dma_buf,
> +					     u64_to_user_ptr(data.test_rw.ptr),
> +					     data.test_rw.offset,
> +					     data.test_rw.size,
> +					     data.test_rw.write);
> +		break;
> +	}
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	if (_IOC_DIR(cmd) & _IOC_READ) {
> +		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
> +			return -EFAULT;
> +	}
> +	return ret;
> +}
> +
> +static int dma_buf_test_open(struct inode *inode, struct file *file)
> +{
> +	struct dma_buf_test_data *data;
> +	struct miscdevice *miscdev = file->private_data;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->dev = miscdev->parent;
> +
> +	file->private_data = data;
> +
> +	return 0;
> +}
> +
> +static int dma_buf_test_release(struct inode *inode, struct file *file)
> +{
> +	struct dma_buf_test_data *data = file->private_data;
> +
> +	kfree(data);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations dma_buf_test_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = dma_buf_test_ioctl,
> +	.compat_ioctl = dma_buf_test_ioctl,
> +	.open = dma_buf_test_open,
> +	.release = dma_buf_test_release,
> +};
> +
> +static int __init dma_buf_test_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct dma_buf_test_device *testdev;
> +
> +	testdev = devm_kzalloc(&pdev->dev, sizeof(struct dma_buf_test_device),
> +			       GFP_KERNEL);
> +	if (!testdev)
> +		return -ENOMEM;
> +
> +	testdev->misc.minor = MISC_DYNAMIC_MINOR;
> +	testdev->misc.name = "dma_buf-test";
> +	testdev->misc.fops = &dma_buf_test_fops;
> +	testdev->misc.parent = &pdev->dev;
> +	/*
> +	 * We need to force 'something' for a DMA mask. This isn't an actual
> +	 * device and won't be doing actual DMA so pick 'something' that
> +	 * probably won't blow up. Probably.
> +	 */
> +	dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	ret = misc_register(&testdev->misc);
> +	if (ret) {
> +		pr_err("failed to register misc device.\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, testdev);
> +
> +	return 0;
> +}
> +
> +static int dma_buf_test_remove(struct platform_device *pdev)
> +{
> +	struct dma_buf_test_device *testdev;
> +
> +	testdev = platform_get_drvdata(pdev);
> +	if (!testdev)
> +		return -ENODATA;
> +
> +	misc_deregister(&testdev->misc);
> +	return 0;
> +}
> +
> +static struct platform_device *dma_buf_test_pdev;
> +static struct platform_driver dma_buf_test_platform_driver = {
> +	.remove = dma_buf_test_remove,
> +	.driver = {
> +		.name = "dma_buf-test",
> +	},
> +};
> +
> +static int __init dma_buf_test_init(void)
> +{
> +	dma_buf_test_pdev = platform_device_register_simple("dma-buf-test",
> +							-1, NULL, 0);
> +	if (IS_ERR(dma_buf_test_pdev))
> +		return PTR_ERR(dma_buf_test_pdev);
> +
> +	return platform_driver_probe(&dma_buf_test_platform_driver,
> +				     dma_buf_test_probe);
> +}
> +
> +static void __exit dma_buf_test_exit(void)
> +{
> +	platform_driver_unregister(&dma_buf_test_platform_driver);
> +	platform_device_unregister(dma_buf_test_pdev);
> +}
> +
> +module_init(dma_buf_test_init);
> +module_exit(dma_buf_test_exit);
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/uapi/linux/dma_buf_test.h b/include/uapi/linux/dma_buf_test.h
> new file mode 100644
> index 0000000..af2d521
> --- /dev/null
> +++ b/include/uapi/linux/dma_buf_test.h
> @@ -0,0 +1,67 @@
> +/*
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License versdma_buf 2, as published by the Free Software Foundatdma_buf, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _UAPI_LINUX_DMA_BUF_TEST_H
> +#define _UAPI_LINUX_DMA_BUF_TEST_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct dma_buf_test_rw_data - metadata passed to the kernel to read handle
> + * @ptr:	a pointer to an area at least as large as size
> + * @offset:	offset into the dma_buf buffer to start reading
> + * @size:	size to read or write
> + * @write:	1 to write, 0 to read
> + */
> +struct dma_buf_test_rw_data {
> +	__u64 ptr;
> +	__u64 offset;
> +	__u64 size;
> +	int write;
> +	int __padding;
> +};
> +
> +#define DMA_BUF_IOC_MAGIC		'I'
> +
> +/**
> + * DOC: DMA_BUF_IOC_TEST_SET_DMA_BUF - attach a dma buf to the test driver
> + *
> + * Attaches a dma buf fd to the test driver.  Passing a second fd or -1 will
> + * release the first fd.
> + */
> +#define DMA_BUF_IOC_TEST_SET_FD \
> +			_IO(DMA_BUF_IOC_MAGIC, 0xf0)
> +
> +/**
> + * DOC: DMA_BUF_IOC_TEST_DMA_MAPPING - read or write memory from a handle as DMA
> + *
> + * Reads or writes the memory from a handle using an uncached mapping.  Can be
> + * used by unit tests to emulate a DMA engine as close as possible.  Only
> + * expected to be used for debugging and testing, may not always be available.
> + */
> +#define DMA_BUF_IOC_TEST_DMA_MAPPING \
> +			_IOW(DMA_BUF_IOC_MAGIC, 0xf1, struct dma_buf_test_rw_data)
> +
> +/**
> + * DOC: DMA_BUF_IOC_TEST_KERNEL_MAPPING - read or write memory from a handle
> + *
> + * Reads or writes the memory from a handle using a kernel mapping.  Can be
> + * used by unit tests to test heap map_kernel functdma_bufs.  Only expected to be
> + * used for debugging and testing, may not always be available.
> + */
> +#define DMA_BUF_IOC_TEST_KERNEL_MAPPING \
> +			_IOW(DMA_BUF_IOC_MAGIC, 0xf2, struct dma_buf_test_rw_data)
> +
> +#endif /* _UAPI_LINUX_DMA_BUF_TEST_H */
> -- 
> 2.7.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
