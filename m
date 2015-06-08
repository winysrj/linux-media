Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48273 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbbFHJUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 05:20:36 -0400
Message-ID: <55755E5E.60104@xs4all.nl>
Date: Mon, 08 Jun 2015 11:20:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 9/9] hackrf: do not set human readable name for formats
References: <1433592188-31748-1-git-send-email-crope@iki.fi> <1433592188-31748-9-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-9-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 02:03 PM, Antti Palosaari wrote:
> Format names are set by core nowadays. Remove name from driver.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/hackrf/hackrf.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 6ad6937..1f9483d 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -69,7 +69,6 @@ static const struct v4l2_frequency_band bands_rx_tx[] = {
>  
>  /* stream formats */
>  struct hackrf_format {
> -	char	*name;
>  	u32	pixelformat;
>  	u32	buffersize;
>  };
> @@ -77,7 +76,6 @@ struct hackrf_format {
>  /* format descriptions for capture and preview */
>  static struct hackrf_format formats[] = {
>  	{
> -		.name		= "Complex S8",
>  		.pixelformat	= V4L2_SDR_FMT_CS8,
>  		.buffersize	= BULK_BUFFER_SIZE,
>  	},
> @@ -977,7 +975,6 @@ static int hackrf_enum_fmt_sdr_cap(struct file *file, void *priv,
>  	if (f->index >= NUM_FORMATS)
>  		return -EINVAL;
>  
> -	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
>  	f->pixelformat = formats[f->index].pixelformat;
>  
>  	return 0;
> 

