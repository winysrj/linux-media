Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab3EULra (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 07:47:30 -0400
Date: Tue, 21 May 2013 08:47:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josephdanielwalter@gmail.com, Greg KH <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: strncpy issue, need always let NUL terminated
 string  ended by zero.
Message-ID: <20130521084713.3cbf25c2@redhat.com>
In-Reply-To: <5188EF5C.3030003@asianux.com>
References: <5188EF5C.3030003@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 07 May 2013 20:11:08 +0800
Chen Gang <gang.chen@asianux.com> escreveu:

> 
> For NUL terminated string, need always let it ended by zero.
> 
> The 'name' may be copied to user mode ('dvb_fe->ops.info' is 'struct
> dvb_frontend_info' which is defined in ./include/uapi/...), and its
> length is also known within as102_dvb_register_fe(), so need fully
> initialize it (not use strlcpy instead of strncpy).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/staging/media/as102/as102_fe.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
> index 9ce8c9d..b3efec9 100644
> --- a/drivers/staging/media/as102/as102_fe.c
> +++ b/drivers/staging/media/as102/as102_fe.c
> @@ -334,6 +334,7 @@ int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
>  	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
>  	strncpy(dvb_fe->ops.info.name, as102_dev->name,
>  		sizeof(dvb_fe->ops.info.name));
> +	dvb_fe->ops.info.name[sizeof(dvb_fe->ops.info.name) - 1] = '\0';

Instead, the better would be to use strlcpy(), as it warrants that the
copied string will be nul-terminated.

Regards,
Mauro
