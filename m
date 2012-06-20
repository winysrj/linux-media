Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58517 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2FTPJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 11:09:20 -0400
Received: by vcbf11 with SMTP id f11so3870930vcb.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 08:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340201368-20751-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340201368-20751-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 20 Jun 2012 08:09:19 -0700
Message-ID: <CAC57bwtvfYDGO91r3zRry+WENm7x=UZ6TdOkXpmHDbQWT0feRA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC/PATCH] fb: Add dma-buf support
From: Jesse Barker <jesse.barker@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Your recent documentation efforts are extremely commendable.  Just a
couple of small nits below...

On Wed, Jun 20, 2012 at 7:09 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Add support for the dma-buf exporter role to the frame buffer API. The
> importer role isn't meaningful for frame buffer devices, as the frame
> buffer device model doesn't allow using externally allocated memory.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/fb/api.txt |   36 ++++++++++++++++++++++++++++++++++++
>  drivers/video/fbmem.c    |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h       |   12 ++++++++++++
>  3 files changed, 84 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/fb/api.txt b/Documentation/fb/api.txt
> index d4ff7de..f0b2173 100644
> --- a/Documentation/fb/api.txt
> +++ b/Documentation/fb/api.txt
> @@ -304,3 +304,39 @@ extensions.
>  Upon successful format configuration, drivers update the fb_fix_screeninfo
>  type, visual and line_length fields depending on the selected format. The type
>  and visual fields are set to FB_TYPE_FOURCC and FB_VISUAL_FOURCC respectively.
> +
> +
> +5. DMA buffer sharing
> +---------------------
> +
> +The dma-buf kernel framework allows DMA buffers to be shared across devices
> +and applications. Sharing buffers across display devices and video capture or
> +video decoding devices allow zero-copy operation when displaying video content
> +produced by a hardware device such as a camera or a hardware codec. This is
> +crucial to achieve optimal system performances during video display.
> +
> +While dma-buf supports both exporting internally allocated memory as a dma-buf
> +object (known as the exporter role) and importing a dma-buf object to be used
> +as device memory (known as the importer role), the frame buffer API only
> +supports the exporter role, as the frame buffer device model doesn't support
> +using externally-allocated memory.
> +
> +The export a frame buffer as a dma-buf file descriptors, applications call the

s/The/To
s/descriptors/descriptor

cheers,
Jesse

> +FBIOGET_DMABUF ioctl. The ioctl takes a pointer to a fb_dmabuf_export
> +structure.
> +
> +struct fb_dmabuf_export {
> +       __u32 fd;
> +       __u32 flags;
> +};
> +
> +The flag field specifies the flags to be used when creating the dma-buf file
> +descriptor. The only supported flag is O_CLOEXEC. If the call is successful,
> +the driver will set the fd field to a file descriptor corresponding to the
> +dma-buf object.
> +
> +Applications can then pass the file descriptors to another application or
> +another device driver. The dma-buf object is automatically reference-counted,
> +applications can and should close the file descriptor as soon as they don't
> +need it anymore. The underlying dma-buf object will not be freed before the
> +last device that uses the dma-buf object releases it.
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 0dff12a..400e449 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -15,6 +15,7 @@
>
>  #include <linux/compat.h>
>  #include <linux/types.h>
> +#include <linux/dma-buf.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/major.h>
> @@ -1074,6 +1075,23 @@ fb_blank(struct fb_info *info, int blank)
>        return ret;
>  }
>
> +#ifdef CONFIG_DMA_SHARED_BUFFER
> +int
> +fb_get_dmabuf(struct fb_info *info, int flags)
> +{
> +       struct dma_buf *dmabuf;
> +
> +       if (info->fbops->fb_dmabuf_export == NULL)
> +               return -ENOTTY;
> +
> +       dmabuf = info->fbops->fb_dmabuf_export(info);
> +       if (IS_ERR(dmabuf))
> +               return PTR_ERR(dmabuf);
> +
> +       return dma_buf_fd(dmabuf, flags);
> +}
> +#endif
> +
>  static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>                        unsigned long arg)
>  {
> @@ -1084,6 +1102,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>        struct fb_cmap cmap_from;
>        struct fb_cmap_user cmap;
>        struct fb_event event;
> +       struct fb_dmabuf_export dmaexp;
>        void __user *argp = (void __user *)arg;
>        long ret = 0;
>
> @@ -1191,6 +1210,23 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
>                console_unlock();
>                unlock_fb_info(info);
>                break;
> +#ifdef CONFIG_DMA_SHARED_BUFFER
> +       case FBIOGET_DMABUF:
> +               if (copy_from_user(&dmaexp, argp, sizeof(dmaexp)))
> +                       return -EFAULT;
> +
> +               if (!lock_fb_info(info))
> +                       return -ENODEV;
> +               dmaexp.fd = fb_get_dmabuf(info, dmaexp.flags);
> +               unlock_fb_info(info);
> +
> +               if (dmaexp.fd < 0)
> +                       return dmaexp.fd;
> +
> +               ret = copy_to_user(argp, &dmaexp, sizeof(dmaexp))
> +                   ? -EFAULT : 0;
> +               break;
> +#endif
>        default:
>                if (!lock_fb_info(info))
>                        return -ENODEV;
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index ac3f1c6..c9fee75 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -39,6 +39,7 @@
>  #define FBIOPUT_MODEINFO        0x4617
>  #define FBIOGET_DISPINFO        0x4618
>  #define FBIO_WAITFORVSYNC      _IOW('F', 0x20, __u32)
> +#define FBIOGET_DMABUF         _IOR('F', 0x21, struct fb_dmabuf_export)
>
>  #define FB_TYPE_PACKED_PIXELS          0       /* Packed Pixels        */
>  #define FB_TYPE_PLANES                 1       /* Non interleaved planes */
> @@ -403,6 +404,11 @@ struct fb_cursor {
>  #define FB_BACKLIGHT_MAX       0xFF
>  #endif
>
> +struct fb_dmabuf_export {
> +       __u32 fd;
> +       __u32 flags;
> +};
> +
>  #ifdef __KERNEL__
>
>  #include <linux/fs.h>
> @@ -418,6 +424,7 @@ struct vm_area_struct;
>  struct fb_info;
>  struct device;
>  struct file;
> +struct dma_buf;
>
>  /* Definitions below are used in the parsed monitor specs */
>  #define FB_DPMS_ACTIVE_OFF     1
> @@ -701,6 +708,11 @@ struct fb_ops {
>        /* called at KDB enter and leave time to prepare the console */
>        int (*fb_debug_enter)(struct fb_info *info);
>        int (*fb_debug_leave)(struct fb_info *info);
> +
> +#ifdef CONFIG_DMA_SHARED_BUFFER
> +       /* Export the frame buffer as a dmabuf object */
> +       struct dma_buf *(*fb_dmabuf_export)(struct fb_info *info);
> +#endif
>  };
>
>  #ifdef CONFIG_FB_TILEBLITTING
> --
> Regards,
>
> Laurent Pinchart
>
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
