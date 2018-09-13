Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51870 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbeIMOe7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:34:59 -0400
Received: by mail-wm0-f66.google.com with SMTP id y2-v6so5358440wma.1
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 02:26:20 -0700 (PDT)
Date: Thu, 13 Sep 2018 10:26:07 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] drm/i2c/tda9950.c: set MAX_RETRIES for errors only
Message-ID: <20180913092607.GA21564@juma.lan>
References: <6109476a-e8fa-6d82-3ed8-3833f0f18615@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6109476a-e8fa-6d82-3ed8-3833f0f18615@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Mon, Aug 27, 2018 at 02:28:50PM +0200, Hans Verkuil wrote:
> The CEC_TX_STATUS_MAX_RETRIES should be set for errors only to
> prevent the CEC framework from retrying the transmit. If the
> transmit was successful, then don't set this flag.
> 
> Found by running 'cec-compliance -A' on a beaglebone box.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/i2c/tda9950.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda9950.c b/drivers/gpu/drm/i2c/tda9950.c
> index 5d2f0d548469..4a14fc3b5011 100644
> --- a/drivers/gpu/drm/i2c/tda9950.c
> +++ b/drivers/gpu/drm/i2c/tda9950.c
> @@ -191,7 +191,8 @@ static irqreturn_t tda9950_irq(int irq, void *data)
>  			break;
>  		}
>  		/* TDA9950 executes all retries for us */
> -		tx_status |= CEC_TX_STATUS_MAX_RETRIES;
> +		if (tx_status != CEC_TX_STATUS_OK)
> +			tx_status |= CEC_TX_STATUS_MAX_RETRIES;
>  		cec_transmit_done(priv->adap, tx_status, arb_lost_cnt,
>  				  nack_cnt, 0, err_cnt);
>  		break;

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.com>

> -- 
> 2.18.0
> 
> 
