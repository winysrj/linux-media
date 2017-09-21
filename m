Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:53592 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdIUOTt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:19:49 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 02/25] media: dvb_frontend: fix return values for
 FE_SET_PROPERTY
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <cover.1505933919.git.mchehab@s-opensource.com>
 <c2110383fc37d875313125cac02df4e68cd5eb82.1505933919.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <11fdb7f3-ddfb-dbd3-35ef-13d285258e4a@kernel.org>
Date: Thu, 21 Sep 2017 08:19:36 -0600
MIME-Version: 1.0
In-Reply-To: <c2110383fc37d875313125cac02df4e68cd5eb82.1505933919.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2017 01:11 PM, Mauro Carvalho Chehab wrote:
> There are several problems with regards to the return of
> FE_SET_PROPERTY. The original idea were to return per-property
> return codes via tvp->result field, and to return an updated
> set of values.
> 
> However, that never worked. What's actually implemented is:
> 
> - the FE_SET_PROPERTY implementation doesn't call .get_frontend
>   callback in order to get the actual parameters after return;
> 
> - the tvp->result field is only filled if there's no error.
>   So, it is always filled with zero;
> 
> - FE_SET_PROPERTY doesn't call memdup_user() nor any other
>   copy_to_user() function. So, any changes at the properies

Spelling - properties

Nit: to the properties

>   will be lost;
> 
> - FE_SET_PROPERTY is declared as a write-only ioctl (IOW).
> 
> While we could fix the above, it could cause regressions.
> 
> So, let's just assume what the code really does, updating
> the documentation accordingly and removing the logic that
> would update the discarded tvp->result.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

The rest looks good.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>

> ---
>  Documentation/media/uapi/dvb/fe-get-property.rst | 7 +++++--
>  drivers/media/dvb-core/dvb_frontend.c            | 2 --
>  include/uapi/linux/dvb/frontend.h                | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
> index 948d2ba84f2c..b69741d9cedf 100644
> --- a/Documentation/media/uapi/dvb/fe-get-property.rst
> +++ b/Documentation/media/uapi/dvb/fe-get-property.rst
> @@ -48,8 +48,11 @@ depends on the delivery system and on the device:
>  
>     -  This call requires read/write access to the device.
>  
> -   -  At return, the values are updated to reflect the actual parameters
> -      used.
> +.. note::
> +
> +   At return, the values aren't updated to reflect the actual
> +   parameters used. If the actual parameters are needed, an explicit
> +   call to ``FE_GET_PROPERTY`` is needed.
>  
>  -  ``FE_GET_PROPERTY:``
>  
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 7dda5acea3f2..bd60a490ce0f 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2142,7 +2142,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
>  				kfree(tvp);
>  				return err;
>  			}
> -			(tvp + i)->result = err;
>  		}
>  		kfree(tvp);
>  		break;
> @@ -2187,7 +2186,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
>  				kfree(tvp);
>  				return err;
>  			}
> -			(tvp + i)->result = err;
>  		}
>  
>  		if (copy_to_user((void __user *)tvps->props, tvp,
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 861cacd5711f..6bc26f35217b 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -830,7 +830,7 @@ struct dtv_fe_stats {
>   * @cmd:	Digital TV command.
>   * @reserved:	Not used.
>   * @u:		Union with the values for the command.
> - * @result:	Result of the command set (currently unused).
> + * @result:	Unused
>   *
>   * The @u union may have either one of the values below:
>   *
> 

thanks,
-- Shuah
