Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45008 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3EAIxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 04:53:31 -0400
Received: by mail-ie0-f178.google.com with SMTP id aq17so1647556iec.23
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 01:53:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367382644-30788-1-git-send-email-airlied@gmail.com>
References: <1367382644-30788-1-git-send-email-airlied@gmail.com>
Date: Wed, 1 May 2013 10:53:30 +0200
Message-ID: <CAKMK7uGJWHb7so8_uNe0JzH_EUAQLExFPda=ZR+8yuG+ALvo2w@mail.gmail.com>
Subject: Re: [PATCH] drm/udl: avoid swiotlb for imported vmap buffers.
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 1, 2013 at 6:30 AM, Dave Airlie <airlied@gmail.com> wrote:
> Since we ask the dmabuf owner to map the dma-buf into our device
> address space, but for udl at present that is the CPU address space,
> since we don't DMA directly from the mapped buffer.
>
> However if we don't set a dma mask on the usb device, the mapping
> ends up using swiotlb on machines that have it enabled, which
> is less than desireable.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Fyi for everyone else who was not on irc when Dave&I discussed this:
This really shouldn't be required and I think the real issue is that
udl creates a dma_buf attachement (which is needed for device dma
only), but only really wants to do cpu access through vmap/kmap. So
not attached the device should be good enough. Cc'ing a few more lists
for better fyi ;-)
-Daniel

> ---
>  drivers/gpu/drm/udl/udl_main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/udl/udl_main.c b/drivers/gpu/drm/udl/udl_main.c
> index 0ce2d71..6770e1b 100644
> --- a/drivers/gpu/drm/udl/udl_main.c
> +++ b/drivers/gpu/drm/udl/udl_main.c
> @@ -293,6 +293,7 @@ int udl_driver_load(struct drm_device *dev, unsigned long flags)
>         udl->ddev = dev;
>         dev->dev_private = udl;
>
> +       dma_set_mask(dev->dev, DMA_BIT_MASK(64));
>         if (!udl_parse_vendor_descriptor(dev, dev->usbdev)) {
>                 DRM_ERROR("firmware not recognized. Assume incompatible device\n");
>                 goto err;
> --
> 1.8.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
