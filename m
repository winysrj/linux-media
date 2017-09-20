Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:59114 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdITULu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:11:50 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 1/6] media: dvb_frontend: cleanup
 dvb_frontend_ioctl_properties()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <bc18d8a6-cf50-3257-71b0-d90e7fb5ba25@kernel.org>
Date: Wed, 20 Sep 2017 14:11:39 -0600
MIME-Version: 1.0
In-Reply-To: <19abade3ce5fe5e57ace5a974bdfd43d64892b67.1505827883.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2017 07:42 AM, Mauro Carvalho Chehab wrote:
> Use a switch() on this function, just like on other ioctl
> handlers and handle parameters inside each part of the
> switch.
> 
> That makes it easier to integrate with the already existing
> ioctl handler function.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

The change looks good. Couple of comments below:

> ---
>  drivers/media/dvb-core/dvb_frontend.c | 83 +++++++++++++++++++++--------------
>  1 file changed, 51 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 8abe4f541a36..725cb1c8a088 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1971,21 +1971,25 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  	struct dvb_frontend *fe = dvbdev->priv;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int err = 0;
> -
> -	struct dtv_properties *tvps = parg;
> -	struct dtv_property *tvp = NULL;
> -	int i;
> +	int err, i;
>  
>  	dev_dbg(fe->dvb->device, "%s:\n", __func__);
>  
> -	if (cmd == FE_SET_PROPERTY) {
> -		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
> -		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
> +	switch(cmd) {
> +	case FE_SET_PROPERTY: {
> +		struct dtv_properties *tvps = parg;
> +		struct dtv_property *tvp = NULL;
>  
> -		/* Put an arbitrary limit on the number of messages that can
> -		 * be sent at once */
> -		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
> +			__func__, tvps->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
> +			__func__, tvps->props);
> +
> +		/*
> +		 * Put an arbitrary limit on the number of messages that can
> +		 * be sent at once
> +		 */
> +		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
>  			return -EINVAL;
>  
>  		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
> @@ -1994,23 +1998,34 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  
>  		for (i = 0; i < tvps->num; i++) {
>  			err = dtv_property_process_set(fe, tvp + i, file);
> -			if (err < 0)
> -				goto out;
> +			if (err < 0) {
> +				kfree(tvp);
> +				return err;
> +			}
>  			(tvp + i)->result = err;
>  		}
>  
>  		if (c->state == DTV_TUNE)
>  			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
>  
> -	} else if (cmd == FE_GET_PROPERTY) {
> +		kfree(tvp);
> +		break;
> +	}
> +	case FE_GET_PROPERTY: {
> +		struct dtv_properties *tvps = parg;
> +		struct dtv_property *tvp = NULL;
>  		struct dtv_frontend_properties getp = fe->dtv_property_cache;
>  
> -		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
> -		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n",
> +			__func__, tvps->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n",
> +			__func__, tvps->props);
>  
> -		/* Put an arbitrary limit on the number of messages that can
> -		 * be sent at once */
> -		if ((tvps->num == 0) || (tvps->num > DTV_IOCTL_MAX_MSGS))
> +		/*
> +		 * Put an arbitrary limit on the number of messages that can
> +		 * be sent at once
> +		 */
> +		if (!tvps->num || (tvps->num > DTV_IOCTL_MAX_MSGS))
>  			return -EINVAL;
>  
>  		tvp = memdup_user(tvps->props, tvps->num * sizeof(*tvp));
> @@ -2025,28 +2040,32 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  		 */
>  		if (fepriv->state != FESTATE_IDLE) {
>  			err = dtv_get_frontend(fe, &getp, NULL);
> -			if (err < 0)
> -				goto out;
> +			if (err < 0) {
> +				kfree(tvp);
> +				return err;
> +			}

Could avoid duplicate code keeping out logic perhaps? Is there a reason
for removing this?

>  		}
>  		for (i = 0; i < tvps->num; i++) {
>  			err = dtv_property_process_get(fe, &getp, tvp + i, file);
> -			if (err < 0)
> -				goto out;
> +			if (err < 0) {
> +				kfree(tvp);
> +				return err;
> +			}
>  			(tvp + i)->result = err;
>  		}
>  
>  		if (copy_to_user((void __user *)tvps->props, tvp,
>  				 tvps->num * sizeof(struct dtv_property))) {
> -			err = -EFAULT;
> -			goto out;
> +			kfree(tvp);
> +			return -EFAULT;
>  		}

Could avoid duplicate code keeping out logic perhaps? Is there a reason
for removing this?

> -
> -	} else
> -		err = -EOPNOTSUPP;
> -
> -out:
> -	kfree(tvp);
> -	return err;
> +		kfree(tvp);
> +		break;
> +	}
> +	default:
> +		return -ENOTSUPP;
> +	} /* switch */
> +	return 0;
>  }
>  
>  static int dtv_set_frontend(struct dvb_frontend *fe)
> 

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
