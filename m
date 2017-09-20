Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:44079 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdITV3X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 17:29:23 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 01/25] media: dvb_frontend: better document the -EPERM
 condition
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <cover.1505933919.git.mchehab@s-opensource.com>
 <31b56d74c88c3d6a867468299e0498ebc15fcf63.1505933919.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <1aaca9b0-d704-cba1-c3ab-efe7125713cc@kernel.org>
Date: Wed, 20 Sep 2017 15:29:11 -0600
MIME-Version: 1.0
In-Reply-To: <31b56d74c88c3d6a867468299e0498ebc15fcf63.1505933919.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2017 01:11 PM, Mauro Carvalho Chehab wrote:
> Two readonly ioctls can't be allowed if the frontend device
> is opened in read only mode. Explain why.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 01bd19fd4c57..7dda5acea3f2 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1940,9 +1940,23 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
>  		return -ENODEV;
>  	}
>  
> -	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
> -	    (_IOC_DIR(cmd) != _IOC_READ || cmd == FE_GET_EVENT ||
> -	     cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
> +	/*
> +	 * If the frontend is opened in read-only mode, only the ioctls
> +	 * that don't interfere at the tune logic should be accepted.

Nit:

with the tune logic

> +	 * That allows an external application to monitor the DVB QoS and
> +	 * statistics parameters.
> +	 *> +	 * That matches all _IOR() ioctls, except for two special cases:
> +	 *   - FE_GET_EVENT is part of the tuning logic on a DVB application;
> +	 *   - FE_DISEQC_RECV_SLAVE_REPLY is part of DiSEqC 2.0
> +	 *     setup
> +	 * So, those two ioctls should also return -EPERM, as otherwise
> +	 * reading from them would interfere with a DVB tune application
> +	 */
> +	if ((file->f_flags & O_ACCMODE) == O_RDONLY
> +	    && (_IOC_DIR(cmd) != _IOC_READ
> +		|| cmd == FE_GET_EVENT
> +		|| cmd == FE_DISEQC_RECV_SLAVE_REPLY)) {
>  		up(&fepriv->sem);
>  		return -EPERM;
>  	}
> 

Same comment from your previous series. I started looking at
the old series and now the latest. Didn't realize the series
has been revised. :(

Looks good to me

Reviewed by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
