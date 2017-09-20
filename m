Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:43366 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbdITVI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 17:08:28 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 3/6] media: dvb_frontend: get rid of proprierty cache's
 state
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
 <c820984659f4930306921bf0cae09a646477611e.1505827883.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <02a52e56-fbf8-d928-9e38-34b75f134b4a@kernel.org>
Date: Wed, 20 Sep 2017 15:08:14 -0600
MIME-Version: 1.0
In-Reply-To: <c820984659f4930306921bf0cae09a646477611e.1505827883.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2017 07:42 AM, Mauro Carvalho Chehab wrote:
> In the past, I guess the idea was to use state in order to
> allow an autofush logic. However, in the current code, it is
> used only for debug messages, on a poor man's solution, as
> there's already a debug message to indicate when the properties
> got flushed.
> 
> So, just get rid of it for good.

Okay now PATCH 2/3 makes sense. Looks good to me.

Reviewed-by: Shuah Khan <shuahkg@osg.samsung.com>

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 20 ++++++--------------
>  drivers/media/dvb-core/dvb_frontend.h |  5 -----
>  2 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index cbe697a094d2..d0a17d67ab1b 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -951,8 +951,6 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>  	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
>  	c->delivery_system = delsys;
>  
> -	c->state = DTV_CLEAR;
> -
>  	dev_dbg(fe->dvb->device, "%s: Clearing cache for delivery system %d\n",
>  			__func__, c->delivery_system);
>  
> @@ -1775,13 +1773,13 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  		dvb_frontend_clear_cache(fe);
>  		break;
>  	case DTV_TUNE:
> -		/* interpret the cache of data, build either a traditional frontend
> -		 * tunerequest so we can pass validation in the FE_SET_FRONTEND
> -		 * ioctl.
> +		/*
> +		 * Use the cached Digital TV properties to tune the
> +		 * frontend
>  		 */
> -		c->state = tvp->cmd;
> -		dev_dbg(fe->dvb->device, "%s: Finalised property cache\n",
> -				__func__);
> +		dev_dbg(fe->dvb->device,
> +			"%s: Setting the frontend from property cache\n",
> +			__func__);
>  
>  		r = dtv_set_frontend(fe);
>  		break;
> @@ -1930,7 +1928,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
>  {
>  	struct dvb_device *dvbdev = file->private_data;
>  	struct dvb_frontend *fe = dvbdev->priv;
> -	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	int err;
>  
> @@ -1950,7 +1947,6 @@ static int dvb_frontend_ioctl(struct file *file, unsigned int cmd, void *parg)
>  		return -EPERM;
>  	}
>  
> -	c->state = DTV_UNDEFINED;
>  	err = dvb_frontend_handle_ioctl(file, cmd, parg);
>  
>  	up(&fepriv->sem);
> @@ -2134,10 +2130,6 @@ static int dvb_frontend_handle_ioctl(struct file *file,
>  			}
>  			(tvp + i)->result = err;
>  		}
> -
> -		if (c->state == DTV_TUNE)
> -			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
> -
>  		kfree(tvp);
>  		break;
>  	}
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 852b91ba49d2..1bdeb10f0d78 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -620,11 +620,6 @@ struct dtv_frontend_properties {
>  	struct dtv_fe_stats	post_bit_count;
>  	struct dtv_fe_stats	block_error;
>  	struct dtv_fe_stats	block_count;
> -
> -	/* private: */
> -	/* Cache State */
> -	u32			state;
> -
>  };
>  
>  #define DVB_FE_NO_EXIT  0
> 

thanks,
-- Shuah
