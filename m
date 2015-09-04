Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46042 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbbIDKHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 06:07:33 -0400
Message-ID: <55E96D26.8090109@xs4all.nl>
Date: Fri, 04 Sep 2015 12:06:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/13] hackrf: add support for transmitter
References: <1441144769-29211-1-git-send-email-crope@iki.fi> <1441144769-29211-11-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-11-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Two comments, see below:

On 09/01/2015 11:59 PM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 923 ++++++++++++++++++++++++++------------
>  1 file changed, 648 insertions(+), 275 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> -static unsigned int hackrf_convert_stream(struct hackrf_dev *dev,
> -		void *dst, void *src, unsigned int src_len)
> +void hackrf_copy_stream(struct hackrf_dev *dev, void *dst,

Is there any reason 'static' was removed here? It's not used externally as
far as I can tell.

> +			void *src, unsigned int src_len)
>  {
>  	memcpy(dst, src, src_len);
>  

<snip>

> +static int hackrf_s_modulator(struct file *file, void *fh,
> +		       const struct v4l2_modulator *a)
> +{
> +	struct hackrf_dev *dev = video_drvdata(file);
> +	int ret;
> +
> +	dev_dbg(dev->dev, "index=%d\n", a->index);
> +
> +	if (a->index == 0)
> +		ret = 0;
> +	else if (a->index == 1)
> +		ret = 0;
> +	else
> +		ret = -EINVAL;
> +
> +	return ret;
> +}

Why implement this at all? It's not doing anything. I'd just drop s_modulator
support.

If there is a reason why you do need it, then simplify it to:

	return a->index > 1 ? -EINVAL : 0;

Regards,

	Hans
