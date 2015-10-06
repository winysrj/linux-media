Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbbJFB7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 21:59:01 -0400
Subject: Re: [PATCH v4 1/2] create SMAF module
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com, daniel.stone@collabora.com,
	linux-security-module@vger.kernel.org, xiaoquan.li@vivantecorp.com
References: <1444039898-7927-1-git-send-email-benjamin.gaignard@linaro.org>
 <1444039898-7927-2-git-send-email-benjamin.gaignard@linaro.org>
Cc: tom.gall@linaro.org, linaro-mm-sig@lists.linaro.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56132AE1.6060503@redhat.com>
Date: Mon, 5 Oct 2015 18:58:57 -0700
MIME-Version: 1.0
In-Reply-To: <1444039898-7927-2-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2015 03:11 AM, Benjamin Gaignard wrote:
> diff --git a/drivers/smaf/smaf-core.c b/drivers/smaf/smaf-core.c
> new file mode 100644
> index 0000000..37914e7
> --- /dev/null
> +++ b/drivers/smaf/smaf-core.c
> @@ -0,0 +1,736 @@
> +/*
> + * smaf.c
> + *
> + * Copyright (C) Linaro SA 2015
> + * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/device.h>
> +#include <linux/dma-buf.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fs.h>
> +#include <linux/ioctl.h>
> +#include <linux/list_sort.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/smaf.h>
> +#include <linux/smaf-allocator.h>
> +#include <linux/smaf-secure.h>
> +#include <linux/uaccess.h>
> +
> +struct smaf_handle {
> +	struct dma_buf *dmabuf;
> +	struct smaf_allocator *allocator;
> +	struct dma_buf *db_alloc;
> +	size_t length;
> +	unsigned int flags;
> +	int fd;
> +	bool is_secure;
> +	void *secure_ctx;
> +};
> +
> +/**
> + * struct smaf_device - smaf device node private data
> + * @misc_dev:	the misc device
> + * @head:	list of allocator
> + * @lock:	list and secure pointer mutex
> + * @secure:	pointer to secure functions helpers
> + */
> +struct smaf_device {
> +	struct miscdevice misc_dev;
> +	struct list_head head;
> +	/* list and secure pointer lock*/
> +	struct mutex lock;
> +	struct smaf_secure *secure;
> +};
> +
> +static struct smaf_device smaf_dev;
> +
> +/**
> + * smaf_allow_cpu_access return true if CPU can access to memory
> + * if their is no secure module associated to SMAF assume that CPU can get
> + * access to the memory.
> + */
> +static bool smaf_allow_cpu_access(struct smaf_handle *handle,
> +				  unsigned long flags)
> +{
> +	if (!handle->is_secure)
> +		return true;
> +
> +	if (!smaf_dev.secure)
> +		return true;
> +
> +	if (!smaf_dev.secure->allow_cpu_access)
> +		return true;
> +
> +	return smaf_dev.secure->allow_cpu_access(handle->secure_ctx, flags);
> +}
> +
> +static int smaf_grant_access(struct smaf_handle *handle, struct device *dev,
> +			     dma_addr_t addr, size_t size,
> +			     enum dma_data_direction dir)
> +{
> +	if (!handle->is_secure)
> +		return 0;
> +
> +	if (!smaf_dev.secure)
> +		return -EINVAL;
> +
> +	if (!smaf_dev.secure->grant_access)
> +		return -EINVAL;
> +
> +	return smaf_dev.secure->grant_access(handle->secure_ctx,
> +					     dev, addr, size, dir);
> +}
> +
> +static void smaf_revoke_access(struct smaf_handle *handle, struct device *dev,
> +			       dma_addr_t addr, size_t size,
> +			       enum dma_data_direction dir)
> +{
> +	if (!handle->is_secure)
> +		return;
> +
> +	if (!smaf_dev.secure)
> +		return;
> +
> +	if (!smaf_dev.secure->revoke_access)
> +		return;
> +
> +	smaf_dev.secure->revoke_access(handle->secure_ctx,
> +				       dev, addr, size, dir);
> +}
> +
> +static int smaf_secure_handle(struct smaf_handle *handle)
> +{
> +	if (handle->is_secure)
> +		return 0;
> +
> +	if (!smaf_dev.secure)
> +		return -EINVAL;
> +
> +	if (!smaf_dev.secure->create_context)
> +		return -EINVAL;
> +
> +	handle->secure_ctx = smaf_dev.secure->create_context();
> +
> +	if (!handle->secure_ctx)
> +		return -EINVAL;
> +
> +	handle->is_secure = true;
> +	return 0;
> +}
> +
> +static int smaf_unsecure_handle(struct smaf_handle *handle)
> +{
> +	if (!handle->is_secure)
> +		return 0;
> +
> +	if (!smaf_dev.secure)
> +		return -EINVAL;
> +
> +	if (!smaf_dev.secure->destroy_context)
> +		return -EINVAL;
> +
> +	if (smaf_dev.secure->destroy_context(handle->secure_ctx))
> +		return -EINVAL;
> +
> +	handle->secure_ctx = NULL;
> +	handle->is_secure = false;
> +	return 0;
> +}

All these functions need to be protected by a lock, otherwise the
secure state could change. For that matter, I think the smaf_handle
needs a lock to protect its state as well for places like map_dma_buf

>
<snip>
> +static long smaf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +	case SMAF_IOC_CREATE:
> +	{
> +		struct smaf_create_data data;
> +		struct smaf_handle *handle;
> +
> +		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +			return -EFAULT;
> +
> +		handle = smaf_create_handle(data.length, data.flags);
> +		if (!handle)
> +			return -EINVAL;
> +
> +		if (data.name[0]) {
> +			/* user force allocator selection */
> +			if (smaf_select_allocator_by_name(handle->dmabuf,
> +							  data.name)) {
> +				dma_buf_put(handle->dmabuf);
> +				return -EINVAL;
> +			}
> +		}
> +
> +		handle->fd = dma_buf_fd(handle->dmabuf, data.flags);
> +		if (handle->fd < 0) {
> +			dma_buf_put(handle->dmabuf);
> +			return -EINVAL;
> +		}
> +
> +		data.fd = handle->fd;
> +		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
> +			dma_buf_put(handle->dmabuf);
> +			return -EFAULT;
> +		}
> +		break;
> +	}
> +	case SMAF_IOC_GET_SECURE_FLAG:
> +	{
> +		struct smaf_secure_flag data;
> +		struct dma_buf *dmabuf;
> +
> +		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +			return -EFAULT;
> +
> +		dmabuf = dma_buf_get(data.fd);
> +		if (!dmabuf)
> +			return -EINVAL;
> +
> +		data.secure = smaf_is_secure(dmabuf);
> +		dma_buf_put(dmabuf);
> +
> +		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd)))
> +			return -EFAULT;
> +		break;
> +	}
> +	case SMAF_IOC_SET_SECURE_FLAG:
> +	{
> +		struct smaf_secure_flag data;
> +		struct dma_buf *dmabuf;
> +		int ret;
> +
> +		if (!smaf_dev.secure)
> +			return -EINVAL;
> +
> +		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +			return -EFAULT;
> +
> +		dmabuf = dma_buf_get(data.fd);
> +		if (!dmabuf)
> +			return -EINVAL;
> +
> +		ret = smaf_set_secure(dmabuf, data.secure);
> +
> +		dma_buf_put(dmabuf);
> +
> +		if (ret)
> +			return -EINVAL;
> +
> +		break;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

How would you see this tying into something like Ion? It seems like
Ion and SMAF have non-zero over lapping functionality for some things
or that SMAF could be implemented as a heap type. I think my biggest
concern here is that it seems like either Ion or SMAF is going to feel
redundant as an interface.

Thanks,
Laura
