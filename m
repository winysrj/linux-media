Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34021 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbcEPW6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2016 18:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
	<1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
Date: Mon, 16 May 2016 23:58:38 +0100
Message-ID: <CACvgo52cHhJ0XoibSXgu2eBg1sK51_nFqtA9CmWZwtCDYa7-WQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] create SMAF module
From: Emil Velikov <emil.l.velikov@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-media@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	zoltan.kuscsik@linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
	cc.ma@mediatek.com, pascal.brand@linaro.org,
	joakim.bech@linaro.org, dan.caprita@windriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi Benjamin,

I'd suspect you're interested in some feedback on these, so here is a few :-)
Sadly (ideally?) nothing serious, but a bunch minor suggestions, plus
the odd bug.

On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:

> --- /dev/null
> +++ b/drivers/smaf/smaf-core.c
> @@ -0,0 +1,794 @@
> +/*
> + * smaf.c
The comment does not match the actual file name.

You could give a brief summary of the file(s), if you're feeling gracious ;-)


> +
> +/**
> + * smaf_grant_access - return true if the specified device can get access
> + * to the memory area
> + *
Reading this makes me wonder if {request,allow}_access won't be better name ?


> +static int smaf_secure_handle(struct smaf_handle *handle)
> +{
> +       if (atomic_read(&handle->is_secure))
> +               return 0;
> +
> +       if (!have_secure_module())
> +               return -EINVAL;
> +
> +       handle->secure_ctx = smaf_dev.secure->create_ctx();
> +
Should one use a temporary variable so that the caller provided
storage is unchanged in case of an error ?

> +       if (!handle->secure_ctx)
> +               return -EINVAL;
> +
> +       atomic_set(&handle->is_secure, 1);
> +       return 0;
> +}
> +


> +int smaf_register_secure(struct smaf_secure *s)
> +{
> +       /* make sure that secure module have all required functions
> +        * to avoid test them each time later
> +        */
> +       WARN_ON(!s || !s->create_ctx || !s->destroy_ctx ||
> +               !s->grant_access || !s->revoke_access);
> +
Is something like below reasonable thing to do in the kernel ?
Same question goes for smaf_register_allocator() further down.

if (!s || ....)
  return -ESHOULDNEVERHAPPEN;



> +static struct vm_operations_struct smaf_vma_ops = {
Ops/vfucs normally are const data. Is there something preventing us here ?

> +       .close = smaf_vm_close,
> +};
> +
> +static int smaf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma)
> +{
> +       struct smaf_handle *handle = dmabuf->priv;
> +       bool ret;
> +       enum dma_data_direction dir;
> +
> +       /* if no allocator attached, get the first allocator */
> +       if (!handle->allocator) {
> +               struct smaf_allocator *alloc;
> +
> +               mutex_lock(&smaf_dev.lock);
> +               alloc = smaf_get_first_allocator(dmabuf);
> +               mutex_unlock(&smaf_dev.lock);
> +
> +               /* still no allocator ? */
> +               if (!alloc)
> +                       return -EINVAL;
> +
> +               handle->allocator = alloc;
> +       }
> +
> +       if (!handle->db_alloc) {
> +               struct dma_buf *db_alloc;
> +
> +               db_alloc = handle->allocator->allocate(dmabuf,
> +                                                      handle->length,
> +                                                      handle->flags);
> +               if (!db_alloc)
> +                       return -EINVAL;
> +
> +               handle->db_alloc = db_alloc;
> +       }
> +
The above half of the function looks identical to smaf_map_dma_buf().
Worth factoring it out to a helper function ?


> +static int smaf_attach(struct dma_buf *dmabuf, struct device *dev,
> +                      struct dma_buf_attachment *attach)
> +{
> +       struct smaf_handle *handle = dmabuf->priv;
> +       struct dma_buf_attachment *db_attach;
> +
> +       if (!handle->db_alloc)
> +               return 0;
> +
Shouldn't one return an error (-EINVAL or similar) here ?


> +static struct dma_buf_ops smaf_dma_buf_ops = {
const ? From a very quick look the compiler should warn us about it -
"smaf_dma_buf_ops discards const qualifier" or similar.


> +struct smaf_handle *smaf_create_handle(size_t length, unsigned int flags)
> +{
> +       struct smaf_handle *handle;
> +
> +       DEFINE_DMA_BUF_EXPORT_INFO(info);
> +
> +       handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +       if (!handle)
> +               return ERR_PTR(-ENOMEM);
> +
Err this should be return NULL; correct ?

> +       info.ops = &smaf_dma_buf_ops;
> +       info.size = round_up(length, PAGE_SIZE);
> +       info.flags = flags;
> +       info.priv = handle;
> +
> +       handle->dmabuf = dma_buf_export(&info);
> +       if (IS_ERR(handle->dmabuf)) {
> +               kfree(handle);
> +               return NULL;
> +       }
> +
> +       handle->length = info.size;
> +       handle->flags = flags;
> +
> +       return handle;
> +}
> +EXPORT_SYMBOL(smaf_create_handle);
> +
> +static long smaf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +       switch (cmd) {
> +       case SMAF_IOC_CREATE:
> +       {
> +               struct smaf_create_data data;
> +               struct smaf_handle *handle;
> +
> +               if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +                       return -EFAULT;
> +
> +               handle = smaf_create_handle(data.length, data.flags);
We want to sanitise the input data.{length,flags} before sending it
deeper in the kernel.

> +               if (!handle)
> +                       return -EINVAL;
> +
> +               if (data.name[0]) {
> +                       /* user force allocator selection */
> +                       if (smaf_select_allocator_by_name(handle->dmabuf,
> +                                                         data.name)) {
> +                               dma_buf_put(handle->dmabuf);
Missing free(handle), here and through the rest of the case statement ?

> +                               return -EINVAL;
> +                       }
> +               }
> +
> +               handle->fd = dma_buf_fd(handle->dmabuf, data.flags);
> +               if (handle->fd < 0) {
Worth adding smaf_DEselect_allocator_by_name() and using it here + below ?

> +                       dma_buf_put(handle->dmabuf);
> +                       return -EINVAL;
> +               }
> +
> +               data.fd = handle->fd;
> +               if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
> +                       dma_buf_put(handle->dmabuf);
> +                       return -EFAULT;
> +               }
> +               break;
> +       }
> +       case SMAF_IOC_GET_SECURE_FLAG:
> +       {
> +               struct smaf_secure_flag data;
> +               struct dma_buf *dmabuf;
> +
> +               if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> +                       return -EFAULT;
> +
> +               dmabuf = dma_buf_get(data.fd);
Worth adding if (data.fd == -1) return -EINVAL; ?



> +
> +static const struct file_operations smaf_fops = {
> +       .owner = THIS_MODULE,
There was a recent 'crusade' to get rid of these. Are you sure we
want/need this ?

> +       .unlocked_ioctl = smaf_ioctl,
> +};
> +
> +static int __init smaf_init(void)
> +{
> +       int ret = 0;
> +
Please drop the default initialization.

> +       smaf_dev.misc_dev.minor = MISC_DYNAMIC_MINOR;
> +       smaf_dev.misc_dev.name  = "smaf";
> +       smaf_dev.misc_dev.fops  = &smaf_fops;
> +
Initialize the global static variable (smaf_dev) upon declaration ?


> --- /dev/null
> +++ b/include/linux/smaf-secure.h

> +/**
> + * smaf_create_handle - create a smaf_handle with the give length and flags
> + * do not allocate memory but provide smaf_handle->dmabuf that can be
> + * shared between devices.
> + *
> + * @length: buffer size
> + * @flags: handle flags
> + */
> +struct smaf_handle *smaf_create_handle(size_t length, unsigned int flags);
> +
Inspired by the bug (?) in this function I think you want to document
the return value throughout the header.


> +#endif
> diff --git a/include/uapi/linux/smaf.h b/include/uapi/linux/smaf.h
> new file mode 100644
> index 0000000..5a9201b
> --- /dev/null
> +++ b/include/uapi/linux/smaf.h
> @@ -0,0 +1,66 @@
> +/*
> + * smaf.h
> + *
Would be nice if we had more elaborate comment in an UAPI header.


> +/**
> + * struct smaf_create_data - allocation parameters
> + * @length:    size of the allocation
> + * @flags:     flags passed to allocator
> + * @name:      name of the allocator to be selected, could be NULL
Is it guaranteed to be null terminated ? If so one should mentioned it
otherwise your userspace should be fixed.
Same comments apply for smaf_info::name.


> + * @fd:                returned file descriptor
> + */
> +struct smaf_create_data {
> +       size_t length;
> +       unsigned int flags;
> +       char name[ALLOCATOR_NAME_LENGTH];
> +       int fd;
The structs here feels quite fragile. Please read up on Daniel
Vetter's "Botching up ioctls" [1]. Personally I find pahole quite
useful is such process.

Hopefully I haven't lost the plot with the above, if I had don't be
shy to point out.

Thanks,
Emil

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/botching-up-ioctls.txt
