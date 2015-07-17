Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53008 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbbGQOoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:44:02 -0400
Message-ID: <55A91474.4000801@xs4all.nl>
Date: Fri, 17 Jul 2015 16:43:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 8/9] hackrf: add support for transmitter
References: <1437030298-20944-1-git-send-email-crope@iki.fi> <1437030298-20944-9-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-9-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2015 09:04 AM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 787 +++++++++++++++++++++++++++-----------
>  1 file changed, 572 insertions(+), 215 deletions(-)
> 


> @@ -611,8 +751,15 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
>  		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
>  {
>  	struct hackrf_dev *dev = vb2_get_drv_priv(vq);
> +	struct usb_interface *intf = dev->intf;
> +	int ret;
>  
> -	dev_dbg(dev->dev, "nbuffers=%d\n", *nbuffers);
> +	dev_dbg(&intf->dev, "nbuffers=%d\n", *nbuffers);
> +
> +	if (test_and_set_bit(QUEUE_SETUP, &dev->flags)) {
> +		ret = -EBUSY;
> +		goto err;
> +	}

This doesn't work. The bit is only cleared when start_streaming fails or
stop_streaming is called. But the application can also call REQBUFS again
or just close the file handle, and then QUEUE_SETUP should also be cleared.

But why is this here in the first place? It doesn't seem to do anything
useful (except mess up the v4l2-compliance tests).

I've removed it and it now seems to work OK.

Regards,

	Hans

>  
>  	/* Need at least 8 buffers */
>  	if (vq->num_buffers + *nbuffers < 8)
> @@ -620,8 +767,11 @@ static int hackrf_queue_setup(struct vb2_queue *vq,
>  	*nplanes = 1;
>  	sizes[0] = PAGE_ALIGN(dev->buffersize);
>  
> -	dev_dbg(dev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
> +	dev_dbg(&intf->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
>  	return 0;
> +err:
> +	dev_dbg(&intf->dev, "failed=%d\n", ret);
> +	return ret;
>  }

