Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49121 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab2JDRfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 13:35:41 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1532980iea.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2012 10:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349359468-18965-1-git-send-email-julian@jusst.de>
References: <1349359468-18965-1-git-send-email-julian@jusst.de>
Date: Thu, 4 Oct 2012 14:35:40 -0300
Message-ID: <CALF0-+U7uPNb058y-FZGt_tvtgh8FMtqf7uRHA5p7h+BCDCXow@mail.gmail.com>
Subject: Re: [PATCH] tm6000: Add parameter to keep urb bufs allocated.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Julian Scheel <julian@jusst.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julian,

Nice work! Just one pico-tiny nitpick:

On Thu, Oct 4, 2012 at 11:04 AM, Julian Scheel <julian@jusst.de> wrote:
> On systems where it cannot be assured that enough continous memory is available
> all the time it can be very useful to only allocate the memory once when it is
> needed the first time. Afterwards the initially allocated memory will be
> reused, so it is ensured that the memory will stay available until the driver
> is unloaded.
>
> Signed-off-by: Julian Scheel <julian@jusst.de>
> ---
>  drivers/media/video/tm6000/tm6000-video.c | 111 +++++++++++++++++++++++++-----
>  drivers/media/video/tm6000/tm6000.h       |   5 ++
>  2 files changed, 97 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
> index 03de3d8..1b8db35 100644
> --- a/drivers/media/video/tm6000/tm6000-video.c
> +++ b/drivers/media/video/tm6000/tm6000-video.c
> @@ -49,12 +49,15 @@
>  #define TM6000_MIN_BUF 4
>  #define TM6000_DEF_BUF 8
>
> +#define TM6000_NUM_URB_BUF 8
> +
>  #define TM6000_MAX_ISO_PACKETS 46      /* Max number of ISO packets */
>
>  /* Declare static vars that will be used as parameters */
>  static unsigned int vid_limit = 16;    /* Video memory limit, in Mb */
>  static int video_nr = -1;              /* /dev/videoN, -1 for autodetect */
>  static int radio_nr = -1;              /* /dev/radioN, -1 for autodetect */
> +static int keep_urb = 0;               /* keep urb buffers allocated */
>

There's no need to initialize this one to zero.

>  /* Debug level */
>  int tm6000_debug;
> @@ -570,6 +573,70 @@ static void tm6000_irq_callback(struct urb *urb)
>  }
>
>  /*
> + * Allocate URB buffers
> + */
> +static int tm6000_alloc_urb_buffers(struct tm6000_core *dev)
> +{
> +       int num_bufs = TM6000_NUM_URB_BUF;
> +       int i;
> +
> +       if (dev->urb_buffer != NULL)
> +               return 0;
> +
> +       dev->urb_buffer = kmalloc(sizeof(void *)*num_bufs, GFP_KERNEL);
> +       if (!dev->urb_buffer) {
> +               tm6000_err("cannot allocate memory for urb buffers\n");
> +               return -ENOMEM;
> +       }
> +
> +       dev->urb_dma = kmalloc(sizeof(dma_addr_t *)*num_bufs, GFP_KERNEL);
> +       if (!dev->urb_dma) {
> +               tm6000_err("cannot allocate memory for urb dma pointers\n");
> +               return -ENOMEM;
> +       }
> +
> +       for (i = 0; i < num_bufs; i++) {
> +               dev->urb_buffer[i] = usb_alloc_coherent(dev->udev, dev->urb_size,
> +                                       GFP_KERNEL, &dev->urb_dma[i]);
> +               if (!dev->urb_buffer[i]) {
> +                       tm6000_err("unable to allocate %i bytes for transfer"
> +                                       " buffer %i\n", dev->urb_size, i);
> +                       return -ENOMEM;
> +               }
> +               memset(dev->urb_buffer[i], 0, dev->urb_size);
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Free URB buffers
> + */
> +static int tm6000_free_urb_buffers(struct tm6000_core *dev)
> +{
> +       int i;
> +
> +       if (dev->urb_buffer == NULL)
> +               return 0;
> +
> +       for (i = 0; i < TM6000_NUM_URB_BUF; i++) {
> +               if (dev->urb_buffer[i]) {
> +                       usb_free_coherent(dev->udev,
> +                                       dev->urb_size,
> +                                       dev->urb_buffer[i],
> +                                       dev->urb_dma[i]);
> +                       dev->urb_buffer[i] = NULL;
> +               }
> +       }
> +       kfree (dev->urb_buffer);
> +       kfree (dev->urb_dma);
> +       dev->urb_buffer = NULL;
> +       dev->urb_dma = NULL;
> +
> +       return 0;
> +}
> +
> +/*
>   * Stop and Deallocate URBs
>   */
>  static void tm6000_uninit_isoc(struct tm6000_core *dev)
> @@ -585,18 +652,15 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
>                 if (urb) {
>                         usb_kill_urb(urb);
>                         usb_unlink_urb(urb);
> -                       if (dev->isoc_ctl.transfer_buffer[i]) {
> -                               usb_free_coherent(dev->udev,
> -                                               urb->transfer_buffer_length,
> -                                               dev->isoc_ctl.transfer_buffer[i],
> -                                               urb->transfer_dma);
> -                       }
>                         usb_free_urb(urb);
>                         dev->isoc_ctl.urb[i] = NULL;
>                 }
>                 dev->isoc_ctl.transfer_buffer[i] = NULL;
>         }
>
> +       if (!keep_urb)
> +               tm6000_free_urb_buffers(dev);
> +
>         kfree(dev->isoc_ctl.urb);
>         kfree(dev->isoc_ctl.transfer_buffer);
>
> @@ -606,12 +670,12 @@ static void tm6000_uninit_isoc(struct tm6000_core *dev)
>  }
>
>  /*
> - * Allocate URBs and start IRQ
> + * Assign URBs and start IRQ
>   */
>  static int tm6000_prepare_isoc(struct tm6000_core *dev)
>  {
>         struct tm6000_dmaqueue *dma_q = &dev->vidq;
> -       int i, j, sb_size, pipe, size, max_packets, num_bufs = 8;
> +       int i, j, sb_size, pipe, size, max_packets, num_bufs = TM6000_NUM_URB_BUF;
>         struct urb *urb;
>
>         /* De-allocates all pending stuff */
> @@ -634,6 +698,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
>
>         max_packets = TM6000_MAX_ISO_PACKETS;
>         sb_size = max_packets * size;
> +       dev->urb_size = sb_size;
>
>         dev->isoc_ctl.num_bufs = num_bufs;
>
> @@ -656,6 +721,17 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
>                     max_packets, num_bufs, sb_size,
>                     dev->isoc_in.maxsize, size);
>
> +
> +       if (!dev->urb_buffer && tm6000_alloc_urb_buffers(dev) < 0) {
> +               tm6000_err("cannot allocate memory for urb buffers\n");
> +
> +               /* call free, as some buffers might have been allocated */
> +               tm6000_free_urb_buffers(dev);
> +               kfree(dev->isoc_ctl.urb);
> +               kfree(dev->isoc_ctl.transfer_buffer);
> +               return -ENOMEM;
> +       }
> +
>         /* allocate urbs and transfer buffers */
>         for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
>                 urb = usb_alloc_urb(max_packets, GFP_KERNEL);
> @@ -667,17 +743,8 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
>                 }
>                 dev->isoc_ctl.urb[i] = urb;
>
> -               dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
> -                       sb_size, GFP_KERNEL, &urb->transfer_dma);
> -               if (!dev->isoc_ctl.transfer_buffer[i]) {
> -                       tm6000_err("unable to allocate %i bytes for transfer"
> -                                       " buffer %i%s\n",
> -                                       sb_size, i,
> -                                       in_interrupt() ? " while in int" : "");
> -                       tm6000_uninit_isoc(dev);
> -                       return -ENOMEM;
> -               }
> -               memset(dev->isoc_ctl.transfer_buffer[i], 0, sb_size);
> +               urb->transfer_dma = dev->urb_dma[i];
> +               dev->isoc_ctl.transfer_buffer[i] = dev->urb_buffer[i];
>
>                 usb_fill_bulk_urb(urb, dev->udev, pipe,
>                                   dev->isoc_ctl.transfer_buffer[i], sb_size,
> @@ -1833,6 +1900,9 @@ int tm6000_v4l2_unregister(struct tm6000_core *dev)
>  {
>         video_unregister_device(dev->vfd);
>
> +       /* if URB buffers are still allocated free them now */
> +       tm6000_free_urb_buffers(dev);
> +
>         if (dev->radio_dev) {
>                 if (video_is_registered(dev->radio_dev))
>                         video_unregister_device(dev->radio_dev);
> @@ -1858,3 +1928,6 @@ MODULE_PARM_DESC(debug, "activates debug info");
>  module_param(vid_limit, int, 0644);
>  MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
>
> +module_param(keep_urb, bool, 0);
> +MODULE_PARM_DESC(keep_urb, "Keep urb buffers allocated even when the device "
> +                               "is closed by the user");
> diff --git a/drivers/media/video/tm6000/tm6000.h b/drivers/media/video/tm6000/tm6000.h
> index 6531d16..4bd3a0d 100644
> --- a/drivers/media/video/tm6000/tm6000.h
> +++ b/drivers/media/video/tm6000/tm6000.h
> @@ -267,6 +267,11 @@ struct tm6000_core {
>
>         spinlock_t                   slock;
>
> +       /* urb dma buffers */
> +       char                            **urb_buffer;
> +       dma_addr_t                      *urb_dma;
> +       unsigned int                    urb_size;
> +
>         unsigned long quirks;
>  };
>
> --
> 1.7.12.2
>

Thanks,
Ezequiel.
