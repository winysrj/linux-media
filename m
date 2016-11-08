Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33124 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbcKHTUa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 14:20:30 -0500
Received: by mail-it0-f66.google.com with SMTP id e187so18410502itc.0
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2016 11:20:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com> <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Tue, 8 Nov 2016 12:20:29 -0700
Message-ID: <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device dynamically
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>
> Allow allocating the media device dynamically. As the struct media_device
> embeds struct media_devnode, the lifetime of that object is that same than
> that of the media_device.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 15 +++++++++++++++
>  include/media/media-device.h | 13 +++++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index a31329d..496195e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
>  }
>  EXPORT_SYMBOL_GPL(media_device_init);
>
> +struct media_device *media_device_alloc(struct device *dev)
> +{
> +       struct media_device *mdev;
> +
> +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +       if (!mdev)
> +               return NULL;
> +
> +       mdev->dev = dev;
> +       media_device_init(mdev);
> +
> +       return mdev;
> +}
> +EXPORT_SYMBOL_GPL(media_device_alloc);
> +

One problem with this allocation is, this media device can't be shared across
drivers. For au0828 and snd-usb-audio should be able to share the
media_device. That is what the Media Allocator API patch series does.
This a quick review and I will review the patch series and get back to
you.

thanks,
-- Shuah

>  void media_device_cleanup(struct media_device *mdev)
>  {
>         ida_destroy(&mdev->entity_internal_idx);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 96de915..c9b5798 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -207,6 +207,15 @@ static inline __must_check int media_entity_enum_init(
>  void media_device_init(struct media_device *mdev);
>
>  /**
> + * media_device_alloc() - Allocate and initialise a media device
> + *
> + * @dev:       The associated struct device pointer
> + *
> + * Allocate and initialise a media device. Returns a media device.
> + */
> +struct media_device *media_device_alloc(struct device *dev);
> +
> +/**
>   * media_device_cleanup() - Cleanups a media device element
>   *
>   * @mdev:      pointer to struct &media_device
> @@ -451,6 +460,10 @@ void __media_device_usb_init(struct media_device *mdev,
>                              const char *driver_name);
>
>  #else
> +static inline struct media_device *media_device_alloc(struct device *dev)
> +{
> +       return NULL;
> +}
>  static inline int media_device_register(struct media_device *mdev)
>  {
>         return 0;
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
