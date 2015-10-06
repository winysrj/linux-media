Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36607 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbJFI45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 04:56:57 -0400
Received: by laddr2 with SMTP id dr2so22492921lad.3
        for <linux-media@vger.kernel.org>; Tue, 06 Oct 2015 01:56:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56132AE1.6060503@redhat.com>
References: <1444039898-7927-1-git-send-email-benjamin.gaignard@linaro.org>
	<1444039898-7927-2-git-send-email-benjamin.gaignard@linaro.org>
	<56132AE1.6060503@redhat.com>
Date: Tue, 6 Oct 2015 10:56:55 +0200
Message-ID: <CA+M3ks4B=stFjxo7kRxb3d=ge63WXxOjEnMUK5EUyHLSnGvdNg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] create SMAF module
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Laura Abbott <labbott@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Cooksey <tom.cooksey@arm.com>,
	Daniel Stone <daniel.stone@collabora.com>,
	linux-security-module@vger.kernel.org,
	Xiaoquan Li <xiaoquan.li@vivantecorp.com>,
	Tom Gall <tom.gall@linaro.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your review I will add a lock in smaf_handle structure.

One of the goal of smaf is to create a standard kernel API to allocate
and secure buffers to avoid forking
while implementing buffer securing feature.

One concern about ION is that the selection of the heap is done by userland
so hardware constraints need to be known by the userland, which is
problematic from my point of view.
Compare to ION I have try to introduce features like securing API,
flexible allocator selection on kernel
and the possibility to add custom allocator and securing modules.

Benjamin



2015-10-06 3:58 GMT+02:00 Laura Abbott <labbott@redhat.com>:
> On 10/05/2015 03:11 AM, Benjamin Gaignard wrote:
>>
>> diff --git a/drivers/smaf/smaf-core.c b/drivers/smaf/smaf-core.c
>> new file mode 100644
>> index 0000000..37914e7
>> --- /dev/null
>> +++ b/drivers/smaf/smaf-core.c
>> @@ -0,0 +1,736 @@
>> +/*
>> + * smaf.c
>> + *
>> + * Copyright (C) Linaro SA 2015
>> + * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org> for Linaro.
>> + * License terms:  GNU General Public License (GPL), version 2
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/dma-buf.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/fs.h>
>> +#include <linux/ioctl.h>
>> +#include <linux/list_sort.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/smaf.h>
>> +#include <linux/smaf-allocator.h>
>> +#include <linux/smaf-secure.h>
>> +#include <linux/uaccess.h>
>> +
>> +struct smaf_handle {
>> +       struct dma_buf *dmabuf;
>> +       struct smaf_allocator *allocator;
>> +       struct dma_buf *db_alloc;
>> +       size_t length;
>> +       unsigned int flags;
>> +       int fd;
>> +       bool is_secure;
>> +       void *secure_ctx;
>> +};
>> +
>> +/**
>> + * struct smaf_device - smaf device node private data
>> + * @misc_dev:  the misc device
>> + * @head:      list of allocator
>> + * @lock:      list and secure pointer mutex
>> + * @secure:    pointer to secure functions helpers
>> + */
>> +struct smaf_device {
>> +       struct miscdevice misc_dev;
>> +       struct list_head head;
>> +       /* list and secure pointer lock*/
>> +       struct mutex lock;
>> +       struct smaf_secure *secure;
>> +};
>> +
>> +static struct smaf_device smaf_dev;
>> +
>> +/**
>> + * smaf_allow_cpu_access return true if CPU can access to memory
>> + * if their is no secure module associated to SMAF assume that CPU can
>> get
>> + * access to the memory.
>> + */
>> +static bool smaf_allow_cpu_access(struct smaf_handle *handle,
>> +                                 unsigned long flags)
>> +{
>> +       if (!handle->is_secure)
>> +               return true;
>> +
>> +       if (!smaf_dev.secure)
>> +               return true;
>> +
>> +       if (!smaf_dev.secure->allow_cpu_access)
>> +               return true;
>> +
>> +       return smaf_dev.secure->allow_cpu_access(handle->secure_ctx,
>> flags);
>> +}
>> +
>> +static int smaf_grant_access(struct smaf_handle *handle, struct device
>> *dev,
>> +                            dma_addr_t addr, size_t size,
>> +                            enum dma_data_direction dir)
>> +{
>> +       if (!handle->is_secure)
>> +               return 0;
>> +
>> +       if (!smaf_dev.secure)
>> +               return -EINVAL;
>> +
>> +       if (!smaf_dev.secure->grant_access)
>> +               return -EINVAL;
>> +
>> +       return smaf_dev.secure->grant_access(handle->secure_ctx,
>> +                                            dev, addr, size, dir);
>> +}
>> +
>> +static void smaf_revoke_access(struct smaf_handle *handle, struct device
>> *dev,
>> +                              dma_addr_t addr, size_t size,
>> +                              enum dma_data_direction dir)
>> +{
>> +       if (!handle->is_secure)
>> +               return;
>> +
>> +       if (!smaf_dev.secure)
>> +               return;
>> +
>> +       if (!smaf_dev.secure->revoke_access)
>> +               return;
>> +
>> +       smaf_dev.secure->revoke_access(handle->secure_ctx,
>> +                                      dev, addr, size, dir);
>> +}
>> +
>> +static int smaf_secure_handle(struct smaf_handle *handle)
>> +{
>> +       if (handle->is_secure)
>> +               return 0;
>> +
>> +       if (!smaf_dev.secure)
>> +               return -EINVAL;
>> +
>> +       if (!smaf_dev.secure->create_context)
>> +               return -EINVAL;
>> +
>> +       handle->secure_ctx = smaf_dev.secure->create_context();
>> +
>> +       if (!handle->secure_ctx)
>> +               return -EINVAL;
>> +
>> +       handle->is_secure = true;
>> +       return 0;
>> +}
>> +
>> +static int smaf_unsecure_handle(struct smaf_handle *handle)
>> +{
>> +       if (!handle->is_secure)
>> +               return 0;
>> +
>> +       if (!smaf_dev.secure)
>> +               return -EINVAL;
>> +
>> +       if (!smaf_dev.secure->destroy_context)
>> +               return -EINVAL;
>> +
>> +       if (smaf_dev.secure->destroy_context(handle->secure_ctx))
>> +               return -EINVAL;
>> +
>> +       handle->secure_ctx = NULL;
>> +       handle->is_secure = false;
>> +       return 0;
>> +}
>
>
> All these functions need to be protected by a lock, otherwise the
> secure state could change. For that matter, I think the smaf_handle
> needs a lock to protect its state as well for places like map_dma_buf
>
>>
> <snip>
>
>> +static long smaf_ioctl(struct file *file, unsigned int cmd, unsigned long
>> arg)
>> +{
>> +       switch (cmd) {
>> +       case SMAF_IOC_CREATE:
>> +       {
>> +               struct smaf_create_data data;
>> +               struct smaf_handle *handle;
>> +
>> +               if (copy_from_user(&data, (void __user *)arg,
>> _IOC_SIZE(cmd)))
>> +                       return -EFAULT;
>> +
>> +               handle = smaf_create_handle(data.length, data.flags);
>> +               if (!handle)
>> +                       return -EINVAL;
>> +
>> +               if (data.name[0]) {
>> +                       /* user force allocator selection */
>> +                       if (smaf_select_allocator_by_name(handle->dmabuf,
>> +                                                         data.name)) {
>> +                               dma_buf_put(handle->dmabuf);
>> +                               return -EINVAL;
>> +                       }
>> +               }
>> +
>> +               handle->fd = dma_buf_fd(handle->dmabuf, data.flags);
>> +               if (handle->fd < 0) {
>> +                       dma_buf_put(handle->dmabuf);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               data.fd = handle->fd;
>> +               if (copy_to_user((void __user *)arg, &data,
>> _IOC_SIZE(cmd))) {
>> +                       dma_buf_put(handle->dmabuf);
>> +                       return -EFAULT;
>> +               }
>> +               break;
>> +       }
>> +       case SMAF_IOC_GET_SECURE_FLAG:
>> +       {
>> +               struct smaf_secure_flag data;
>> +               struct dma_buf *dmabuf;
>> +
>> +               if (copy_from_user(&data, (void __user *)arg,
>> _IOC_SIZE(cmd)))
>> +                       return -EFAULT;
>> +
>> +               dmabuf = dma_buf_get(data.fd);
>> +               if (!dmabuf)
>> +                       return -EINVAL;
>> +
>> +               data.secure = smaf_is_secure(dmabuf);
>> +               dma_buf_put(dmabuf);
>> +
>> +               if (copy_to_user((void __user *)arg, &data,
>> _IOC_SIZE(cmd)))
>> +                       return -EFAULT;
>> +               break;
>> +       }
>> +       case SMAF_IOC_SET_SECURE_FLAG:
>> +       {
>> +               struct smaf_secure_flag data;
>> +               struct dma_buf *dmabuf;
>> +               int ret;
>> +
>> +               if (!smaf_dev.secure)
>> +                       return -EINVAL;
>> +
>> +               if (copy_from_user(&data, (void __user *)arg,
>> _IOC_SIZE(cmd)))
>> +                       return -EFAULT;
>> +
>> +               dmabuf = dma_buf_get(data.fd);
>> +               if (!dmabuf)
>> +                       return -EINVAL;
>> +
>> +               ret = smaf_set_secure(dmabuf, data.secure);
>> +
>> +               dma_buf_put(dmabuf);
>> +
>> +               if (ret)
>> +                       return -EINVAL;
>> +
>> +               break;
>> +       }
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>
>
> How would you see this tying into something like Ion? It seems like
> Ion and SMAF have non-zero over lapping functionality for some things
> or that SMAF could be implemented as a heap type. I think my biggest
> concern here is that it seems like either Ion or SMAF is going to feel
> redundant as an interface.
>
> Thanks,
> Laura



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
