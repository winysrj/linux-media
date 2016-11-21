Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55959 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754646AbcKUOhY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:37:24 -0500
Subject: Re: [PATCH 2/4] [media] davinci: vpif_capture: don't lock over
 s_stream
To: Kevin Hilman <khilman@baylibre.com>, linux-media@vger.kernel.org
References: <20161119003208.10550-1-khilman@baylibre.com>
 <20161119003208.10550-2-khilman@baylibre.com>
Cc: devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=c5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f385c65b-1f73-a5b1-b498-43916d5bdfb6@xs4all.nl>
Date: Mon, 21 Nov 2016 15:37:20 +0100
MIME-Version: 1.0
In-Reply-To: <20161119003208.10550-2-khilman@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/11/16 01:32, Kevin Hilman wrote:
> Video capture subdevs may be over I2C and may sleep during xfer, so we
> cannot do IRQ-disabled locking when calling the subdev.
>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 79cef74e164f..becc3e63b472 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -193,12 +193,16 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  		}
>  	}
>
> +	spin_unlock_irqrestore(&common->irqlock, flags);
> +
>  	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
>  	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
>  		vpif_dbg(1, debug, "stream on failed in subdev\n");
>  		goto err;
>  	}
>
> +	spin_lock_irqsave(&common->irqlock, flags);

This needs to be moved to right after the v4l2_subdev_call, otherwise the
goto err above will not have the spinlock.

	Hans

> +
>  	/* Call vpif_set_params function to set the parameters and addresses */
>  	ret = vpif_set_video_params(vpif, ch->channel_id);
>  	if (ret < 0) {
>
