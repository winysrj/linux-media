Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47591 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbbKKPlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 10:41:13 -0500
Subject: Re: [PATCH] [media] hackrf: don't emit dev debug on a kfree'd or null
 dev
To: Colin King <colin.king@canonical.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
References: <1447254353-12452-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56436195.7070204@iki.fi>
Date: Wed, 11 Nov 2015 17:41:09 +0200
MIME-Version: 1.0
In-Reply-To: <1447254353-12452-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2015 05:05 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Static analysis with smatch detected a couple of issues:
>
> drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
>    error: we previously assumed 'dev' could be null (see line 1366)
> drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
>    error: dereferencing freed memory 'dev'
>
> A dev_dbg message is being output on a kfree'd dev.  Worse, if dev
> is not allocated earlier, on, a null pointer deference on dev->dev
> can occur onthe deb_dbg call.  Clean this up by only printing a debug
> message if dev is not null and has not been kfree'd.

It is already fixed:
https://patchwork.linuxtv.org/patch/31712/

>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/media/usb/hackrf/hackrf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index e05bfec..faf3670 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -1528,9 +1528,9 @@ err_v4l2_ctrl_handler_free_tx:
>   err_v4l2_ctrl_handler_free_rx:
>   	v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
>   err_kfree:
> +	dev_dbg(dev->dev, "failed=%d\n", ret);
>   	kfree(dev);
>   err:
> -	dev_dbg(dev->dev, "failed=%d\n", ret);
>   	return ret;
>   }
>
>

regards
Antti




-- 
http://palosaari.fi/
