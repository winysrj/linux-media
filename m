Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaIXKsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 06:48:51 -0400
Message-ID: <5422A18F.9090106@iki.fi>
Date: Wed, 24 Sep 2014 13:48:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] hackrf: harmless off by one in debug code
References: <20140924103639.GB15107@mwanda>
In-Reply-To: <20140924103639.GB15107@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 09/24/2014 01:36 PM, Dan Carpenter wrote:
> My static checker complains that "i" could be one element beyond the end
> of the array.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 328b5ba..fd1fa41 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -932,7 +932,7 @@ static int hackrf_set_bandwidth(struct hackrf_dev *dev)
>   	dev->bandwidth->val = bandwidth;
>   	dev->bandwidth->cur.val = bandwidth;
>
> -	dev_dbg(dev->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
> +	dev_dbg(dev->dev, "bandwidth selected=%d\n", bandwidth);
>
>   	u16tmp = 0;
>   	u16tmp |= ((bandwidth >> 0) & 0xff) << 0;
>

-- 
http://palosaari.fi/
