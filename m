Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41957 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaAGPzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 10:55:52 -0500
Received: by mail-wi0-f182.google.com with SMTP id en1so890184wid.15
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 07:55:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389068966-14594-1-git-send-email-tmester@ieee.org>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
Date: Tue, 7 Jan 2014 10:55:51 -0500
Message-ID: <CAGoCfix35wCBMaKUmEq2PiB2DkwCwrFFCBpTkJdjZbdoTKN4-w@mail.gmail.com>
Subject: Re: [PATCH 1/3] au8028: Fix cleanup on kzalloc fail
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Mester <ttmesterr@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 6, 2014 at 11:29 PM, Tim Mester <ttmesterr@gmail.com> wrote:
> Free what was allocated if there is a failure allocating
> transfer buffers.
>
> Stop the feed on a start feed error.  The stop feed is not always called
> if start feed fails.  If the feed is not stopped on error, then the driver
> will be stuck so that it can never start feeding again.
>
> Signed-off-by: Tim Mester <tmester@ieee.org>
> ---
>  linux/drivers/media/usb/au0828/au0828-dvb.c | 70 +++++++++++++++++++++--------
>  linux/drivers/media/usb/au0828/au0828.h     |  2 +
>  2 files changed, 53 insertions(+), 19 deletions(-)
>
> diff --git a/linux/drivers/media/usb/au0828/au0828-dvb.c b/linux/drivers/media/usb/au0828/au0828-dvb.c
> index 9a6f156..2312381 100644
> --- a/linux/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/linux/drivers/media/usb/au0828/au0828-dvb.c
> @@ -153,9 +153,11 @@ static int stop_urb_transfer(struct au0828_dev *dev)
>
>         dev->urb_streaming = 0;
>         for (i = 0; i < URB_COUNT; i++) {
> -               usb_kill_urb(dev->urbs[i]);
> -               kfree(dev->urbs[i]->transfer_buffer);
> -               usb_free_urb(dev->urbs[i]);
> +               if (dev->urbs[i]) {
> +                       usb_kill_urb(dev->urbs[i]);
> +                       kfree(dev->urbs[i]->transfer_buffer);
> +                       usb_free_urb(dev->urbs[i]);
> +               }
>         }
>
>         return 0;
> @@ -185,6 +187,8 @@ static int start_urb_transfer(struct au0828_dev *dev)
>                 if (!purb->transfer_buffer) {
>                         usb_free_urb(purb);
>                         dev->urbs[i] = NULL;
> +                       printk(KERN_ERR "%s: failed big buffer allocation, "
> +                              "err = %d\n", __func__, ret);
>                         goto err;
>                 }
>
> @@ -217,6 +221,27 @@ err:
>         return ret;
>  }
>
> +static void au0828_start_transport(struct au0828_dev *dev)
> +{
> +       au0828_write(dev, 0x608, 0x90);
> +       au0828_write(dev, 0x609, 0x72);
> +       au0828_write(dev, 0x60a, 0x71);
> +       au0828_write(dev, 0x60b, 0x01);
> +
> +}
> +
> +static void au0828_stop_transport(struct au0828_dev *dev, int full_stop)
> +{
> +       if (full_stop) {
> +               au0828_write(dev, 0x608, 0x00);
> +               au0828_write(dev, 0x609, 0x00);
> +               au0828_write(dev, 0x60a, 0x00);
> +       }
> +       au0828_write(dev, 0x60b, 0x00);
> +}
> +
> +
> +
>  static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
>  {
>         struct dvb_demux *demux = feed->demux;
> @@ -231,13 +256,17 @@ static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
>
>         if (dvb) {
>                 mutex_lock(&dvb->lock);
> +               dvb->start_count++;
> +               dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
> +                       dvb->start_count, dvb->stop_count);
>                 if (dvb->feeding++ == 0) {
>                         /* Start transport */
> -                       au0828_write(dev, 0x608, 0x90);
> -                       au0828_write(dev, 0x609, 0x72);
> -                       au0828_write(dev, 0x60a, 0x71);
> -                       au0828_write(dev, 0x60b, 0x01);
> +                       au0828_start_transport(dev);
>                         ret = start_urb_transfer(dev);
> +                       if (ret < 0) {
> +                               au0828_stop_transport(dev, 0);
> +                               dvb->feeding--; /* We ran out of memory... */
> +                       }
>                 }
>                 mutex_unlock(&dvb->lock);
>         }
> @@ -256,10 +285,16 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
>
>         if (dvb) {
>                 mutex_lock(&dvb->lock);
> -               if (--dvb->feeding == 0) {
> -                       /* Stop transport */
> -                       ret = stop_urb_transfer(dev);
> -                       au0828_write(dev, 0x60b, 0x00);
> +               dvb->stop_count++;
> +               dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
> +                       dvb->start_count, dvb->stop_count);
> +               if (dvb->feeding > 0) {
> +                       dvb->feeding--;
> +                       if (dvb->feeding == 0) {
> +                               /* Stop transport */
> +                               ret = stop_urb_transfer(dev);
> +                               au0828_stop_transport(dev, 0);
> +                       }
>                 }
>                 mutex_unlock(&dvb->lock);
>         }
> @@ -282,16 +317,10 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
>
>         /* Stop transport */
>         stop_urb_transfer(dev);
> -       au0828_write(dev, 0x608, 0x00);
> -       au0828_write(dev, 0x609, 0x00);
> -       au0828_write(dev, 0x60a, 0x00);
> -       au0828_write(dev, 0x60b, 0x00);
> +       au0828_stop_transport(dev, 1);
>
>         /* Start transport */
> -       au0828_write(dev, 0x608, 0x90);
> -       au0828_write(dev, 0x609, 0x72);
> -       au0828_write(dev, 0x60a, 0x71);
> -       au0828_write(dev, 0x60b, 0x01);
> +       au0828_start_transport(dev);
>         start_urb_transfer(dev);
>
>         mutex_unlock(&dvb->lock);
> @@ -375,6 +404,9 @@ static int dvb_register(struct au0828_dev *dev)
>
>         /* register network adapter */
>         dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
> +
> +       dvb->start_count = 0;
> +       dvb->stop_count = 0;
>         return 0;
>
>  fail_fe_conn:
> diff --git a/linux/drivers/media/usb/au0828/au0828.h b/linux/drivers/media/usb/au0828/au0828.h
> index ef1f57f..a00b400 100644
> --- a/linux/drivers/media/usb/au0828/au0828.h
> +++ b/linux/drivers/media/usb/au0828/au0828.h
> @@ -102,6 +102,8 @@ struct au0828_dvb {
>         struct dmx_frontend fe_mem;
>         struct dvb_net net;
>         int feeding;
> +       int start_count;
> +       int stop_count;
>  };
>
>  enum au0828_stream_state {
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Devin Heitmueller <dheitmueller@kernellabs.com>

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
