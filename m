Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46399 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753560AbeGCIiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 04:38:02 -0400
Received: by mail-ed1-f68.google.com with SMTP id r17-v6so994861edo.13
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 01:38:01 -0700 (PDT)
Date: Tue, 3 Jul 2018 10:37:57 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Corbet <corbet@lwn.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6] Add udmabuf misc device
Message-ID: <20180703083757.GG7880@phenom.ffwll.local>
References: <20180703075359.30349-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703075359.30349-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 03, 2018 at 09:53:58AM +0200, Gerd Hoffmann wrote:
> A driver to let userspace turn memfd regions into dma-bufs.
> 
> Use case:  Allows qemu create dmabufs for the vga framebuffer or
> virtio-gpu ressources.  Then they can be passed around to display
> those guest things on the host.  To spice client for classic full
> framebuffer display, and hopefully some day to wayland server for
> seamless guest window display.
> 
> qemu test branch:
>   https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

I think some ack for a 2nd use-case, like virtio-wl or whatever would be
really cool. To give us some assurance that this is generically useful.
Plus an ack from dma-buf folks (nag them on irc, you don't have them on Cc
here). Then this is imo good to go.

I assume you'll push it to drm-misc, like all the other dma-buf stuff?
-Daniel

> ---
>  Documentation/ioctl/ioctl-number.txt              |   1 +
>  include/uapi/linux/udmabuf.h                      |  33 +++
>  drivers/dma-buf/udmabuf.c                         | 287 ++++++++++++++++++++++
>  tools/testing/selftests/drivers/dma-buf/udmabuf.c |  96 ++++++++
>  MAINTAINERS                                       |   8 +
>  drivers/dma-buf/Kconfig                           |   8 +
>  drivers/dma-buf/Makefile                          |   1 +
>  tools/testing/selftests/drivers/dma-buf/Makefile  |   5 +
>  8 files changed, 439 insertions(+)
>  create mode 100644 include/uapi/linux/udmabuf.h
>  create mode 100644 drivers/dma-buf/udmabuf.c
>  create mode 100644 tools/testing/selftests/drivers/dma-buf/udmabuf.c
>  create mode 100644 tools/testing/selftests/drivers/dma-buf/Makefile
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 480c8609dc..6636dea476 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -271,6 +271,7 @@ Code  Seq#(hex)	Include File		Comments
>  't'	90-91	linux/toshiba.h		toshiba and toshiba_acpi SMM
>  'u'	00-1F	linux/smb_fs.h		gone
>  'u'	20-3F	linux/uvcvideo.h	USB video class host driver
> +'u'	40-4f	linux/udmabuf.h		userspace dma-buf misc device
>  'v'	00-1F	linux/ext2_fs.h		conflict!
>  'v'	00-1F	linux/fs.h		conflict!
>  'v'	00-0F	linux/sonypi.h		conflict!
> diff --git a/include/uapi/linux/udmabuf.h b/include/uapi/linux/udmabuf.h
> new file mode 100644
> index 0000000000..46b6532ed8
> --- /dev/null
> +++ b/include/uapi/linux/udmabuf.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_UDMABUF_H
> +#define _UAPI_LINUX_UDMABUF_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define UDMABUF_FLAGS_CLOEXEC	0x01
> +
> +struct udmabuf_create {
> +	__u32 memfd;
> +	__u32 flags;
> +	__u64 offset;
> +	__u64 size;
> +};
> +
> +struct udmabuf_create_item {
> +	__u32 memfd;
> +	__u32 __pad;
> +	__u64 offset;
> +	__u64 size;
> +};
> +
> +struct udmabuf_create_list {
> +	__u32 flags;
> +	__u32 count;
> +	struct udmabuf_create_item list[];
> +};
> +
> +#define UDMABUF_CREATE       _IOW('u', 0x42, struct udmabuf_create)
> +#define UDMABUF_CREATE_LIST  _IOW('u', 0x43, struct udmabuf_create_list)
> +
> +#endif /* _UAPI_LINUX_UDMABUF_H */
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> new file mode 100644
> index 0000000000..8e24204526
> --- /dev/null
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -0,0 +1,287 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/miscdevice.h>
> +#include <linux/dma-buf.h>
> +#include <linux/highmem.h>
> +#include <linux/cred.h>
> +#include <linux/shmem_fs.h>
> +#include <linux/memfd.h>
> +
> +#include <uapi/linux/udmabuf.h>
> +
> +struct udmabuf {
> +	u32 pagecount;
> +	struct page **pages;
> +};
> +
> +static int udmabuf_vm_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct udmabuf *ubuf = vma->vm_private_data;
> +
> +	if (WARN_ON(vmf->pgoff >= ubuf->pagecount))
> +		return VM_FAULT_SIGBUS;
> +
> +	vmf->page = ubuf->pages[vmf->pgoff];
> +	get_page(vmf->page);
> +	return 0;
> +}
> +
> +static const struct vm_operations_struct udmabuf_vm_ops = {
> +	.fault = udmabuf_vm_fault,
> +};
> +
> +static int mmap_udmabuf(struct dma_buf *buf, struct vm_area_struct *vma)
> +{
> +	struct udmabuf *ubuf = buf->priv;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
> +		return -EINVAL;
> +
> +	vma->vm_ops = &udmabuf_vm_ops;
> +	vma->vm_private_data = ubuf;
> +	return 0;
> +}
> +
> +static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
> +				    enum dma_data_direction direction)
> +{
> +	struct udmabuf *ubuf = at->dmabuf->priv;
> +	struct sg_table *sg;
> +
> +	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
> +	if (!sg)
> +		goto err1;
> +	if (sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
> +				      0, ubuf->pagecount << PAGE_SHIFT,
> +				      GFP_KERNEL) < 0)
> +		goto err2;
> +	if (!dma_map_sg(at->dev, sg->sgl, sg->nents, direction))
> +		goto err3;
> +
> +	return sg;
> +
> +err3:
> +	sg_free_table(sg);
> +err2:
> +	kfree(sg);
> +err1:
> +	return ERR_PTR(-ENOMEM);
> +}
> +
> +static void unmap_udmabuf(struct dma_buf_attachment *at,
> +			  struct sg_table *sg,
> +			  enum dma_data_direction direction)
> +{
> +	sg_free_table(sg);
> +	kfree(sg);
> +}
> +
> +static void release_udmabuf(struct dma_buf *buf)
> +{
> +	struct udmabuf *ubuf = buf->priv;
> +	pgoff_t pg;
> +
> +	for (pg = 0; pg < ubuf->pagecount; pg++)
> +		put_page(ubuf->pages[pg]);
> +	kfree(ubuf->pages);
> +	kfree(ubuf);
> +}
> +
> +static void *kmap_udmabuf(struct dma_buf *buf, unsigned long page_num)
> +{
> +	struct udmabuf *ubuf = buf->priv;
> +	struct page *page = ubuf->pages[page_num];
> +
> +	return kmap(page);
> +}
> +
> +static void kunmap_udmabuf(struct dma_buf *buf, unsigned long page_num,
> +			   void *vaddr)
> +{
> +	kunmap(vaddr);
> +}
> +
> +static struct dma_buf_ops udmabuf_ops = {
> +	.map_dma_buf	  = map_udmabuf,
> +	.unmap_dma_buf	  = unmap_udmabuf,
> +	.release	  = release_udmabuf,
> +	.map		  = kmap_udmabuf,
> +	.unmap		  = kunmap_udmabuf,
> +	.mmap		  = mmap_udmabuf,
> +};
> +
> +#define SEALS_WANTED (F_SEAL_SHRINK)
> +#define SEALS_DENIED (F_SEAL_WRITE)
> +
> +static long udmabuf_create(struct udmabuf_create_list *head,
> +			   struct udmabuf_create_item *list)
> +{
> +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> +	struct file *memfd = NULL;
> +	struct udmabuf *ubuf;
> +	struct dma_buf *buf;
> +	pgoff_t pgoff, pgcnt, pgidx, pgbuf;
> +	struct page *page;
> +	int seals, ret = -EINVAL;
> +	u32 i, flags;
> +
> +	ubuf = kzalloc(sizeof(struct udmabuf), GFP_KERNEL);
> +	if (!ubuf)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < head->count; i++) {
> +		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
> +			goto err_free_ubuf;
> +		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
> +			goto err_free_ubuf;
> +		ubuf->pagecount += list[i].size >> PAGE_SHIFT;
> +	}
> +	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
> +				    GFP_KERNEL);
> +	if (!ubuf->pages) {
> +		ret = -ENOMEM;
> +		goto err_free_ubuf;
> +	}
> +
> +	pgbuf = 0;
> +	for (i = 0; i < head->count; i++) {
> +		memfd = fget(list[i].memfd);
> +		if (!memfd)
> +			goto err_put_pages;
> +		if (!shmem_mapping(file_inode(memfd)->i_mapping))
> +			goto err_put_pages;
> +		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
> +		if (seals == -EINVAL ||
> +		    (seals & SEALS_WANTED) != SEALS_WANTED ||
> +		    (seals & SEALS_DENIED) != 0)
> +			goto err_put_pages;
> +		pgoff = list[i].offset >> PAGE_SHIFT;
> +		pgcnt = list[i].size   >> PAGE_SHIFT;
> +		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
> +			page = shmem_read_mapping_page(
> +				file_inode(memfd)->i_mapping, pgoff + pgidx);
> +			if (IS_ERR(page)) {
> +				ret = PTR_ERR(page);
> +				goto err_put_pages;
> +			}
> +			ubuf->pages[pgbuf++] = page;
> +		}
> +		fput(memfd);
> +	}
> +	memfd = NULL;
> +
> +	exp_info.ops  = &udmabuf_ops;
> +	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
> +	exp_info.priv = ubuf;
> +
> +	buf = dma_buf_export(&exp_info);
> +	if (IS_ERR(buf)) {
> +		ret = PTR_ERR(buf);
> +		goto err_put_pages;
> +	}
> +
> +	flags = 0;
> +	if (head->flags & UDMABUF_FLAGS_CLOEXEC)
> +		flags |= O_CLOEXEC;
> +	return dma_buf_fd(buf, flags);
> +
> +err_put_pages:
> +	while (pgbuf > 0)
> +		put_page(ubuf->pages[--pgbuf]);
> +err_free_ubuf:
> +	fput(memfd);
> +	kfree(ubuf->pages);
> +	kfree(ubuf);
> +	return ret;
> +}
> +
> +static long udmabuf_ioctl_create(struct file *filp, unsigned long arg)
> +{
> +	struct udmabuf_create create;
> +	struct udmabuf_create_list head;
> +	struct udmabuf_create_item list;
> +
> +	if (copy_from_user(&create, (void __user *)arg,
> +			   sizeof(struct udmabuf_create)))
> +		return -EFAULT;
> +
> +	head.flags  = create.flags;
> +	head.count  = 1;
> +	list.memfd  = create.memfd;
> +	list.offset = create.offset;
> +	list.size   = create.size;
> +
> +	return udmabuf_create(&head, &list);
> +}
> +
> +static long udmabuf_ioctl_create_list(struct file *filp, unsigned long arg)
> +{
> +	struct udmabuf_create_list head;
> +	struct udmabuf_create_item *list;
> +	int ret = -EINVAL;
> +	u32 lsize;
> +
> +	if (copy_from_user(&head, (void __user *)arg, sizeof(head)))
> +		return -EFAULT;
> +	if (head.count > 1024)
> +		return -EINVAL;
> +	lsize = sizeof(struct udmabuf_create_item) * head.count;
> +	list = memdup_user((void __user *)(arg + sizeof(head)), lsize);
> +	if (IS_ERR(list))
> +		return PTR_ERR(list);
> +
> +	ret = udmabuf_create(&head, list);
> +	kfree(list);
> +	return ret;
> +}
> +
> +static long udmabuf_ioctl(struct file *filp, unsigned int ioctl,
> +			  unsigned long arg)
> +{
> +	long ret;
> +
> +	switch (ioctl) {
> +	case UDMABUF_CREATE:
> +		ret = udmabuf_ioctl_create(filp, arg);
> +		break;
> +	case UDMABUF_CREATE_LIST:
> +		ret = udmabuf_ioctl_create_list(filp, arg);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static const struct file_operations udmabuf_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl = udmabuf_ioctl,
> +};
> +
> +static struct miscdevice udmabuf_misc = {
> +	.minor          = MISC_DYNAMIC_MINOR,
> +	.name           = "udmabuf",
> +	.fops           = &udmabuf_fops,
> +};
> +
> +static int __init udmabuf_dev_init(void)
> +{
> +	return misc_register(&udmabuf_misc);
> +}
> +
> +static void __exit udmabuf_dev_exit(void)
> +{
> +	misc_deregister(&udmabuf_misc);
> +}
> +
> +module_init(udmabuf_dev_init)
> +module_exit(udmabuf_dev_exit)
> +
> +MODULE_AUTHOR("Gerd Hoffmann <kraxel@redhat.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/tools/testing/selftests/drivers/dma-buf/udmabuf.c b/tools/testing/selftests/drivers/dma-buf/udmabuf.c
> new file mode 100644
> index 0000000000..376b1d6730
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/dma-buf/udmabuf.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <malloc.h>
> +
> +#include <sys/ioctl.h>
> +#include <sys/syscall.h>
> +#include <linux/memfd.h>
> +#include <linux/udmabuf.h>
> +
> +#define TEST_PREFIX	"drivers/dma-buf/udmabuf"
> +#define NUM_PAGES       4
> +
> +static int memfd_create(const char *name, unsigned int flags)
> +{
> +	return syscall(__NR_memfd_create, name, flags);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct udmabuf_create create;
> +	int devfd, memfd, buf, ret;
> +	off_t size;
> +	void *mem;
> +
> +	devfd = open("/dev/udmabuf", O_RDWR);
> +	if (devfd < 0) {
> +		printf("%s: [skip,no-udmabuf]\n", TEST_PREFIX);
> +		exit(77);
> +	}
> +
> +	memfd = memfd_create("udmabuf-test", MFD_CLOEXEC);
> +	if (memfd < 0) {
> +		printf("%s: [skip,no-memfd]\n", TEST_PREFIX);
> +		exit(77);
> +	}
> +
> +	size = getpagesize() * NUM_PAGES;
> +	ret = ftruncate(memfd, size);
> +	if (ret == -1) {
> +		printf("%s: [FAIL,memfd-truncate]\n", TEST_PREFIX);
> +		exit(1);
> +	}
> +
> +	memset(&create, 0, sizeof(create));
> +
> +	/* should fail (offset not page aligned) */
> +	create.memfd  = memfd;
> +	create.offset = getpagesize()/2;
> +	create.size   = getpagesize();
> +	buf = ioctl(devfd, UDMABUF_CREATE, &create);
> +	if (buf >= 0) {
> +		printf("%s: [FAIL,test-1]\n", TEST_PREFIX);
> +		exit(1);
> +	}
> +
> +	/* should fail (size not multiple of page) */
> +	create.memfd  = memfd;
> +	create.offset = 0;
> +	create.size   = getpagesize()/2;
> +	buf = ioctl(devfd, UDMABUF_CREATE, &create);
> +	if (buf >= 0) {
> +		printf("%s: [FAIL,test-2]\n", TEST_PREFIX);
> +		exit(1);
> +	}
> +
> +	/* should fail (not memfd) */
> +	create.memfd  = 0; /* stdin */
> +	create.offset = 0;
> +	create.size   = size;
> +	buf = ioctl(devfd, UDMABUF_CREATE, &create);
> +	if (buf >= 0) {
> +		printf("%s: [FAIL,test-3]\n", TEST_PREFIX);
> +		exit(1);
> +	}
> +
> +	/* should work */
> +	create.memfd  = memfd;
> +	create.offset = 0;
> +	create.size   = size;
> +	buf = ioctl(devfd, UDMABUF_CREATE, &create);
> +	if (buf < 0) {
> +		printf("%s: [FAIL,test-4]\n", TEST_PREFIX);
> +		exit(1);
> +	}
> +
> +	fprintf(stderr, "%s: ok\n", TEST_PREFIX);
> +	close(buf);
> +	close(memfd);
> +	close(devfd);
> +	return 0;
> +}
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 07d1576fc7..a8e1bb3bc3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14638,6 +14638,14 @@ S:	Maintained
>  F:	Documentation/filesystems/udf.txt
>  F:	fs/udf/
>  
> +UDMABUF DRIVER
> +M:	Gerd Hoffmann <kraxel@redhat.com>
> +L:	dri-devel@lists.freedesktop.org
> +S:	Maintained
> +F:	drivers/dma-buf/udmabuf.c
> +F:	include/uapi/linux/udmabuf.h
> +F:	tools/testing/selftests/drivers/dma-buf/udmabuf.c
> +
>  UDRAW TABLET
>  M:	Bastien Nocera <hadess@hadess.net>
>  L:	linux-input@vger.kernel.org
> diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
> index ed3b785bae..338129eb12 100644
> --- a/drivers/dma-buf/Kconfig
> +++ b/drivers/dma-buf/Kconfig
> @@ -30,4 +30,12 @@ config SW_SYNC
>  	  WARNING: improper use of this can result in deadlocking kernel
>  	  drivers from userspace. Intended for test and debug only.
>  
> +config UDMABUF
> +	bool "userspace dmabuf misc driver"
> +	default n
> +	depends on DMA_SHARED_BUFFER
> +	help
> +	  A driver to let userspace turn memfd regions into dma-bufs.
> +	  Qemu can use this to create host dmabufs for guest framebuffers.
> +
>  endmenu
> diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
> index c33bf88631..0913a6ccab 100644
> --- a/drivers/dma-buf/Makefile
> +++ b/drivers/dma-buf/Makefile
> @@ -1,3 +1,4 @@
>  obj-y := dma-buf.o dma-fence.o dma-fence-array.o reservation.o seqno-fence.o
>  obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
>  obj-$(CONFIG_SW_SYNC)		+= sw_sync.o sync_debug.o
> +obj-$(CONFIG_UDMABUF)		+= udmabuf.o
> diff --git a/tools/testing/selftests/drivers/dma-buf/Makefile b/tools/testing/selftests/drivers/dma-buf/Makefile
> new file mode 100644
> index 0000000000..4154c3d7aa
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/dma-buf/Makefile
> @@ -0,0 +1,5 @@
> +CFLAGS += -I../../../../../usr/include/
> +
> +TEST_GEN_PROGS := udmabuf
> +
> +include ../../lib.mk
> -- 
> 2.9.3
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
