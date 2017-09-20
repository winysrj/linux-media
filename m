Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:59243 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdITVMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 17:12:55 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 5/6] media: dvb_frontend: better document the -EPERM
 condition
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
 <347ca7486c6c33f4229c6dc182cdde73b7e8879e.1505827883.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <5ce292d7-380a-61f9-07f4-7a2663459abe@kernel.org>
Date: Wed, 20 Sep 2017 15:12:43 -0600
MIME-Version: 1.0
In-Reply-To: <347ca7486c6c33f4229c6dc182cdde73b7e8879e.1505827883.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2017 07:42 AM, Mauro Carvalho Chehab wrote:
> Two readonly ioctls can't be allowed if the frontend device
> is opened in read only mode. Explain why.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index d0a17d67ab1b..db3f8c597a24 100644
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
> +	 *
> +	 * That matches all _IOR() ioctls, except for two special cases:
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

Looks good to me

Reviewed by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
