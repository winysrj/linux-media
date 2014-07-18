Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3789 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbaGRFPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 01:15:19 -0400
Message-ID: <53C8AD58.1000200@xs4all.nl>
Date: Fri, 18 Jul 2014 07:15:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] airspy: print notice to point SDR API is not 100%
 stable yet
References: <1405645513-25616-1-git-send-email-crope@iki.fi> <1405645513-25616-3-git-send-email-crope@iki.fi>
In-Reply-To: <1405645513-25616-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 03:05 AM, Antti Palosaari wrote:
> Print notice on driver load: "SDR API is still slightly
> experimental and functionality changes may follow". It is just
> remind possible used SDR API is very new and surprises may occur.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/airspy/airspy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
> index 5b3310f..6cf09ef 100644
> --- a/drivers/media/usb/airspy/airspy.c
> +++ b/drivers/media/usb/airspy/airspy.c
> @@ -1086,7 +1086,9 @@ static int airspy_probe(struct usb_interface *intf,
>  	}
>  	dev_info(&s->udev->dev, "Registered as %s\n",
>  			video_device_node_name(&s->vdev));
> -
> +	dev_notice(&s->udev->dev,
> +			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
> +			KBUILD_MODNAME);
>  	return 0;
>  
>  err_free_controls:
> 

On that topic: I would like to see a 'buffersize' or 'samples_per_buffer'
field in struct v4l2_sdr_format. That gives applications the opportunity
to 1) get the current buffer size and 2) be able to change it if the driver
supports that. E.g. for high sampling rates they might want to use larger
buffers, for low they might want to select smaller buffers.

Right now it is fixed and you won't know the buffer size until you do
QUERYBUF. Which is not in sync with what other formats do.

Regards,

	Hans
