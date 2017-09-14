Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47006
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751407AbdINUvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 16:51:13 -0400
Date: Thu, 14 Sep 2017 17:50:59 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: mchehab@kernel.org, max.kellermann@gmail.com,
        sakari.ailus@linux.intel.com, mingo@kernel.org,
        hans.verkuil@cisco.com, yamada.masahiro@socionext.com,
        shuah@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, taeyoung0432.lee@samsung.com,
        jackee.lee@samsung.com, hemanshu.s@samsung.com,
        p.awasthi@samsung.com, siddharth.s@samsung.com,
        madhur.verma@samsung.com
Subject: Re: [RFC] [DVB][FRONTEND] Added a new ioctl for optimizing frontend
 property set operation
Message-ID: <20170914175059.722ac4f3@vento.lan>
In-Reply-To: <1505383167-2836-1-git-send-email-satendra.t@samsung.com>
References: <CGME20170914095941epcas5p3520a04d543890249b4952fea48747276@epcas5p3.samsung.com>
 <1505383167-2836-1-git-send-email-satendra.t@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satendra,

Em Thu, 14 Sep 2017 05:59:27 -0400
Satendra Singh Thakur <satendra.t@samsung.com> escreveu:

> -For setting one frontend property , one FE_SET_PROPERTY ioctl is called
> -Since, size of struct dtv_property is 72 bytes, this ioctl requires
> ---allocating 72 bytes of memory in user space
> ---allocating 72 bytes of memory in kernel space
> ---copying 72 bytes of data from user space to kernel space
> -However, for all the properties, only 8 out of 72 bytes are used
>  for setting the property  

That's true. Yet, for get, the size can be bigger, as ISDB-T can
return statistics per layer, plus a global one.

> -Four bytes are needed for specifying property type and another 4 for
>  property value
> -Moreover, there are 2 properties DTV_CLEAR and DTV_TUNE which use
>  only 4 bytes for property name
> ---They don't use property value
> -Therefore, we have defined new short variant/forms/version of currently
>  used structures for such 8 byte properties.
> -This results in 89% (8*100/72) of memory saving in user and kernel space
>  each.
> -This also results in faster copy (8 bytes as compared to 72 bytes) from
>  user to kernel space
> -We have added new ioctl FE_SET_PROPERTY_SHORT which utilizes above
>  mentioned new property structures
> -This ioctl can co-exist with present ioctl FE_SET_PROPERTY
> -If the apps wish to use shorter forms they can use
>  proposed FE_SET_PROPERTY_SHORT, rest of them can continue to use
>  current versions FE_SET_PROPERTY  

> -We are currently not validating incoming properties in
>  function dtv_property_short_process_set because most of
>  the frontend drivers in linux source are not using the
>  method ops.set_property. Just two drivers are using it
>  drivers/media/dvb-frontends/stv0288.c
>  driver/media/usb/dvb-usb/friio-fe.c
>  -Moreover, stv0288 driver implemments blank function
>  for set_property.
> -If needed in future, we can define a new
>  ops.set_property_short method to support
>  struct dtv_property_short.  

Nah. Better to just get rid of get_property()/set_froperty() for good.

Just sent a RFC patch series doing that.

The only thing is that stv6110 seems to have a dirty hack that may
depend on that. Someone need to double-check if the patch series
I just sent doesn't break anything. If it breaks, then we'll need
to add an extra parameter to stv6110 attach for it to know what
behavior is needed there.


> Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 228 +++++++++++++++++++++++++++++++++-
>  include/uapi/linux/dvb/frontend.h     |  24 ++++
>  2 files changed, 248 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index e3fff8f..e183025 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1914,6 +1914,192 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  	return r;
>  }
>  
> +/**
> + * dtv_property_short_process_set
> + * @fe: Pointer to struct dvb_frontend
> + * @tvp: Pointer to struct dtv_property_short
> + * @file: Pointer to struct file
> + *
> + * helper function for dvb_frontend_ioctl_properties,
> + * which can be used to set dtv property using ioctl
> + * cmd FE_SET_PROPERTY_SHORT.
> + * It assigns property value to corresponding member of
> + * property-cache structure
> + * This func is a variant of the func dtv_property_process_set
> + * Returns:
> + * Zero on success, negative errno on failure.
> + */
> +static int dtv_property_short_process_set(struct dvb_frontend *fe,
> +				    struct dtv_property_short *tvp,
> +				    struct file *file)
> +{
> +	int r = 0;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	/* Currently, We do not allow the frontend to validate incoming
> +	 * properties, currently, just 2 drivers are using
> +	 * ops.set_property method , If required, we can define new
> +	 * ops.set_property_short method for this purpose
> +	 */
> +	switch (tvp->cmd) {
> +	case DTV_CLEAR:  

Nah. Let's not have multiple validation routines for each variant.

It would be better to change the parameters for dtv_property_process_set
to something like:

static int dtv_property_process_set(struct dvb_frontend *fe,
                                    struct file *file,
				    u32 cmd, u32 data)

And have just one validation routine that would work for both.

If we end by adding some DTV properties that would require more than
4 bytes, only such properties would be implemented on a different
function.

>  static int dvb_frontend_ioctl(struct file *file,
>  			unsigned int cmd, void *parg)
>  {
> @@ -1939,7 +2125,8 @@ static int dvb_frontend_ioctl(struct file *file,
>  		return -EPERM;
>  	}
>  
> -	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
> +	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY)
> +		|| (cmd == FE_SET_PROPERTY_SHORT))
>  		err = dvb_frontend_ioctl_properties(file, cmd, parg);
>  	else {
>  		c->state = DTV_UNDEFINED;
> @@ -2026,9 +2213,42 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  			err = -EFAULT;
>  			goto out;
>  		}
> -
> -	} else
> -		err = -EOPNOTSUPP;
> +	/* New ioctl for optimizing property set
> +	 */
> +	} else if (cmd == FE_SET_PROPERTY_SHORT) {
> +		struct dtv_property_short *tvp_short = NULL;
> +		struct dtv_properties_short *tvps_short = parg;
> +
> +		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", \
> +		__func__, tvps_short->num);
> +		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", \
> +		__func__, tvps_short->props);
> +		if ((!tvps_short->num) ||
> +		(tvps_short->num > DTV_IOCTL_MAX_MSGS))
> +			return -EINVAL;
> +		tvp_short = memdup_user(tvps_short->props,
> +		tvps_short->num * sizeof(*tvp_short));
> +		if (IS_ERR(tvp_short))
> +			return PTR_ERR(tvp_short);
> +		for (i = 0; i < tvps_short->num; i++) {
> +			err = dtv_property_short_process_set(fe, tvp_short + i,\
> +				file);
> +			if (err < 0) {
> +				kfree(tvp_short);
> +				return err;
> +			}
> +			/* Since we are returning when error occurs
> +			 * There is no need to store the result as it
> +			 * would have been >=0 in case we didn't return
> +			 * (tvp + i)->result = err;
> +			 */
> +		}
> +		if (c->state == DTV_TUNE)
> +			dev_dbg(fe->dvb->device, "%s: Property cache\
> +		is full, tuning\n", __func__);  

Don't break strings on two lines.

> +		kfree(tvp_short);  

> +		} else
> +			err = -EOPNOTSUPP;  

Indentation here is wrong.

>  
>  out:
>  	kfree(tvp);
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 00a20cd..aa82179 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -476,6 +476,17 @@ struct dtv_property {
>  	int result;
>  } __attribute__ ((packed));
>  
> +/**
> + * @struct dtv_property_short
> + * A shorter version of struct dtv_property
> + * @cmd: Property type
> + * @data: Property value
> + */
> +struct dtv_property_short {
> +	__u32 cmd;
> +	__u32 data;
> +};
> +
>  /* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
>  #define DTV_IOCTL_MAX_MSGS 64
>  
> @@ -484,6 +495,18 @@ struct dtv_properties {
>  	struct dtv_property *props;
>  };
>  
> +/**
> + * @struct dtv_properties_short
> + * A variant of struct dtv_properties
> + * to support struct dtv_property_short
> + * @num: Number of properties
> + * @props: Pointer to struct dtv_property_short
> + */
> +struct dtv_properties_short {
> +	__u32 num;
> +	struct dtv_property_short *props;
> +};
> +
>  #if defined(__DVB_CORE__) || !defined (__KERNEL__)
>  
>  /*
> @@ -565,6 +588,7 @@ struct dvb_frontend_event {
>  
>  #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
>  #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
> +#define FE_SET_PROPERTY_SHORT	   _IOW('o', 84, struct dtv_properties_short)  
>  
>  /**
>   * When set, this flag will disable any zigzagging or other "normal" tuning  

Thanks,
Mauro
